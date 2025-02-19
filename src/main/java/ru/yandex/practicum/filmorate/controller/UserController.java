package ru.yandex.practicum.filmorate.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.Errors;
import org.springframework.web.bind.annotation.*;
import ru.yandex.practicum.filmorate.model.User;
import ru.yandex.practicum.filmorate.service.UserService;
import ru.yandex.practicum.filmorate.validator.FilmorateValidationErrorBuilder;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.*;

@RestController
@Slf4j
public class UserController {
    private final UserService userService;

    @Autowired
    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/users")
    public List<User> getAllUsers() {
        return userService.getAllUsers();
    }

    @GetMapping("/users/{id}")
    public ResponseEntity<?> getUserById(@PathVariable int id) {
        return ResponseEntity.ok(userService.getUserById(id));
    }

    @PutMapping("/users/{id}/friends/{friendId}")
    public ResponseEntity<?> makeFriends(@PathVariable int id, @PathVariable int friendId) {
        return ResponseEntity.ok(userService.makeFriends(id, friendId));
    }

    @DeleteMapping("/users/{id}/friends/{friendId}")
    public ResponseEntity<?> removeFriends(@PathVariable int id, @PathVariable int friendId) {
        return ResponseEntity.ok(userService.removeFriends(id, friendId));
    }

    @GetMapping("/users/{id}/friends")
    public ResponseEntity<?> getUserFriends(@PathVariable int id) {
        return ResponseEntity.ok(userService.getUserFriends(id));
    }

    @GetMapping("/users/{id}/friends/common/{otherId}")
    public ResponseEntity<?> getCommonFriends(@PathVariable int id, @PathVariable int otherId) {
        return ResponseEntity.ok(userService.showCommonFriends(id, otherId));
    }

    @PostMapping("/users")
    public ResponseEntity<?> create(HttpServletRequest request, @Valid @RequestBody User user, Errors errors) {
        if (errors.hasErrors()) {
            log.info("Validation error with request: " + request.getRequestURI());
            return ResponseEntity.badRequest()
                .body(FilmorateValidationErrorBuilder.fromBindingErrors(errors));
        }
        return ResponseEntity.ok(userService.addUser(user));
    }

    @PutMapping("/users")
    public ResponseEntity<?> updateUser(HttpServletRequest request, @Valid @RequestBody User user, Errors errors) {
        if (errors.hasErrors()) {
            log.info("Validation error with request: " + request.getRequestURI());
            return ResponseEntity.badRequest()
                    .body(FilmorateValidationErrorBuilder.fromBindingErrors(errors));
        }
        return ResponseEntity.ok(userService.updateUser(user.getId(), user));
    }

    @PatchMapping("/user/{id}")
    public ResponseEntity<?> update(HttpServletRequest request, @Valid @RequestBody User user, @PathVariable int id, Errors errors) {
        if (errors.hasErrors()) {
            log.info("Validation error with request: " + request.getRequestURI());
            return ResponseEntity.badRequest()
                    .body(FilmorateValidationErrorBuilder.fromBindingErrors(errors));
        }
        return ResponseEntity.ok(userService.updateUser(id, user));
    }
}
