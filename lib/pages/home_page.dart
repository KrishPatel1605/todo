import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import '../services/todo_service.dart';
import '../services/fcm_service.dart';
import '../models/todo.dart';
import '../widgets/todo_tile.dart';
import 'add_edit_todo_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = AuthService();
  final _todoService = TodoService();
  final _fcm = FcmService();
  List<Todo> _todos = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _fcm.init();
    await _load();
    Supabase.instance.client
        .channel('public:todos')
        .onPostgresChanges(event: PostgresChangeEvent.insert, schema: 'public', table: 'todos', callback: (_) => _load())
        .onPostgresChanges(event: PostgresChangeEvent.update, schema: 'public', table: 'todos', callback: (_) => _load())
        .onPostgresChanges(event: PostgresChangeEvent.delete, schema: 'public', table: 'todos', callback: (_) => _load())
        .subscribe();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    _todos = await _todoService.fetchTodos();
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _add() async {
    final res = await Navigator.push<Map<String, dynamic>?>(
      context,
      MaterialPageRoute(builder: (_) => const AddEditTodoPage()),
    );
    if (res == null) return;
    await _todoService.addTodo(res['title'], res['deadline']);
    await _load();
  }

  Future<void> _edit(Todo t) async {
    final res = await Navigator.push<Map<String, dynamic>?>(
      context,
      MaterialPageRoute(builder: (_) => AddEditTodoPage(todo: t)),
    );
    if (res == null) return;
    t.title = res['title'];
    t.deadline = res['deadline'];
    await _todoService.updateTodo(t);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.user;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: user?.userMetadata?['avatar_url'] != null
                  ? NetworkImage(user!.userMetadata!['avatar_url'])
                  : null,
              child: user?.userMetadata?['avatar_url'] == null ? const Icon(Icons.person) : null,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text('Hi, ${user?.userMetadata?['name'] ?? 'There'}')),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
            },
          )
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _todos.length,
                itemBuilder: (_, i) {
                  final t = _todos[i];
                  return TodoTile(
                    todo: t,
                    onTap: () => _edit(t),
                    onCheckChanged: (v) async {
                      t.isDone = v ?? false;
                      await _todoService.updateTodo(t);
                      await _load();
                    },
                    onDelete: () async {
                      await _todoService.deleteTodo(t.id);
                      await _load();
                    },
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        child: const Icon(Icons.add),
      ),
    );
  }
}
