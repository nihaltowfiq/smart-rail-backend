CREATE DATABASE IF NOT EXISTS railway_system;
USE railway_system;

-- DROP TABLE IF EXISTS train_running_days, payments, booking_seats,
--                      bookings, seats, train_coaches, schedules,
--                      fare_rules, routes, trains, stations, users;

-- ============================================================
-- 1. USERS
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
  user_id    INT AUTO_INCREMENT PRIMARY KEY,
  name       VARCHAR(100) NOT NULL,
  phone      VARCHAR(15)  UNIQUE NOT NULL,
  password   VARCHAR(255) NOT NULL,
  role       ENUM('user','admin') DEFAULT 'user',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 2. STATIONS
-- ============================================================
CREATE TABLE IF NOT EXISTS stations (
  station_id   INT AUTO_INCREMENT PRIMARY KEY,
  station_name VARCHAR(100) NOT NULL,
  city         VARCHAR(100) NOT NULL
);

-- ============================================================
-- 3. TRAINS
-- ============================================================
CREATE TABLE IF NOT EXISTS trains (
  train_id     INT AUTO_INCREMENT PRIMARY KEY,
  train_name   VARCHAR(100) NOT NULL,
  train_number VARCHAR(20) UNIQUE NOT NULL
);

-- ============================================================
-- 4. ROUTES
-- ============================================================
CREATE TABLE IF NOT EXISTS routes (
  route_id               INT AUTO_INCREMENT PRIMARY KEY,
  source_station_id      INT,
  destination_station_id INT,
  distance_km            INT,
  FOREIGN KEY (source_station_id)      REFERENCES stations(station_id),
  FOREIGN KEY (destination_station_id) REFERENCES stations(station_id)
);

-- ============================================================
-- 5. FARE RULES
-- ============================================================
CREATE TABLE IF NOT EXISTS fare_rules (
  fare_id      INT AUTO_INCREMENT PRIMARY KEY,
  class_type   ENUM('AC','NON_AC') NOT NULL,
  price_per_km DECIMAL(10,2) NOT NULL
);

-- ============================================================
-- 6. SCHEDULES
-- ============================================================
CREATE TABLE IF NOT EXISTS schedules (
  schedule_id    INT AUTO_INCREMENT PRIMARY KEY,
  train_id       INT,
  route_id       INT,
  departure_time TIME,
  arrival_time   TIME,
  FOREIGN KEY (train_id) REFERENCES trains(train_id),
  FOREIGN KEY (route_id) REFERENCES routes(route_id)
);

-- ============================================================
-- 7. TRAIN COACHES
-- ============================================================
CREATE TABLE IF NOT EXISTS train_coaches (
  coach_id    INT AUTO_INCREMENT PRIMARY KEY,
  train_id    INT,
  coach_label VARCHAR(5),
  class_type  ENUM('AC','NON_AC'),
  FOREIGN KEY (train_id) REFERENCES trains(train_id)
);

-- ============================================================
-- 8. SEATS
-- ============================================================
CREATE TABLE IF NOT EXISTS seats (
  seat_id     INT AUTO_INCREMENT PRIMARY KEY,
  coach_id    INT,
  seat_number INT,
  FOREIGN KEY (coach_id) REFERENCES train_coaches(coach_id)
);

-- ============================================================
-- 9. BOOKINGS
-- ============================================================
CREATE TABLE IF NOT EXISTS bookings (
  booking_id   INT AUTO_INCREMENT PRIMARY KEY,
  user_id      INT,
  schedule_id  INT,
  journey_date DATE,
  class_type   ENUM('AC','NON_AC') NOT NULL,
  seat_count   INT NOT NULL DEFAULT 1,
  total_amount DECIMAL(10,2),
  status       ENUM('PENDING','CONFIRMED','CANCELLED','FAILED') DEFAULT 'PENDING',
  created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id)     REFERENCES users(user_id),
  FOREIGN KEY (schedule_id) REFERENCES schedules(schedule_id)
);

-- ============================================================
-- 10. BOOKING SEATS
-- ============================================================
CREATE TABLE IF NOT EXISTS booking_seats (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  booking_id INT,
  seat_id    INT,
  FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
  FOREIGN KEY (seat_id)    REFERENCES seats(seat_id)
);

-- ============================================================
-- 11. PAYMENTS
-- ============================================================
CREATE TABLE IF NOT EXISTS payments (
  payment_id     INT AUTO_INCREMENT PRIMARY KEY,
  booking_id     INT,
  transaction_id VARCHAR(100),
  amount         DECIMAL(10,2),
  status         ENUM('SUCCESS','FAILED','PENDING') DEFAULT 'PENDING',
  payment_date   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

-- ============================================================
-- 12. TRAIN RUNNING DAYS
-- ============================================================
CREATE TABLE IF NOT EXISTS train_running_days (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  train_id    INT,
  day_of_week ENUM('SUN','MON','TUE','WED','THU','FRI','SAT'),
  is_off      BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (train_id) REFERENCES trains(train_id),
  UNIQUE KEY unique_train_day (train_id, day_of_week)
);