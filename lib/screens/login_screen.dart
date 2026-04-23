import 'package:flutter/material.dart';
import 'todo_list_screen.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_button.dart';
import '../services/auth_service.dart'; // Certifique-se de que o path está correto

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final IAuthService authService = AuthServiceMock();
  // final IAuthService authService = AuthService();

  // 3. A sua função handleLogin atualizada
  void _handleLogin() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final result = await authService.login(
        _loginController.text, 
        _passwordController.text
      );
      
      if (!mounted) return;
      Navigator.pop(context);
      
      print("Token recebido: ${result['access_token']}");
      
      // Navegação para a próxima tela
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (_) => const TodoListScreen())
      );
    } catch (e) {
      // Remove o dialog de carregando em caso de erro
      if (mounted) Navigator.pop(context);

      // Limpa a mensagem de erro para o usuário (remove "Exception: ")
      final errorMessage = e.toString().replaceAll("Exception: ", "");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Container(
              height: 120, width: 120,
              decoration: BoxDecoration(
                color: Colors.blueGrey[900],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.bolt, size: 60, color: Colors.cyan),
            ),
            const SizedBox(height: 50),
            // IMPORTANTE: Adicionei o parâmetro controller no seu CustomInput
            CustomInput(
              label: "Login", 
              hint: "Digite seu usuário",
              controller: _loginController, 
            ),
            const SizedBox(height: 20),
            CustomInput(
              label: "Password",
              hint: "Digite sua senha",
              isObscure: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 30),
            CustomButton(
              text: "Logar",
              onPressed: _handleLogin, // Agora chama a função de autenticação
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