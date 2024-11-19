import 'package:flutter/material.dart';
import 'package:todofront/models/todo_item.dart';
import 'package:todofront/screens/update_todo.dart';
import 'package:todofront/services/api_service.dart';

class TodoItemWidget extends StatelessWidget {
  const TodoItemWidget({
    super.key,
    required this.item,
    required this.hasRoleAdmin,
    required this.onRefresh,
  });

  final TodoItem item;
  final bool hasRoleAdmin;
  final VoidCallback onRefresh; // Callback to trigger refresh

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListTile(
          leading: Text(
            item.username.toString().toUpperCase(),
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          title: Text(
            item.title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
          ),
          subtitle: Text(
            item.task,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          trailing: hasRoleAdmin
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.amberAccent,
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) =>
                                      UpdateTodoScreen(todoId: item.id!, initialTitle: item.title, initialTask: item.task)))
                              .then((result) {
                            if (result == true) {
                              onRefresh();
                            }
                          });
                        }),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ),
                      onPressed: () async {
                        try {
                          await ApiService().deleteTodo(item.id!);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Todo deleted successfully!'),
                            ),
                          );
                          onRefresh(); // Trigger page refresh
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to delete todo: $e'),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                )
              : const SizedBox(),
        ),
      ),
    );
  }
}
