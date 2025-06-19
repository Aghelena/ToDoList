import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkTheme = false;

  // Função para alternar entre temas claro e escuro
  void _toggleTheme() {
    setState(() {
      isDarkTheme = !isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo Estilizado',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFF5F7FA),
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF4A90E2)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkTheme
          ? ThemeMode.dark
          : ThemeMode.light, // Controle dinâmico do tema
      home: ToDoPage(
        toggleTheme: _toggleTheme,
      ),
    );
  }
}

class ToDoPage extends StatefulWidget {
  final Function toggleTheme;

  ToDoPage({required this.toggleTheme});

  @override
  _ToDoPageState createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  final List<Map<String, dynamic>> _tasks = [];
  final TextEditingController _controller = TextEditingController();

  // Adicionar tarefa
  void _addTask(String task) {
    if (task.isNotEmpty) {
      setState(() {
        _tasks.add({
          'task': task,
          'completed': false,
          'priority': 'Baixa',
          'time': DateTime.now(),
        });
        _controller.clear();
      });
    }
  }

  // Marcar tarefa como concluída
  void _toggleCompletion(int index) {
    setState(() {
      _tasks[index]['completed'] = !_tasks[index]['completed'];
    });
  }

  // Remover tarefa
  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  // Alterar prioridade da tarefa
  void _changePriority(int index, String value) {
    setState(() {
      _tasks[index]['priority'] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('📝 Minha Lista'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.wb_sunny
                  : Icons.nightlight_round,
            ),
            onPressed: () {
              widget.toggleTheme(); // Alterna o tema quando clicado
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Campo para digitar tarefas
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Digite uma nova tarefa...',
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _addTask(_controller.text),
            ),
            SizedBox(height: 20),

            // Lista de tarefas
            Expanded(
              child: _tasks.isEmpty
                  ? Center(child: Text("Nenhuma tarefa adicionada."))
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                            leading: IconButton(
                              icon: Icon(
                                task['completed']
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: task['completed']
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                              onPressed: () => _toggleCompletion(index),
                            ),
                            title: Text(
                              task['task'],
                              style: TextStyle(
                                decoration: task['completed']
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: task['completed'] ? Colors.grey : null,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Prioridade: ${task['priority']}  ',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ),
                                DropdownButton<String>(
                                  value: task['priority'],
                                  icon: Icon(Icons.arrow_drop_down),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      _changePriority(index, newValue);
                                    }
                                  },
                                  items: <String>['Baixa', 'Média', 'Alta']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () => _removeTask(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTask(_controller.text),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
