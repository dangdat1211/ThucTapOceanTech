import 'package:bai1_l1/colors.dart';
import 'package:bai1_l1/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final List<Todo> _todos = [];
  final TextEditingController _nameController = TextEditingController();
  Color _selectedColor = AppColors.defaultColor;

  void _showAddEditDialog({Todo? todo}) {
    final bool isEditing = todo != null;
    _nameController.text = isEditing ? todo.name : '';
    _selectedColor = isEditing ? todo.color : AppColors.defaultColor;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: Text(
                  isEditing ? 'Chỉnh sửa công việc' : 'Thêm công việc mới'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Tên công việc',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 16, 
                    children: AppColors.todoColors.map((color) {
                      return GestureDetector(
                        onTap: () {
                          setDialogState(() {
                            _selectedColor = color;
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: color == _selectedColor
                                ? Border.all(color: Colors.black, width: 2)
                                : null,
                          ),
                        ),
                      );
                    }).toList(),
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Hủy'),
                ),
                TextButton(
                  onPressed: () {
                    if (_nameController.text.isNotEmpty) {
                      setState(() {
                        if (isEditing) {
                          todo.name = _nameController.text;
                          todo.color = _selectedColor;
                          todo.updatedAt = DateTime.now();
                        } else {
                          _todos.add(
                            Todo(
                              id: DateTime.now().toString(),
                              name: _nameController.text,
                              color: _selectedColor,
                              createdAt: DateTime.now(),
                            ),
                          );
                        }
                      });
                      Navigator.pop(context);
                      _nameController.clear();
                    }
                  },
                  child: Text(isEditing ? 'Cập nhật' : 'Thêm'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách công việc'),
      ),
      body:  _todos.isEmpty 
    ? const Center(
        child: Text(
          'Chưa có công việc nào',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      )
    :
      ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          final todo = _todos[index];
          final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Dismissible(
              key: Key(todo.id),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                setState(() {
                  _todos.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã xóa công việc'),
                  ),
                );
              },
              child: Card(
                elevation: 2,
                color: todo.color,
                child: ListTile(
                  title: Text(
                    todo.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'Tạo lúc: ${dateFormat.format(todo.createdAt)}',
                        style: TextStyle(color: Colors.black87),
                      ),
                      if (todo.updatedAt != null)
                        Text(
                          'Cập nhật lúc: ${dateFormat.format(todo.updatedAt!)}',
                          style: TextStyle(color: Colors.black87),
                        ),
                    ],
                  ),
                  onTap: () => _showAddEditDialog(todo: todo),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
