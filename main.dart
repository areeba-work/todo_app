import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; //for the presistent storage

void main() {
  runApp(MyApp());  //entry point
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF311432),  //bg color dark purple
      ),
      home: TodoScreen(), //main screen of app
    );
  }
}

class TodoScreen extends StatefulWidget {

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {

  final TextEditingController _taskController = TextEditingController(); // Controller for input field
  List<String> _tasks = []; // List to hold tasks

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Load saved tasks on app start
  }

  // Load tasks from shared preferences
  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tasks = prefs.getStringList('tasks') ?? []; // Get tasks or initialize an empty list
    });
  }

  // Save tasks to shared preferences
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('tasks', _tasks);
  }

  // Add a new task
  void _addTask(String task) {
    if (task.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task cannot be empty!')), // Validation feedback
      );
      return;
    }
    setState(() {
      _tasks.add(task); // Add the task to the list
      _taskController.clear(); // Clear the input field
    });
    _saveTasks(); // Save tasks persistently
  }

  // Delete a task
  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index); // Remove task at the given index
    });
    _saveTasks(); // Save updated tasks persistently
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do App'),
        backgroundColor: Color(0xFFE0B0FF), // App bar color (light purple/lavender) app barr color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input field and add button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      hintText: 'Enter your task here',
                      filled: true,
                      fillColor: Color(0xFFB768A2), // Light purple notes box
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0), // Spacing between field and button
                ElevatedButton(
                  onPressed: () => _addTask(_taskController.text),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.purple, backgroundColor: Colors.white, // Text color on button
                  ),
                  child: Text('Add'),
                ),
              ],
            ),
            SizedBox(height: 16.0), // Space between input and task list
            // Display tasks in a list
            Expanded(
              child: _tasks.isEmpty
                  ? Center(
                child: Text(
                  'No tasks added yet!',
                  style: TextStyle(color: Colors.black),
                ),
              )
                  : ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.purple[200], // Light lavender card
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        _tasks[index],
                        style: TextStyle(color: Colors.black),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.white12),
                        onPressed: () => _deleteTask(index), // Delete action
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}