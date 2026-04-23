# [Project Name] - Product Requirements Document

*One-line description of the project.*

## Approvals

*List the stakeholders who need to review and sign off on this PRD before work begins.*


| Name       | Role         | Status   | Date       |
| ---------- | ------------ | -------- | ---------- |
| Jane Smith | Product Lead | Approved | 2026-01-15 |
|            |              |          |            |


# Problem

### What is the problem?

*Describe the problem we are trying to solve for our customer (and/or internal customer) in 1-3 sentences. We should be able to read this alone and communicate the value and risks to someone else. Add additional context to the summary by adding screenshots, charts, data, or links to any relevant source material or research that was previously conducted.*

### How does this connect to our strategy & priorities?

*Describe the qualitative and quantitative impact solving this problem will have on our strategy and priorities. Why are we working on this now and what would happen if we didn't?*

### What does success look like?

*Describe how we know we were successful. What will we measure? What will our customers and/or internal customers do differently if we do a great job solving the problem?*


| Metric                                   | Current Baseline | Target    | Measurement Method            |
| ---------------------------------------- | ---------------- | --------- | ----------------------------- |
| Customer support ticket volume (billing) | 1,200/month      | 600/month | Zendesk reporting dashboard   |
| Self-service payment completion rate     | 34%              | 75%       | Product analytics (Amplitude) |


### What are we not trying to solve?

*List explicit areas of this problem we do not plan to address. Explain why they are out of scope.*

# Proposal

### How do we intend to solve this problem?

*Describe how we will solve the problem in one to three sentences. Then share what we expect will happen and why. Summarize what makes this the best option versus the alternatives we considered.*

### How will our solution work?

*Include a mock or reference for the design and architecture. These can be formal (Figma links, architecture diagrams) or informal (hand-drawn sketches, whiteboard photos). Document any trade-offs to this approach.*

### What are the key requirements?

**Functional Requirements**
*List the specific functional requirements. Each requirement should be testable and unambiguous.*


| Priority (P0/P1/P2) | Requirement                        | Notes                                                                                          |
| ------------------- | ---------------------------------- | ---------------------------------------------------------------------------------------------- |
| P0                  | Self-service payment portal        | Borrower can view balance, make a one-time payment, and set up autopay without calling support |
| P1                  | Payment confirmation notifications | Borrower receives email and in-app confirmation within 60 seconds of payment submission        |


**Non-functional Requirements**
*List performance, security, scalability, accessibility, and other non-functional requirements.*


| Priority (P0/P1/P2) | Requirement                          | Notes                                              |
| ------------------- | ------------------------------------ | -------------------------------------------------- |
| P0                  | Page load time under 2 seconds       | Measured at P95 on 4G mobile connections           |
| P1                  | WCAG 2.1 AA accessibility compliance | All payment flows must be screen-reader accessible |


**Out of Scope**
*List specific features we love but aren't building with the rationale to exclude them for now (or indefinitely).*

### What dependencies do we have on others?

*Write out the items you're depending on other teams to deliver for your key features.*


| Team                 | Dependency                                                      | POC                  |
| -------------------- | --------------------------------------------------------------- | -------------------- |
| Customer Support     | Agents must be trained 3 months prior to feature being released | First Name Last Name |
| Platform Engineering | Payment processing API v2 must be deployed to production        | First Name Last Name |


# Plan

### Timeline

*Outline the high-level milestones and target dates that are required from kickoff to launch.*


| Milestone     | Description                                     | Target Date | Status      |
| ------------- | ----------------------------------------------- | ----------- | ----------- |
| Design review | Final mocks approved by product and engineering | 2026-02-01  | Complete    |
| Beta launch   | Internal team testing with production data      | 2026-03-15  | In Progress |


### Risks and Mitigations

*Identify risks that could impact delivery or success. For each risk, describe the likelihood, impact, and mitigation strategy.*


| Risk                                         | Likelihood | Impact | Mitigation                                                        |
| -------------------------------------------- | ---------- | ------ | ----------------------------------------------------------------- |
| Payment API v2 delivery slips past March     | Medium     | High   | Build against v1 with an adapter layer; swap to v2 when ready     |
| Low borrower adoption of self-service portal | Medium     | Medium | Partner with CX team on email campaign and in-app onboarding flow |


### Open Questions

*List any unresolved questions that need answers before or during implementation.*


| Question                              | Owner      | Due Date   | Resolution |
| ------------------------------------- | ---------- | ---------- | ---------- |
| Do we support partial payments in v1? | Jane Smith | 2026-01-20 |            |


