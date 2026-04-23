import 'package:anchieta_flutter_todo/screens/login_screen.dart';
import 'package:anchieta_flutter_todo/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';
import '../database/db_helper.dart';
import '../models/task_model.dart';
import '../widgets/todo_tile.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final DbHelper _db = DbHelper();
  final TextEditingController _taskController = TextEditingController();

  void _handleLogout(BuildContext context) {
    // Aqui futuramente você limparia os tokens salvos (SharedPreferences)

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Sair"),
        content: const Text("Deseja realmente encerrar a sessão?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              // Remove todas as telas e volta para o Login
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text("Sair", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddTaskModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        // Criamos uma função interna para salvar, assim evitamos repetir código
        void handleSave() async {
          if (_taskController.text.trim().isNotEmpty) {
            await _db.insertTask(
              TaskModel(tarefa: _taskController.text.trim()),
            );
            _taskController.clear();
            if (context.mounted) Navigator.pop(context);
            setState(() {}); // Atualiza a lista na tela principal
          }
        }

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Nova Tarefa",
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _taskController,
                autofocus: true, // Foca automaticamente ao abrir
                style: const TextStyle(color: Colors.white),
                textInputAction: TextInputAction
                    .done, // Muda o ícone do teclado para "Check/Done"
                onSubmitted: (_) =>
                    handleSave(), // Aciona o salvar ao apertar Enter
                decoration: InputDecoration(
                  hintText: "O que precisa ser feito?",
                  hintStyle: const TextStyle(color: Colors.white24),
                  filled: true,
                  fillColor: Colors.black26,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              CustomButton(
                // Usando o seu widget customizado de botão
                text: "Salvar Tarefa",
                onPressed: handleSave,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "TODOS",
          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu),
            onSelected: (val) {
              if (val == 'chat') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChatScreen()),
                );
              } else if (val == 'logout') {
                _handleLogout(context); // Chama a função de logout
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'sync',
                child: Text("Forçar Sincronismo"),
              ),
              const PopupMenuItem(value: 'chat', child: Text("Suporte (Chat)")),
              const PopupMenuDivider(), // Linha divisória para estética
              const PopupMenuItem(
                value: 'logout',
                child: Text("Sair", style: TextStyle(color: Colors.redAccent)),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<TaskModel>>(
        future: _db.getTasksAtivas(), // Busca tarefas do SQLite
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Nenhuma tarefa pendente.",
                style: TextStyle(color: Colors.white54),
              ),
            );
          }

          final tasks = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final item = tasks[index];

              // Efeito de arrastar para o lado (iOS style)
              return Dismissible(
                key: Key(item.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(
                      10,
                    ), // Bordas leves para o swipe
                  ),
                  child: const Icon(Icons.delete_outline, color: Colors.white),
                ),
                onDismissed: (direction) async {
                  // await _db.deleteTask(item.id);
                  await _db.updateTaskStatus(item.id, 2);
                },
                child: TodoTile(
                  label: item.tarefa,
                  onCheck: () async {
                    // Esta função só é chamada após o delay da animação no Widget
                    await _db.updateTaskStatus(item.id, 1);
                    if (mounted) setState(() {});
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskModal,
        backgroundColor: const Color(0xFF1A4D6B),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
