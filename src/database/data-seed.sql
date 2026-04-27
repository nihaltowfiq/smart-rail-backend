-- ============================================================
-- SMART-RAIL COMPLETE SEED FILE
-- ============================================================
USE railway_system;

-- ============================================================
-- 1. STATIONS (10 rows)
-- ============================================================
INSERT INTO stations (station_name, city) VALUES
('Dhaka Station',      'Dhaka'),       -- station_id 1
('Chittagong Station', 'Chittagong'),  -- station_id 2
('Sylhet Station',     'Sylhet'),      -- station_id 3
('Rajshahi Station',   'Rajshahi'),    -- station_id 4
('Khulna Station',     'Khulna'),      -- station_id 5
('Barisal Station',    'Barisal'),     -- station_id 6
('Cumilla Station',    'Cumilla'),     -- station_id 7
('Noakhali Station',   'Noakhali'),    -- station_id 8
('Rangpur Station',    'Rangpur'),     -- station_id 9
('Mymensingh Station', 'Mymensingh'); -- station_id 10

-- ============================================================
-- 2. TRAINS (10 rows)
-- ============================================================
INSERT INTO trains (train_name, train_number) VALUES
('Suborno Express',   '701'),  -- train_id 1
('Turna Nishitha',    '702'),  -- train_id 2
('Mohanagar Express', '703'),  -- train_id 3
('Sonar Bangla',      '704'),  -- train_id 4
('Padma Express',     '705'),  -- train_id 5
('Jamuna Express',    '706'),  -- train_id 6
('Banalata Express',  '707'),  -- train_id 7
('Tista Express',     '708'),  -- train_id 8
('Drutojan Express',  '709'),  -- train_id 9
('Sundarban Express', '710');  -- train_id 10

-- ============================================================
-- 3. FARE RULES (2 rows)
-- ============================================================
INSERT INTO fare_rules (class_type, price_per_km) VALUES
('AC',     2.50),  -- fare_id 1
('NON_AC', 1.50);  -- fare_id 2

-- ============================================================
-- 4. ROUTES (10 rows)
-- ============================================================
INSERT INTO routes (source_station_id, destination_station_id, distance_km) VALUES
(1,  2,  300),  -- route_id 1:  Dhaka       → Chittagong
(1,  3,  250),  -- route_id 2:  Dhaka       → Sylhet
(1,  4,  260),  -- route_id 3:  Dhaka       → Rajshahi
(1,  5,  350),  -- route_id 4:  Dhaka       → Khulna
(1,  10, 120),  -- route_id 5:  Dhaka       → Mymensingh
(2,  3,  200),  -- route_id 6:  Chittagong  → Sylhet
(2,  7,  100),  -- route_id 7:  Chittagong  → Cumilla
(3,  10, 210),  -- route_id 8:  Sylhet      → Mymensingh
(4,  9,  180),  -- route_id 9:  Rajshahi    → Rangpur
(5,  6,  90);   -- route_id 10: Khulna      → Barisal

-- ============================================================
-- 5. SCHEDULES (10 rows)
-- Dhaka→Chittagong : trains 1, 2, 3
-- Dhaka→Sylhet     : trains 4, 5
-- Dhaka→Rajshahi   : trains 6, 7
-- Dhaka→Khulna     : train  8
-- Dhaka→Mymensingh : train  9
-- Chittagong→Sylhet: train  10
-- ============================================================
INSERT INTO schedules (train_id, route_id, departure_time, arrival_time) VALUES
(1,  1, '06:00:00', '11:00:00'),  -- schedule_id 1:  Suborno Express    Dhaka→Chittagong (morning)
(2,  1, '08:00:00', '13:00:00'),  -- schedule_id 2:  Turna Nishitha     Dhaka→Chittagong (morning)
(3,  1, '22:00:00', '03:00:00'),  -- schedule_id 3:  Mohanagar Express  Dhaka→Chittagong (night)
(4,  2, '07:00:00', '13:00:00'),  -- schedule_id 4:  Sonar Bangla       Dhaka→Sylhet
(5,  2, '15:00:00', '21:00:00'),  -- schedule_id 5:  Padma Express      Dhaka→Sylhet
(6,  3, '08:30:00', '14:00:00'),  -- schedule_id 6:  Jamuna Express     Dhaka→Rajshahi
(7,  3, '20:00:00', '01:30:00'),  -- schedule_id 7:  Banalata Express   Dhaka→Rajshahi (night)
(8,  4, '07:30:00', '15:30:00'),  -- schedule_id 8:  Tista Express      Dhaka→Khulna
(9,  5, '09:00:00', '11:00:00'),  -- schedule_id 9:  Drutojan Express   Dhaka→Mymensingh
(10, 6, '10:00:00', '14:00:00'); -- schedule_id 10: Sundarban Express  Chittagong→Sylhet

