import 'package:firebase_l1/bai4_5/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/work_model.dart';
import '../services/work_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkScreen extends StatefulWidget {
  const WorkScreen({super.key});

  @override
  _WorkScreenState createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  final WorkService _workService = WorkService();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }  

  void _showWorkDialog([WorkModel? work, String? documentId]) {
    // Nếu work != null thì là edit, ngược lại là add
    final bool isEditing = work != null;

    final titleController = TextEditingController(text: work?.title ?? '');
    final descriptionController =
        TextEditingController(text: work?.description ?? '');
    DateTime selectedDate = work?.dueDate ?? DateTime.now();
    Color selectedColor = work?.backgroundColor ?? AppColors.todoColors[0];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isEditing ? 'Edit work' : 'Add work'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12), // Bo tròn border
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                    SizedBox(height: 16), 
                    TextField(
                      controller: descriptionController,
                      maxLines: null, 
                      minLines: 3, 
                      keyboardType:
                          TextInputType.multiline, 
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12), 
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.access_time),
                        SizedBox(width: 8),
                        Text(
                          'Due: ${DateFormat('dd/MM/yyyy HH:mm').format(selectedDate)}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () async {
                        final DateTime? picked = await showDateTimePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null) {
                          setDialogState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      child: Text(
                          isEditing ? 'Change Due Date' : 'Select Due Date'),
                    ),
                    SizedBox(height: 16),
                    Text('Select Color:', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 16,
                      children: AppColors.todoColors.map((color) {
                        return GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              selectedColor = color;
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: color == selectedColor
                                  ? Border.all(color: Colors.black, width: 2)
                                  : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (titleController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter a title')),
                      );
                      return;
                    }

                    final newWork = WorkModel(
                      title: titleController.text,
                      description: descriptionController.text,
                      dueDate: selectedDate,
                      userId: user!.uid,
                      isCompleted: work?.isCompleted ?? false,
                      backgroundColor: selectedColor,
                    );

                    if (isEditing) {
                      await _workService.updateWork(documentId!, newWork);
                    } else {
                      await _workService.createWork(newWork);
                    }

                    Navigator.pop(context);
                  },
                  child: Text(isEditing ? 'Update' : 'Add'),
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
        title: Text('Work list'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _workService.getWorks(user!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final workList = snapshot.data!;
          return ListView.builder(
            itemCount: workList.length,
            itemBuilder: (context, index) {
              final work = workList[index]['work'] as WorkModel;
              final documentId = workList[index]['documentId'] as String;

              return Dismissible(
                  key: Key(documentId),
                  onDismissed: (direction) {
                    _workService.deleteWork(documentId);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    color: work.backgroundColor,
                    elevation: 2,
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      title: Text(work.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(work.description),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 16),
                              SizedBox(width: 4),
                              Text(
                                DateFormat('dd/MM/yyyy HH:mm')
                                    .format(work.dueDate),
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Checkbox(
                        value: work.isCompleted,
                        onChanged: (bool? value) {
                          work.isCompleted = value!;
                          _workService.updateWork(documentId, work);
                        },
                      ),
                      onTap: () {
                        _showWorkDialog(work, documentId);
                      },
                    ),
                  ));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showWorkDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}

Future<DateTime?> showDateTimePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) async {
  final DateTime? date = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );
  if (date == null) return null;

  final TimeOfDay? time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initialDate),
  );
  if (time == null) return null;

  return DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
  );
}
