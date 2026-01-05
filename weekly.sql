CREATE TYPE user_role AS ENUM ('ADMIN', 'USER');

CREATE TABLE users (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  email VARCHAR,
  password VARCHAR,
  first_name VARCHAR,
  last_name VARCHAR,
  role user_role,
  loyalty_point VARCHAR,
  user_image VARCHAR,
  last_login TIMESTAMP,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE TABLE genres (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  genre_name VARCHAR
);

CREATE TABLE actors (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name VARCHAR
);

CREATE TABLE directors (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  director_name VARCHAR
);

CREATE TABLE cinema_locations (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  city VARCHAR
);

CREATE TABLE cinemas (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  cinemas_name VARCHAR,
  location_id INT,
  FOREIGN KEY (location_id) REFERENCES cinema_locations (id)
);

CREATE TYPE seat_type AS ENUM ('single', 'love-love <3');

CREATE TABLE seat_types (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  type seat_type,
  seat_price INT
);

CREATE TABLE seats (
  seat_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  seat_info VARCHAR,
  seat_type_id INT,
  FOREIGN KEY (seat_type_id) REFERENCES seat_types (id)
);

CREATE TABLE movies (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  movie_name VARCHAR,
  movie_title VARCHAR,
  movie_release_date DATE,
  director_id INT,
  poster_image VARCHAR,
  backdrop_image VARCHAR,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  FOREIGN KEY (director_id) REFERENCES directors (id)
);

CREATE TABLE movie_genres (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  movie_id INT,
  genre_id INT,
  FOREIGN KEY (movie_id) REFERENCES movies (id),
  FOREIGN KEY (genre_id) REFERENCES genres (id)
);

CREATE TABLE movie_actors (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  movie_id INT,
  actor_id INT,
  FOREIGN KEY (movie_id) REFERENCES movies (id),
  FOREIGN KEY (actor_id) REFERENCES actors (id)
);

CREATE TABLE schedules (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  movie_id INT,
  cinema_id INT,
  show_time TIMESTAMP,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  FOREIGN KEY (movie_id) REFERENCES movies (id),
  FOREIGN KEY (cinema_id) REFERENCES cinemas (id)
);

CREATE TABLE payment_methods (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name VARCHAR
);

CREATE TABLE orders (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  total_price INT,
  schedules_id INT,
  user_id INT,
  payment_id INT,
  seats_id INT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  FOREIGN KEY (seats_id) REFERENCES seats (seat_id),
  FOREIGN KEY (schedules_id) REFERENCES schedules (id),
  FOREIGN KEY (user_id) REFERENCES users (id),
  FOREIGN KEY (payment_id) REFERENCES payment_methods (id)
);