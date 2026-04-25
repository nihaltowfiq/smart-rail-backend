-- ============================================================
-- SMART-RAIL COMPLETE SEED FILE
-- ============================================================

USE railway_system;

-- ============================================================
-- 1. STATIONS (10 stations)
-- ============================================================
INSERT INTO stations (station_name, city) VALUES
('Dhaka Station',      'Dhaka'),
('Chittagong Station', 'Chittagong'),
('Sylhet Station',     'Sylhet'),
('Rajshahi Station',   'Rajshahi'),
('Khulna Station',     'Khulna'),
('Barisal Station',    'Barisal'),
('Cumilla Station',    'Cumilla'),
('Noakhali Station',   'Noakhali'),
('Rangpur Station',    'Rangpur'),
('Mymensingh Station', 'Mymensingh');

-- ============================================================
-- 2. TRAINS (10 trains)
-- ============================================================
INSERT INTO trains (train_name, train_number) VALUES
('Suborno Express',   '701'),
('Turna Nishitha',    '702'),
('Mohanagar Express', '703'),
('Sonar Bangla',      '704'),
('Padma Express',     '705'),
('Jamuna Express',    '706'),
('Banalata Express',  '707'),
('Tista Express',     '708'),
('Drutojan Express',  '709'),
('Sundarban Express', '710');

-- ============================================================
-- 3. FARE RULES
-- ============================================================
INSERT INTO fare_rules (class_type, price_per_km) VALUES
('AC',     2.50),
('NON_AC', 1.50);

-- ============================================================
-- 4. ROUTES
-- Route map:
--   1→2  Dhaka      → Chittagong  300km
--   1→3  Dhaka      → Sylhet      250km
--   1→4  Dhaka      → Rajshahi    260km
--   1→5  Dhaka      → Khulna      350km
--   1→10 Dhaka      → Mymensingh  120km
--   2→3  Chittagong → Sylhet      200km
--   2→7  Chittagong → Cumilla     100km
--   3→10 Sylhet     → Mymensingh  210km
--   4→9  Rajshahi   → Rangpur     180km
--   5→6  Khulna     → Barisal     90km
-- ============================================================
INSERT INTO routes (source_station_id, destination_station_id, distance_km) VALUES
(1,  2,  300),   -- route_id 1:  Dhaka → Chittagong
(1,  3,  250),   -- route_id 2:  Dhaka → Sylhet
(1,  4,  260),   -- route_id 3:  Dhaka → Rajshahi
(1,  5,  350),   -- route_id 4:  Dhaka → Khulna
(1,  10, 120),   -- route_id 5:  Dhaka → Mymensingh
(2,  3,  200),   -- route_id 6:  Chittagong → Sylhet
(2,  7,  100),   -- route_id 7:  Chittagong → Cumilla
(3,  10, 210),   -- route_id 8:  Sylhet → Mymensingh
(4,  9,  180),   -- route_id 9:  Rajshahi → Rangpur
(5,  6,  90);    -- route_id 10: Khulna → Barisal

-- ============================================================
-- 5. SCHEDULES
-- (fare_id removed — fare resolved dynamically by class_type)
-- Multiple trains assigned per popular route for rich search results
--
-- Route 1 (Dhaka→Chittagong): trains 1,2,3
-- Route 2 (Dhaka→Sylhet):     trains 4,5
-- Route 3 (Dhaka→Rajshahi):   trains 6,7
-- Route 4 (Dhaka→Khulna):     train  8
-- Route 5 (Dhaka→Mymensingh): train  9
-- Route 6 (Ctg→Sylhet):       train  10
-- ============================================================
INSERT INTO schedules (train_id, route_id, departure_time, arrival_time) VALUES
(1,  1, '06:00:00', '11:00:00'),  -- schedule_id 1:  Suborno Express   Dhaka→Chittagong
(2,  1, '08:00:00', '13:00:00'),  -- schedule_id 2:  Turna Nishitha    Dhaka→Chittagong
(3,  1, '22:00:00', '03:00:00'),  -- schedule_id 3:  Mohanagar Express Dhaka→Chittagong (night)
(4,  2, '07:00:00', '13:00:00'),  -- schedule_id 4:  Sonar Bangla      Dhaka→Sylhet
(5,  2, '15:00:00', '21:00:00'),  -- schedule_id 5:  Padma Express     Dhaka→Sylhet
(6,  3, '08:30:00', '14:00:00'),  -- schedule_id 6:  Jamuna Express    Dhaka→Rajshahi
(7,  3, '20:00:00', '01:30:00'),  -- schedule_id 7:  Banalata Express  Dhaka→Rajshahi (night)
(8,  4, '07:30:00', '15:30:00'),  -- schedule_id 8:  Tista Express     Dhaka→Khulna
(9,  5, '09:00:00', '11:00:00'),  -- schedule_id 9:  Drutojan Express  Dhaka→Mymensingh
(10, 6, '10:00:00', '14:00:00');  -- schedule_id 10: Sundarban Express Chittagong→Sylhet

