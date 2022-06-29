-- drop table IF EXISTS EVENTS;
-- drop table IF EXISTS EVENT_OPERATIONS;
-- drop table IF EXISTS EVENT_TYPES;
-- drop table IF EXISTS FILMS_LIKED;
-- drop table IF EXISTS FILM_DIRECTORS;
-- drop table IF EXISTS DIRECTORS;
-- drop table IF EXISTS FILM_GENRES;
-- drop table IF EXISTS FRIENDSHIPS;
-- drop table IF EXISTS GENRES;
-- drop table IF EXISTS REVIEWS_FEEDBACK;
-- drop table IF EXISTS REVIEWS;
-- drop table IF EXISTS FILMS;
-- drop table IF EXISTS RATINGS;
-- drop table IF EXISTS USERS;

CREATE TABLE IF NOT EXISTS ratings (
                                       rating_id           integer         GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
                                       rating_name         varchar(255)    NOT NULL UNIQUE
    );
CREATE TABLE IF NOT EXISTS genres (
                                      genre_id            integer         GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
                                      genre_name          varchar(255)    NOT NULL UNIQUE
    );
CREATE TABLE IF NOT EXISTS films (
                                     film_id             integer         GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
                                     film_name           varchar(255)    NOT NULL,
    film_description    varchar(255),
    film_release_date   date,
    film_duration       integer,
    film_rating_id      integer,
    FOREIGN KEY (film_rating_id)
    REFERENCES ratings (rating_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    );
CREATE TABLE IF NOT EXISTS film_genres (
                                           film_id             integer         NOT NULL,
                                           genre_id            integer         NOT NULL,
                                           FOREIGN KEY (film_id)
    REFERENCES films
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (genre_id)
    REFERENCES genres
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    PRIMARY KEY (film_id, genre_id)
    );
CREATE TABLE IF NOT EXISTS users (
                                     user_id             integer         GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
                                     user_email          varchar(255)    NOT NULL UNIQUE,
    user_login          varchar(255)    NOT NULL UNIQUE,
    user_name           varchar(255)    NOT NULL,
    user_birthday       date
    );
CREATE TABLE IF NOT EXISTS films_liked (
                                           user_id             integer         NOT NULL,
                                           film_id             integer         NOT NULL,
                                           FOREIGN KEY (user_id)
    REFERENCES users
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (film_id)
    REFERENCES films
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    PRIMARY KEY (user_id, film_id)
    );
CREATE TABLE IF NOT EXISTS friendships (
                                           from_id             integer         NOT NULL,
                                           to_id               integer         NOT NULL,
                                           is_approved         boolean         NOT NULL DEFAULT false,
                                           FOREIGN KEY (from_id)
    REFERENCES users (user_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (to_id)
    REFERENCES users (user_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    PRIMARY KEY (from_id, to_id)
    );
CREATE TABLE IF NOT EXISTS reviews (
                                       review_id           integer         GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
                                       review_timestamp    timestamp       NOT NULL,
                                       user_id             integer         NOT NULL,
                                       film_id             integer         NOT NULL,
                                       review_text         varchar         NOT NULL,
                                       FOREIGN KEY (user_id)
    REFERENCES users (user_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (film_id)
    REFERENCES films (film_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    );
CREATE TABLE IF NOT EXISTS reviews_feedback (
                                                user_id             integer         NOT NULL,
                                                review_id           integer         NOT NULL,
                                                feedback_mark       integer         NOT NULL,
                                                FOREIGN KEY (user_id)
    REFERENCES users (user_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (review_id)
    REFERENCES reviews (review_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    PRIMARY KEY (user_id, review_id)
    );
CREATE TABLE IF NOT EXISTS directors (
                                         director_id         integer         GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
                                         director_name       varchar(255)    NOT NULL
    );
CREATE TABLE IF NOT EXISTS event_types (
                                           event_type_id           integer         GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
                                           event_type_name         varchar(255)    NOT NULL
    );
CREATE TABLE IF NOT EXISTS event_operations (
                                                event_operation_id      integer         GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
                                                event_operation_name    varchar(255)    NOT NULL
    );
CREATE TABLE IF NOT EXISTS events (
                                      event_id            integer         GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
                                      event_time          timestamp       NOT NULL,
                                      user_id             integer         NOT NULL,
                                      event_type_id       integer         NOT NULL,
                                      event_operation_id  integer         NOT NULL,
                                      event_pk_id         integer         NOT NULL,
                                      entity_id           integer         NOT NULL,
                                      FOREIGN KEY (user_id)
    REFERENCES users (user_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (event_type_id)
    REFERENCES event_types (event_type_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (event_operation_id)
    REFERENCES event_operations (event_operation_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
    );

CREATE TABLE IF NOT EXISTS film_directors (
                                              film_id             integer         NOT NULL,
                                              director_id         integer         NOT NULL,
                                              FOREIGN KEY (film_id)
    REFERENCES films (film_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (director_id)
    REFERENCES directors (director_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    PRIMARY KEY (film_id, director_id)
    );