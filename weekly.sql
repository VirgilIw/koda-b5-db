CREATE TABLE users (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    role VARCHAR(10) NOT NULL CHECK (role in ('USER','ADMIN'))
)

CREATE Table genre (
  id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  genre_name varchar(255)
)

CREATE Table seats (
  seat_id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  seat_info varchar(255) NOT NULL CHECK (seat_info IN ('AVAILABLE', 'SOLD')),
  seat_price int
)


CREATE Table movie (
  id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  movie_name varchar(255),
  movie_title varchar(255),
  movie_release_date DATE,
  movie_detail varchar(255),
  genre_id INT,
  seat_id INT,
  FOREIGN KEY (genre_id) REFERENCES genre(id),
  FOREIGN KEY (seat_id) REFERENCES seats(seat_id)
)

CREATE TABLE orders (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  order_time timestamp,
  history_orders timestamp,
  schedules_id INT,
  user_id INT,
  movie_id INT,
  FOREIGN KEY (schedules_id) REFERENCES schedules(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (movie_id) REFERENCES movie(id)
)

CREATE TABLE studios (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  studios_name VARCHAR(255),
  studios_location VARCHAR(255) 
);

CREATE TABLE schedules (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  movie_id INT,
  studio_id INT,
  show_time TIMESTAMP NOT NULL,
  price INT NOT NULL,
  FOREIGN KEY (movie_id) REFERENCES movie(id),
  FOREIGN KEY (studio_id) REFERENCES studios(id)
);

SELECT *
-- FROM schedules;
FROM orders;

