# Public Mortgage Context

Resources shared by future EM as onboarding context for mortgage servicing work.

---

## Mortgage Servicing Overview

> Sources: [Rocket Mortgage — What is Mortgage Servicing](https://www.rocketmortgage.com/learn/what-is-mortgage-servicing) (unable to fetch — see link directly)

A **mortgage servicer** is the company that manages a mortgage loan after it has been originated. The servicer handles day-to-day administration on behalf of the loan owner (investor), including:

- **Collecting monthly payments** (principal, interest, escrow)
- **Managing escrow accounts** for taxes and insurance
- **Distributing payments** to investors, tax authorities, and insurance companies
- **Handling borrower communications** (statements, payoff quotes, loss mitigation)
- **Reporting to credit bureaus**
- **Managing delinquency and default** (loss mitigation, foreclosure proceedings)

The loan originator and the servicer are often different entities. Loans are frequently sold on the secondary market, but servicing rights may transfer independently of loan ownership.

---

## Escrow Accounts

### What is an Escrow Account?

> Source: [CFPB — What is an escrow or impound account?](https://www.consumerfinance.gov/ask-cfpb/what-is-an-escrow-or-impound-account-en-140/)

An **escrow account** (also called an **impound account**) is established by a mortgage servicer to collect and disburse property-related expenses on behalf of the borrower. A portion of each monthly mortgage payment goes into escrow to cover:

- **Property taxes**
- **Homeowners insurance**
- **Mortgage insurance** (if applicable)

Key details:

- Monthly escrow amounts adjust as property taxes and insurance premiums change
- Many lenders require escrow; borrowers can also request one voluntarily
- Without escrow, borrowers must independently budget and pay these obligations
- If a borrower fails to maintain taxes or insurance, the servicer may:
  - Add unpaid amounts to the loan balance
  - Establish a mandatory escrow account
  - Purchase **force-placed insurance** (typically more expensive than self-obtained coverage)
- Failure to pay property taxes risks penalties, tax liens, and potential foreclosure

### Additional Escrow Primer

> Sources: [Rocket Mortgage — What is Escrow](https://www.rocketmortgage.com/learn/what-is-escrow) (unable to fetch — see link directly)

---

## Escrow Analysis

> Sources: [Mr. Cooper — Escrow Analysis](https://www.mrcooper.com/help-center/escrow/escrow-analysis-escrow-review), [Valon Help Center — Escrow](https://help.valon.com/hc/en-us/categories/4405709597716-Escrow-Taxes-Insurance) (unable to fetch — see link directly)

An **escrow analysis** (or **escrow review**) is an annual examination of a borrower's escrow account to ensure sufficient funds exist for upcoming property tax and insurance payments.

### What Gets Examined

- Current escrow account balance
- Monthly payment amount and minimum required balance
- Recent tax and insurance disbursements made on the borrower's behalf
- Projected tax and insurance amounts and due dates for the upcoming year

### When It Happens

- Conducted **at least once per year**, on a schedule that varies by state
- For transferred loans, the analysis follows the standard state cycle unless 12+ months have passed since the prior review

### Shortages

A **shortage** occurs when projected balances fall below the minimum required cushion:

- The shortage is automatically spread over the next 12 months and added to monthly payments
- Borrowers may pay the shortage as a lump sum instead

### Surpluses

A **surplus** occurs when excess funds accumulate:

- Surpluses exceeding **$50** result in a refund check within 30 days (if account is current)
- Smaller surpluses are applied over 12 months to reduce payments

### Statement

Borrowers receive an **Escrow Review Statement** explaining the results, indicating payment increases or decreases, and identifying any shortage or surplus.

---

## Accounting Fundamentals (for Developers)

> Source: [Modern Treasury — Accounting for Developers, Part I](https://www.moderntreasury.com/journal/accounting-for-developers-part-i)

Recommended by EM as relevant to how Valon handles accounting internally.

### Double-Entry Accounting

Every transaction records both **where money came from** and **what it was used for**. This creates system reliability through balanced records — no money appears or disappears without a trace.

### Core Concepts


| Concept         | Description                                                                                                     |
| --------------- | --------------------------------------------------------------------------------------------------------------- |
| **Ledger**      | A timestamped log of monetary events; enables balance reconstruction at any point in time and full auditability |
| **Account**     | A discrete pool of value representing a balance to track; each has a type that determines how entries affect it |
| **Transaction** | An atomic event affecting multiple accounts simultaneously, always maintaining ledger equilibrium               |


### Account Types


| Type            | Normal Balance | Increases With | Tracks                            |
| --------------- | -------------- | -------------- | --------------------------------- |
| **Assets**      | Debit          | Debit          | Uses of funds (cash, receivables) |
| **Expenses**    | Debit          | Debit          | Uses of funds (costs incurred)    |
| **Liabilities** | Credit         | Credit         | Sources of funds (debts owed)     |
| **Equity**      | Credit         | Credit         | Sources of funds (owner's stake)  |
| **Revenue**     | Credit         | Credit         | Sources of funds (income earned)  |


### Debits and Credits

- Function as **directional flags**, not positive/negative values
- A debit adds to debit-normal accounts (assets, expenses) but subtracts from credit-normal accounts (liabilities, equity, revenue)
- Credits work inversely

### Ledger Balance Validation

System correctness requires that the **sum of all credit-normal balances equals the sum of all debit-normal balances**. An imbalance indicates missing or phantom funds.

---

## Source Links


| Resource                                                                                                                 | Source          | Notes                                 | Status                                               |
| ------------------------------------------------------------------------------------------------------------------------ | --------------- | ------------------------------------- | ---------------------------------------------------- |
| [What is Mortgage Servicing](https://www.rocketmortgage.com/learn/what-is-mortgage-servicing)                            | Rocket Mortgage | High-level primer                     | Fetch blocked (403) — section uses general knowledge |
| [Escrow, Taxes & Insurance Help Center](https://help.valon.com/hc/en-us/categories/4405709597716-Escrow-Taxes-Insurance) | Valon           | Key topics overview                   | Fetch blocked (403) — not used                       |
| [What is an Escrow Account](https://www.consumerfinance.gov/ask-cfpb/what-is-an-escrow-or-impound-account-en-140/)       | CFPB            | Compliance / regulatory               | Fetched and used                                     |
| [What is Escrow](https://www.rocketmortgage.com/learn/what-is-escrow)                                                    | Rocket Mortgage | Primer                                | Fetch blocked (403) — not used                       |
| [Escrow Analysis / Review](https://www.mrcooper.com/help-center/escrow/escrow-analysis-escrow-review)                    | Mr. Cooper      | Escrow analysis details               | Fetched and used                                     |
| [Accounting for Developers, Part I](https://www.moderntreasury.com/journal/accounting-for-developers-part-i)             | Modern Treasury | Accounting concepts relevant to Valon | Fetched and used                                     |


