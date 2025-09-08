import 'package:flutter/material.dart';
import '../models/todo.dart';

class AddEditTodoPage extends StatefulWidget {
  final Todo? todo;
  const AddEditTodoPage({super.key, this.todo});

  @override
  State<AddEditTodoPage> createState() => _AddEditTodoPageState();
}

class _AddEditTodoPageState extends State<AddEditTodoPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  DateTime? _deadline;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.todo?.title ?? '');
    _deadline = widget.todo?.deadline ?? DateTime.now().add(const Duration(hours: 2));
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.todo == null ? 'Add Todo' : 'Edit Todo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(_deadline == null ? 'Pick deadline' : _deadline!.toLocal().toString()),
                  ),
                  TextButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 3650)),
                        initialDate: _deadline ?? DateTime.now().add(const Duration(hours: 2)),
                      );
                      if (date == null) return;
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(_deadline ?? DateTime.now().add(const Duration(hours: 2))),
                      );
                      if (time == null) return;
                      setState(() {
                        _deadline = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                      });
                    },
                    child: const Text('Pick date & time'),
                  )
                ],
              ),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate() || _deadline == null) return;
                  Navigator.pop(context, {
                    'title': _titleCtrl.text.trim(),
                    'deadline': _deadline,
                  });
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
