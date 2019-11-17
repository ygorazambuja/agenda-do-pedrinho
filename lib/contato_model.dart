import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String contatoTable = "contatoTable";
final String idColumn = "idColumn";
final String nomeColumn = "nomeColumn";
final String emailColumn = "emailColumn";
final String telefoneColumn = "telefoneColumn";
final String imgColumn = "imgColumn";

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

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
    final path = join(databasesPath, "contacts.database");

    return await openDatabase(path, version: 1,
        onCreate: (Database database, int novaVersao) async {
      await database.execute(
          "CREATE TABLE $contatoTable($idColumn INTEGER PRIMARY KEY, $nomeColumn TEXT, $emailColumn TEXT, $telefoneColumn TEXT, $imgColumn)");
    });
  }

  Future<Contato> saveContact(Contato contact) async {
    Database dbContact = await database;
    contact.id = await dbContact.insert(contatoTable, contact.toMap());
    return contact;
  }

  Future<Contato> getContact(int id) async {
    Database dbContact = await database;
    List<Map> maps = await dbContact.query(contatoTable,
        columns: [idColumn, nomeColumn, emailColumn, telefoneColumn, imgColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);

    if (maps.length > 0) {
      return Contato.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteContact(int id) async {
    Database dbContact = await database;
    return await dbContact
        .delete(contatoTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateContact(Contato contact) async {
    Database dbContact = await database;
    return await dbContact.update(contatoTable, contact.toMap(),
        where: "$idColumn = ?", whereArgs: [contact.id]);
  }

  Future<List> getAllContacts() async {
    Database dbContact = await database;
    List listMap = await dbContact.rawQuery("SELECT * FROM $contatoTable");
    List<Contato> listContact = List();
    for (Map m in listMap) {
      listContact.add(Contato.fromMap(m));
    }
    return listContact;
  }

  Future<int> getNumber() async {
    Database dbContact = await database;
    return Sqflite.firstIntValue(
        await dbContact.rawQuery("SELECT COUNT(*) FROM $contatoTable"));
  }

  Future close() async {
    Database dbContact = await database;
    dbContact.close();
  }
}

class Contato {
  int id;
  String nome;
  String email;
  String telefone;
  String img;

  Contato();

  Contato.fromMap(Map map) {
    id = map[idColumn];
    nome = map[nomeColumn];
    email = map[emailColumn];
    telefone = map[telefoneColumn];
    img = map[imgColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nomeColumn: nome,
      emailColumn: email,
      telefoneColumn: telefone,
      imgColumn: img
    };
    if (id != null) {
      map[idColumn] = id;
    }

    return map;
  }

  @override
  String toString() {
    return "Contato (id: $id, nome: $nome, email: $email, phone: $telefone, img: $img)";
  }
}
