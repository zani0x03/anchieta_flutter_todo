import 'dart:convert';
import 'package:anchieta_flutter_todo/dtos/auth_response_dto.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

abstract class IAuthService {
  Future<AuthResponseDto> login(String username, String password);
}

class AuthService implements IAuthService {
  final String baseUrl = "https://mobile-ios-login.zani0x03.eti.br/api/auth/login";
  final String sistemaId = "d7f0bddd-ac36-4cdf-8dba-7c752ace6ec6";

@override
  Future<AuthResponseDto> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "username": username,
          "password": password,
          "sistemaId": sistemaId, 
        }),
      );

      if (response.statusCode == 200) {
        return AuthResponseDto.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Credenciais inválidas ou erro no servidor.");
      }
    } catch (e) {
      throw Exception("Erro ao conectar na API: $e");
    }
  }
}

// --- IMPLEMENTAÇÃO MOCK REFATORADA ---
class AuthServiceMock implements IAuthService {
  @override
  Future<AuthResponseDto> login(String username, String password) async {
    // Simula um pequeno atraso de rede (UX para ver o loading)
    await Future.delayed(const Duration(seconds: 1));

    final String mockToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI0ZWQ5NGYxOS03YTY2LTQxNjAtYjUxZC04NTcyZGFhNGU1N2EiLCJuYW1lIjoiVGlhZ28gWmFuaXF1ZWxsaSIsImVtYWlsIjoienRpYWdvQGdtYWlsLmNvbSIsImV4cCI6MTc3NzI2ODc4NiwiaWF0IjoxNzc3MjMyNzg2fQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c";

    if (username == "ztiago" && password == "123456") {
      // 1. Criamos os dados que simulariam o JSON da API
      final Map<String, dynamic> mockData = {
        "access_token": mockToken, // Seu token aqui
        "refresh_token": "mock_refresh_token_123",
        "expires_in": 3600,
      };

      // 2. Retornamos a instância da classe usando o factory que já existe no DTO
      return AuthResponseDto.fromJson(mockData);
    } else {
      // Simula um erro de credenciais
      throw Exception("Usuário ou senha inválidos (Mock)");
    }
  }
}