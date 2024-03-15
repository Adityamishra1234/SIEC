import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:siec_assignment/animals/animal_list_screen.dart';

import '../constants/constants.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  TextEditingController _titleController = TextEditingController();
  List<Todo> _todos = [];
  @override
  void initState() {
    K.setBackgroundImage();
    _loadTodos();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.arrow_back),
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Create a new Task"),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.menu),
          )
        ],
      ),
      floatingActionButton: Container(
        width: 200,
        child: FloatingActionButton(
          backgroundColor: K.primaryColor,
          child: const Text("Animal List Screen", style: TextStyle(
            color: Colors.white,
            fontFamily: 'Lato',
            fontSize: 20
          ),),

          onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AnimalListScreen()));
        },

        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Enter Todo Title',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _addTodo,
            child: Text('Submit',style: TextStyle(
              fontFamily: 'lato'
            ),),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return ListTile(
                  title: Text(todo.title),
                  trailing: Checkbox(
                    value: todo.isCompleted,
                    onChanged: (_) => _toggleTodoCompletion(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _loadTodos() async {
    try {
      final file = await _getLocalFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> jsonData = json.decode(content);
        setState(() {
          _todos = jsonData.map((item) => Todo.fromJson(item)).toList();
        });
      }
    } catch (e) {
      print('Error loading todos: $e');
    }
  }


  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/todos.json');
  }

  Future<void> _saveTodos() async {
    final file = await _getLocalFile();
    await file.writeAsString(json.encode(_todos));
  }

  void _addTodo() {
    final title = _titleController.text.trim();
    if (title.isNotEmpty) {
      setState(() {
        _todos.add(Todo(title: title));
        _titleController.clear();
      });
      _saveTodos();
    }
  }


  void _toggleTodoCompletion(int index) {
    setState(() {
      _todos[index] = Todo(
        title: _todos[index].title,
        isCompleted: !_todos[index].isCompleted,
      );
    });
    _saveTodos();
  }
}


class Todo {
  final String title;
  final bool isCompleted;

  Todo({
    required this.title,
    this.isCompleted = false,
  });


  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isCompleted': isCompleted,
    };
  }
}