import 'package:flutter/material.dart';
import 'todo_list_screen.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.blueGrey[900],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.bolt, size: 60, color: Colors.cyan),
            ),
            const SizedBox(height: 50),
            const CustomInput(label: "Login", hint: "Digite seu usuário"),
            const SizedBox(height: 20),
            const CustomInput(
              label: "Password",
              hint: "Digite sua senha",
              isObscure: true,
            ),
            const SizedBox(height: 30),
            CustomButton(
              text: "Logar",
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TodoListScreen())),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                "esqueci minha senha",
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
