import 'dart:async';
import 'dart:io' as io;
import 'package:competency_matrix/database/models/knowledge_db.dart';
import 'package:competency_matrix/database/models/level_db.dart';
import 'package:competency_matrix/database/models/matrix_db.dart';
import 'package:competency_matrix/database/models/matrix_detaildb.dart';
import 'package:competency_matrix/utils/consts.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class MatrixRepositoryDb{
  static const String MATRIX_TABLE_NAME = "matrices";
  static const String MATRIX_DETAIL_TABLE_NAME = "matrix_details";
  static const String KNOWLEDGE_ITEMS_TABLE_NAME = "knowlede_items";
  static const String LEVELS_TABLE_NAME = "levels";

  static const String ID_COLUMN_NAME = "id";
  static const String NAME_COLUMN_NAME = "name";
  static const String CATEGORY_COLUMN_NAME = "category";
  static const String DESCRITPION_COLUMN_NAME = "description";

  static const String MATRIX_ID_COLUMN_NAME = "matrix_id";
  static const String KNOWLEDGE_ITEM_ID_COLUMN_NAME = "knowledge_item_id";

  static Database _db;

  Future<Database> get db async {
    if(_db != null)
      return _db;
    _db = await initDb();
    return _db;
  }

  //Creating a database with name test.db in your directory
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, Consts.DATABASE_NAME);
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  // Creating a table name Matrix with fields
  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        """CREATE TABLE $MATRIX_TABLE_NAME
        ($ID_COLUMN_NAME INTEGER PRIMARY KEY, 
        $NAME_COLUMN_NAME TEXT, 
        $CATEGORY_COLUMN_NAME TEXT, 
        $DESCRITPION_COLUMN_NAME TEXT)
        """);

    await db.execute(
        """CREATE TABLE $KNOWLEDGE_ITEMS_TABLE_NAME
        ($ID_COLUMN_NAME INTEGER PRIMARY KEY, 
        $NAME_COLUMN_NAME TEXT,
        $MATRIX_ID_COLUMN_NAME INTEGER NOT NULL,
        FOREIGN KEY ($MATRIX_ID_COLUMN_NAME) 
        REFERENCES $MATRIX_TABLE_NAME($ID_COLUMN_NAME)
        )""");

    await db.execute(
        """CREATE TABLE $LEVELS_TABLE_NAME
        ($ID_COLUMN_NAME INTEGER PRIMARY KEY, 
        $NAME_COLUMN_NAME TEXT, 
        $DESCRITPION_COLUMN_NAME TEXT
        $KNOWLEDGE_ITEM_ID_COLUMN_NAME INTEGER NOT NULL,
        FOREIGN KEY ($KNOWLEDGE_ITEM_ID_COLUMN_NAME) 
        REFERENCES $KNOWLEDGE_ITEMS_TABLE_NAME($ID_COLUMN_NAME)
        )""");
  }

  // Retrieving matrices from Matrix Tables
  Future<List<MatrixDb>> getMatrices() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM $MATRIX_TABLE_NAME');
    List<MatrixDb> matrices = new List();
    for (int i = 0; i < list.length; i++) {
      matrices.add(
          new MatrixDb(
              id: BigInt.from(list[i][ID_COLUMN_NAME]),
              name: list[i][NAME_COLUMN_NAME],
              category: list[i][CATEGORY_COLUMN_NAME],
              description: list[i][DESCRITPION_COLUMN_NAME],
              isEmbedded: false,
              progress: 0));
    }
    return matrices;
  }

  Future<List<LevelDb>> getLevels(BigInt knowledgeItemId) async {
    var dbClient = await db;
    List<Map> list =
    await dbClient.rawQuery(
        """SELECT * FROM $LEVELS_TABLE_NAME 
        WHERE $KNOWLEDGE_ITEM_ID_COLUMN_NAME=$knowledgeItemId""");
    List<LevelDb> levels = new List();
    for (int i = 0; i < list.length; i++) {
      levels.add(
          new LevelDb(
              id: BigInt.from(list[i][ID_COLUMN_NAME]),
              name: list[i][NAME_COLUMN_NAME],
              description: list[i][DESCRITPION_COLUMN_NAME]
          ));
    }
    return levels;
  }

  Future<List<KnowledgeItemDb>> getKnowledgeItems(BigInt matrixId) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM $KNOWLEDGE_ITEMS_TABLE_NAME WHERE $MATRIX_ID_COLUMN_NAME=$matrixId');
    List<KnowledgeItemDb> knowledgeItems = new List();
    for (int i = 0; i < list.length; i++) {
      knowledgeItems.add(
          new KnowledgeItemDb(
              id: BigInt.from(list[i][ID_COLUMN_NAME]),
              name: list[i][NAME_COLUMN_NAME],
              levelDbItems: await getLevels(BigInt.from(list[i][ID_COLUMN_NAME]))));
  }
    return knowledgeItems;
  }

  Future<MatrixDetailDb> getMatrix(BigInt id) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM $MATRIX_TABLE_NAME WHERE $ID_COLUMN_NAME=$id');
    MatrixDetailDb matrix = new MatrixDetailDb(
      id: BigInt.from(list[0][ID_COLUMN_NAME]),
      name: list[0][NAME_COLUMN_NAME],
      knowledgeDbItems: await getKnowledgeItems(BigInt.from(list[0][ID_COLUMN_NAME])));

    return matrix;
  }

  void saveMatrix(MatrixDb matrix) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO $MATRIX_TABLE_NAME($ID_COLUMN_NAME, $NAME_COLUMN_NAME, $CATEGORY_COLUMN_NAME, $DESCRITPION_COLUMN_NAME) VALUES(' +
              '\'' +
              matrix.id.toString() +
              '\'' +
              ',' +
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

  void deleteMatrix(BigInt matrixId) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'DELETE FROM $MATRIX_TABLE_NAME WHERE $ID_COLUMN_NAME=$matrixId');
    });
  }
}