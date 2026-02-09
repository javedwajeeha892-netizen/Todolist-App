import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.user != null) {
      Provider.of<TaskProvider>(context, listen: false)
          .fetchTasks(auth.user!['id']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    
    if (!auth.isAuthenticated) {
        // Redundant safety check
        return const LoginScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List - ${auth.user!['username']}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.logout();
            },
          ),
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, _) {
          if (taskProvider.isLoading && taskProvider.tasks.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (taskProvider.tasks.isEmpty) {
            return const Center(child: Text('No tasks yet.'));
          }
          return ListView.builder(
            itemCount: taskProvider.tasks.length,
            itemBuilder: (context, index) {
              final task = taskProvider.tasks[index];
              return ListTile(
                title: Text(
                  task['title'],
                  style: TextStyle(
                    decoration: task['is_completed'] == 1
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                leading: Checkbox(
                  value: task['is_completed'] == 1,
                  onChanged: (value) {
                    taskProvider.toggleTask(
                      auth.user!['id'],
                      task['id'],
                      value!,
                    );
                  },
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Implement delete in provider if needed, for now just UI
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
            _showAddTaskDialog(context, auth.user!['id']);
        },
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, int userId) {
      final controller = TextEditingController();
      showDialog(
          context: context,
          builder: (context) {
              return AlertDialog(
                  title: const Text('Add Task'),
                  content: TextField(
                      controller: controller,
                      decoration: const InputDecoration(hintText: 'Task Title'),
                  ),
                  actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                      ),
                      TextButton(
                          onPressed: () {
                              if (controller.text.isNotEmpty) {
                                  Provider.of<TaskProvider>(context, listen: false)
                                      .addTask(userId, controller.text);
                                  Navigator.pop(context);
                              }
                          },
                          child: const Text('Add'),
                      ),
                  ],
              );
          },
      );
  }
}
