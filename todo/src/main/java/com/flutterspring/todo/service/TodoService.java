package com.flutterspring.todo.service;

import com.flutterspring.todo.entity.Todo;

import java.util.List;

public interface TodoService {

    List<Todo> findAll();

    Todo findById(int theId);

    Todo save(Todo theTodo);

    void deleteById(int theId);
}
