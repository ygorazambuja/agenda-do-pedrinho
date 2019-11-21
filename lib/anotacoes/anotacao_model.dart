import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String anotacaoTable = 'anotacaoTable';
final String idColumn = 'idColumn';
final String tituloColumn = "tituloColumn";
final String informacoesColumn = "informacoesColumn";
final String dateColumn = "dateColumn";

class AnotacaoHelper {
  static final AnotacaoHelper _instance = AnotacaoHelper.internal();

  factory AnotacaoHelper() => _instance;

  AnotacaoHelper.internal();

  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await initDb();
      return _database;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'anotacoes.database');

    return await openDatabase(path, version: 1,
        onCreate: (Database database, int novaVersao) async {
      await database.execute(
          "CREATE TABLE $anotacaoTable($idColumn INTEGER PRIMARY KEY, $tituloColumn TEXT, $informacoesColumn TEXT, $dateColumn TEXT)");
    });
  }

  Future<Anotacao> salvaAnotacao(Anotacao anotacao) async {
    Database db = await database;
    anotacao.id = await db.insert(anotacaoTable, anotacao.toMap());
    return anotacao;
  }

  Future<Anotacao> getAnotacao(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(anotacaoTable,
        columns: [tituloColumn, informacoesColumn, dateColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Anotacao.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deletaAnotacao(int id) async {
    Database db = await database;
    return await db
        .delete(anotacaoTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateAnotacao(Anotacao anotacao) async {
    Database db = await database;
    return await db.update(anotacaoTable, anotacao.toMap(),
        where: '$idColumn = ?', whereArgs: [anotacao.id]);
  }

  Future<List> getTodasAnotacoes() async {
    Database db = await database;
    List listMap = await db.rawQuery('SELECT * FROM $anotacaoTable');
    List<Anotacao> anotacoes = List();
    for (Map m in listMap) {
      anotacoes.add(Anotacao.fromMap(m));
    }
    return anotacoes;
  }

  Future<int> getTotal() async {
    Database db = await database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $anotacaoTable'));
  }

  Future close() async {
    Database db = await database;
    db.close();
  }
}

class Anotacao {
  int id;
  String titulo;
  String informacoes;
  String dateTime;

  Anotacao();

  Anotacao.fromMap(Map map) {
    id = map[idColumn];
    titulo = map[tituloColumn];
    informacoes = map[informacoesColumn];
    dateTime = map[dateTime];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      tituloColumn: titulo,
      informacoesColumn: informacoes,
      dateColumn: dateTime,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Anotação: (id: $id, titulo: $titulo, infomações: $informacoes, data: $dateTime";
  }
}
