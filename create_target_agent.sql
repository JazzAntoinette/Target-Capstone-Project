USE ROLE CHEETAH_ROLE;
USE DATABASE CHEETAH_DB;
USE SCHEMA GOLD_BUSINESS_DATA;

CREATE OR REPLACE AGENT TARGET_ANNUAL_REPORT_AGENT
    COMMENT = 'Target Corporation 2024 Annual Report assistant combining structured chunk analytics (Cortex Analyst) and semantic PDF search (Cortex Search)'
FROM SPECIFICATION
$$
models:
  orchestration: auto
instructions:
  response: "You are a Target Corporation financial analyst assistant. Answer questions clearly and concisely using the 2024 Annual Report. When providing financial figures, include exact numbers. When citing report content, reference the relevant section."
  orchestration: "For questions about chunk counts, document structure, or metadata queries, use the Analyst tool. For questions about Target's financials, strategy, store operations, ESG initiatives, or any content from the annual report, use the Search tool."
tools:
  - tool_spec:
      type: "cortex_analyst_text_to_sql"
      name: "target_analyst"
      description: "Queries structured metadata about the chunked annual report. Use for questions about document structure, chunk counts, or source file information."
  - tool_spec:
      type: "cortex_search"
      name: "target_report_search"
      description: "Searches the full text of the Target Corporation 2024 Annual Report. Use for questions about financial performance, strategy, store operations, ESG, executive commentary, risk factors, and any specific content from the report."
  - tool_spec:
      type: "data_to_chart"
      name: "data_to_chart"
      description: "Generates visualizations from query results."
tool_resources:
  target_analyst:
    semantic_view: "CHEETAH_DB.GOLD_BUSINESS_DATA.TARGET_ANNUAL_REPORT_CHUNKS"
  target_report_search:
    name: "CHEETAH_DB.GOLD_BUSINESS_DATA.TARGET_PDF_SEARCH"
    max_results: 5
$$;

SHOW AGENTS IN SCHEMA CHEETAH_DB.GOLD_BUSINESS_DATA;
