-- login
SELECT id,email,role
FROM users;

-- register
INSERT INTO users (email, password, name,role)
VALUES ('test@gmail.com', '1234Im','virgil','ADMIN');

-- get upcoming movie
SELECT m.id, m.movie_title, m.genre_id
FROM movie m
WHERE m.movie_release_date > CURRENT_DATE

-- get POPULAR MOVIE
SELECT m.id, m.movie_title, COUNT(o.id) AS total_order
FROM movie m
JOIN schedules s ON s.movie_id = m.id
JOIN orders o ON o.order_time = TO_TIMESTAMP(s.id)
GROUP BY m.id, m.movie_title
ORDER BY total_order DESC;

-- get movie with pagination
SELECT m.id, m.movie_name, m.movie_title, m.movie_detail
FROM movie m
ORDER BY m.movie_release_date DESC
LIMIT 20;

-- filter movie by name dan genre
SELECT m.id, m.movie_name, m.genre_id
FROM movie m
JOIN genre g ON g.id = m.genre_id
WHERE m.movie_title LIKE 'ultraman nexus'
  AND g.genre_name LIKE 'sci-fi'
LIMIT 10;

-- get schedule
SELECT s.id, s.movie_id, s.studio_id,s.price
FROM schedules s
ORDER BY s.id ASC;

-- get seat sold/avaliable
SELECT se.seat_id,se.seat_info, se.seat_price
FROM seats se

-- Get Schedule
SELECT s.id, s.show_time, s.price, st.studios_name AS studio
FROM schedules s
JOIN studios st ON st.id = s.studio_id
WHERE s.movie_id = 1;

-- seat available
SELECT s.id, s.seat_number
FROM seats s
WHERE s.studio_id = $1
AND s.id NOT IN (
  SELECT os.seat_id
  FROM order_seats os
  JOIN orders o ON o.id = os.order_id
  WHERE o.schedule_id = $2
);

--  movie detail
SELECT m.*, g.genre_name AS genre
FROM movie m
JOIN genre g ON g.id = m.genre_id
WHERE m.id = 1;

INSERT INTO orders (user_id, schedules_id)
VALUES (1, 3);

-- get profile
SELECT id, email, name, role
FROM users
WHERE id = 1;

-- get history 
SELECT ord.id, m.title, s.show_time
FROM orders ord
JOIN schedules s ON s.id = TO_TIMESTAMP(ord.order_time)
JOIN movies m ON m.id = s.id
WHERE ord.user_id = 1
ORDER BY o.created_at DESC;

-- edit profile
UPDATE users
SET name = "ngab gans"
WHERE id = 2;

-- get all movie
SELECT *
FROM movie;

-- edit movie
UPDATE movie
SET title = "golongan rak'buku",
    description = "film tentang sebuah partai yang suka warna matahari",
    release_date = "zaman presiden 3",
    genre_id = 1
WHERE id = 1;

-- hapus movie
DELETE FROM movie
WHERE id = 1;
