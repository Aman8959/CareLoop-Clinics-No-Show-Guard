# CareLoop Clinics — No-Show Guard

> **GitHub repository:** https://github.com/Aman8959/CareLoop-Clinics-No-Show-Guard.git

## Project summary
- **Part 1 — Data preparation:** cleaned 990 appointments; retained 218 no-shows (22.0%).
- **Part 2 — SQL analysis:** analysed 8 clinics; Gomti Nagar recorded 33.3% no-shows across 90 appointments.
- **Part 3 — Prediction:** Logistic Regression achieved training 5-fold CV ROC-AUC ≈ 0.774 and held-out test ROC-AUC ≈ 0.789; operating threshold = 0.35.
- **Part 4 — GenAI review:** analysed 10 notes; 9/9 nonblank classifications agreed with the expected categories; 5/10 linked appointments had no reminder.

## Executive recommendation
CareLoop should prioritize appointments with long booking lead times and a history of missed visits for proactive confirmation: 296 of 990 appointments (29.9%) were booked more than 14 days ahead, and the 31+ day lead-time segment had a 60.5% no-show rate in the SQL analysis. The overall dataset contained 218 no-shows out of 990 appointments (22.0%), while Gomti Nagar had a 33.3% rate across 90 appointments. The Logistic Regression model is the preferred first-pass ranking model (CV ROC-AUC 0.774; test ROC-AUC 0.789); at threshold 0.35 it flags 49 of 198 held-out appointments for outreach. The call-centre should first confirm high-risk, long-lead appointments, offer rescheduling, and use the follow-up themes to address reminder delivery, transport access, affordability, illness, and work conflicts. GenAI classifications should support—not replace—staff review.

## Model choice and operating threshold
Logistic Regression was selected because it had the strongest 5-fold training CV ROC-AUC among the compared models (approximately 0.774) and achieved held-out ROC-AUC of approximately 0.789. The 0.35 threshold was selected using training-fold out-of-fold predictions to improve recall and F1; the held-out test set was evaluated once. Clinics should calibrate the operational threshold against call-centre capacity and the cost of empty appointment slots.

## Part 4 — Note review
- `notes_analysed.csv` contains 10 rows and 8 columns; N004 is recorded as `skipped_blank` with no API request.
- Expected-label agreement: 9/9 nonblank notes.
- Linked appointments with `reminder_sent=No`: 5/10.
- Actual Gemini API requests across Tasks 4.1–4.3: 13.

## Execution order
1. Run `01_ingest_clean.ipynb` to generate the cleaned data files.
2. Run the SQL schema/load/query scripts using the database engine specified in the project instructions.
3. Run `03_model.ipynb` to generate `test_risk_scores.csv`.
4. Run this notebook with a valid Gemini API key to generate `notes_analysed.csv` and this README.

## Limitations
1. Imputation and IQR outlier capping were performed before the train/test split, which can introduce preprocessing leakage.
2. The random row split may place appointments from the same patient in both train and test sets, making generalization to unseen patients look better than it is.
3. The dataset is observational; reminder associations and model feature effects do not establish causality.
4. The GenAI review uses only 10 notes, so its themes are illustrative and require human verification before operational use.


