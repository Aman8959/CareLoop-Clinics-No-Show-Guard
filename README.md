# CareLoop Clinics — No-Show Guard

A data analytics and machine-learning capstone project that studies clinic appointment no-shows, identifies operational patterns, predicts no-show risk, and uses GenAI to classify patient follow-up notes.

## Current submission status

- **Part 1 — Data ingestion and cleaning:** completed and audited.
- **Part 2 — SQL analysis:** completed; SQLite database and queries included.
- **Part 3 — Machine learning:** completed and independently reproduced.
- **Part 4 — GenAI note analysis:** notebook and workflow included, but the final API-dependent run is **pending**. The latest Gemini request returned `503 UNAVAILABLE` (temporary model high demand). No synthetic GenAI classifications have been inserted.

Do not mark the entire project fully complete until Part 4 is run successfully and its acceptance checks pass.

## Verified project results

### Part 1 — Data preparation
- Raw appointments: **1,020 rows × 14 columns**
- Cleaned appointments: **990 rows × 16 columns**
- Rejected rows: **32** (20 missing `distance_km`, 12 missing `age`)
- Duplicate rows removed: **20**
- No-show appointments: **218 / 990 (22.0%)**
- Cleaned dataset: no missing values; 990 unique appointment IDs

### Part 2 — SQL analysis
- Clinics: **8**
- Appointments loaded into SQLite: **990**
- No-shows: **218**
- Foreign-key violations: **0**
- Duplicate appointment IDs: **0**
- The SQLite queries cover clinic no-show rates, lead-time buckets, monthly trends, and within-city clinic rankings.

### Part 3 — Machine learning
- Train/test split: **792 / 198**
- Baseline accuracy: **0.753**
- Logistic Regression held-out ROC-AUC: **0.789**
- Logistic Regression threshold used for risk flags: **0.35**
- Test risk-score output: **198 rows × 4 columns**
- Flagged test appointments: **49**

The model is a prioritization aid, not a causal explanation or a clinical decision system.

## Folder contents

- `01_ingest_clean.ipynb` — Part 1 ingestion, cleaning, feature engineering, weather enrichment, exports.
- `02_schema_sqlite.sql` — SQLite table schema.
- `02_load_data_sqlite.sql` — inserts 8 clinics and 990 cleaned appointments.
- `02_queries_sqlite.sql` — Part 2 analysis queries.
- `noshowguard.sqlite` — ready-to-open SQLite database.
- `03_model.ipynb` — Part 3 model training, evaluation, tuning, and risk scoring.
- `04_genai.ipynb` — Part 4 Gemini structured output, Pydantic validation, red-team tests, V1/V2 comparison, and merge.
- `appointments.csv`, `clinics.csv`, `followup_notes.csv` — source data.
- `appointments_clean.csv`, `clinics_enriched.csv`, `rejected_rows.json` — Part 1 outputs.
- `test_risk_scores.csv` — Part 3 held-out risk scores.
- `PROJECT_AUDIT.md`, `PART4_STATUS.md`, `RUN_INSTRUCTIONS.md` — audit and execution guidance.

## Execution order

1. Run `01_ingest_clean.ipynb` from this folder.
2. Open `noshowguard.sqlite` in DB Browser for SQLite. The database is already populated. To rebuild it, execute `02_schema_sqlite.sql`, then `02_load_data_sqlite.sql`.
3. Run the queries in `02_queries_sqlite.sql`.
4. Run `03_model.ipynb` to regenerate `test_risk_scores.csv`.
5. Run `04_genai.ipynb` only after confirming Gemini API availability. It requires a new valid API key entered at runtime; never commit the key.

## Part 4 completion gate

The final Part 4 output must contain 10 rows × 8 columns in `notes_analysed.csv`; N004 must be `skipped_blank` with no API request; at least 7/9 nonblank labels must match the expected categories; the Pydantic red-team cases must fail as expected; V2 must return allowed categories for N007 and N009; total API calls must be 12–14 and below 25; the merged table must have 10 rows; and the reminder checks must pass (2/2 key forgotten/no-reminder notes and 5/10 notes linked to `reminder_sent=No`). The notebook contains assertions for these checks.

## Security and privacy

- The Gemini API key is requested at runtime and is not stored in this project folder.
- Never upload an API key to GitHub or paste it into chat.
- If a key has been exposed, revoke it and create a new one before continuing.
