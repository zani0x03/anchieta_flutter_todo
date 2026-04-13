import 'package:uuid/uuid.dart';

class TaskModel {
  String id;
  String tarefa;
  int status; // 0: Ativa, 1: Removida, 2: Sincronizada
  String? idUserCreated;
  String dtCreated;
  String? idUserLastUpdated;
  String? dtLastUpdated;

  TaskModel({
    String? id,
    required this.tarefa,
    this.status = 0,
    this.idUserCreated,
    String? dtCreated,
    this.idUserLastUpdated,
    this.dtLastUpdated,
  })  : id = id ?? const Uuid().v4(), // Gera UUID se não for passado
        dtCreated = dtCreated ?? DateTime.now().toIso8601String();

  // Converte o Objeto para Map (para salvar no Banco)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tarefa': tarefa,
      'status': status,
      'idUserCreated': idUserCreated,
      'dtCreated': dtCreated,
      'idUserLastUpdated': idUserLastUpdated,
      'dtLastUpdated': dtLastUpdated,
    };
  }

  // Converte o Map do Banco para Objeto
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      tarefa: map['tarefa'],
      status: map['status'],
      idUserCreated: map['idUserCreated'],
      dtCreated: map['dtCreated'],
      idUserLastUpdated: map['idUserLastUpdated'],
      dtLastUpdated: map['dtLastUpdated'],
    );
  }
}