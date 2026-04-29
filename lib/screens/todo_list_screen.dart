import 'package:anchieta_flutter_todo/dtos/task_update_dto.dart';
import 'package:anchieta_flutter_todo/dtos/auth_response_dto.dart';
import 'package:anchieta_flutter_todo/screens/login_screen.dart';
import 'package:anchieta_flutter_todo/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';
import '../database/db_helper.dart';
import '../models/task_model.dart';
import '../widgets/todo_tile.dart';

class TodoListScreen extends StatefulWidget {
  final AuthResponseDto user;
  
  const TodoListScreen({super.key, required this.user});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final DbHelper _db = DbHelper();
  final TextEditingController _taskController = TextEditingController();

  void _handleLogout(BuildContext context) {
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
        void handleSave() async {
          if (_taskController.text.trim().isNotEmpty) {
            // Agora salvamos passando o ID do usuário que extraímos do JWT
            await _db.insertTask(
              TaskModel(
                tarefa: _taskController.text.trim(),
                idUserCreated: widget.user.userId, 
              ),
            );
            _taskController.clear();
            if (context.mounted) Navigator.pop(context);
            setState(() {}); 
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
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => handleSave(),
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
        elevation: 0,
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
                  MaterialPageRoute(builder: (_) => ChatScreen(user: widget.user)),
                );
              } else if (val == 'logout') {
                _handleLogout(context);
              }
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 'sync', child: Text("Forçar Sincronismo")),
              const PopupMenuItem(value: 'chat', child: Text("Suporte (Chat)")),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Text("Sair", style: TextStyle(color: Colors.redAccent)),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SEÇÃO BEM-VINDO (USANDO O MODEL/DTO)
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 10, 25, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Seja bem-vindo,",
                  style: TextStyle(color: Colors.white54, fontSize: 16),
                ),
                Text(
                  widget.user.name, // Nome vindo da API/JWT
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // O FutureBuilder precisa do Expanded para ocupar o resto da tela
          Expanded(
            child: FutureBuilder<List<TaskModel>>(
              future: _db.getTasksAtivas(widget.user.userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.orange));
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final item = tasks[index];

                    return Dismissible(
                      key: Key(item.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.delete_outline, color: Colors.white),
                      ),
                      onDismissed: (direction) async {
                        final updateData = TaskUpdateDTO(
                          id: item.id,
                          status: 2,
                          idUserLastUpdated: widget.user.userId,
                        );

                        await _db.updateTask(updateData);
                      },
                      child: TodoTile(
                        label: item.tarefa,
                        onCheck: () async {
                          final updateData = TaskUpdateDTO(
                            id: item.id,
                            status: 1,
                            idUserLastUpdated: widget.user.userId,
                          );
                          await _db.updateTask(updateData);
                          if (mounted) setState(() {});
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskModal,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}