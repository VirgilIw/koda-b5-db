-- 1. Login
-- Mengambil user berdasarkan email untuk verifikasi password
SELECT id, email, password, first_name, last_name, role, loyalty_point, user_image
FROM users
WHERE email = 'user@example.com';

-- Update last_login setelah berhasil login
UPDATE users 
SET last_login = NOW() 
WHERE id = 1;

-- 2. Register
INSERT INTO users (email, password, first_name, last_name, role, loyalty_point, created_at, updated_at)
VALUES ('user@example.com', 'hashed_password', 'John', 'Doe', 'USER', '0', NOW(), NOW())
RETURNING id, email, first_name, last_name, role;

-- 3. Get Upcoming Movie
SELECT m.id, m.movie_name, m.movie_title, m.movie_release_date, 
       m.poster_image, m.backdrop_image, d.director_name,
       STRING_AGG(DISTINCT g.genre_name, ', ') as genres,
       STRING_AGG(DISTINCT a.name, ', ') as actors
FROM movies m
LEFT JOIN directors d ON m.director_id = d.id
LEFT JOIN movie_genres mg ON m.id = mg.movie_id
LEFT JOIN genres g ON mg.genre_id = g.id
LEFT JOIN movie_actors ma ON m.id = ma.movie_id
LEFT JOIN actors a ON ma.actor_id = a.id
WHERE m.movie_release_date > CURRENT_DATE
GROUP BY m.id, m.movie_name, m.movie_title, m.movie_release_date, 
         m.poster_image, m.backdrop_image, d.director_name
ORDER BY m.movie_release_date ASC;

-- 4. Get Popular Movie
-- Berdasarkan jumlah order
SELECT m.id, m.movie_name, m.movie_title, m.movie_release_date,
       m.poster_image, m.backdrop_image, d.director_name,
       COUNT(o.id) as total_orders,
       STRING_AGG(DISTINCT g.genre_name, ', ') as genres
FROM movies m
LEFT JOIN directors d ON m.director_id = d.id
LEFT JOIN movie_genres mg ON m.id = mg.movie_id
LEFT JOIN genres g ON mg.genre_id = g.id
LEFT JOIN schedules s ON m.id = s.movie_id
LEFT JOIN orders o ON s.id = o.schedules_id
GROUP BY m.id, m.movie_name, m.movie_title, m.movie_release_date,
         m.poster_image, m.backdrop_image, d.director_name
ORDER BY total_orders DESC;

-- 5. Get Movie with Pagination
-- Limit 10, Offset 0 (page 1)
SELECT m.id, m.movie_name, m.movie_title, m.movie_release_date,
       m.poster_image, m.backdrop_image, d.director_name,
       STRING_AGG(DISTINCT g.genre_name, ', ') as genres
FROM movies m
LEFT JOIN directors d ON m.director_id = d.id
LEFT JOIN movie_genres mg ON m.id = mg.movie_id
LEFT JOIN genres g ON mg.genre_id = g.id
GROUP BY m.id, m.movie_name, m.movie_title, m.movie_release_date,
         m.poster_image, m.backdrop_image, d.director_name
ORDER BY m.created_at DESC
LIMIT 10 OFFSET 0;

-- Get total count untuk pagination
SELECT COUNT(*) as total FROM movies;

-- 6. Filter Movie by Name and Genre with Pagination
-- Search: 'avengers', Genre ID: 1, Limit: 10, Offset: 0
SELECT m.id, m.movie_name, m.movie_title, m.movie_release_date,
       m.poster_image, m.backdrop_image, d.director_name,
       STRING_AGG(DISTINCT g.genre_name, ', ') as genres
FROM movies m
LEFT JOIN directors d ON m.director_id = d.id
LEFT JOIN movie_genres mg ON m.id = mg.movie_id
LEFT JOIN genres g ON mg.genre_id = g.id
WHERE (m.movie_name ILIKE '%avengers%' OR m.movie_title ILIKE '%avengers%')
  AND (1 IS NULL OR g.id = 1)
