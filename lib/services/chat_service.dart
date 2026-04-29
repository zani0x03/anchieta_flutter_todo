import 'dart:convert';
import 'package:http/http.dart' as http;
import '../dtos/chat_dto.dart';

class ChatService {
  final String baseUrl = "https://mobile-ios-ia.zani0x03.eti.br/api/ai/chat";

  Future<ChatResponseDTO> sendMessage(String prompt, String token) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', 
      },
      body: jsonEncode(ChatRequestDTO(prompt: prompt).toJson()),
    );

    if (response.statusCode == 200) {
      return ChatResponseDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Erro ao falar com a IA: ${response.statusCode}");
    }
  }
}