import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../utils/date_time.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;
  final VoidCallback? onTap;
  final ValueChanged<bool?>? onCheckChanged;
  final VoidCallback? onDelete;

  const TodoTile({
    super.key,
    required this.todo,
    this.onTap,
    this.onCheckChanged,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Checkbox(
          value: todo.isDone,
          onChanged: onCheckChanged,
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text('Due: ${formatDeadline(todo.deadline)}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
