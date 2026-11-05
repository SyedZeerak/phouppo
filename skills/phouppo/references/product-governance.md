# Product Fit, Cognitive Ergonomics, and Governance Review

Contents: foundational product and HCI principles, problem and workflow fit (JTBD), cognitive ergonomics and field reality, privacy by design and regulatory readiness, operational governance.

## Foundational product & human-factors principles
- **Jobs-to-be-Done (Clayton Christensen) & Marty Cagan's Product Discovery:** Users "hire" software to complete a specific job in a real physical and organizational context. Vibe-coded apps often model a generic SaaS CRUD template rather than the actual operational workflow, exceptions, and approval chains of the business.
- **Cognitive Ergonomics & Situated Action (Lucy Suchman / Don Norman):** Real work is full of interruptions, messy inputs, partial information, shared devices, and time pressure. Systems must support draft recovery, exception handling, and clear auditability when humans override automated rules.
- **Privacy by Design (Ann Cavoukian):** Proactive data minimization, privacy as the default setting, end-to-end lifecycle protection, and visibility/transparency for users.

## 1. Problem fit and domain workflow completeness
- **Real-world workflow alignment:** Trace the primary user jobs (for example plant production logging, distributor claim approval, field sales order capture, finance reconciliation). Does the app support the complete loop—including rejections, partial deliveries, credit notes, backdated adjustments, and supervisor overrides—or only the happy-path creation step?
- **Requirements traceability & bloat detection:** Map features against stated business needs. Flag "AI feature hallucination" (invented gamification, unrequested chat widgets, fake analytics tabs) that adds attack surface and maintenance debt, as well as missing core requirements that force users back into side Excel spreadsheets.
- **Explicit domain rules:** Confirm pricing slabs, tax rules, approval thresholds, and cutoff dates came from the domain owner rather than LLM guesswork.

## 2. Cognitive ergonomics, adoption, and field reality
- **Domain language match (Jakob's Law & Mental Models):** Labels, statuses, and reports use the exact terminology the organization's staff already speak (not developer database column names or generic western SaaS terms).
- **Field and environmental constraints:**
  - Usable on low-end Android phones over high-latency 3G/edge connections, under bright sunlight (high contrast), and with one-handed thumb operation where field staff are the target users.
  - Shared-device safety: fast user switching, clear active-user indicator, and clean session termination on logout so Kiosk/warehouse tablets do not leak sessions.
- **Human override & exception paths:** When real life deviates from the happy path (a shipment arrives short, an invoice needs manual adjustment, a payout is disputed), can an authorized role make an audited adjustment with a mandatory reason code?
- **Support & feedback loop:** Clear in-app help, error reference codes, and a named support/escalation channel.

## 3. Privacy by Design and regulatory governance
- **Data minimization:** Collect only PII/fields strictly necessary for the workflow; avoid collecting national IDs (CNIC/SSN), precise GPS coordinates, or sensitive documents unless required by business/legal policy.
- **Consent, retention & offboarding:** Clear user lifecycle (onboarding, role transfer, immediate access revocation when an employee or distributor leaves, and data export/deletion capability).
- **Sign-offs & compliance:** Confirm required internal reviews (Information Security, Finance/Audit for calculation sign-off, HR, Legal) are identified before go-live.

## 4. Operational ownership and handover readiness
- Named Product Owner and Technical Owner inside the organization.
- Stakeholder acceptance demo conducted using realistic (masked) operational volumes and edge cases—not 5 rows of synthetic happy-path demo data.
- Long-term maintenance and exit plan if the original prompt-builder or contractor transitions off.
