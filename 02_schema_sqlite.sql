-- CareLoop Clinics — No-Show Guard | SQLite
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS clinics;

CREATE TABLE clinics (
    clinic_id TEXT PRIMARY KEY,
    clinic_name TEXT NOT NULL,
    city TEXT NOT NULL,
    tier TEXT,
    latitude REAL,
    longitude REAL,
    temp_c REAL
);

CREATE TABLE appointments (
    appointment_id TEXT PRIMARY KEY,
    patient_id TEXT NOT NULL,
    clinic_id TEXT NOT NULL,
    booked_on TEXT NOT NULL,
    appt_date TEXT NOT NULL,
    age INTEGER NOT NULL,
    gender TEXT,
    distance_km REAL,
    fee_inr INTEGER,
    booking_channel TEXT,
    visit_type TEXT,
    reminder_sent TEXT,
    prior_no_shows INTEGER,
    status TEXT NOT NULL,
    lead_days INTEGER,
    no_show INTEGER NOT NULL CHECK (no_show IN (0, 1)),
    FOREIGN KEY (clinic_id) REFERENCES clinics(clinic_id)
);
