import 'dart:async';
import 'dart:io' as io;
import 'package:competency_matrix/database/models/matrix.dart';
import 'package:competency_matrix/utils/consts.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class MatrixRepositoryDb{
  static const String MATRIX_TABLE_NAME = "Matrix";

  static const String ID_COLUMN_NAME = "id";
  static const String NAME_COLUMN_NAME = "name";
  static const String CATEGORY_COLUMN_NAME = "category";
  static const String DESCRITPION_COLUMN_NAME = "description";


  static Database _db;

  Future<Database> get db async {
    if(_db != null)
      return _db;
    _db = await initDb();
    return _db;
  }

  //Creating a database with name test.dn in your directory
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, Consts.DATABASE_NAME);
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  // Creating a table name Employee with fields
  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE $MATRIX_TABLE_NAME($ID_COLUMN_NAME INTEGER PRIMARY KEY, $NAME_COLUMN_NAME TEXT, $CATEGORY_COLUMN_NAME TEXT, $DESCRITPION_COLUMN_NAME TEXT)");
    print("Created tables");
  }

  // Retrieving employees from Employee Tables
  Future<List<Matrix>> getMatrices() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM $MATRIX_TABLE_NAME');
    List<Matrix> matrices = new List();
    for (int i = 0; i < list.length; i++) {
      matrices.add(
          new Matrix(
              id: list[i][ID_COLUMN_NAME],
              name: list[i][NAME_COLUMN_NAME],
              category: list[i][CATEGORY_COLUMN_NAME],
              description: list[i][DESCRITPION_COLUMN_NAME],
              isEmbedded: true,
              progress: 0));
    }
    print(matrices.length);
    return matrices;
  }

  void saveEmployee(Matrix matrix) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO Employee($NAME_COLUMN_NAME, $CATEGORY_COLUMN_NAME, $DESCRITPION_COLUMN_NAME) VALUES(' +
              '\'' +
              matrix.name +
              '\'' +
              ',' +
              '\'' +
              matrix.category +
              '\'' +
              ',' +
              '\'' +
              matrix.description +
              '\'' +
              ')');
    });
  }


}