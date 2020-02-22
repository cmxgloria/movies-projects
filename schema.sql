CREATE DATABASE movies_app;

CREATE TABLE movies (
    id SERIAL PRIMARY KEY,
    title VARCHAR(500),
    poster TEXT,
    year VARCHAR(10), 
    score VARCHAR(30),
    runtime VARCHAR(500),
    actors VARCHAR(500),
    director VARCHAR(250),
    plot VARCHAR(250),
    rating VARCHAR(800)
);