-- ============================================================
-- 6. TRAIN COACHES
-- Every train has 6 coaches (mix of AC and NON_AC)
-- coach_id will be 1–60 (6 coaches × 10 trains)
--
-- Train 1  (Suborno Express):   coaches 1–6
-- Train 2  (Turna Nishitha):    coaches 7–12
-- Train 3  (Mohanagar Express): coaches 13–18
-- Train 4  (Sonar Bangla):      coaches 19–24
-- Train 5  (Padma Express):     coaches 25–30
-- Train 6  (Jamuna Express):    coaches 31–36
-- Train 7  (Banalata Express):  coaches 37–42
-- Train 8  (Tista Express):     coaches 43–48
-- Train 9  (Drutojan Express):  coaches 49–54
-- Train 10 (Sundarban Express): coaches 55–60
-- ============================================================
INSERT INTO train_coaches (train_id, coach_label, class_type) VALUES
-- Train 1: Suborno Express (3 AC + 3 NON_AC)
(1, 'A', 'AC'),     -- coach_id 1
(1, 'B', 'AC'),     -- coach_id 2
(1, 'C', 'AC'),     -- coach_id 3
(1, 'D', 'NON_AC'), -- coach_id 4
(1, 'E', 'NON_AC'), -- coach_id 5
(1, 'F', 'NON_AC'), -- coach_id 6
-- Train 2: Turna Nishitha (2 AC + 4 NON_AC)
(2, 'A', 'AC'),     -- coach_id 7
(2, 'B', 'AC'),     -- coach_id 8
(2, 'C', 'NON_AC'), -- coach_id 9
(2, 'D', 'NON_AC'), -- coach_id 10
(2, 'E', 'NON_AC'), -- coach_id 11
(2, 'F', 'NON_AC'), -- coach_id 12
-- Train 3: Mohanagar Express (3 AC + 3 NON_AC)
(3, 'A', 'AC'),     -- coach_id 13
(3, 'B', 'AC'),     -- coach_id 14
(3, 'C', 'AC'),     -- coach_id 15
(3, 'D', 'NON_AC'), -- coach_id 16
(3, 'E', 'NON_AC'), -- coach_id 17
(3, 'F', 'NON_AC'), -- coach_id 18
-- Train 4: Sonar Bangla (4 AC + 2 NON_AC)
(4, 'A', 'AC'),     -- coach_id 19
(4, 'B', 'AC'),     -- coach_id 20
(4, 'C', 'AC'),     -- coach_id 21
(4, 'D', 'AC'),     -- coach_id 22
(4, 'E', 'NON_AC'), -- coach_id 23
(4, 'F', 'NON_AC'), -- coach_id 24
-- Train 5: Padma Express (2 AC + 4 NON_AC)
(5, 'A', 'AC'),     -- coach_id 25
(5, 'B', 'AC'),     -- coach_id 26
(5, 'C', 'NON_AC'), -- coach_id 27
(5, 'D', 'NON_AC'), -- coach_id 28
(5, 'E', 'NON_AC'), -- coach_id 29
(5, 'F', 'NON_AC'), -- coach_id 30
-- Train 6: Jamuna Express (3 AC + 3 NON_AC)
(6, 'A', 'AC'),     -- coach_id 31
(6, 'B', 'AC'),     -- coach_id 32
(6, 'C', 'AC'),     -- coach_id 33
(6, 'D', 'NON_AC'), -- coach_id 34
(6, 'E', 'NON_AC'), -- coach_id 35
(6, 'F', 'NON_AC'), -- coach_id 36
-- Train 7: Banalata Express (2 AC + 4 NON_AC)
(7, 'A', 'AC'),     -- coach_id 37
(7, 'B', 'AC'),     -- coach_id 38
(7, 'C', 'NON_AC'), -- coach_id 39
(7, 'D', 'NON_AC'), -- coach_id 40
(7, 'E', 'NON_AC'), -- coach_id 41
(7, 'F', 'NON_AC'), -- coach_id 42
-- Train 8: Tista Express (3 AC + 3 NON_AC)
(8, 'A', 'AC'),     -- coach_id 43
(8, 'B', 'AC'),     -- coach_id 44
(8, 'C', 'AC'),     -- coach_id 45
(8, 'D', 'NON_AC'), -- coach_id 46
(8, 'E', 'NON_AC'), -- coach_id 47
(8, 'F', 'NON_AC'), -- coach_id 48
-- Train 9: Drutojan Express (2 AC + 4 NON_AC)
(9, 'A', 'AC'),     -- coach_id 49
(9, 'B', 'AC'),     -- coach_id 50
(9, 'C', 'NON_AC'), -- coach_id 51
(9, 'D', 'NON_AC'), -- coach_id 52
(9, 'E', 'NON_AC'), -- coach_id 53
(9, 'F', 'NON_AC'), -- coach_id 54
-- Train 10: Sundarban Express (3 AC + 3 NON_AC)
(10, 'A', 'AC'),    -- coach_id 55
(10, 'B', 'AC'),    -- coach_id 56
(10, 'C', 'AC'),    -- coach_id 57
(10, 'D', 'NON_AC'),-- coach_id 58
(10, 'E', 'NON_AC'),-- coach_id 59
(10, 'F', 'NON_AC');-- coach_id 60

