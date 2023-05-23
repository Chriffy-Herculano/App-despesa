import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as pat;
import 'dart:async';

import 'despesa.dart';

//classe para o gerenciamento de Despesas
class DespesaDao {
  static const String databaseName = 'despesas.db';
  late Future<Database> database;

  //Método para conexão com o banco de dados
  Future connect() async {
    var databasesPath = await getDatabasesPath();
    String path = pat.join(databasesPath, databaseName);
    database = openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) {
        return db.execute("CREATE TABLE IF NOT EXISTS ${Despesa.tableName} ( "
            "${Despesa.columnDespesa} TEXT PRIMARY KEY, "
            "${Despesa.columnTipo} TEXT, "
            "${Despesa.columnValor} DOUBLE)");
      },
    );
  }

  //Método para retornar todos os registros do banco de dados
  //Método para retornar todos os registros do banco de dados
  Future<List<Despesa>> list() async {
    //carrega o banco de dados
    final Database db = await database;
    //aramzena todos os registro em uma lista Map
    final List<Map<String, dynamic>> maps = await db.query(Despesa.tableName);

    //transforrma o Map JSON em um objeto despesa
    return List.generate(maps.length, (i) {
      return Despesa(
        nomeDespesa: maps[i][Despesa.columnDespesa],
        tipoDespesa: maps[i][Despesa.columnTipo],
        valorDespesa: maps[i][Despesa.columnValor],
      );
    });
  }

  // Método para inserir um contato na banco de dados
  Future<void> insert(Despesa despesa) async {
    final Database db = await database;
    await db.insert(
      Despesa.tableName,
      despesa.toMap(),
    );
  }
}
