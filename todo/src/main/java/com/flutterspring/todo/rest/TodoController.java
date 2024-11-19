package com.flutterspring.todo.rest;

import com.flutterspring.todo.dao.UserRepository;
import com.flutterspring.todo.entity.Todo;
import com.flutterspring.todo.entity.User;
import com.flutterspring.todo.entity.Role;
import com.flutterspring.todo.service.TodoService;
import com.flutterspring.todo.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api")
public class TodoController {

    private TodoService todoService;
    private UserService userService;

    @Autowired
    public TodoController(TodoService theTodoService, UserService theUserService) {
        todoService = theTodoService;
        userService = theUserService;
    }



    private ResponseEntity<User> getAuthenticatedUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();
        User user = userService.findByUserName(username);

        if (user == null) {
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
        }
        return new ResponseEntity<>(user, HttpStatus.OK);
    }



    // expose "/todos" and return a list of todos
    @GetMapping("/todos")
    public List<Todo> findAll() {
        return todoService.findAll();
    }

    @GetMapping("/user/roles")
        public Set<String> getUserRoles(Authentication authentication) {
            String username = authentication.getName();
            User user = userService.findByUserName(username);
            if (user != null) {
                return user.getRoles().stream()
                        .map(Role::getName)
                        .collect(Collectors.toSet());
            } else {
                throw new UsernameNotFoundException("User not found");
            }
        }

    @GetMapping("/user")
    public User getLoggedUser(Authentication authentication) {
        String username = authentication.getName();
        User user = userService.findByUserName(username);
        if (user != null) {
            return user;
        } else {
            throw new UsernameNotFoundException("User not found");
        }
    }

    // add mapping for GET /todos/{todoId}

    @GetMapping("/todos/{todoId}")
    public Todo getTodo(@PathVariable int todoId) {

        Todo theTodo = todoService.findById(todoId);

        if (theTodo == null) {
            throw new RuntimeException("Todo id not found - " + todoId);
        }

        return theTodo;
    }







    // add mapping for POST /todos - add new todo

    @PostMapping("/todos")
    public ResponseEntity<?> createTodo(@RequestBody Todo todo) {
        ResponseEntity<User> userResponse = getAuthenticatedUser();
        if (!userResponse.getStatusCode().is2xxSuccessful()) {
            return new ResponseEntity<>("User not found", HttpStatus.UNAUTHORIZED);
        }
        User user = userResponse.getBody();

        todo.setUser(user);
        Todo savedTodo = todoService.save(todo);
        return new ResponseEntity<>(savedTodo, HttpStatus.CREATED);
    }

    // add mapping for PUT /todos - update existing todo

    @PutMapping("/todos")
    public ResponseEntity<?> updateTodo(@RequestBody Todo theTodo) {
        ResponseEntity<User> userResponse = getAuthenticatedUser();
        if (!userResponse.getStatusCode().is2xxSuccessful()) {
            return new ResponseEntity<>("User not found", HttpStatus.UNAUTHORIZED);
        }
        User user = userResponse.getBody();

        theTodo.setUser(user);
        Todo updatedTodo = todoService.save(theTodo);
        return new ResponseEntity<>(updatedTodo, HttpStatus.OK);
    }

    // add mapping for DELETE /todos/{todoId} - delete todo

    @DeleteMapping("/todos/{todoId}")
    public String deleteTodo(@PathVariable int todoId) {

        Todo tempTodo = todoService.findById(todoId);

        // throw exception if null

        if (tempTodo == null) {
            throw new RuntimeException("Todo id not found - " + todoId);
        }

        todoService.deleteById(todoId);

        return "Deleted todo id - " + todoId;
    }

}