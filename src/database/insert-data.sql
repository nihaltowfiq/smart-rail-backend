INSERT INTO stations (station_name, city) VALUES
('Dhaka Station','Dhaka'),
('Chittagong Station','Chittagong'),
('Sylhet Station','Sylhet'),
('Rajshahi Station','Rajshahi'),
('Khulna Station','Khulna'),
('Barisal Station','Barisal'),
('Cumilla Station','Cumilla'),
('Noakhali Station','Noakhali'),
('Rangpur Station','Rangpur'),
('Mymensingh Station','Mymensingh');

INSERT INTO trains (train_name, train_number) VALUES
('Suborno Express','701'),
('Turna Nishitha','702'),
('Mohanagar Express','703'),
('Sonar Bangla','704'),
('Padma Express','705'),
('Jamuna Express','706'),
('Banalata Express','707'),
('Tista Express','708'),
('Drutojan Express','709'),
('Sundarban Express','710');

INSERT INTO fare_rules (class_type, price_per_km) VALUES
('AC',2.5),
('NON_AC',1.5);

INSERT INTO routes (source_station_id,destination_station_id,distance_km) VALUES
(1,2,300),
(1,3,250),
(2,3,200),
(2,4,280),
(3,5,260),
(4,5,220),
(5,6,210),
(6,7,180),
(7,8,160),
(8,9,140);

INSERT INTO schedules (train_id,route_id,fare_id,departure_time,arrival_time) VALUES
(1,1,1,'08:00:00','12:00:00'),
(2,2,2,'09:00:00','13:00:00'),
(3,3,1,'10:00:00','14:00:00'),
(4,4,2,'11:00:00','15:00:00'),
(5,5,1,'12:00:00','16:00:00'),
(6,6,2,'13:00:00','17:00:00'),
(7,7,1,'14:00:00','18:00:00'),
(8,8,2,'15:00:00','19:00:00'),
(9,9,1,'16:00:00','20:00:00'),
(10,10,2,'17:00:00','21:00:00');

INSERT INTO train_coaches (train_id,coach_label,class_type) VALUES
(1,'A','AC'),
(1,'B','AC'),
(1,'C','NON_AC'),
(2,'A','NON_AC'),
(2,'B','NON_AC'),
(3,'A','AC'),
(3,'B','NON_AC'),
(4,'A','AC'),
(5,'A','NON_AC'),
(6,'A','AC');

INSERT INTO seats (coach_id,seat_number) VALUES
(1,1),(1,2),(1,3),(1,4),(1,5),
(2,1),(2,2),(2,3),(2,4),(2,5);

INSERT INTO users (phone,password,role) VALUES
('01711111111','123456','user'),
('01711111112','123456','user'),
('01711111113','123456','user'),
('01711111114','123456','user'),
('01711111115','123456','user'),
('01711111116','123456','user'),
('01711111117','123456','user'),
('01711111118','123456','user'),
('01711111119','123456','user'),
('01711111120','123456','admin');