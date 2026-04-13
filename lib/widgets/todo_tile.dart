import 'package:flutter/material.dart';

class TodoTile extends StatefulWidget {
  final String label;
  final VoidCallback onCheck;

  const TodoTile({
    super.key, 
    required this.label, 
    required this.onCheck
  });

  @override
  State<TodoTile> createState() => _TodoTileState();
}

class _TodoTileState extends State<TodoTile> {
  bool _isDone = false;

  void _handleTap() async {
    setState(() {
      _isDone = true;
    });

    // Aguarda um tempinho para o usuário ver o efeito antes de sumir/subir
    await Future.delayed(const Duration(milliseconds: 600));
    widget.onCheck();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: _isDone ? 0.3 : 1.0, // Fica "apagadinho" ao concluir
      child: ListTile(
        onTap: _isDone ? null : _handleTap, // Desabilita cliques repetidos
        leading: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: _isDone ? Colors.green : Colors.white54,
              width: 2,
            ),
            color: _isDone ? Colors.green : Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: _isDone 
              ? const Icon(Icons.check, size: 18, color: Colors.white)
              : const Icon(Icons.circle, size: 18, color: Colors.transparent),
          ),
        ),
        title: Text(
          widget.label,
          style: TextStyle(
            color: _isDone ? Colors.grey : Colors.orange,
            fontSize: 18,
            decoration: _isDone ? TextDecoration.lineThrough : null, // Efeito riscado
            decorationColor: Colors.grey,
            decorationThickness: 2,
          ),
        ),
      ),
    );
  }
}