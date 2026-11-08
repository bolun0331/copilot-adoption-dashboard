# Copilot Adoption & Workforce Engagement Dashboard

## Project Overview

This portfolio project analyzes employee adoption of Microsoft Copilot and other AI tools using Power BI and SQL Server. The dashboard is designed for business leaders who need to understand adoption, engagement, retention, and licensing opportunities across the organization.

The analysis uses a synthetic Microsoft AI-in-One dataset and does not contain confidential company information.

## Business Questions

- How many employees are actively using AI tools?
- How effectively are Copilot licenses being utilized?
- Which departments have the strongest and weakest adoption?
- How many users are retained, new, returning, or lapsed?
- Where should enablement and license optimization efforts be focused?

## Dashboard Pages

### 1. Executive Overview

Provides an organization-wide view of AI adoption and weekly engagement.

Key metrics:

- **10,050** total employees
- **6,499** employees with Copilot licenses
- **7,705** active AI users in the latest complete week
- **76.67%** organization-wide weekly AI reach

### 2. Adoption Diagnostics

Examines Copilot license utilization, repeat usage, user movement, and department-level opportunities.

Key metrics:

- **4,824** active licensed Copilot users
- **74.2%** Copilot license utilization
- **1,675** licensed employees with no Copilot activity
- **4,288** two-week repeat users
- **82.1%** repeat-user rate
- **536** new or returning users
- **938** lapsed users

## Key Insights

1. Copilot license utilization is strong but not complete: approximately one in four licensed employees did not use Copilot during the latest complete week.
2. Repeat usage remains healthy, with 82.1% of the previous week's active Copilot users returning.
3. Lapsed users exceeded new and returning users, contributing to a net weekly decline in active Copilot usage.
4. Engineering has the largest license activation opportunity, with **469** licensed employees showing no Copilot activity.
5. Research & Development has the lowest observed utilization rate at **50%** (**67 of 134** licensed employees active).

## Recommendations

- Prioritize targeted enablement for Engineering and Research & Development.
- Investigate the drivers behind the increase in lapsed users.
- Track repeat usage alongside overall active-user counts to distinguish sustained adoption from one-time activity.
- Review unused licenses and separate training needs from genuine license-reallocation opportunities.
- Monitor adoption by department and role after each enablement initiative.

## Tools & Skills Demonstrated

- **Power BI Desktop:** dashboard design, data modeling, drill-down analysis, and visual storytelling
- **DAX:** adoption, utilization, retention, and user-movement measures
- **Power Query:** data cleaning and transformation
- **SQL Server:** data validation and business-rule verification
- **Business Analysis:** KPI definition, opportunity identification, and stakeholder recommendations

## Planned Repository Structure

```text
copilot-adoption-dashboard/
├── dashboard/        # Power BI file and exported dashboard
├── images/           # Dashboard screenshots
├── sql/              # SQL validation queries
├── data/             # Data notes or permitted sample data
└── README.md
```

## Data Disclaimer

This project is based on synthetic Microsoft AI-in-One sample data and was created solely for portfolio and educational purposes. All findings represent analysis of the sample dataset rather than the performance of a real organization.

## Author

**Bolun Zhang**  
Business & BI Analyst | Power BI, SQL & AI Adoption
