package ru.yandex.practicum.filmorate.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;
import ru.yandex.practicum.filmorate.model.Film;
import ru.yandex.practicum.filmorate.model.Genre;
import ru.yandex.practicum.filmorate.model.Rating;
import ru.yandex.practicum.filmorate.model.User;
import ru.yandex.practicum.filmorate.storage.FilmStorage;
import ru.yandex.practicum.filmorate.storage.UserStorage;

import java.util.List;

import static org.springframework.http.HttpStatus.NOT_FOUND;

@Service
public class FilmService {
    private final FilmStorage filmStorage;
    private final UserStorage userStorage;

    @Autowired
    public FilmService(@Qualifier("dbFilmStorage") FilmStorage filmStorage,
                       @Qualifier("dbUserStorage") UserStorage userStorage) {
        this.filmStorage = filmStorage;
        this.userStorage = userStorage;
    }

    /**
     * Add like to film by User and Film IDs.
     * @param userId User ID.
     * @param filmId Film ID.
     * @return Film object to which like was added.
     */
    public Film addLike(int userId, int filmId) {
        User user = userStorage.getUser(userId).orElseThrow(() -> new ResponseStatusException(NOT_FOUND, "Unable to find user"));
        Film film = getFilmById(filmId);
        filmStorage.saveFilmLike(user, film);
        return film;
    }

    /**
     * Remove like from Film by User ID.
     * @param userId User ID.
     * @param filmId Film ID.
     * @return Film object from which like was removed.
     */
    public Film removeLike(int userId, int filmId) {
        User user = userStorage.getUser(userId).orElseThrow(()-> new ResponseStatusException(NOT_FOUND, "Unable to find user"));
        Film film = getFilmById(filmId);
        filmStorage.removeFilmLike(user, film);
        return film;
    }

    /**
     * Show top films, more likes - more popular.
     * @param amount Size of List to show.
     * @return List of Film objects.
     */
    public List<Film> showTopFilms(int amount) {
        return filmStorage.getTopFilms(amount);
    }

    public List<Film> getAllFilms() { return filmStorage.getAllFilms(); }

    public Film getFilmById(int id) {
        return filmStorage.getFilm(id).orElseThrow(() -> new ResponseStatusException(NOT_FOUND, "Unable to find film"));
    }

    public Film updateFilm(int id, Film film) {
        return filmStorage.updateFilm(id, film).orElseThrow(() -> new ResponseStatusException(NOT_FOUND, "Unable to find film"));
    }

    public Film addFilm(Film film) { return filmStorage.addFilm(film); }

    public List<Genre> getAllGenres() { return filmStorage.getAllGenres(); }

    public Genre getGenreById(int id) {
        return filmStorage.getGenre(id).orElseThrow(() -> new ResponseStatusException(NOT_FOUND, "Unable to find genre"));
    }

    public List<Rating> getAllRatings() { return filmStorage.getAllRatings(); }

    public Rating getRatingById(int id) {
        return filmStorage.getRating(id).orElseThrow(() -> new ResponseStatusException(NOT_FOUND, "Unable to find rating"));
    }
}
