import 'dart:convert';

import 'package:anchieta_flutter_todo/services/background_service.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'config/storage_config.dart';
import 'screens/login_screen.dart';
import 'screens/todo_list_screen.dart'; // Importe sua tela principal
import 'dtos/auth_response_dto.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await BackgroundService.init();

  await BackgroundService.startPeriodicTask();

  // 1. Pega a String (JSON) do disco
  final String? authJson = await StorageConfig.storage.getAuthData();

  Widget initialScreen;

  if (authJson != null) {
    // 2. Transforma a String salva de volta em um Map
    final Map<String, dynamic> authMap = jsonDecode(authJson);
    
    // 3. Pega o token de dentro do Map para validar a expiração
    final String token = authMap['access_token'];

    if (!JwtDecoder.isExpired(token)) {
      // 4. Se estiver tudo OK, reconstrói o DTO completo com nome, email, etc.
      final user = AuthResponseDto.fromJson(authMap);
      initialScreen = TodoListScreen(user: user);
    } else {
      initialScreen = const LoginScreen();
    }
  } else {
    initialScreen = const LoginScreen();
  }

  runApp(TodoApp(initialScreen: initialScreen));
}

class TodoApp extends StatelessWidget {
  final Widget initialScreen;

  const TodoApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: initialScreen,
    );
  }
}