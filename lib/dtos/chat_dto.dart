class ChatRequestDTO {
  final String prompt;

  ChatRequestDTO({required this.prompt});

  Map<String, dynamic> toJson() => {"prompt": prompt};
}

class ChatResponseDTO {
  final String response;

  ChatResponseDTO({required this.response});

  factory ChatResponseDTO.fromJson(Map<String, dynamic> json) {
    return ChatResponseDTO(response: json['response'] ?? "");
  }
}