-- ============================================================
-- 7. SEATS (120 seats per coach × 60 coaches = 7200 seats)
-- Using stored procedure to avoid 7200 lines of INSERT
-- ============================================================
DROP PROCEDURE IF EXISTS generate_seats;
DELIMITER $$
CREATE PROCEDURE generate_seats()
BEGIN
  DECLARE c INT DEFAULT 1;
  DECLARE s INT DEFAULT 1;
  WHILE c <= 60 DO
    SET s = 1;
    WHILE s <= 120 DO
      INSERT INTO seats (coach_id, seat_number) VALUES (c, s);
      SET s = s + 1;
    END WHILE;
    SET c = c + 1;
  END WHILE;
END$$
DELIMITER ;
CALL generate_seats();
DROP PROCEDURE IF EXISTS generate_seats;

-- ============================================================
-- 8. TRAIN RUNNING DAYS
-- Every train has all 7 days — exactly 1 off day per train
-- Train 1  off: FRI  | Train 2  off: SAT  | Train 3  off: SUN
-- Train 4  off: MON  | Train 5  off: TUE  | Train 6  off: WED
-- Train 7  off: THU  | Train 8  off: FRI  | Train 9  off: SAT
-- Train 10 off: SUN
-- ============================================================
INSERT INTO train_running_days (train_id, day_of_week, is_off) VALUES
-- Train 1: Suborno Express — off Friday
(1,'SUN',FALSE),(1,'MON',FALSE),(1,'TUE',FALSE),(1,'WED',FALSE),(1,'THU',FALSE),(1,'FRI',TRUE),(1,'SAT',FALSE),
-- Train 2: Turna Nishitha — off Saturday
(2,'SUN',FALSE),(2,'MON',FALSE),(2,'TUE',FALSE),(2,'WED',FALSE),(2,'THU',FALSE),(2,'FRI',FALSE),(2,'SAT',TRUE),
-- Train 3: Mohanagar Express — off Sunday
(3,'SUN',TRUE),(3,'MON',FALSE),(3,'TUE',FALSE),(3,'WED',FALSE),(3,'THU',FALSE),(3,'FRI',FALSE),(3,'SAT',FALSE),
-- Train 4: Sonar Bangla — off Monday
(4,'SUN',FALSE),(4,'MON',TRUE),(4,'TUE',FALSE),(4,'WED',FALSE),(4,'THU',FALSE),(4,'FRI',FALSE),(4,'SAT',FALSE),
-- Train 5: Padma Express — off Tuesday
(5,'SUN',FALSE),(5,'MON',FALSE),(5,'TUE',TRUE),(5,'WED',FALSE),(5,'THU',FALSE),(5,'FRI',FALSE),(5,'SAT',FALSE),
-- Train 6: Jamuna Express — off Wednesday
(6,'SUN',FALSE),(6,'MON',FALSE),(6,'TUE',FALSE),(6,'WED',TRUE),(6,'THU',FALSE),(6,'FRI',FALSE),(6,'SAT',FALSE),
-- Train 7: Banalata Express — off Thursday
(7,'SUN',FALSE),(7,'MON',FALSE),(7,'TUE',FALSE),(7,'WED',FALSE),(7,'THU',TRUE),(7,'FRI',FALSE),(7,'SAT',FALSE),
-- Train 8: Tista Express — off Friday
(8,'SUN',FALSE),(8,'MON',FALSE),(8,'TUE',FALSE),(8,'WED',FALSE),(8,'THU',FALSE),(8,'FRI',TRUE),(8,'SAT',FALSE),
-- Train 9: Drutojan Express — off Saturday
(9,'SUN',FALSE),(9,'MON',FALSE),(9,'TUE',FALSE),(9,'WED',FALSE),(9,'THU',FALSE),(9,'FRI',FALSE),(9,'SAT',TRUE),
-- Train 10: Sundarban Express — off Sunday
(10,'SUN',TRUE),(10,'MON',FALSE),(10,'TUE',FALSE),(10,'WED',FALSE),(10,'THU',FALSE),(10,'FRI',FALSE),(10,'SAT',FALSE);

