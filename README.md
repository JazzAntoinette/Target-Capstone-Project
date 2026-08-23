# Target Corporation Analytics & RAG Agent — Snowflake Cortex Capstone

A Snowflake-native analytics and generative AI project that combines a **structured retail data pipeline** with an **unstructured document Q&A agent**, built entirely on Snowflake Cortex (AI_PARSE_DOCUMENT, Cortex Search, Cortex Analyst, and Cortex Agents).

The project ingests raw store-level retail data (sales drivers, markdowns, economic indicators) alongside Target Corporation's 2024 Annual Report (Form 10-K), transforms both into governed Snowflake tables, and exposes them through a conversational AI agent capable of answering both quantitative and narrative questions.

## What it does

- **Medallion data pipeline (Raw → Silver → Gold)**: Loads raw CSVs from Azure Blob Storage, parses/cleans store metadata and weekly store metrics (fuel price, CPI, unemployment rate, promotional markdowns, holiday flags), and aggregates them into gold-layer summary tables.
- **Statistical analysis**: Runs a multiple linear regression (via `statsmodels`) testing whether regional cost-of-living and labor market conditions (CPI, unemployment, fuel price) predict promotional markdown behavior, with results written back to a gold analytics table.
- **PDF parsing & chunking**: Uses `SNOWFLAKE.CORTEX.AI_PARSE_DOCUMENT` (LAYOUT mode) to extract text from Target's 2024 Annual Report PDF, splits it into overlapping chunks, and generates `e5-base-v2` vector embeddings for each chunk.
- **Semantic search**: Stands up a Cortex Search Service over the chunked/embedded report text for natural-language retrieval.
- **Semantic view**: Defines a Cortex Analyst semantic model over the chunk metadata for structured queries (chunk counts, document structure).
- **Conversational agent**: Deploys a Snowflake Cortex Agent that routes questions between Cortex Analyst (structured/metadata queries) and Cortex Search (financial performance, strategy, ESG, risk factors, executive commentary), with built-in chart generation.

## Tech stack

- **Snowflake**: Cortex AI_PARSE_DOCUMENT, Cortex Search, Cortex Analyst, Cortex Agents, Semantic Views, Snowpark
- **Python**: pandas, numpy, statsmodels, scikit-learn, matplotlib
- **SQL**: Snowflake SQL / Snowpark DataFrames
- **Storage**: Azure Blob Storage (external stage/storage integration)

## Repo contents

| File | Purpose |
|---|---|
| `Module10Capstone.sql` | Role/warehouse/database setup, Azure storage integration, raw ingestion, silver/gold transformations |
| `Module10Capstone.ipynb` | Regression analysis of markdowns vs. economic indicators; writes results to gold layer |
| `pdf_chunking_capstoone.ipynb` | PDF upload, parsing, chunking, and embedding generation for the Annual Report |
| `create_cortex_search_target.sql` | Cortex Search Service definition over PDF chunks |
| `deploy_semantics_capstone.sql` | Semantic view (YAML-defined) for chunk metadata |
| `create_target_agent.sql` | Cortex Agent specification combining Analyst + Search tools |
| `2024-Annual-Report-Target-Corporation.pdf` | Source document (Target Corporation Form 10-K) |

## Key finding

Economic conditions (CPI, unemployment, fuel price) show a *statistically* significant relationship with markdown levels but explain only ~1.4% of variance (R² = 0.014) — i.e., statistically detectable but not practically meaningful, with store strategy, inventory, and seasonality likely driving most markdown behavior.

## Setup

1. Run `Module10Capstone.sql` to provision the role, warehouse, storage integration, and raw/silver/gold tables.
2. Run `pdf_chunking_capstoone.ipynb` to parse and embed the annual report PDF.
3. Run `deploy_semantics_capstone.sql` and `create_cortex_search_target.sql` to stand up the semantic view and search service.
4. Run `create_target_agent.sql` to deploy the Cortex Agent.
5. Run `Module10Capstone.ipynb` for the markdown regression analysis.

---
*Educational/capstone project — not affiliated with or endorsed by Target Corporation.*