GROUP BY m.id, m.movie_name, m.movie_title, m.movie_release_date,
         m.poster_image, m.backdrop_image, d.director_name
ORDER BY m.created_at DESC
LIMIT 10 OFFSET 0;

-- Get total count untuk filter pagination
SELECT COUNT(DISTINCT m.id) as total
FROM movies m
LEFT JOIN movie_genres mg ON m.id = mg.movie_id
LEFT JOIN genres g ON mg.genre_id = g.id
WHERE (m.movie_name ILIKE '%avengers%' OR m.movie_title ILIKE '%avengers%')
  AND (1 IS NULL OR g.id = 1);

-- 7. Get Schedule
-- Get schedule berdasarkan movie_id = 1
SELECT s.id, s.show_time, c.cinemas_name, cl.city, m.movie_name, m.movie_title
FROM schedules s
JOIN cinemas c ON s.cinema_id = c.id
JOIN cinema_locations cl ON c.location_id = cl.id
JOIN movies m ON s.movie_id = m.id
WHERE s.movie_id = 1 AND s.show_time > NOW()
ORDER BY s.show_time ASC;

-- 8. Get Seat Sold/Available
-- Get semua seat dengan status untuk schedule_id = 1
SELECT s.seat_id, s.seat_info, st.type, st.seat_price,
       CASE WHEN o.id IS NULL THEN 'available' ELSE 'sold' END as status
FROM seats s
JOIN seat_types st ON s.seat_type_id = st.id
LEFT JOIN orders o ON s.seat_id = o.seats_id AND o.schedules_id = 1
ORDER BY s.seat_id;

-- 9. Get Movie Detail
-- Movie ID = 1
SELECT m.id, m.movie_name, m.movie_title, m.movie_release_date,
       m.poster_image, m.backdrop_image, d.director_name,
       STRING_AGG(DISTINCT g.genre_name, ', ') as genres,
       STRING_AGG(DISTINCT a.name, ', ') as actors
FROM movies m
LEFT JOIN directors d ON m.director_id = d.id
LEFT JOIN movie_genres mg ON m.id = mg.movie_id
LEFT JOIN genres g ON mg.genre_id = g.id
LEFT JOIN movie_actors ma ON m.id = ma.movie_id
LEFT JOIN actors a ON ma.actor_id = a.id
WHERE m.id = 1
GROUP BY m.id, m.movie_name, m.movie_title, m.movie_release_date,
         m.poster_image, m.backdrop_image, d.director_name;

-- 10. Create Order
-- total_price: 50000, schedules_id: 1, user_id: 1, payment_id: 1, seats_id: 5
INSERT INTO orders (total_price, schedules_id, user_id, payment_id, seats_id, created_at, updated_at)
VALUES (50000, 1, 1, 1, 5, NOW(), NOW())
RETURNING id;

-- Update loyalty points setelah order (50 points dari 50000)
UPDATE users 
SET loyalty_point = (COALESCE(loyalty_point::INT, 0) + 50)::VARCHAR
WHERE id = 1;

-- 11. Get Profile
-- User ID = 1
SELECT id, email, first_name, last_name, role, loyalty_point, user_image, last_login
FROM users
WHERE id = 1;

-- 12. Get History
-- User ID = 1
SELECT o.id, o.total_price, o.created_at,
       m.movie_name, m.movie_title, m.poster_image,
       s.show_time, c.cinemas_name, cl.city,
       st.seat_info, stp.type, pm.name as payment_method
FROM orders o
JOIN schedules s ON o.schedules_id = s.id
JOIN movies m ON s.movie_id = m.id
JOIN cinemas c ON s.cinema_id = c.id
JOIN cinema_locations cl ON c.location_id = cl.id
JOIN seats st ON o.seats_id = st.seat_id
JOIN seat_types stp ON st.seat_type_id = stp.id
JOIN payment_methods pm ON o.payment_id = pm.id
WHERE o.user_id = 1
ORDER BY o.created_at DESC;

