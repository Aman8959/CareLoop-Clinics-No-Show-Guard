-- CareLoop Clinics — No-Show Guard | SQLite
-- Task 2.1 verification
SELECT COUNT(*) AS appointments, SUM(no_show) AS no_shows FROM appointments;
SELECT COUNT(*) AS clinics FROM clinics;
-- Optional duplicate-key test (run separately; expected SQLite UNIQUE constraint failure):
-- INSERT INTO appointments SELECT * FROM appointments WHERE appointment_id='A0001';

-- Task 2.2: clinic rates, HAVING threshold
SELECT c.clinic_name,c.city,COUNT(*) AS appointments,SUM(a.no_show) AS no_shows,
 ROUND(100.0*SUM(a.no_show)/COUNT(*),1) AS no_show_pct
FROM appointments a JOIN clinics c ON c.clinic_id=a.clinic_id
GROUP BY c.clinic_id,c.clinic_name,c.city
HAVING COUNT(*)>=95
ORDER BY no_show_pct DESC;

-- Task 2.2: all eight clinics (Gomti Nagar has 90 appointments)
SELECT c.clinic_name,c.city,COUNT(*) AS appointments,SUM(a.no_show) AS no_shows,
 ROUND(100.0*SUM(a.no_show)/COUNT(*),1) AS no_show_pct
FROM appointments a JOIN clinics c ON c.clinic_id=a.clinic_id
GROUP BY c.clinic_id,c.clinic_name,c.city
ORDER BY no_show_pct DESC;

-- Task 2.3: lead-time buckets (inclusive upper bounds)
SELECT CASE
 WHEN lead_days BETWEEN 1 AND 7 THEN '1-7'
 WHEN lead_days BETWEEN 8 AND 14 THEN '8-14'
 WHEN lead_days BETWEEN 15 AND 30 THEN '15-30'
 WHEN lead_days>=31 THEN '31+'
 ELSE 'Outside specified buckets' END AS lead_time_bucket,
 COUNT(*) AS appointments,SUM(no_show) AS no_shows,
 ROUND(100.0*SUM(no_show)/COUNT(*),1) AS no_show_pct
FROM appointments
GROUP BY lead_time_bucket
ORDER BY MIN(lead_days);

-- Task 2.4: monthly trend and percentage-point movement
WITH monthly AS (
 SELECT SUBSTR(appt_date,1,7) AS month,
 COUNT(*) AS appointments,
 ROUND(100.0*SUM(no_show)/COUNT(*),1) AS no_show_pct
 FROM appointments GROUP BY SUBSTR(appt_date,1,7)
), monthly_lag AS (
 SELECT month,appointments,no_show_pct,
 LAG(no_show_pct) OVER(ORDER BY month) AS prior_month_pct
 FROM monthly
)
SELECT month,appointments,no_show_pct,
 ROUND(no_show_pct-prior_month_pct,1) AS mom_change_pp
FROM monthly_lag ORDER BY month;

-- Task 2.5: rank clinics within city and compare with overall no-show rate
WITH clinic_rates AS (
 SELECT c.clinic_name AS clinic,c.city,
 ROUND(100.0*SUM(a.no_show)/COUNT(*),2) AS no_show_pct
 FROM appointments a JOIN clinics c ON c.clinic_id=a.clinic_id
 GROUP BY c.clinic_id,c.clinic_name,c.city
), ranked AS (
 SELECT clinic,city,no_show_pct,
 RANK() OVER(PARTITION BY city ORDER BY no_show_pct DESC) AS rank_in_city
 FROM clinic_rates
)
SELECT clinic,city,no_show_pct,rank_in_city,
 CASE WHEN no_show_pct>(SELECT 100.0*AVG(no_show) FROM appointments) THEN 'above'
      WHEN no_show_pct<(SELECT 100.0*AVG(no_show) FROM appointments) THEN 'below'
      ELSE 'equal' END AS vs_overall
FROM ranked ORDER BY city,rank_in_city;
