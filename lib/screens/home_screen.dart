import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.user != null) {
      Provider.of<TaskProvider>(context, listen: false)
          .fetchTasks(auth.user!['id']);
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    
    if (!auth.isAuthenticated) {
        return const LoginScreen();
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'My Tasks',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.logout();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Consumer<TaskProvider>(
            builder: (context, taskProvider, _) {
              if (taskProvider.isLoading && taskProvider.tasks.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (taskProvider.tasks.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.task_alt, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'No tasks yet',
                        style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.separated(
                  itemCount: taskProvider.tasks.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final task = taskProvider.tasks[index];
                    final isCompleted = task['is_completed'] == 1;
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        title: Text(
                          task['title'],
                          style: GoogleFonts.poppins(
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: isCompleted ? Colors.grey : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        leading: Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            activeColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            value: isCompleted,
                            onChanged: (value) {
                              taskProvider.toggleTask(
                                auth.user!['id'],
                                task['id'],
                                value!,
                              );
                              if (value) {
                                _confettiController.play();
                              }
                            },
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () {
                             Provider.of<TaskProvider>(context, listen: false)
                                .deleteTask(auth.user!['id'], task['id']);
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          
          // Confetti Widget
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive, // radial value - random direction
              shouldLoop: false, 
              colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple], 
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: Text('Add New Task', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  content: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: 'What needs to be done?',
                        hintStyle: GoogleFonts.poppins(),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
                        ),
                      ),
                  ),
                  actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.grey)),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                              if (controller.text.isNotEmpty) {
                                  Provider.of<TaskProvider>(context, listen: false)
                                      .addTask(userId, controller.text);
                                  Navigator.pop(context);
                              }
                          },
                          child: Text('Add Task', style: GoogleFonts.poppins(color: Colors.white)),
                      ),
                  ],
              );
          },
      );
  }
}
