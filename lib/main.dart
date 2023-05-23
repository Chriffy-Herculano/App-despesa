import 'package:flutter/material.dart';
import 'package:projeto_ex1/reg_despesa.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

void main() async{
 // Exibir o caminho do banco de dados
  runApp(const MyApp());
  final documentsDirectory = await getApplicationDocumentsDirectory();
  final path = join(documentsDirectory.path, 'despesas.db');
  print(path);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gerenciador de Despesa',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const RegDespesa(),
    );
  }
}