-- ============================================================
-- 6. TRAIN COACHES (60 rows — 6 coaches per train × 10 trains)
-- coach_id 1–6   → Train 1  (Suborno Express)
-- coach_id 7–12  → Train 2  (Turna Nishitha)
-- coach_id 13–18 → Train 3  (Mohanagar Express)
-- coach_id 19–24 → Train 4  (Sonar Bangla)
-- coach_id 25–30 → Train 5  (Padma Express)
-- coach_id 31–36 → Train 6  (Jamuna Express)
-- coach_id 37–42 → Train 7  (Banalata Express)
-- coach_id 43–48 → Train 8  (Tista Express)
-- coach_id 49–54 → Train 9  (Drutojan Express)
-- coach_id 55–60 → Train 10 (Sundarban Express)
-- ============================================================
INSERT INTO train_coaches (train_id, coach_label, class_type) VALUES
-- Train 1: Suborno Express (3 AC + 3 NON_AC)
(1, 'A', 'AC'),      -- coach_id 1
(1, 'B', 'AC'),      -- coach_id 2
(1, 'C', 'AC'),      -- coach_id 3
(1, 'D', 'NON_AC'),  -- coach_id 4
(1, 'E', 'NON_AC'),  -- coach_id 5
(1, 'F', 'NON_AC'),  -- coach_id 6
-- Train 2: Turna Nishitha (2 AC + 4 NON_AC)
(2, 'A', 'AC'),      -- coach_id 7
(2, 'B', 'AC'),      -- coach_id 8
(2, 'C', 'NON_AC'),  -- coach_id 9
(2, 'D', 'NON_AC'),  -- coach_id 10
(2, 'E', 'NON_AC'),  -- coach_id 11
(2, 'F', 'NON_AC'),  -- coach_id 12
-- Train 3: Mohanagar Express (3 AC + 3 NON_AC)
(3, 'A', 'AC'),      -- coach_id 13
(3, 'B', 'AC'),      -- coach_id 14
(3, 'C', 'AC'),      -- coach_id 15
(3, 'D', 'NON_AC'),  -- coach_id 16
(3, 'E', 'NON_AC'),  -- coach_id 17
(3, 'F', 'NON_AC'),  -- coach_id 18
-- Train 4: Sonar Bangla (4 AC + 2 NON_AC)
(4, 'A', 'AC'),      -- coach_id 19
(4, 'B', 'AC'),      -- coach_id 20
(4, 'C', 'AC'),      -- coach_id 21
(4, 'D', 'AC'),      -- coach_id 22
(4, 'E', 'NON_AC'),  -- coach_id 23
(4, 'F', 'NON_AC'),  -- coach_id 24
-- Train 5: Padma Express (2 AC + 4 NON_AC)
(5, 'A', 'AC'),      -- coach_id 25
(5, 'B', 'AC'),      -- coach_id 26
(5, 'C', 'NON_AC'),  -- coach_id 27
(5, 'D', 'NON_AC'),  -- coach_id 28
(5, 'E', 'NON_AC'),  -- coach_id 29
(5, 'F', 'NON_AC'),  -- coach_id 30
-- Train 6: Jamuna Express (3 AC + 3 NON_AC)
(6, 'A', 'AC'),      -- coach_id 31
(6, 'B', 'AC'),      -- coach_id 32
(6, 'C', 'AC'),      -- coach_id 33
(6, 'D', 'NON_AC'),  -- coach_id 34
(6, 'E', 'NON_AC'),  -- coach_id 35
(6, 'F', 'NON_AC'),  -- coach_id 36
-- Train 7: Banalata Express (2 AC + 4 NON_AC)
(7, 'A', 'AC'),      -- coach_id 37
(7, 'B', 'AC'),      -- coach_id 38
(7, 'C', 'NON_AC'),  -- coach_id 39
(7, 'D', 'NON_AC'),  -- coach_id 40
(7, 'E', 'NON_AC'),  -- coach_id 41
(7, 'F', 'NON_AC'),  -- coach_id 42
-- Train 8: Tista Express (3 AC + 3 NON_AC)
(8, 'A', 'AC'),      -- coach_id 43
(8, 'B', 'AC'),      -- coach_id 44
(8, 'C', 'AC'),      -- coach_id 45
(8, 'D', 'NON_AC'),  -- coach_id 46
(8, 'E', 'NON_AC'),  -- coach_id 47
(8, 'F', 'NON_AC'),  -- coach_id 48
-- Train 9: Drutojan Express (2 AC + 4 NON_AC)
(9, 'A', 'AC'),      -- coach_id 49
(9, 'B', 'AC'),      -- coach_id 50
(9, 'C', 'NON_AC'),  -- coach_id 51
(9, 'D', 'NON_AC'),  -- coach_id 52
(9, 'E', 'NON_AC'),  -- coach_id 53
(9, 'F', 'NON_AC'),  -- coach_id 54
-- Train 10: Sundarban Express (3 AC + 3 NON_AC)
(10, 'A', 'AC'),     -- coach_id 55
(10, 'B', 'AC'),     -- coach_id 56
(10, 'C', 'AC'),     -- coach_id 57
(10, 'D', 'NON_AC'), -- coach_id 58
(10, 'E', 'NON_AC'), -- coach_id 59
(10, 'F', 'NON_AC'); -- coach_id 60