-- 13. Edit Profile
-- first_name: 'John', last_name: 'Updated', user_image: 'new_image.jpg', user_id: 1
UPDATE users
SET first_name = 'John',
    last_name = 'Updated',
    user_image = 'new_image.jpg',
    updated_at = NOW()
WHERE id = 1
RETURNING id, email, first_name, last_name, role, loyalty_point, user_image;

-- 14. Get All Movie (Admin)
SELECT m.id, m.movie_name, m.movie_title, m.movie_release_date,
       m.poster_image, m.backdrop_image, d.director_name,
       m.created_at, m.updated_at,
       STRING_AGG(DISTINCT g.genre_name, ', ') as genres,
       STRING_AGG(DISTINCT a.name, ', ') as actors
FROM movies m
LEFT JOIN directors d ON m.director_id = d.id
LEFT JOIN movie_genres mg ON m.id = mg.movie_id
LEFT JOIN genres g ON mg.genre_id = g.id
LEFT JOIN movie_actors ma ON m.id = ma.movie_id
LEFT JOIN actors a ON ma.actor_id = a.id
GROUP BY m.id, m.movie_name, m.movie_title, m.movie_release_date,
         m.poster_image, m.backdrop_image, d.director_name, m.created_at, m.updated_at
ORDER BY m.created_at DESC;

-- 15. Delete Movie (Admin)
-- Movie ID = 1
-- Hapus relasi terlebih dahulu
DELETE FROM movie_genres WHERE movie_id = 1;
DELETE FROM movie_actors WHERE movie_id = 1;
DELETE FROM schedules WHERE movie_id = 1;
-- Hapus movie
DELETE FROM movies WHERE id = 1;

-- 16. Edit Movie (Admin)
-- Update movie ID = 1
UPDATE movies
SET movie_name = 'Avengers Endgame',
    movie_title = 'Avengers: Endgame',
    movie_release_date = '2019-04-26',
    director_id = 1,
    poster_image = 'poster.jpg',
    backdrop_image = 'backdrop.jpg',
    updated_at = NOW()
WHERE id = 1;

-- Hapus relasi lama
DELETE FROM movie_genres WHERE movie_id = 1;
DELETE FROM movie_actors WHERE movie_id = 1;

-- Insert relasi genre baru (genre_id: 1, 2, 3)
INSERT INTO movie_genres (movie_id, genre_id) VALUES (1, 1);
INSERT INTO movie_genres (movie_id, genre_id) VALUES (1, 2);
INSERT INTO movie_genres (movie_id, genre_id) VALUES (1, 3);

-- Insert relasi actor baru (actor_id: 1, 2, 3)
INSERT INTO movie_actors (movie_id, actor_id) VALUES (1, 1);
INSERT INTO movie_actors (movie_id, actor_id) VALUES (1, 2);
INSERT INTO movie_actors (movie_id, actor_id) VALUES (1, 3);

-- BONUS: Create Movie (Admin)
INSERT INTO movies (movie_name, movie_title, movie_release_date, director_id, poster_image, backdrop_image, created_at, updated_at)
VALUES ('Spider-Man', 'Spider-Man: No Way Home', '2021-12-17', 2, 'spiderman_poster.jpg', 'spiderman_backdrop.jpg', NOW(), NOW())
RETURNING id;

-- Insert genre untuk movie baru (movie_id: 2, genre_id: 1, 2)
INSERT INTO movie_genres (movie_id, genre_id) VALUES (2, 1);
INSERT INTO movie_genres (movie_id, genre_id) VALUES (2, 2);

-- Insert actor untuk movie baru (movie_id: 2, actor_id: 4, 5)
INSERT INTO movie_actors (movie_id, actor_id) VALUES (2, 4);
INSERT INTO movie_actors (movie_id, actor_id) VALUES (2, 5);