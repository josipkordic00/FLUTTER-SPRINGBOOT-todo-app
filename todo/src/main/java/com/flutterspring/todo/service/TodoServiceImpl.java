package com.flutterspring.todo.service;

import com.flutterspring.todo.dao.TodoRepository;
import com.flutterspring.todo.entity.Todo;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class TodoServiceImpl implements TodoService {

    private TodoRepository todoRepository;

    @Autowired
    public TodoServiceImpl(TodoRepository theTodoRepository) {
        todoRepository = theTodoRepository;
    }

    @Override
    public List<Todo> findAll() {
        return todoRepository.findAll();
    }

    @Override
    public Todo findById(int theId) {
        Optional<Todo> result = todoRepository.findById(theId);

        Todo theTodo = null;

        if (result.isPresent()) {
            theTodo = result.get();
        }
        else {
            throw new RuntimeException("Did not find todo id - " + theId);
        }

        return theTodo;
    }

    @Override
    @Transactional
    public Todo save(Todo theTodo) {
        return todoRepository.save(theTodo);
    }

    @Override
    @Transactional
    public void deleteById(int theId) {
        todoRepository.deleteById(theId);
    }




}