-- ============================================================
-- 7. SEATS (7200 rows — 120 seats × 60 coaches)
-- Using stored procedure to keep the file clean
-- ============================================================
INSERT INTO seats (coach_id, seat_number)
WITH RECURSIVE coach_seq AS (
  SELECT 1 AS coach_id
  UNION ALL
  SELECT coach_id + 1 FROM coach_seq WHERE coach_id < 60
),
seat_seq AS (
  SELECT 1 AS seat_number
  UNION ALL
  SELECT seat_number + 1 FROM seat_seq WHERE seat_number < 120
)
SELECT c.coach_id, s.seat_number
FROM coach_seq c
CROSS JOIN seat_seq s
ORDER BY c.coach_id, s.seat_number;

-- ============================================================
-- 8. TRAIN RUNNING DAYS (70 rows — 7 days × 10 trains)
-- Each train has exactly 1 off day per week
-- ============================================================
INSERT INTO train_running_days (train_id, day_of_week, is_off) VALUES
-- Train 1: Suborno Express — off Friday
(1, 'SUN', FALSE), (1, 'MON', FALSE), (1, 'TUE', FALSE), (1, 'WED', FALSE), (1, 'THU', FALSE), (1, 'FRI', TRUE),  (1, 'SAT', FALSE),
-- Train 2: Turna Nishitha — off Saturday
(2, 'SUN', FALSE), (2, 'MON', FALSE), (2, 'TUE', FALSE), (2, 'WED', FALSE), (2, 'THU', FALSE), (2, 'FRI', FALSE), (2, 'SAT', TRUE),
-- Train 3: Mohanagar Express — off Sunday
(3, 'SUN', TRUE),  (3, 'MON', FALSE), (3, 'TUE', FALSE), (3, 'WED', FALSE), (3, 'THU', FALSE), (3, 'FRI', FALSE), (3, 'SAT', FALSE),
-- Train 4: Sonar Bangla — off Monday
(4, 'SUN', FALSE), (4, 'MON', TRUE),  (4, 'TUE', FALSE), (4, 'WED', FALSE), (4, 'THU', FALSE), (4, 'FRI', FALSE), (4, 'SAT', FALSE),
-- Train 5: Padma Express — off Tuesday
(5, 'SUN', FALSE), (5, 'MON', FALSE), (5, 'TUE', TRUE),  (5, 'WED', FALSE), (5, 'THU', FALSE), (5, 'FRI', FALSE), (5, 'SAT', FALSE),
-- Train 6: Jamuna Express — off Wednesday
(6, 'SUN', FALSE), (6, 'MON', FALSE), (6, 'TUE', FALSE), (6, 'WED', TRUE),  (6, 'THU', FALSE), (6, 'FRI', FALSE), (6, 'SAT', FALSE),
-- Train 7: Banalata Express — off Thursday
(7, 'SUN', FALSE), (7, 'MON', FALSE), (7, 'TUE', FALSE), (7, 'WED', FALSE), (7, 'THU', TRUE),  (7, 'FRI', FALSE), (7, 'SAT', FALSE),
-- Train 8: Tista Express — off Friday
(8, 'SUN', FALSE), (8, 'MON', FALSE), (8, 'TUE', FALSE), (8, 'WED', FALSE), (8, 'THU', FALSE), (8, 'FRI', TRUE),  (8, 'SAT', FALSE),
-- Train 9: Drutojan Express — off Saturday
(9, 'SUN', FALSE), (9, 'MON', FALSE), (9, 'TUE', FALSE), (9, 'WED', FALSE), (9, 'THU', FALSE), (9, 'FRI', FALSE), (9, 'SAT', TRUE),
-- Train 10: Sundarban Express — off Sunday
(10,'SUN', TRUE),  (10,'MON', FALSE), (10,'TUE', FALSE), (10,'WED', FALSE), (10,'THU', FALSE), (10,'FRI', FALSE), (10,'SAT', FALSE);

