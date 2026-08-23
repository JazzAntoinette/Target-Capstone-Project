USE ROLE CHEETAH_ROLE;
USE DATABASE CHEETAH_DB;
USE SCHEMA GOLD_BUSINESS_DATA;

CALL SYSTEM$CREATE_SEMANTIC_VIEW_FROM_YAML(
    'CHEETAH_DB.GOLD_BUSINESS_DATA',
$$
name: TARGET_ANNUAL_REPORT_CHUNKS
description: >
  Chunked text from the Target Corporation 2024 Annual Report with vector embeddings.
  Contains approximately 315 overlapping text chunks covering financial highlights,
  strategic initiatives, store operations, ESG disclosures, and executive commentary.
  Use for natural-language Q&A about Target's fiscal 2024 performance and outlook.
tables:
  - name: TARGET_PDF_EMBEDDINGS
    description: >
      Each row is one text chunk (~1000 chars, 200-char overlap) extracted from the
      Target Corporation 2024 Annual Report PDF via SNOWFLAKE.CORTEX.AI_PARSE_DOCUMENT
      in LAYOUT mode, with a precomputed e5-base-v2 vector embedding for semantic search.
    base_table:
      database: CHEETAH_DB
      schema: GOLD_BUSINESS_DATA
      table: TARGET_PDF_EMBEDDINGS
    dimensions:
      - name: CHUNK_ID
        description: Sequential zero-based position of this chunk within the source document.
        expr: CHUNK_ID
        data_type: NUMBER
      - name: CHUNK_TEXT
        description: >
          Raw text content of the chunk. Approximately 1000 characters with 200-character
          overlap between consecutive chunks. Contains financial figures, narrative text,
          and table data from the annual report.
        expr: CHUNK_TEXT
        data_type: TEXT
      - name: SOURCE_FILE
        description: Filename of the source PDF in the pdf_stage (e.g. 2024-Annual-Report-Target-Corporation.pdf).
        expr: SOURCE_FILE
        data_type: TEXT
    measures:
      - name: TOTAL_CHUNKS
        description: Total number of text chunks available for the document.
        expr: COUNT(*)
        data_type: NUMBER
      - name: MAX_CHUNK_ID
        description: Highest chunk index, indicating document length in chunks.
        expr: MAX(CHUNK_ID)
        data_type: NUMBER
$$
);

SHOW SEMANTIC VIEWS IN SCHEMA CHEETAH_DB.GOLD_BUSINESS_DATA;