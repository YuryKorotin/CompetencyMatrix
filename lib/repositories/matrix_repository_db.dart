import 'dart:async';
import 'dart:collection';
import 'dart:io' as io;
import 'package:competency_matrix/database/models/knowledge_db.dart';
import 'package:competency_matrix/database/models/level_db.dart';
import 'package:competency_matrix/database/models/matrix_db.dart';
import 'package:competency_matrix/database/models/matrix_detaildb.dart';
import 'package:competency_matrix/entities/matrix_detail_entity.dart';
import 'package:competency_matrix/entities/matrix_entity.dart';
import 'package:competency_matrix/entities/matrix_load_result.dart';
import 'package:competency_matrix/repositories/base_matrix_repository.dart';
import 'package:competency_matrix/repositories/matrix_detail_db_result.dart';
import 'package:competency_matrix/statistics/matrix_statistics.dart';
import 'package:competency_matrix/utils/consts.dart';
import 'package:competency_matrix/utils/matrix_preferences.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class MatrixRepositoryDb extends BaseMatrixRepository {
  static const String MATRIX_TABLE_NAME = "matrices";
  static const String MATRIX_DETAIL_TABLE_NAME = "matrix_details";
  static const String KNOWLEDGE_ITEMS_TABLE_NAME = "knowledge_items";
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

    theDb.execute("PRAGMA foreign_keys=ON;");

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
        REFERENCES $MATRIX_TABLE_NAME($ID_COLUMN_NAME) ON DELETE CASCADE
        )""");

    await db.execute(
        """CREATE TABLE $LEVELS_TABLE_NAME
        ($ID_COLUMN_NAME INTEGER PRIMARY KEY, 
        $NAME_COLUMN_NAME TEXT, 
        $DESCRITPION_COLUMN_NAME TEXT,
        $KNOWLEDGE_ITEM_ID_COLUMN_NAME INTEGER NOT NULL,
        FOREIGN KEY ($KNOWLEDGE_ITEM_ID_COLUMN_NAME) 
        REFERENCES $KNOWLEDGE_ITEMS_TABLE_NAME($ID_COLUMN_NAME) ON DELETE CASCADE
        )""");
  }

  // Retrieving matrices from Matrix Tables
  Future<List<MatrixEntity>> load() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM $MATRIX_TABLE_NAME');
    List<MatrixDb> matrices = new List();
    for (int i = 0; i < list.length; i++) {
      matrices.add(
          new MatrixDb(
              BigInt.from(list[i][ID_COLUMN_NAME]),
              list[i][NAME_COLUMN_NAME],
              list[i][CATEGORY_COLUMN_NAME],
              list[i][DESCRITPION_COLUMN_NAME],
              false,
              0));
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
              BigInt.from(list[i][ID_COLUMN_NAME]),
              list[i][NAME_COLUMN_NAME],
              list[i][DESCRITPION_COLUMN_NAME]
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
              BigInt.from(list[i][ID_COLUMN_NAME]),
              list[i][NAME_COLUMN_NAME],
              await getLevels(BigInt.from(list[i][ID_COLUMN_NAME]))));
  }
    return knowledgeItems;
  }

  Future<MatrixDetailEntity> getMatrix(BigInt id) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM $MATRIX_TABLE_NAME WHERE $ID_COLUMN_NAME=$id');
    MatrixDetailDb matrix = new MatrixDetailDb(
      BigInt.from(list[0][ID_COLUMN_NAME]),
      list[0][NAME_COLUMN_NAME],
      await getKnowledgeItems(BigInt.from(list[0][ID_COLUMN_NAME])));

    return matrix;
  }

  Future<MatrixLoadResult> loadSingle(BigInt id) async {
    MatrixDetailEntity parsedItem = await getMatrix(id);

    MatrixPreferences preferences = MatrixPreferences(id);

    var levels = await preferences.getChosenLevels(id);
    var dependentLevelsToCheck = new HashMap<BigInt, List<BigInt>>();
    var dependentLevelsToUncheck = new HashMap<BigInt, List<BigInt>>();

    for (final item in parsedItem.items) {
      var currentLevels = new List<BigInt>();
      for (LevelDb level in item.levels) {
        if (levels.contains(level.id.toString())) {
          level.isChecked = true;
        } else {
          level.isChecked = false;
        }
        currentLevels.add(level.id);

        var levelsCopy = new List<BigInt>();
        levelsCopy.addAll(currentLevels);

        dependentLevelsToCheck[level.id] = levelsCopy;
      }

      currentLevels = new List<BigInt>();

      for (var i = item.levels.length - 1; i >= 0; i--) {
        LevelDb level = item.levels[i];

        currentLevels.add(level.id);

        var levelsCopy = new List<BigInt>();
        levelsCopy.addAll(currentLevels);

        dependentLevelsToUncheck[level.id] = levelsCopy;
      }

    }

    return new MatrixLoadResult.origin(
        parsedItem,
        dependentLevelsToCheck,
        dependentLevelsToUncheck);
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

  void saveKnowledgeItem(KnowledgeItemDb item, BigInt matrixId) async {
    var dbClient = await db;
    var id = await dbClient.transaction((txn) async {
      var name = item.name;
      var id = matrixId.toString();
      var queryString = """INSERT INTO $KNOWLEDGE_ITEMS_TABLE_NAME
          ($NAME_COLUMN_NAME, 
           $MATRIX_ID_COLUMN_NAME) VALUES(
          \'$name\',
          \'$id\')""";
      print(queryString);
      return await txn.rawInsert(queryString);
    });

    item.id = BigInt.from(id);
    saveLevels(item);
  }

  void deleteMatrix(BigInt matrixId) async {
    var dbClient = await db;
    await dbClient.transaction((txn) async {
      return await txn.rawInsert(
          'DELETE FROM $MATRIX_TABLE_NAME WHERE $ID_COLUMN_NAME=$matrixId');
    });
  }

  void saveLevels(KnowledgeItemDb item) async {
    var dbClient = await db;
    for (LevelDb levelDb in item.levels) {
      dbClient.transaction((txn) async {
        var id = item.id.toString();
        var description = levelDb.description;
        var name = levelDb.name;
        var queryString = """INSERT INTO $LEVELS_TABLE_NAME
          ($NAME_COLUMN_NAME, 
           $DESCRITPION_COLUMN_NAME,
           $KNOWLEDGE_ITEM_ID_COLUMN_NAME) VALUES(
            \'$name\',
            \'$description\',
            \'$id\')""";
        print(queryString);
        return await txn.rawInsert(queryString);
      });
    }
  }

  @override
  Future<MatrixEntity> matrixWithProgress(MatrixEntity matrix) async {

    MatrixStatistics statistics = MatrixStatistics(matrix.id);
    var matrixProgress = await statistics.getMatrixProgress();

    return new MatrixDb(
        matrix.id,
        matrix.name,
        matrix.description,
        matrix.category,
        true,
        matrixProgress);
  }
}