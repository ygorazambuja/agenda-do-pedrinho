import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String contatoTable = "contatoTable";
final String idColumn = "idColumn";
final String nomeColumn = "nomeColumn";
final String emailColumn = "emailColumn";
final String telefoneColumn = "telefoneColumn";
final String imgColumn = "imgColumn";
final String cpfColumn = "cpfColumn";
final String sexoColumn = 'sexoColumn';
final String enderecoColumn = "enderecoColumn";
final String instagramColumn = 'instagramColumn';
final String facebookColumn = "facebookColumn";
final String dataNascimentoColumn = "dataNascimentoColumn";

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
          await database
              .execute(
              "CREATE TABLE $contatoTable($idColumn INTEGER PRIMARY KEY,"
                  " $nomeColumn TEXT,"
                  " $emailColumn TEXT,"
                  " $telefoneColumn TEXT,"
                  " $imgColumn,"
                  "$cpfColumn TEXT,"
                  "$instagramColumn TEXT,"
                  "$facebookColumn TEXT,"
                  "$sexoColumn TEXT,"
                  "$enderecoColumn TEXT,"
                  "$dataNascimentoColumn TEXT)");
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
        columns: [
          idColumn,
          nomeColumn,
          emailColumn,
          telefoneColumn,
          imgColumn,
          cpfColumn,
          facebookColumn,
          instagramColumn,
          sexoColumn,
          enderecoColumn,
          dataNascimentoColumn
        ],
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
  String cpf;
  String sexo;
  String endereco;
  String instagram;
  String facebook;
  String dataNascimento;

  Contato();

  Contato.fromMap(Map map) {
    id = map[idColumn];
    nome = map[nomeColumn];
    email = map[emailColumn];
    telefone = map[telefoneColumn];
    img = map[imgColumn];
    cpf = map[cpfColumn];
    sexo = map[sexoColumn];
    endereco = map[enderecoColumn];
    instagram = map[instagramColumn];
    facebook = map[facebookColumn];
    dataNascimento = map[dataNascimentoColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nomeColumn: nome,
      emailColumn: email,
      telefoneColumn: telefone,
      imgColumn: img,
      cpfColumn: cpf,
      sexoColumn: sexo,
      enderecoColumn: endereco,
      instagramColumn: instagram,
      facebookColumn: facebook,
      dataNascimentoColumn: dataNascimento
    };
    if (id != null) {
      map[idColumn] = id;
    }

    return map;
  }
}
