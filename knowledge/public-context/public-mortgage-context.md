# Public Mortgage Context

Resources shared by future EM as onboarding context for mortgage servicing work.

---

## Mortgage Servicing Overview

> Source: [Rocket Mortgage — What is Mortgage Servicing](https://www.rocketmortgage.com/learn/what-is-mortgage-servicing)

**Mortgage servicing** is the management of a home loan once it closes, on behalf of the investors in the mortgage. The servicer is distinct from the originator — origination covers the application, underwriting, appraisal, and closing, while servicing covers everything between closing and loan payoff.

### What Mortgage Servicers Do

- **Collect payments**: Principal and interest payments are forwarded to investors in the loan
- **Manage escrow accounts**: Disburse funds from escrow to insurers and government authorities for taxes and insurance
- **Create and send statements/disclosures**: Monthly mortgage statements and end-of-year tax information
- **Handle late payments**: Collect payments past the due date/grace period and any fees permitted under the contract
- **Help prevent foreclosure**: Qualify struggling borrowers for options to avoid foreclosure

### Servicing Transfers

A borrower's mortgage servicer can change at any time during the life of the loan. Reasons include:

- Some lenders don't service their own loans, so servicing is sold shortly after closing
- Servicers may purchase servicing rights to generate revenue during low-origination periods or to build a relationship with the borrower for future refinancing

During a transfer, the borrower receives communication from the outgoing servicer and onboarding info from the new servicer. The account and payment destination change, but **existing mortgage terms are unaffected**.

### How Servicing Affects Borrowers

- **Payment processing**: Servicers collect P&I and pass it to investors; they also manage escrow disbursements
- **Statement timing**: At least one statement per month, arriving well in advance of when the monthly payment is due
- **Borrower communications**: Delivered on the statement, through the payment portal, or both

### Borrower Rights Under RESPA (Regulation X)

If issues arise with servicing (misapplied payments, escrow shortages, etc.), borrowers should contact the servicer first. If unresolved, borrowers have rights under the **Real Estate Settlement Procedures Act (RESPA)**, Regulation X, which requires servicers to provide:

- Periodic billing statements
- Notification of interest rate adjustments for ARMs
- Prompt payment application and payoff statements upon request
- Available mortgage relief options
- Error resolution and information inquiry handling

Complaints can be filed with the **Consumer Financial Protection Bureau (CFPB)** or the **State Attorney General**.

### Rocket Mortgage as Servicer

Rocket Mortgage is both a lender and a servicer of the mortgages it originates (not all lenders do this). A mortgage servicer does **not** own the loan — servicers forward P&I payments to market investors who own the loan. Investors pay servicers via a flat fee or a small percentage of the amount collected each month.

> Note: Some lenders (like Rocket Mortgage) are both originators and servicers. This is relevant context for understanding how competitors like Valon position as servicer-only.

---

## Government-Sponsored Enterprises (GSEs): Fannie Mae & Freddie Mac

> Source: [Rocket Mortgage — Fannie Mae vs Freddie Mac](https://www.rocketmortgage.com/learn/fannie-mae-vs-freddie-mac)

Fannie Mae and Freddie Mac are **government-sponsored enterprises (GSEs)** created by Congress and overseen by the Federal Housing Finance Agency (FHFA). They buy conforming mortgages from lenders, package them into **mortgage-backed securities (MBS)**, and sell them on secondary markets. This frees up lender capital to issue new loans and creates a stable national mortgage market.

### Brief history

**Fannie Mae** (Federal National Mortgage Association)
- 1938: created by Congress to provide steady housing funding; introduced the long-term, fixed-rate mortgage
- 1954: adopted a private-public structure
- 1968: privatized as a shareholder-owned company
- 1970: approved to buy conventional mortgages (in addition to FHA/VA loans)
- 2008: placed in FHFA conservatorship after the housing collapse (still in place today)

**Freddie Mac** (Federal Home Loan Mortgage Corp.)
- 1970: created under the Emergency Home Finance Act to expand the secondary mortgage market and compete with Fannie Mae
- 1989: became a public, shareholder-owned company
- 2008: placed in FHFA conservatorship after the housing collapse (still in place today)

### Similarities

- Both are GSEs overseen by HUD and the FHFA
- Both buy conforming, conventional loans (loans meeting FHFA standards)
- Both guarantee timely P&I payments on the underlying loans in their MBS — this makes secondary mortgage markets more liquid and reduces borrower interest rates
- Both expand the pool of capital available for housing by attracting investors to secondary mortgage markets

### Key differences

| Dimension | Fannie Mae | Freddie Mac |
|---|---|---|
| Founded | 1938 — accessible/affordable housing | 1970 — expand secondary market, reduce bank rate risk |
| Sources loans from | Larger commercial banks | Community banks, regional banks, credit unions |
| Affordable loan program | HomeReady® (<80% area median income) | Home Possible® (similar income limits, different underwriting) |
| Approval guidelines | Differ on credit history, DTI, income evaluation | Differ — rare but possible for a borrower to qualify with one and not the other |
| Down-payment minimums | Own guidelines | Own guidelines |

### Why this matters for Valon

- Both fall under what Valon refers to as **"GSE loans"** — the platform's first-tier supported loan type. See `knowledge/company/loan-types.md` for Valon's loan-type sequencing.
- A loan being a conforming Fannie or Freddie loan has implications for servicing requirements (reporting, remittance, default handling), but ValonOS treats them as the same readiness tier.
- Rhythm Capital (NewRez's parent) gave Valon its first Fannie Mae and first Freddie Mac loans to service — historical context for the NewRez relationship.

---

## Escrow Accounts

### Two Types of Escrow

> Sources: [Rocket Mortgage — What is Escrow](https://www.rocketmortgage.com/learn/what-is-escrow), [CFPB — What is an escrow or impound account?](https://www.consumerfinance.gov/ask-cfpb/what-is-an-escrow-or-impound-account-en-140/), [Valon — What is an escrow account?](https://help.valon.com/hc/en-us/categories/4405709597716-Escrow-Taxes-Insurance)

**1. Escrow during home buying** — A third-party account (managed by a title company or real estate attorney) holds the buyer's **earnest money deposit** until contractual obligations are met. If the sale falls through due to buyer fault, the seller generally keeps the earnest money. If the sale completes, the earnest money is applied toward the down payment. An **escrow holdback** may also reserve funds post-closing (e.g., seller needs time to move out, or agreed-upon repairs aren't yet complete).

**2. Escrow for taxes and insurance (impound account)** — Set up by the mortgage lender as part of the purchase. Each month, the loan servicer sets aside a portion of the mortgage payment in escrow until tax and insurance bills are due, then pays them on behalf of the borrower. This is the type of escrow relevant to mortgage servicing.

### How Escrow Works (Taxes & Insurance)

An **escrow account** (also called an **impound account**) is a special account created at mortgage closing. The funds are used to pay taxes and insurance. Because the lender has a financial interest in the property, they set up escrow to ensure tax and insurance payments are made.

When Valon begins servicing a loan, it takes over the escrow account and makes payments on the borrower's behalf.

**How it works:**
- A portion of the monthly mortgage payment is contributed to escrow
- Escrow funds cover required tax and insurance expenses
- Tax payment timing/frequency depends on the state; insurance timing depends on origination date
- Monthly escrow amounts adjust as property taxes and insurance premiums change
- Each year, the servicer recalculates escrow payments based on current-year bills
- Most lenders require a minimum **2 months' worth** of extra payments as a cushion

**Why have escrow:**
- Spreads lump-sum obligations into monthly payments for budgeting
- Servicer ensures taxes and insurance are paid on time, taking advantage of early-payment benefits
- Borrower doesn't need to track due dates — the servicer handles payment timing
- If the account comes up short, the servicer covers the bills and the borrower repays the shortage later

**Who manages escrow:**
- During home buying: escrow companies, real estate attorneys, title companies
- During loan life: the **mortgage servicer** — collects payments, maintains records, manages the escrow account
- If the borrower changes insurance providers, they must notify the servicer to update records

### When Escrow Is Required

- **FHA loans**: Escrow required for all borrowers
- **VA loans**: Escrow required unless borrower has 10% down and a strong credit profile
- **Conventional loans**: Escrow required unless borrower has 20%+ down payment
- Borrowers can sometimes escrow for some expenses but not others (e.g., taxes but not insurance)

### What Escrow Does NOT Cover

- Utilities (electricity, gas, water)
- Home maintenance and upkeep
- Homeowners association (HOA) fees
- **Supplemental tax bills** (from property ownership changes or new construction) — generally not managed through escrow, though if severely delinquent, the servicer may make a one-time disbursement from escrow that the borrower must repay

### Why Lenders Want Escrow

Lenders have strong incentive to ensure taxes and insurance are paid:
- Unpaid tax bills → tax authority lien on the home → potential foreclosure, costing the lender money
- Lapsed homeowners insurance → significant property damage could substantially decrease the home's value

### Key Details (CFPB)

- Many lenders require escrow; borrowers can also request one voluntarily
- Without escrow, borrowers must independently budget and pay these obligations
- If a borrower fails to maintain taxes or insurance, the servicer may:
  - Add unpaid amounts to the loan balance
  - Establish a mandatory escrow account
  - Purchase **force-placed insurance** (typically more expensive than self-obtained coverage)
- Failure to pay property taxes risks penalties, tax liens, and potential foreclosure

### Drawbacks of Escrow

- **Higher monthly payments**: Escrow adds ~1% of total purchase price in fees; monthly bills are higher than without escrow
- **Estimate accuracy**: Upon moving in, property reassessment can cause tax increases not predicted by the lender's initial estimate. Servicer estimates are based on prior-year bills and may not anticipate changes.
- **Annual payment changes**: Escrow is reassessed yearly, so monthly payment amounts shift. Tip: setting aside 15-20% of prior-year escrow costs as a personal cushion can help cover increases.

### Escrow Cushion (Reserve)

> Source: [Valon — What is an escrow cushion?](https://help.valon.com/hc/en-us/categories/4405709597716-Escrow-Taxes-Insurance)

An escrow cushion is extra funds the servicer requires to cover unanticipated disbursements or disbursements made before the borrower's payments are available. It acts as a buffer equal to about **two months of escrow payments**.

- Federal law allows servicers to collect an extra two months' worth of escrow payments per year
- Example: If annual escrow (taxes + insurance) = $6,000/yr ($500/mo), the servicer collects an additional $1,000/yr for a total of $7,000 → ~$583/mo

### Closing an Escrow Account (Waiver)

> Source: [Valon — How can I close my escrow account?](https://help.valon.com/hc/en-us/categories/4405709597716-Escrow-Taxes-Insurance)

Borrowers can request an escrow waiver (removing property tax, insurance, or both from escrow). If approved, the borrower is responsible for paying those obligations directly.

**Eligibility requirements:**
- Loan was not previously modified
- No delinquency (including tax delinquency) in the last 12 months
- No 60+ day delinquency in the last 24 months
- Principal balance < 80% of the property's original appraised value
- No prior missed payments after a previous escrow waiver approval

**Restrictions:**
- Mortgage insurance escrow cannot be waived
- Flood insurance (if required) must remain escrowed
- Even without escrow, borrowers must maintain active property insurance — otherwise the servicer purchases lender-placed insurance and creates an escrow account to recoup the cost

**Processing timing:**
- If a waiver request is within 45 days of a tax installment due date, the servicer may complete the tax payment before processing the waiver
- Insurance payments are typically sent 21 days before policy due date

---

## Escrow Analysis

> Sources: [Mr. Cooper — Escrow Analysis](https://www.mrcooper.com/help-center/escrow/escrow-analysis-escrow-review), [Valon — What is an escrow analysis?](https://help.valon.com/hc/en-us/categories/4405709597716-Escrow-Taxes-Insurance)

An **escrow analysis** is an annual estimation of what the borrower will owe for property taxes and homeowners insurance over the next 12 months. Three items go into the calculation: taxes, insurance, and cushion funds.

### How It Works (Valon Example)

1. Estimate tax and insurance values from closing documents, local property tax office, and insurance carrier
2. Sum the yearly totals and divide by 12 for the monthly escrow amount
3. Calculate the cushion (typically 2 months of escrow payments) and add it to the yearly total
4. Divide the final yearly contribution by 12 for the actual monthly escrow payment

Example: $2,000 taxes + $1,600 insurance = $3,600/yr → $300/mo base → $600 cushion → $4,200/yr total → **$350/mo**

### What Gets Examined

- Current escrow account balance
- Monthly payment amount and minimum required balance
- Recent tax and insurance disbursements made on the borrower's behalf
- Projected tax and insurance amounts and due dates for the upcoming year

### When It Happens

- Conducted **at least once per year**, on a schedule that varies by state
- For transferred loans, the analysis follows the standard state cycle unless 12+ months have passed since the prior review

### Why Escrow Payments Change

Monthly mortgage payments = principal + interest + escrow. While P&I are typically fixed, escrow can change yearly due to:
- Tax and insurance rate fluctuations
- Home value increases pushing up property tax bills
- Home improvements increasing insurance costs
- Prior underfunding causing a shortage

The servicer determines the escrow payment through a yearly analysis and notifies borrowers of changes.

> A payment can increase even when the account has a surplus — the monthly escrow payment is calculated from next year's projected expenses divided by 12, regardless of the current account balance.

### Shortages

> Source: [Valon — Why do I have an escrow shortage?](https://help.valon.com/hc/en-us/categories/4405709597716-Escrow-Taxes-Insurance)

A **shortage** means there's not enough money in escrow to pay taxes and/or insurance as they come due. Causes include:
- Taxes and/or insurance costs went up
- Insufficient escrow cushion
- Servicer had to purchase lender-placed insurance

**Resolution options:**
- **Option 1 — Spread over time**: Shortage divided by 12 and added to monthly payments. Borrower may request up to **60 months** to spread the shortage.
- **Option 2 — Pay upfront**: Pay the shortage as a lump sum (account must be current). Prevents the shortage from being added to monthly payments, but the payment may still increase due to higher projected tax/insurance costs.

### Surpluses

> Source: [Valon — What is a surplus?](https://help.valon.com/hc/en-us/categories/4405709597716-Escrow-Taxes-Insurance)

A **surplus (overage)** occurs when the projected escrow balance exceeds the required balance:

- Surpluses of **$50 or more** → refund check issued within 30 days of the analysis
- Surpluses under **$50** → credited to the next monthly payment

An escrow refund typically occurs when tax/insurance bills decreased more than projected in the last analysis.

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
| [What is Mortgage Servicing](https://www.rocketmortgage.com/learn/what-is-mortgage-servicing)                            | Rocket Mortgage | High-level primer                     | Manually provided and used                           |
| [Escrow, Taxes & Insurance Help Center](https://help.valon.com/hc/en-us/categories/4405709597716-Escrow-Taxes-Insurance) | Valon           | Key topics overview                   | Manually provided and used                           |
| [What is an Escrow Account](https://www.consumerfinance.gov/ask-cfpb/what-is-an-escrow-or-impound-account-en-140/)       | CFPB            | Compliance / regulatory               | Fetched and used                                     |
| [What is Escrow](https://www.rocketmortgage.com/learn/what-is-escrow)                                                    | Rocket Mortgage | Primer                                | Manually provided and used                           |
| [Escrow Analysis / Review](https://www.mrcooper.com/help-center/escrow/escrow-analysis-escrow-review)                    | Mr. Cooper      | Escrow analysis details               | Fetched and used                                     |
| [Accounting for Developers, Part I](https://www.moderntreasury.com/journal/accounting-for-developers-part-i)             | Modern Treasury | Accounting concepts relevant to Valon | Fetched and used                                     |
| [Fannie Mae vs Freddie Mac](https://www.rocketmortgage.com/learn/fannie-mae-vs-freddie-mac)                              | Rocket Mortgage | GSE comparison                        | Quoted in Granola notes; synthesized 2026-05-21      |


