CREATE DATABASE railway_system;
USE railway_system;

CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  phone VARCHAR(15) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  role ENUM('user','admin') DEFAULT 'user',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE stations (
  station_id INT AUTO_INCREMENT PRIMARY KEY,
  station_name VARCHAR(100) NOT NULL,
  city VARCHAR(100) NOT NULL
);

CREATE TABLE trains (
  train_id INT AUTO_INCREMENT PRIMARY KEY,
  train_name VARCHAR(100) NOT NULL,
  train_number VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE routes (
  route_id INT AUTO_INCREMENT PRIMARY KEY,
  source_station_id INT,
  destination_station_id INT,
  distance_km INT,
  FOREIGN KEY (source_station_id) REFERENCES stations(station_id),
  FOREIGN KEY (destination_station_id) REFERENCES stations(station_id)
);

CREATE TABLE fare_rules (
  fare_id INT AUTO_INCREMENT PRIMARY KEY,
  class_type ENUM('AC','NON_AC') NOT NULL,
  price_per_km DECIMAL(10,2) NOT NULL
);


CREATE TABLE schedules (
  schedule_id INT AUTO_INCREMENT PRIMARY KEY,
  train_id INT,
  route_id INT,
  departure_time TIME,
  arrival_time TIME,
  FOREIGN KEY (train_id) REFERENCES trains(train_id),
  FOREIGN KEY (route_id) REFERENCES routes(route_id)
);

CREATE TABLE train_coaches (
  coach_id INT AUTO_INCREMENT PRIMARY KEY,
  train_id INT,
  coach_label VARCHAR(5),
  class_type ENUM('AC','NON_AC'),
  FOREIGN KEY (train_id) REFERENCES trains(train_id)
);


CREATE TABLE seats (
  seat_id INT AUTO_INCREMENT PRIMARY KEY,
  coach_id INT,
  seat_number INT,
  FOREIGN KEY (coach_id) REFERENCES train_coaches(coach_id)
);


CREATE TABLE bookings (
  booking_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  schedule_id INT,
  journey_date DATE,
  class_type ENUM('AC','NON_AC') NOT NULL,
  seat_count INT NOT NULL DEFAULT 1,
  total_amount DECIMAL(10,2),
  status ENUM('PENDING','CONFIRMED','CANCELLED','FAILED') DEFAULT 'PENDING',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (schedule_id) REFERENCES schedules(schedule_id)
);

CREATE TABLE booking_seats (
  id INT AUTO_INCREMENT PRIMARY KEY,
  booking_id INT,
  seat_id INT,
  FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
  FOREIGN KEY (seat_id) REFERENCES seats(seat_id)
);

CREATE TABLE payments (
  payment_id INT AUTO_INCREMENT PRIMARY KEY,
  booking_id INT,
  transaction_id VARCHAR(100),
  amount DECIMAL(10,2),
  status ENUM('SUCCESS','FAILED','PENDING') DEFAULT 'PENDING',
  payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

CREATE TABLE train_running_days (
  id INT AUTO_INCREMENT PRIMARY KEY,
  train_id INT,
  day_of_week ENUM('SUN','MON','TUE','WED','THU','FRI','SAT'),
  is_off BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (train_id) REFERENCES trains(train_id),
  UNIQUE KEY unique_train_day (train_id, day_of_week)
);

-- 🔗 RELATIONSHIP SUMMARY
-- users → bookings
-- trains → coaches → seats
-- trains → schedules
-- routes → schedules
-- bookings → booking_seats → seats
-- bookings → payments