-- ============================================================
-- 9. USERS (10 rows — 9 users + 1 admin)
-- All passwords are bcrypt hash of: 123456
-- ============================================================
INSERT INTO users (name, phone, password, role) VALUES
('Rahim Uddin',   '01711111111', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user'),
('Karim Hossain', '01711111112', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user'),
('Nasrin Akter',  '01711111113', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user'),
('Jamal Uddin',   '01711111114', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user'),
('Sadia Islam',   '01711111115', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user'),
('Tanjim Ahmed',  '01711111116', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user'),
('Roksana Begum', '01711111117', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user'),
('Farhan Kabir',  '01711111118', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user'),
('Mitu Rani Das', '01711111119', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user'),
('Kazi Nihal Towfiq', '01610742596', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user'),
('Admin User',    '01790831130', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin');

-- ============================================================
-- SEED COMPLETE — SUMMARY
-- ============================================================
-- stations           : 10   rows
-- trains             : 10   rows
-- fare_rules         :  2   rows
-- routes             : 10   rows
-- schedules          : 10   rows
-- train_coaches      : 60   rows  (6 per train × 10 trains)
-- seats              : 7200 rows  (120 per coach × 60 coaches)
-- train_running_days : 70   rows  (7 days × 10 trains)
-- users              : 10   rows  (9 user + 1 admin)
-- ============================================================
-- SEARCH TEST CASES:
-- from=1 to=2  (Dhaka→Chittagong)  → trains 1,2,3  (3 results)
-- from=1 to=3  (Dhaka→Sylhet)      → trains 4,5    (2 results)
-- from=1 to=4  (Dhaka→Rajshahi)    → trains 6,7    (2 results)
-- from=1 to=5  (Dhaka→Khulna)      → train  8      (1 result)
-- from=1 to=10 (Dhaka→Mymensingh)  → train  9      (1 result)
-- from=2 to=3  (Ctg→Sylhet)        → train  10     (1 result)
-- ============================================================
-- FARE EXAMPLES (per seat):
-- Dhaka→Chittagong  AC     : 300 × 2.50 =  750.00 BDT
-- Dhaka→Chittagong  NON_AC : 300 × 1.50 =  450.00 BDT
-- Dhaka→Sylhet      AC     : 250 × 2.50 =  625.00 BDT
-- Dhaka→Sylhet      NON_AC : 250 × 1.50 =  375.00 BDT
-- Dhaka→Rajshahi    AC     : 260 × 2.50 =  650.00 BDT
-- Dhaka→Rajshahi    NON_AC : 260 × 1.50 =  390.00 BDT
-- Dhaka→Khulna      AC     : 350 × 2.50 =  875.00 BDT
-- Dhaka→Khulna      NON_AC : 350 × 1.50 =  525.00 BDT
-- Dhaka→Mymensingh  AC     : 120 × 2.50 =  300.00 BDT
-- Dhaka→Mymensingh  NON_AC : 120 × 1.50 =  180.00 BDT
-- Ctg→Sylhet        AC     : 200 × 2.50 =  500.00 BDT
-- Ctg→Sylhet        NON_AC : 200 × 1.50 =  300.00 BDT
-- ============================================================
-- OFF DAYS:
-- Train 1  Suborno Express    → FRI
-- Train 2  Turna Nishitha     → SAT
-- Train 3  Mohanagar Express  → SUN
-- Train 4  Sonar Bangla       → MON
-- Train 5  Padma Express      → TUE
-- Train 6  Jamuna Express     → WED
-- Train 7  Banalata Express   → THU
-- Train 8  Tista Express      → FRI
-- Train 9  Drutojan Express   → SAT
-- Train 10 Sundarban Express  → SUN
-- ============================================================
-- LOGIN:
-- password (all accounts) : 123456
-- users  : 01711111111 → 01711111119
-- admin  : 01711111120
-- ============================================================