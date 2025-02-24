import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:super_app/models/history_detail_model.dart';

class DatabaseHelper {
  static const _databaseName = 'test.db';
  static const _databaseVersion = 2;

  // final qrController = Get.find<QrController>();
  static const table = 'tb_proof';

  // static const columnId = 'id';
  // static const columnName = 'event_name';
  // static const columnDate = 'event_date';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getDatabasesPath();
    final path = join(documentsDirectory, _databaseName);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // id TEXT PRIMARY KEY,
    await db.execute('''
      CREATE TABLE $table (
        id TEXT PRIMARY KEY,
        transid TEXT,
        timestamp TEXT,
        chanel TEXT,
        logo TEXT,
        provider TEXT,
        from_acc TEXT,
        to_acc TEXT,
        to_acc_name TEXT,
        from_acc_name TEXT,
        amount TEXT,
        fee TEXT,
        ramark TEXT,
        point TEXT
      )
    ''');
  }

  Future<void> showTableSchema(String tableName) async {
    final database = openDatabase(
      join(await getDatabasesPath(), _databaseName),
      version: 1,
    );
    final db = await database;
    final columns = await db.rawQuery("PRAGMA table_info('$tableName')");
    for (final column in columns) {
      final name = column['name'];
      final type = column['type'];
      final isNotNull = column['notnull'] == 1;
      final isPrimaryKey = column['pk'] == 1;
      print('Name: $name');
      print('Type: $type');
      print('Not Null: $isNotNull');
      print('Primary Key: $isPrimaryKey');
      print('---');
    }
  }

  Future<List<String>> getAllTables() async {
    final db = await instance.database;
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table'",
    );
    print(tables);
    return List.generate(
        tables.length, (index) => tables[index]['name'] as String);
  }

  Future dropTable() async {
    Database db = await instance.database;
    await db.execute('DROP TABLE IF EXISTS $table');
  }

  Future<void> dropDatabase() async {
    final appDir = await getApplicationDocumentsDirectory();
    final databasePath =
        '${appDir.path}/$_databaseName'; // Replace with the actual database name
    await deleteDatabase(databasePath);
  }

  Future<int> insert(HistoryDetailModel detailModel) async {
    Database db = await instance.database;
    return await db.insert(table, detailModel.toJson());
  }

  // Future<List<Map<String, dynamic>>> queryAllRows() async {
  //   Database db = await instance.database;
  //   return await db.query(table, orderBy: 'primaryKeyColumnName asc');
  // }

  // Future<List<Map<String, dynamic>>> queryAllRows() async {
  //   Database db = await instance.database;
  //   List<Map<String, dynamic>> rows = await db.query(
  //     table,
  //     orderBy: 'id DESC',
  //   );
  //   return rows.reversed.toList();
  // }

  Future<List<HistoryDetailModel>> queryAll() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> rows = await db.query(
      table,
      orderBy: 'id DESC',
    );
    List<HistoryDetailModel> historyDetails = [];
    for (var row in rows) {
      HistoryDetailModel historyDetail = HistoryDetailModel.fromJson(row);
      historyDetails.add(historyDetail);
    }

    return historyDetails;
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update(table, row, where: 'transid = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: 'transid = ?', whereArgs: [id]);
  }

  Future<int> deleteDataByCondition(
      String conditionColumn, dynamic conditionValue) async {
    Database db = await instance.database;
    return await db.delete(table,
        where: '$conditionColumn = ?', whereArgs: [conditionValue]);
  }

  Future deleteAll() async {
    Database db = await instance.database;
    return await db.execute('DELETE FROM $table');
  }
}
