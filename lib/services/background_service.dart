import 'package:workmanager/workmanager.dart';
import 'dart:developer' as developer;

// 1. Função Global (Top-level): É o ponto de entrada do processo separado
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    // Aqui você coloca o que deve acontecer de hora em hora
    // Exemplo: Print no console ou uma notificação
    developer.log("Serviço de Background: Executando tarefa $taskName");
    
    // IMPORTANTE: Retornar true para dizer ao SO que a tarefa foi concluída
    return Future.value(true);
  });
}

class BackgroundService {
  static const String taskName = "com.anchieta.todo.periodicTask";

  // 2. Inicializa o Workmanager
  static Future<void> init() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true, // Deixe true para ver notificações de debug no Android
    );
  }

  // 3. Agenda a tarefa periódica
  static Future<void> startPeriodicTask() async {
    await Workmanager().registerPeriodicTask(
      "1", // ID único da tarefa
      taskName,
      frequency: const Duration(minutes: 1), // Frequência desejada
      constraints: Constraints(
        networkType: NetworkType.connected, // Só executa se houver internet
      ),
    );
  }
}