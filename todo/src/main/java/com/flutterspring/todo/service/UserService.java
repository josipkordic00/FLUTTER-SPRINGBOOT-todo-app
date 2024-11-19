package com.flutterspring.todo.service;


import com.flutterspring.todo.entity.User;

public interface UserService {

    User findByUserName(String userName);
}
