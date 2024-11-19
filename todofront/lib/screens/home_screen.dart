import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:todofront/models/todo_item.dart';
import 'package:todofront/screens/create_todo.dart';
import 'package:todofront/screens/login_screen.dart';
import 'package:todofront/widgets/todo_item_widget.dart';
import 'package:todofront/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  List<TodoItem> todos = [];
  List<String> roles = [];
  String currentUser = "";

  @override
  void initState() {
    super.initState();
    fetchAndPrintTodos();
    fetchAndPrintRoles();
    fetchUser();
  }

  void fetchAndPrintTodos() async {
    try {
      String response = await apiService.fetchTodos();
      List<dynamic> jsonList = jsonDecode(response);
      List<TodoItem> todosList =
          jsonList.map((json) => TodoItem.fromJson(json)).toList();
      setState(() {
        todos = todosList;
      });
    } catch (e) {
      print('Error fetching todos: $e');
    }
  }

  void fetchAndPrintRoles() async {
    try {
      List<String> rolesList = [];
      String response = await apiService.currentUserRole();
      List<dynamic> jsonList = jsonDecode(response);
      for (var item in jsonList) {
        rolesList.add(item);
      }
      setState(() {
        roles = rolesList;
      });
    } catch (e) {
      print('Error fetching roles: $e');
    }
  }

  void fetchUser() async {
    try {
      String response = await apiService.currentUser();
      dynamic json = jsonDecode(response);
      setState(() {
        currentUser = json['userName'];
      });
    } catch (e) {
      print('Error fetching user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                const storage = FlutterSecureStorage();
                await storage.delete(key: 'token');
                // Navigate back to the login screen
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (ctx) => const LoginScreen()));
              }),
          const SizedBox(
            width: 20,
          ),
          Text(
            currentUser.toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(
            width: 50,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Column(
          children: [
            roles.contains("ROLE_USER")
                ? ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => const CreateTodoScreen()))
                          .then((result) {
                        if (result == true) {
                          // Refresh the page here
                          fetchAndPrintTodos();
                        }
                      });
                    },
                    label: const Icon(Icons.add))
                : const SizedBox(
                    height: 10,
                  ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (ctx, index) {
                    return Dismissible(
                        key: ValueKey(todos[index]),
                        child: InkWell(
                            onTap: fetchAndPrintTodos,
                            child: TodoItemWidget(
                              item: todos[index],
                              hasRoleAdmin: roles.contains("ROLE_ADMIN"),
                              onRefresh: fetchAndPrintTodos,
                            )));
                  }),
            ),
          ],
        )),
      ),
    );
  }
}