-- ============================================================
-- 9. USERS
-- NOTE: Passwords below are bcrypt hashes of '123456'
-- All real users must register via /auth/signup (bcrypt enforced)
-- Plain text '123456' → bcrypt hash used here for API compatibility
-- ============================================================
INSERT INTO users (phone, password, role) VALUES
('01711111111', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user'),
('01711111112', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user'),
('01711111113', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user'),
('01711111114', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user'),
('01711111115', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user'),
('01711111116', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user'),
('01711111117', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user'),
('01711111118', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user'),
('01711111119', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user'),
('01711111120', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin');

-- ============================================================
-- SEED COMPLETE — SUMMARY
-- ============================================================
-- stations:          10 rows
-- trains:            10 rows
-- fare_rules:         2 rows
-- routes:            10 rows
-- schedules:         10 rows  (multiple trains per popular route)
-- train_coaches:     60 rows  (6 coaches per train × 10 trains)
-- seats:           7200 rows  (120 seats per coach × 60 coaches)
-- train_running_days: 70 rows (7 days × 10 trains, 1 off day each)
-- users:             10 rows  (9 users + 1 admin, bcrypt hashed)
-- ============================================================
-- ROUTE COVERAGE FOR SEARCH TESTING:
-- Dhaka→Chittagong  : trains 1, 2, 3  (3 options)
-- Dhaka→Sylhet      : trains 4, 5     (2 options)
-- Dhaka→Rajshahi    : trains 6, 7     (2 options)
-- Dhaka→Khulna      : train  8        (1 option)
-- Dhaka→Mymensingh  : train  9        (1 option)
-- Chittagong→Sylhet : train  10       (1 option)
-- ============================================================
-- OFF DAY SCHEDULE:
-- Train 1 (Suborno Express)   → off FRI
-- Train 2 (Turna Nishitha)    → off SAT
-- Train 3 (Mohanagar Express) → off SUN
-- Train 4 (Sonar Bangla)      → off MON
-- Train 5 (Padma Express)     → off TUE
-- Train 6 (Jamuna Express)    → off WED
-- Train 7 (Banalata Express)  → off THU
-- Train 8 (Tista Express)     → off FRI
-- Train 9 (Drutojan Express)  → off SAT
-- Train 10 (Sundarban Express)→ off SUN
-- ============================================================
-- LOGIN CREDENTIALS (all users):
-- phone: 01711111111 to 01711111120
-- password: 123456
-- admin: 01711111120 / 123456
-- ============================================================

-- INSERT INTO stations (station_name, city) VALUES
-- ('Dhaka Station','Dhaka'),
-- ('Chittagong Station','Chittagong'),
-- ('Sylhet Station','Sylhet'),
-- ('Rajshahi Station','Rajshahi'),
-- ('Khulna Station','Khulna'),
-- ('Barisal Station','Barisal'),
-- ('Cumilla Station','Cumilla'),
-- ('Noakhali Station','Noakhali'),
-- ('Rangpur Station','Rangpur'),
-- ('Mymensingh Station','Mymensingh');

-- INSERT INTO trains (train_name, train_number) VALUES
-- ('Suborno Express','701'),
-- ('Turna Nishitha','702'),
-- ('Mohanagar Express','703'),
-- ('Sonar Bangla','704'),
-- ('Padma Express','705'),
-- ('Jamuna Express','706'),
-- ('Banalata Express','707'),
-- ('Tista Express','708'),
-- ('Drutojan Express','709'),
-- ('Sundarban Express','710');

-- INSERT INTO fare_rules (class_type, price_per_km) VALUES
-- ('AC',2.5),
-- ('NON_AC',1.5);

-- INSERT INTO routes (source_station_id,destination_station_id,distance_km) VALUES
-- (1,2,300),
-- (1,3,250),
-- (2,3,200),
-- (2,4,280),
-- (3,5,260),
-- (4,5,220),
-- (5,6,210),
-- (6,7,180),
-- (7,8,160),
-- (8,9,140);

-- INSERT INTO schedules (train_id,route_id,fare_id,departure_time,arrival_time) VALUES
-- (1,1,1,'08:00:00','12:00:00'),
-- (2,2,2,'09:00:00','13:00:00'),
-- (3,3,1,'10:00:00','14:00:00'),
-- (4,4,2,'11:00:00','15:00:00'),
-- (5,5,1,'12:00:00','16:00:00'),
-- (6,6,2,'13:00:00','17:00:00'),
-- (7,7,1,'14:00:00','18:00:00'),
-- (8,8,2,'15:00:00','19:00:00'),
-- (9,9,1,'16:00:00','20:00:00'),
-- (10,10,2,'17:00:00','21:00:00');

-- INSERT INTO train_coaches (train_id,coach_label,class_type) VALUES
-- (1,'A','AC'),
-- (1,'B','AC'),
-- (1,'C','NON_AC'),
-- (2,'A','NON_AC'),
-- (2,'B','NON_AC'),
-- (3,'A','AC'),
-- (3,'B','NON_AC'),
-- (4,'A','AC'),
-- (5,'A','NON_AC'),
-- (6,'A','AC');

-- INSERT INTO seats (coach_id,seat_number) VALUES
-- (1,1),(1,2),(1,3),(1,4),(1,5),
-- (2,1),(2,2),(2,3),(2,4),(2,5);

-- INSERT INTO users (phone,password,role) VALUES
-- ('01711111111','123456','user'),
-- ('01711111112','123456','user'),
-- ('01711111113','123456','user'),
-- ('01711111114','123456','user'),
-- ('01711111115','123456','user'),
-- ('01711111116','123456','user'),
-- ('01711111117','123456','user'),
-- ('01711111118','123456','user'),
-- ('01711111119','123456','user'),
-- ('01711111120','123456','admin');