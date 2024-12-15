
import 'package:external_path/external_path.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path_provider_android/path_provider_android.dart';
import 'package:path_provider_ios/path_provider_ios.dart';


class SqlHelperV2 {
  // Singleton instance
  static final SqlHelperV2 _instance = SqlHelperV2._internal();

  // Database instance
  static sql.Database? _database;

  // Private constructor
  SqlHelperV2._internal();

  // Factory constructor untuk mengakses instance
  factory SqlHelperV2() {
    return _instance;
  }

  // Mendapatkan instance database
  Future<sql.Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  // Inisialisasi database
  Future<sql.Database> _initDatabase() async {
    // Membuka database
    //final PathProviderAndroid providerAndroid = PathProviderAndroid();
    //final PathProviderIOS providerIOS = PathProviderIOS();

    String? path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
    return sql.openDatabase('$path/ops/IGSgForce.db', version: 1, onCreate: (sql.Database database, int version) async {
      // await createTables(database);
    });
  }

  // Menutup database
  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
