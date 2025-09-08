import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/todo.dart';

class TodoService {
  final _client = Supabase.instance.client;

  Future<List<Todo>> fetchTodos() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];
    final data = await _client
        .from('todos')
        .select()
        .order('deadline', ascending: true);
    return (data as List).map((e) => Todo.fromMap(e)).toList();
  }

  Future<Todo> addTodo(String title, DateTime deadline) async {
    final user = _client.auth.currentUser!;
    final inserted = await _client.from('todos').insert({
      'title': title,
      'deadline': deadline.toUtc().toIso8601String(),
      'user_id': user.id,
      'is_done': false,
    }).select().single();
    return Todo.fromMap(inserted);
  }

  Future<void> updateTodo(Todo todo) async {
    await _client.from('todos').update({
      'title': todo.title,
      'deadline': todo.deadline.toUtc().toIso8601String(),
      'is_done': todo.isDone,
    }).eq('id', todo.id);
  }

  Future<void> deleteTodo(String id) async {
    await _client.from('todos').delete().eq('id', id);
  }
}
