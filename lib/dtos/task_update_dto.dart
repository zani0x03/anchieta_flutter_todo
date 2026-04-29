class TaskUpdateDTO {
  final String id;
  final int status;
  final String idUserLastUpdated;

  TaskUpdateDTO({
    required this.id,
    required this.status,
    required this.idUserLastUpdated,
  });

  // Convertemos para um Map apenas com o que o banco precisa atualizar
  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'idUserLastUpdated': idUserLastUpdated,
      'dtLastUpdated': DateTime.now().toIso8601String(),
    };
  }
}