import 'package:external_path/external_path.dart';
import 'package:ops_mobile/core/core/base/base_controller.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:path_provider_ios/path_provider_ios.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SqlHelper extends BaseController {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE branch(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        region_id TINYINT NOT NULL,
        code VARCHAR(50) NOT NULL,
        branch VARCHAR(150) NOT NULL,
        description VARCHAR(255),
        time_zone_id INTEGER NOT NULL
        auto_inc INTEGER(2) NOT NULL,
        created_at DATETIME,
        created_by INTEGER(11),
        update_at DATETIME,
        updated_by INTEGER(11)
      )
      
      CREATE TABLE m_laboratorium(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      code TEXT NOT NULL,
      m_branch_id INTEGER NOT NULL,
      name TEXT NOT NULL,
      preparation_capacity INTEGER,
      analysis_capacity INTEGER,
      status INTEGER NOT NULL,
      created_by INTEGER NOT NULL,
      updated_by INTEGER,
      created_at TIMESTAMP,
      updated_at TIMESTAMP,
      lab_type_id INTEGER NOT NULL 
      )
      
      CREATE TABLE m_statusinspectionstages(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      name TEXT NOT NULL,
      status INTEGER NOT NULL,
      created_by INTEGER NOT NULL,
      updated_by INTEGER NOT NULL,
      created_at TIMESTAMP,
      updated_at TIMESTAMP
      )
      
      CREATE TABLE m_statusjo(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      name VARCHAR(50) NOT NULL,
      status TINYINT,
      created_by INTEGER,
      updated_by INTEGER,
      created_at DATETIME,
      updated_at DATETIME
      )
      
      CREATE TABLE m_statuslaboratoryprogres(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      name TEXT NOT NULL,
      status INTEGER NOT NULL,
      created_by INTEGER NOT NULL,
      updated_by INTEGER,
      created_at TIMESTAMP,
      updated_at TIMESTAMP
      )
      
      CREATE TABLE m_uom(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      name VARCHAR(50) NOT NULL,
      flag_active TINYINT,
      created_by INTEGER,
      updated_by INTEGER,
      created_at DATETIME,
      updated_at DATETIME
      )
      
      CREATE TABLE t_d_jo_document_inspection(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      t_d_jo_finalize_inspection_id INTEGER NOT NULL,
      path_file TEXT,
      file_name TEXT,
      created_by INTEGER NOT NULL,
      updated_by INTEGER NOT NULL,
      created_at TIMESTAMP,
      updated_at TIMESTAMP
      )
      
      CREATE TABLE t_d_jo_document_laboratory(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      t_d_jo_finalize_laboratory_id INTEGER NOT NULL,
      path_file TEXT NOT NULL,
      file_name TEXT,
      created_by INTEGER NOT NULL,
      updated_by INTEGER,
      created_at TIMESTAMP,
      updated_at TIMESTAMP
      )
      
      CREATE TABLE t_d_jo_finalize_inspection(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      t_h_jo_id INTEGER NOT NULL,
      no_report TEXT NOT NULL,
      date_report TEXT NOT NULL,
      no_blanko_certificate TEXT NOT NULL,
      lhv_number TEXT NOT NULL,
      ls_number TEXT NOT NULL,
      created_by INTEGER NOT NULL,
      updated_by INTEGER,
      created_at TIMESTAMP,
      updated_at TIMESTAMP,
      )
      
      CREATE TABLE t_d_jo_finalize_laboratory(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      t_d_jo_laboratory_id INTEGER NOT NULL,
      no_report TEXT NOT NULL,
      date_report TEXT NOT NULL,
      no_blanko_certificate TEXT NOT NULL,
      lhv_number TEXT NOT NULL,
      ls_number TEXT NOT NULL,
      path_pdf TEXT NOT NULL,
      created_by INTEGER NOT NULL,
      updated_by INTEGER,
      created_at TIMESTAMP,
      updated_at TIMESTAMP
      )
      
      
      """);
  }

  static Future<sql.Database> db() async{
    final PathProviderAndroid providerAndroid = PathProviderAndroid();
    final PathProviderIOS providerIOS = PathProviderIOS();

    String? path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
    return sql.openDatabase('$path/ops/IGSgForce.db', version: 1, onCreate: (sql.Database database, int version) async {
      // await createTables(database);
    });
  }

  static Future<List<Map<String, dynamic>>> getUser(String id) async {
    final db = await SqlHelper.db();
    return db.query('user', where: "username = ?", whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getEmployee(String id) async {
    final db = await SqlHelper.db();
    return db.rawQuery('''
      select u.id, u.password_aes  from employee e 
      join user_profile up on up.employee_id = e.id 
      join 'user' u on u.id = up.id
      where e.e_number = "$id"
    ''');
  }

  static Future<List<Map<String, dynamic>>> getLogin(String id) async {
    final db = await SqlHelper.db();
    return db.rawQuery('''select id, password_aes  from user
        where username = $id''');
  }
}