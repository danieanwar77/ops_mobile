import 'dart:convert';

import 'package:external_path/external_path.dart';
import 'package:flutter/widgets.dart';
import 'package:ops_mobile/core/core/base/base_controller.dart';
import 'package:ops_mobile/data/model/t_d_jo_laboratory_activity_stages.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:path_provider_ios/path_provider_ios.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

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

  static Future<List<Map<String, dynamic>>> getEmployeePassword(String id) async {
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
        where username = ? ''',[id]);
  }

  // static Future<List<Map<String, dynamic>>> decryptPassword(String id) async {
  //   final db = await SqlHelper.db();
  //   return db.rawQuery('''
  //   SELECT id, username, CONVERT(AES_DECRYPT(password_aes, '\$NtIsH@k42@@4')) AS password_aes
  //   FROM user
  //   WHERE id = $id;''');
  // }

  static Future<List<Map<String, dynamic>>> getUserDetail(String id) async {
    final db = await SqlHelper.db();
    return db.rawQuery('''
      select e.id, e.fullname, e.e_number, e.jabatan_id, j.jabatan, e.division_id,  e.superior_id from employee e
      join user u on u.username  = e.e_number
      join jabatan j on j.id = e.jabatan_id
      
      where e.e_number = "$id"
    ''');
  }

  static Future<List<Map<String, dynamic>>> getListJo(int id, int status) async {
    final db = await SqlHelper.db();
    return db.rawQuery('''SELECT 
      a.id as jo_id, 
      a.code, 
      b.id as id_h_so, 
      c.id as id_d_kos, 
      b.sbu_id, 
      d.name as sbu_name, 
      b.company_acc_id, 
      e.company_name, 
      a.m_statusjo_id, 
      f.name as statusjo_name, 
      g.name as kos_name, 
      a.created_at 
      FROM t_h_jo AS a 
      LEFT JOIN t_d_so_kos AS c ON a.m_kindofservice_id = c.id 
      LEFT JOIN t_h_so AS b ON a.t_so_id = b.id 
      LEFT JOIN m_sbu AS d ON d.id = b.sbu_id 
      LEFT JOIN t_h_lead_account AS e ON e.id = b.company_acc_id 
      LEFT JOIN m_statusjo AS f ON f.id = a.m_statusjo_id 
      LEFT JOIN m_kos AS g ON a.m_kindofservice_id = g.id 
      WHERE a.m_statusjo_id = $status
      AND (a.pic_inspector = $id OR a.pic_laboratory = $id)
    ''');
  }

  static Future<List<Map<String, dynamic>>> getDetailJo(int idJo) async {
    final db = await SqlHelper.db();
    return db.rawQuery(''' 
      SELECT
      a.id, b.so_code, a.code,
      inspection_finished_date, laboratory_finished_date,
      a.canceled_date,
      b.created_at AS so_created_at, a.created_at AS jo_created_at, c.id AS id_status_jo, c.`name` AS status_jo, f.company_name,
      g.name as m_client_category_name, b.project_tittle,
      i.region, j.branch, k.site_office,
      l.survey_location,
      m.country as country_survey, n.province as province_survey, o.city as city_survey,
      a1.loading_port,
      a2.country as loading_port_country, a3.province as loading_port_province, a4.city as loading_port_city, p.discharge_port ,
      q.country as discharge_port_country, r.province as discharge_port_province, s.city as discharge_port_city,
      case when t.supplier is null then t.supplier_other else x.company_name end as supplier_name,
      case when t.trader1 is null then t.trader1_other else x1.company_name end as trader1_name,
      case when t.trader2 is null then t.trader2_other else x2.company_name end as trader2_name,
      case when t.trader3 is null then t.trader3_other else x3.company_name end as trader3_name,
      case when t.end_buyer is null then t.end_buyer_other else x.company_name end as end_buyer_name,
      t.notes,
      d.`name`as sbu_name,
      e.`name` as commodity_name, a.etta_vessel,
      a.start_date_of_attendance as start_date_of_attendance, a.end_date_of_attendance as end_date_of_attendance, k.site_office as lokasi_kerja,
      a.pic_inspector as id_pic_inspector,
      a.pic_laboratory as id_pic_laboratory, y.fullname as pic_laboratory, z.fullname as pic_inspector,
      ja.jabatan as pic_lab_job, jb.jabatan as pic_inspector_job,
      u.country as destination_country,
      v.name as destination_category_name, w.name as job_category_name, d1.`name`as kos_name,
      l1.vessel, l1.qty,
      c1.id AS uom_id,
      c1.name as uom_name, a.created_at as jo_created_date,
      GROUP_CONCAT(c4.barge , '|') as barge, d11.`name`as market_segment_name,
      d12.`name`as sub_market_segment_name FROM
      `t_h_jo` AS a
      left join m_kos as d1 on d1.id = a.m_kindofservice_id 
      JOIN t_h_so AS b ON a.t_so_id = b.id
      JOIN m_statusjo AS c ON a.m_statusjo_id = c.id 
      join m_sbu as d on b.sbu_id = d.id
      left join m_commodity as e on b.commodity_id = e.id
      left join t_h_lead_account as f on f.id = b.company_acc_id 
      left join m_client_category as g on g.id= b.client_category_id 
      left join t_d_so_est_rev_ops as h on h.so_id = b.id
      left join region as i on i.id = h.region_id 
      left join branch as j on j.id = h.branch_id
      left join site_office as k on k.id = h.site_office_id
      left join t_d_so_survey_loc as l on l.so_id = b.id and l.flag_active = 1 
      left join country as m on m.id = l.country_id
      left join province as n on l.province_id = n.id 
      left join city as o on l.city_id = o.id
      left join t_d_so_discharge_port as p on p.so_id = b.id and p.flag_active = 1 
      left join country as q on q.id = p.country_id
      left join province as r on p.province_id = r.id 
      left join city as s on p.city_id = s.id
      left join t_d_so_others_ops as t on t.so_id = b.id and t.flag_active = 1 
      left join country as u on u.id = t.dest_country_id
      left join m_destination_cat as v on v.id = t.dest_cat_id and v.flag_active = 1 
      left join m_job_cat as w on w.id = t.job_category_id and w.flag_active = 1 
      left join t_h_lead_account as x on x.id = t.end_buyer and x.flag_active = 1
      left join t_h_lead_account as x1 on x1.id = t.trader1 and x1.flag_active = 1 
      left join t_h_lead_account as x2 on x2.id = t.trader2 and x2.flag_active = 1 
      left join t_h_lead_account as x3 on x3.id = t.trader3 and x3.flag_active = 1 
      left join t_d_so_load_port as a1 on a1.so_id = b.id and a1.flag_active = 1 
      left join country as a2 on a2.id = l.country_id
      left join province as a3 on l.province_id = a3.id 
      left join city as a4 on l.city_id = a4.id
      left join t_d_so_kos l1 on a.t_so_id = l1.so_id and a.m_kindofservice_id = l1.kos_id
      left join t_d_so_kos_barge as c4 on c4.so_kos_id = l1.id and c4.flag_active = 1 
      left join m_uom c1 on c1.id = a.uom_id
      left join m_market_segment as d11 on d11.id = t.market_segment_id and d11.flag_active = 1
      left join m_submarket_segment as d12 on d12.id = t.submarket_segment_id and d12.flag_active = 1
      left join employee as y on a.pic_laboratory = y.id 
      left join employee as z on a.pic_inspector = z.id
      LEFT JOIN jabatan AS ja ON ja.id = y.jabatan_id
      LEFT JOIN jabatan AS jb ON jb.id = z.jabatan_id
      WHERE
      a.id = $idJo
    ''');
  }

  static Future<List<Map<String, dynamic>>> getDetailJoSow(int idJo) async {
    final db = await SqlHelper.db();
    return db.rawQuery(''' 
      select b3.name, b3.id
      from t_h_jo
      join t_d_so_kos as b1 on t_h_jo.t_so_id = b1.so_id and t_h_jo.m_kindofservice_id = b1.kos_id
      join t_d_so_kos_sow as b2 on b1.id = b2.so_kos_id
      join m_sow as b3 on b3.id = b2.sow_id
      where t_h_jo.id = $idJo
    ''');
  }

  static Future<List<Map<String, dynamic>>> getDetailJoOos(int idJo) async {
    final db = await SqlHelper.db();
    return db.rawQuery(''' 
      select d.name, d.id
      from t_h_jo as a
      join t_d_so_kos as b on b.kos_id = a.m_kindofservice_id and b.so_id = a.t_so_id
      join t_d_so_kos_oos as c on c.so_kos_id = b.id
      join m_oos as d on d.id = c.oos_id
      where a.id = $idJo
    ''');
  }

  static Future<List<Map<String, dynamic>>> getDetailJoLap(int idJo) async {
    final db = await SqlHelper.db();
    return db.rawQuery(''' 
      select d.name, d.id
      FROM t_h_jo as a
      join t_d_so_kos as b on b.kos_id = a.m_kindofservice_id and b.so_id = a.t_so_id
      join t_d_so_kos_oos as c on c.so_kos_id = b.id
      join m_lap as d on d.id = c.oos_id
      where a.id = $idJo
    ''');
  }

  static Future<List<Map<String, dynamic>>> getDetailJoStdMethod(int idJo) async {
    final db = await SqlHelper.db();
    return db.rawQuery(''' 
      select d.name, d.id
      from t_h_jo as a
      join t_d_so_kos as b on b.kos_id = a.m_kindofservice_id and b.so_id = a.t_so_id
      join t_d_so_kos_std_method as c on c.so_kos_id = b.id
      join m_std_method as d on d.id = c.std_method_id
      where a.id = $idJo
    ''');
  }

  static Future<List<Map<String, dynamic>>> getDetailJoPicHistory(int idJo) async {
    final db = await SqlHelper.db();
    return db.rawQuery(''' 
       SELECT a.created_at as assigned_date, b.fullname as assign_by,a.remarks,a.etta_vessel,a.start_date_of_attendance,
        a.end_date_of_attendance, k.site_office as lokasi_kerja,
        y.fullname as pic_laboratory,
        z.fullname as pic_inspector
        FROM `t_d_jo_pic_history` as a
        join employee as b on a.created_by = b.id
        join site_office as k on k.id = a.lokasi_kerja
        join employee as y on a.pic_laboratory = y.id
        join employee as z on a.pic_inspector = z.id
        where a.t_h_jo_id = $idJo
    ''');
  }

  static Future<List<Map<String, dynamic>>> getDetailJoLaboratoryList(int idJo) async {
    final db = await SqlHelper.db();
    return db.rawQuery(''' 
    select a.id, b.id as t_d_jo_laboratory_id, b.laboratorium_id , c.name, ifnull(max(d.m_statuslaboratoryprogres_id),0) as max_stage
    from t_h_jo a
    join t_d_jo_laboratory b on b.t_h_jo_id = a.id
    LEFT join t_d_jo_laboratory_activity_stages d on d.d_jo_laboratory_id = b.id AND d.t_h_jo_id = a.id
    join m_laboratorium c on c.id = b.laboratorium_id
    where a.id = $idJo
    group by b.laboratorium_id
    ''');
  }

  static Future<List<Map<String, dynamic>>> getDetailJoImageList(int idJo) async {
    final db = await SqlHelper.db();
    return db.rawQuery(''' 
    select a.id,b.laboratorium_id , c.name, max(d.m_statuslaboratoryprogres_id) as max_stage
    from t_h_jo a
    join t_d_jo_laboratory b on b.t_h_jo_id = a.id
    join t_d_jo_laboratory_activity_stages d on d.d_jo_laboratory_id = b.laboratorium_id
    join m_laboratorium c on c.id = b.laboratorium_id
    where a.id = $idJo
    group by b.laboratorium_id
    ''');
  }

  static Future<List<Map<String, dynamic>>> getDailyPhoto(String idJo) async {
    final db = await SqlHelper.db();
    return db.rawQuery('''
      Select * from t_d_jo_inspection_pict where t_h_jo_id = ‘$idJo’
    ''');
  }

  static Future<List<Map<String, dynamic>>> insertDailyPhoto(int idJo,photo) async {
    final db = await SqlHelper.db();
    return db.rawQuery('''
      INSERT INTO 
      t_d_jo_inspection_pict(t_h_jo_id,path_photo,keterangan,code,created_at) 
      VALUES(
      $idJo,
      
      );
    ''');
  }

  static Future<List<Map<String, dynamic>>> getListActivity(int idJo) async {
    final db = await SqlHelper.db();
    String sql = '''
      SELECT
      a.id AS inspection_stages_id,
      b.code AS code,
      b.id AS inspection_activity_id, a.t_h_jo_id, a.code AS stage_code, a.m_statusinspectionstages_id, c.`name` AS stages_name, a.trans_date,
      a.remarks, b.start_activity_time, b.end_activity_time, b.activity, a.actual_qty
      FROM t_d_jo_inspection_activity_stages AS a
      JOIN t_d_jo_inspection_activity AS b ON a.id = b.t_d_jo_inspection_activity_stages_id JOIN m_statusinspectionstages AS c ON c.id = a.m_statusinspectionstages_id
      WHERE a.t_h_jo_id = $idJo
      AND a.is_active = 1
      AND b.is_active = 1
    ''';
    debugPrint("sql get jo activity ${sql}");
    return db.rawQuery(sql);
  }

  static Future<List<Map<String, dynamic>>> insertActivityStage(int idJo,int status,String transDate, String remarks, String code, int createdBy, String createdAt) async {
    final db = await SqlHelper.db();
    return db.rawQuery('''
      INSERT INTO t_d_jo_inspection_activity_stages(
      t_h_jo_id, 
      m_statusinspectionstages_id, 
      trans_date, 
      remarks, 
      code, 
      is_active,
      created_by, 
      created_at) 
      VALUES(
      $idJo,
      $status,
      '$transDate',
      '$remarks',
      '$code',
      '1',
      $createdBy,
      '$createdAt')
    ''');
  }

  static Future<List<Map<String, dynamic>>> getActivityStage(String date, int employee) async {
    final db = await SqlHelper.db();
    return db.rawQuery('''
      SELECT 
      id, code 
      FROM t_d_jo_inspection_activity_stages 
      WHERE ROWID IN ( SELECT max( id ) FROM t_d_jo_inspection_activity_stages WHERE trans_date = '$date' AND created_by = $employee )
    ''');
  }

  static Future<List<Map<String, dynamic>>> getActivityStageId(String date, int employee, int id) async {
    final db = await SqlHelper.db();
    return db.rawQuery('''
      SELECT 
      id, code 
      FROM t_d_jo_inspection_activity_stages 
      WHERE id = $id AND trans_date = '$date' AND created_by = $employee AND is_active = 1
    ''');
  }

  static Future<List<Map<String, dynamic>>> getActivityListStage(int id) async {
    final db = await SqlHelper.db();
    return db.rawQuery('''
      SELECT 
      id, code 
      FROM t_d_jo_inspection_activity 
      WHERE t_d_jo_inspection_activity_stages_id = $id
      AND is_active = 1
    ''');
  }

  static Future<List<Map<String, dynamic>>> insertActivity(int idJo, int idActStage, String startTime, String endTime, String activity, String code, int idEmployee, String createdAt) async {
    final db = await SqlHelper.db();
    return db.rawQuery('''
      INSERT INTO 
      t_d_jo_inspection_activity(
      t_h_jo_id, 
      t_d_jo_inspection_activity_stages_id, 
      start_activity_time, 
      end_activity_time, 
      activity, 
      code, 
      is_active,
      created_by, 
      created_at) 
      VALUES(
      $idJo,
      $idActStage,
      '$startTime',
      '$endTime',
      '$activity',
      '$code',
      1,
      $idEmployee,
      '$createdAt');
    ''');
  }

  static Future<List<Map<String, dynamic>>> getActivityId(int employee, int id, String code) async {
    final db = await SqlHelper.db();
    return db.rawQuery('''
      SELECT 
      id, code 
      FROM t_d_jo_inspection_activity 
      WHERE id = $id AND code = '$code' AND created_by = $employee
    ''');
  }

  static Future<List<Map<String, dynamic>>> updateActivityStage(int id, String remarks, int idEmployee, String updatedAt) async {
    final db = await SqlHelper.db();
    return db.rawQuery('''
      UPDATE t_d_jo_inspection_activity_stages SET
      remarks = '$remarks',
      updated_by = $idEmployee,
      updated_at = '$updatedAt'
      WHERE
      id = $id
    ''');
  }

  static Future<List<Map<String, dynamic>>> updateActivity(int id, int idActStage, String startTime, String endTime, String activity, String code, int idEmployee, String updatedAt) async {
    final db = await SqlHelper.db();
    return db.rawQuery('''
      UPDATE t_d_jo_inspection_activity SET
      start_activity_time = '$startTime',
      end_activity_time = '$endTime',
      activity = '$activity',
      updated_by = $idEmployee,
      updated_at = '$updatedAt'
      WHERE
      id = $id AND
      code = '$code'
    ''');
  }

  static Future<List<Map<String, dynamic>>> deleteActivityStage(int idJo, String code) async {
    final db = await SqlHelper.db();
    return db.rawQuery('''
      UPDATE t_d_jo_inspection_activity SET 
      is_active = 0
      WHERE
      id = $idJo AND
      code = '$code'
    ''');
  }

  static Future<List<Map<String, dynamic>>> deleteActivity(int id, String code) async {
    final db = await SqlHelper.db();
    return db.rawQuery('''
      UPDATE t_d_jo_inspection_activity  SET 
      is_active = 0
      WHERE
      id = $id AND
      code = '$code'
    ''');
  }

  static Future<List<Map<String, dynamic>>> getInspectionDocument(int idJo) async {
    final db = await SqlHelper.db();
    return db.rawQuery('''
      SELECT 
      id,
      t_h_jo_id,
      no_report, 
      date_report,
      no_blanko_certificate,
      lhv_number,
      ls_number,
      code,
      is_active,
      is_upload,
      created_by,
      updated_by,
      created_at,
      updated_at
      FROM t_d_jo_finalize_inspection
      WHERE t_h_jo_id = $idJo
      and is_active = 1
    ''');
  }

  static Future<List<Map<String, dynamic>>> getLaboratoryDocument(int idJo) async {
    final db = await SqlHelper.db();
    return db.rawQuery('''
      SELECT 
      id,
      t_d_jo_laboratory_id,
      no_report, 
      date_report,
      no_blanko_certificate,
      lhv_number,
      ls_number,
      code,
      is_active,
      is_upload,
      created_by,
      updated_by,
      created_at,
      updated_at
      FROM t_d_jo_finalize_laboratory
      WHERE t_d_jo_laboratory_id = $idJo
      and is_active = 1
    ''');
  }

  static Future<List<Map<String, dynamic>>> getInspectionDocumentFiles(List<dynamic> id) async {
    final db = await SqlHelper.db();
    return db.rawQuery('''
      SELECT 
      id,
      t_d_jo_finalize_inspection_id,
      path_file, 
      file_name,
      code,
      is_active,
      is_upload,
      created_by,
      updated_by,
      created_at,
      updated_at
      FROM t_d_jo_document_inspection
      WHERE t_d_jo_finalize_inspection_id in (${id.join(',')})
      AND is_active = 1
    ''');
  }

  static Future<List<Map<String, dynamic>>> getLaboratoryDocumentFiles(List<dynamic> id) async {
    final db = await SqlHelper.db();
    return db.rawQuery('''
      SELECT 
      id,
      t_d_jo_finalize_laboratory_id,
      path_file, 
      file_name,
      code,
      is_active,
      is_upload,
      created_by,
      updated_by,
      created_at,
      updated_at
      FROM t_d_jo_document_laboratory
      WHERE t_d_jo_finalize_laboratory_id in (${id.join(',')})
      and is_active = 1
    ''');
  }

  static Future<List<Map<String, dynamic>>> getInspectionActivityData() async {
    final db = await SqlHelper.db();
    return db.rawQuery('''
    SELECT a.id, a.code, a.t_h_jo_id AS , a.t_d_jo_inspection_activity_stages_id, b.code AS stage_code, b.m_statusinspectionstages_id, b.trans_date, a.start_activity_time, a.end_activity_time, a.activity, b.remarks, a.is_active, a.is_upload, a.created_by, a.created_at, a.updated_by, a.updated_at FROM t_d_jo_inspection_activity a 
    INNER JOIN t_d_jo_inspection_activity_stages b ON a.t_h_jo_id = b.t_h_jo_id AND a.t_d_jo_inspection_activity_stages_id = b.id ;
    ''');
  }

  static Future<List<Map<String, dynamic>>> getInspectionActivity5Data() async {
    final db = await SqlHelper.db();
    return db.rawQuery('''
    
    ''');
  }

  static Future<List<Map<String, dynamic>>> getDataInspectionForSendManual(int idEmployee) async {
    final db = await SqlHelper.db();
    return db.rawQuery('''
    SELECT * FROM 
(
SELECT 
a.id, 
a.m_statusjo_id AS status_jo,
'inspection' AS jo_type,
'activity' AS status_type, 
NULL AS jo_laboratory_id,
NULL AS laboratorium_id, 
b.id AS stage_id, 
b.code as stage_code, 
b.m_statusinspectionstages_id AS progress_id, 
b.trans_date, 
b.remarks , 
b.is_active as stage_is_active, 
b.is_upload as stage_is_upload,
b.created_by as stage_created_by, 
b.created_at as stage_created_at,
b.updated_by as stage_updated_by, 
b.updated_at as stage_updated_at,
NULL AS total_sample_received , 
NULL AS total_sample_preparation , 
NULL AS total_sample_analyzed ,
c.id AS activity_id,
c.code as activity_code, 
c.start_activity_time , 
c.end_activity_time, 
c.activity , 
c.is_active as activity_is_active, 
c.is_upload as activity_is_upload,
c.created_by as activity_created_by, 
c.created_at as activity_created_at, 
c.updated_by as activity_updated_by,
c.updated_at as activity_updated_at,
d.t_d_jo_inspection_activity_stages_id AS vessel_stage_id, 
d.code AS vessel_code, 
d.vessel , 
d.is_active as vessel_is_active, 
d.is_upload as vessel_is_upload,
d.created_by as vessel_created_by, 
d.created_at as vessel_created_at, 
d.updated_by as vessel_updated_by, 
e.id AS barge_id, 
e.t_d_jo_inspection_activity_stages_id AS barge_stage_id , 
e.barge, 
e.code AS barge_code, 
e.is_active as barge_is_active, 
e.is_upload as barge_is_upload,
e.created_by as barge_created_by, 
e.created_at as barge_created_at, 
e.updated_by as barge_updated_by, 
f.id AS transhipment_id, 
f.t_d_inspection_stages_id AS transhipment_stage_id, 
f.t_d_jo_inspection_activity_id AS transhipment_activity_id , 
f.jetty , 
f.date_arrive , 
f.initial_date , 
f.final_date , 
f.delivery_qty,
f.uom_id , 
f.is_active as transhipment_is_active, 
f.is_upload as transhipment_is_upload,
f.created_by as transhipment_created_by, 
f.created_at as transhipment_created_at, 
f.updated_by as transhipment_updated_by,
g.id AS attachment_id, 
g.t_d_jo_inspection_activity_stages_id AS attachment_stage_id , 
NULL AS attachment_laboratory_id,
g.path_name , 
g.file_name, 
g.description, 
g.code AS attachment_code, 
g.is_active as attachment_is_active, 
g.is_upload as attachment_is_upload,
g.created_by as attachment_created_by, 
g.created_at AS attachment_created_at, 
g.updated_by as attachment_updated_by,
NULL AS finalize_id, NULL AS finalize_jo_id, NULL AS finalize_code, 
NULL AS no_report, NULL AS date_report, NULL AS no_blanko_certificate, 
NULL AS lhv_number, NULL AS ls_number,
NULL AS finalize_is_active, NULL AS finalize_is_upload,
NULL AS finalize_created_by, NULL AS finalize_created_at,
NULL AS finalize_updated_by,
NULL AS document_id, NULL AS document_path_file, NULL AS document_file_name 
from t_h_jo a
  left join t_d_jo_inspection_activity_stages b on b.t_h_jo_id = a.id AND b.is_active = 1
  left join t_d_jo_inspection_activity c on c.t_h_jo_id = a.id and c.t_d_jo_inspection_activity_stages_id = b.id AND c.is_active = 1
  LEFT JOIN t_d_jo_inspection_activity_vessel d ON d.t_d_jo_inspection_activity_stages_id = b.id AND d.t_h_jo_id = a.id AND d.is_active = 1
  LEFT JOIN t_d_jo_inspection_activity_barge e ON e.t_h_jo_id  = a.id AND e.t_d_jo_inspection_activity_stages_id = b.id AND e.is_active = 1
  LEFT JOIN t_d_jo_inspection_activity_stages_transhipment f ON f.t_d_inspection_stages_id = b.id AND f.t_d_jo_inspection_activity_id = c.id AND f.is_active = 1
  LEFT JOIN t_d_jo_inspection_attachment g ON g.t_h_jo_id = a.id AND g.t_d_jo_inspection_activity_stages_id = b.id AND g.is_active = 1
  where b.is_active = 1 AND a.pic_inspector = $idEmployee
UNION
SELECT
b.id, 
b.m_statusjo_id AS status_jo,
'inspection' AS jo_type,
'finalize' AS status_type, 
NULL AS jo_laboratory_id,
NULL AS laboratorium_id, 
NULL AS stage_id, 
NULL AS stage_code, 
NULL AS progress_id, 
NULL AS trans_date, 
NULL AS remarks , 
NULL AS stage_is_active, 
NULL AS stage_is_upload,
NULL AS stage_created_by, 
NULL AS stage_created_at,
NULL AS stage_updated_by, 
NULL AS stage_updated_at,
NULL AS total_sample_received , 
NULL AS total_sample_preparation , 
NULL AS total_sample_analyzed ,
NULL AS activity_id,
NULL AS activity_code, 
NULL AS start_activity_time , 
NULL AS end_activity_time, 
NULL AS activity , 
NULL AS activity_is_active, 
NULL AS activity_is_upload,
NULL AS activity_created_by, 
NULL AS activity_created_at, 
NULL AS activity_updated_by,
NULL AS activity_updated_at,
NULL AS vessel_stage_id, 
NULL AS vessel_code, 
NULL AS vessel , 
NULL AS vessel_is_active, 
NULL AS vessel_is_upload,
NULL AS vessel_created_by, 
NULL AS vessel_created_at, 
NULL AS vessel_updated_by, 
NULL AS barge_id, 
NULL AS barge_stage_id , 
NULL AS barge, 
NULL AS barge_code, 
NULL AS barge_is_active, 
NULL AS barge_is_upload,
NULL AS barge_created_by, 
NULL AS barge_created_at, 
NULL AS barge_updated_by, 
NULL AS transhipment_id, 
NULL AS transhipment_stage_id, 
NULL AS transhipment_activity_id , 
NULL AS jetty , 
NULL AS date_arrive , 
NULL AS initial_date , 
NULL AS final_date , 
NULL AS delivery_qty,
NULL AS uom_id , 
NULL AS transhipment_is_active, 
NULL AS transhipment_is_upload,
NULL AS transhipment_created_by, 
NULL AS transhipment_created_at, 
NULL AS transhipment_updated_by,
NULL AS attachment_id, 
NULL AS attachment_stage_id , 
NULL AS attachment_laboratory_id,
NULL AS path_name , 
NULL AS file_name, 
NULL AS description, 
NULL AS attachment_code, 
NULL AS attachment_is_active, 
NULL AS attachment_is_upload,
NULL AS attachment_created_by, 
NULL AS attachment_created_at, 
NULL AS attachment_updated_by,
a.id AS finalize_id, a.t_h_jo_id AS finalize_jo_id, a.code AS finalize_code, 
a.no_report, a.date_report, a.no_blanko_certificate, a.lhv_number, a.ls_number,
a.is_active as finalize_is_active, a.is_upload as finalize_is_upload,
a.created_by as finalize_created_by, a.created_at AS finalize_created_at,
a.updated_by AS finalize_updated_by, 
c.id AS document_id, c.path_file AS document_path_file, c.file_name AS document_file_name
FROM t_d_jo_finalize_inspection a
LEFT JOIN t_h_jo b ON a.t_h_jo_id = b.id
LEFT JOIN t_d_jo_document_inspection c ON c.t_d_jo_finalize_inspection_id = a.id AND c.is_active = 1
WHERE a.is_active = 1 AND b.pic_inspector = $idEmployee
UNION 
SELECT 
a.id, 
a.m_statusjo_id AS status_jo,
'laboratory' AS jo_type,
'activity' AS status_type, 
b.id AS laboratory_id,
b.laboratorium_id , 
c.id AS stage_id, 
c.code as stage_code, 
c.m_statuslaboratoryprogres_id AS progress_id, 
c.trans_date, 
c.remarks , 
c.is_active as stage_is_active, 
c.is_upload as stage_is_upload,
c.created_by as stage_created_by, 
c.created_at as stage_created_at,
c.updated_by as stage_updated_by, 
c.updated_at as stage_updated_at,
c.total_sample_received , 
c.total_sample_preparation , 
c.total_sample_analyzed ,
d.id AS activity_id,
d.code as activity_code, 
d.start_activity_time , 
d.end_activity_time, 
d.activity , 
d.is_active as activity_is_active, 
d.is_upload as activity_is_upload,
d.created_by as activity_created_by, 
d.created_at as activity_created_at, 
d.updated_by as activity_updated_by,
d.updated_at as activity_updated_at,
NULL AS vessel_stage_id, 
NULL AS vessel_code, 
NULL AS vessel , 
NULL as vessel_is_active, 
NULL as vessel_is_upload,
NULL as vessel_created_by, 
NULL as vessel_created_at, 
NULL as vessel_updated_by, 
NULL AS barge_id, 
NULL AS barge_stage_id , 
NULL AS barge, 
NULL AS barge_code, 
NULL as barge_is_active, 
NULL as barge_is_upload,
NULL as barge_created_by, 
NULL as barge_created_at, 
NULL as barge_updated_by, 
NULL AS transhipment_id, 
NULL AS transhipment_stage_id, 
NULL AS transhipment_activity_id , 
NULL AS jetty , 
NULL AS date_arrive , 
NULL AS initial_date , 
NULL AS final_date , 
NULL AS delivery_qty,
NULL AS uom_id , 
NULL AS transhipment_is_active, 
NULL AS transhipment_is_upload,
NULL AS transhipment_created_by, 
NULL AS transhipment_created_at, 
NULL AS transhipment_updated_by,
e.id AS attachment_id, 
NULL AS attachment_stage_id , 
e.t_d_jo_laboratory_id AS attachment_laboratory_id,
e.path_name , 
e.file_name, 
NULL AS description, 
e.code AS attachment_code, 
e.is_active as attachment_is_active, 
e.is_upload as attachment_is_upload,
e.created_by as attachment_created_by, 
e.created_at AS attachment_created_at, 
e.updated_by as attachment_updated_by,
NULL AS finalize_id, NULL AS finalize_jo_id, NULL AS finalize_code, 
NULL AS no_report, NULL AS date_report, NULL AS no_blanko_certificate, 
NULL AS lhv_number, NULL AS ls_number,
NULL AS finalize_is_active, NULL AS finalize_is_upload,
NULL AS finalize_created_by, NULL AS finalize_created_at,
NULL AS finalize_updated_by,
NULL AS document_id, NULL AS document_path_file, NULL AS document_file_name 
FROM t_h_jo a
LEFT JOIN t_d_jo_laboratory AS b ON b.t_h_jo_id = a.id AND b.is_active = 1
LEFT JOIN t_d_jo_laboratory_activity_stages AS c ON c.t_h_jo_id = a.id AND c.d_jo_laboratory_id = b.id AND c.is_active = 1
LEFT JOIN t_d_jo_laboratory_activity AS d ON d.t_d_jo_laboratory_activity_stages_id = c.id AND d.t_d_jo_laboratory_id = b.id AND d.is_active = 1
LEFT JOIN t_d_jo_laboratory_attachment AS e ON e.t_d_jo_laboratory_id = b.id AND e.is_active = 1
where a.pic_laboratory = $idEmployee
UNION 
SELECT 
b.id, 
b.m_statusjo_id AS status_jo,
'laboratory' AS jo_type,
'finalize' AS status_type, 
NULL AS jo_laboratory_id,
NULL AS laboratorium_id, 
NULL AS stage_id, 
NULL AS stage_code, 
NULL AS progress_id, 
NULL AS trans_date, 
NULL AS remarks , 
NULL AS stage_is_active, 
NULL AS stage_is_upload,
NULL AS stage_created_by, 
NULL AS stage_created_at,
NULL AS stage_updated_by, 
NULL AS stage_updated_at,
NULL AS total_sample_received , 
NULL AS total_sample_preparation , 
NULL AS total_sample_analyzed ,
NULL AS activity_id,
NULL AS activity_code, 
NULL AS start_activity_time , 
NULL AS end_activity_time, 
NULL AS activity , 
NULL AS activity_is_active, 
NULL AS activity_is_upload,
NULL AS activity_created_by, 
NULL AS activity_created_at, 
NULL AS activity_updated_by,
NULL AS activity_updated_at,
NULL AS vessel_stage_id, 
NULL AS vessel_code, 
NULL AS vessel , 
NULL AS vessel_is_active, 
NULL AS vessel_is_upload,
NULL AS vessel_created_by, 
NULL AS vessel_created_at, 
NULL AS vessel_updated_by, 
NULL AS barge_id, 
NULL AS barge_stage_id , 
NULL AS barge, 
NULL AS barge_code, 
NULL AS barge_is_active, 
NULL AS barge_is_upload,
NULL AS barge_created_by, 
NULL AS barge_created_at, 
NULL AS barge_updated_by, 
NULL AS transhipment_id, 
NULL AS transhipment_stage_id, 
NULL AS transhipment_activity_id , 
NULL AS jetty , 
NULL AS date_arrive , 
NULL AS initial_date , 
NULL AS final_date , 
NULL AS delivery_qty,
NULL AS uom_id , 
NULL AS transhipment_is_active, 
NULL AS transhipment_is_upload,
NULL AS transhipment_created_by, 
NULL AS transhipment_created_at, 
NULL AS transhipment_updated_by,
NULL AS attachment_id, 
NULL AS attachment_stage_id , 
NULL AS attachment_laboratory_id,
NULL AS path_name , 
NULL AS file_name, 
NULL AS description, 
NULL AS attachment_code, 
NULL AS attachment_is_active, 
NULL AS attachment_is_upload,
NULL AS attachment_created_by, 
NULL AS attachment_created_at, 
NULL AS attachment_updated_by,
a.id AS finalize_id, b.id AS finalize_jo_id, a.code AS finalize_code, 
a.no_report, a.date_report, a.no_blanko_certificate, a.lhv_number, a.ls_number,
a.is_active as finalize_is_active, a.is_upload as finalize_is_upload,
a.created_by as finalize_created_by, a.created_at AS finalize_created_at,
a.updated_by AS finalize_updated_by, 
c.id AS document_id, c.path_file AS document_path_file, c.file_name AS document_file_name
FROM t_d_jo_finalize_laboratory a
LEFT JOIN t_d_jo_laboratory d ON d.id = a.t_d_jo_laboratory_id 
LEFT JOIN t_h_jo b ON b.id = d.t_h_jo_id
LEFT JOIN t_d_jo_document_inspection c ON c.t_d_jo_finalize_inspection_id = a.id AND c.is_active = 1
WHERE a.is_active = 1 AND b.pic_laboratory = $idEmployee
) ORDER BY id
    ''');
  }

  static Future<List<Map<String, dynamic>>> getDetailActivityLaboratory(int id, int employeeId, int labId) async {
    final db = await SqlHelper.db();
    return db.rawQuery('''
    SELECT
a.id, 
a.m_statusjo_id AS status_jo,
'laboratory' AS jo_type,
'activity' AS status_type, 
b.id AS laboratory_id,
b.laboratorium_id , 
c.id AS stage_id, 
c.code as stage_code, 
c.m_statuslaboratoryprogres_id AS progress_id, 
c.trans_date, 
c.remarks , 
c.is_active as stage_is_active, 
c.is_upload as stage_is_upload,
c.created_by as stage_created_by, 
c.created_at as stage_created_at,
c.updated_by as stage_updated_by, 
c.updated_at as stage_updated_at,
c.total_sample_received , 
c.total_sample_preparation , 
c.total_sample_analyzed ,
d.id AS activity_id,
d.code as activity_code, 
d.start_activity_time , 
d.end_activity_time, 
d.activity , 
d.is_active as activity_is_active, 
d.is_upload as activity_is_upload,
d.created_by as activity_created_by, 
d.created_at as activity_created_at, 
d.updated_by as activity_updated_by,
d.updated_at as activity_updated_at,
e.id AS attachment_id, 
NULL AS attachment_stage_id , 
e.t_d_jo_laboratory_id AS attachment_laboratory_id,
e.path_name , 
e.file_name, 
NULL AS description, 
e.code AS attachment_code, 
e.is_active as attachment_is_active, 
e.is_upload as attachment_is_upload,
e.created_by as attachment_created_by, 
e.created_at AS attachment_created_at, 
e.updated_by as attachment_updated_by,
NULL AS finalize_id, NULL AS finalize_jo_id, NULL AS finalize_code, 
NULL AS no_report, NULL AS date_report, NULL AS no_blanko_certificate, 
NULL AS lhv_number, NULL AS ls_number,
NULL AS finalize_is_active, NULL AS finalize_is_upload,
NULL AS finalize_created_by, NULL AS finalize_created_at,
NULL AS finalize_updated_by,
NULL AS document_id, NULL AS document_path_file, NULL AS document_file_name 
FROM t_h_jo a
LEFT JOIN t_d_jo_laboratory AS b ON b.t_h_jo_id = a.id
LEFT JOIN t_d_jo_laboratory_activity_stages AS c ON c.t_h_jo_id = a.id AND c.d_jo_laboratory_id = b.id AND c.is_active = 1
LEFT JOIN t_d_jo_laboratory_activity AS d ON d.t_d_jo_laboratory_activity_stages_id = c.id AND d.t_d_jo_laboratory_id = b.id AND d.is_active = 1
LEFT JOIN t_d_jo_laboratory_attachment AS e ON e.t_d_jo_laboratory_id = b.id AND e.is_active = 1
WHERE a.id = $id AND b.laboratorium_id = $labId AND a.pic_laboratory = $employeeId
    ''');
  }

  static Future<void> insertInspectionActivity6(String stage, String activity, String? attachment) async {
    final db = await SqlHelper.db();
    db.execute('''
      INSERT INTO t_d_jo_inspection_activity_stages (t_h_jo_id, m_statusinspectionstages_id, trans_date, remarks, created_by, created_at, code, is_active, is_upload)
     VALUES $stage
    ''');
    db.execute('''
      INSERT INTO t_d_jo_inspection_activity (t_h_jo_id, t_d_jo_inspection_activity_stages_id, start_activity_time, end_activity_time, activity, code, is_active, is_upload, created_by, created_at)
         VALUES $activity
    ''');
    if(attachment != null){
      db.execute('''
      INSERT INTO t_d_jo_inspection_attachment (t_h_jo_id, path_name, file_name, code, is_active, is_upload, created_by, created_at)
        VALUES $attachment
    ''');
    }
  }

  static Future<void> updateInspectionActivity6(String stage, String activity, List<Map<String,dynamic>> attachment, int idJo) async {
    final db = await SqlHelper.db();
    db.execute('''
      INSERT OR REPLACE INTO t_d_jo_inspection_activity_stages (id, t_h_jo_id, m_statusinspectionstages_id, trans_date, remarks, created_by, updated_by, created_at, updated_at, code, is_active, is_upload)
     VALUES $stage
    ''');
    db.execute('''
      INSERT OR REPLACE INTO t_d_jo_inspection_activity (id, t_h_jo_id, t_d_jo_inspection_activity_stages_id, start_activity_time, end_activity_time, activity, code, is_active, is_upload, created_by, updated_by, created_at, updated_at)
         VALUES $activity
    ''');

    Batch batch = db.batch();
    attachment.forEach((item){
      batch.insert('t_d_jo_inspection_attachment',item,conflictAlgorithm: ConflictAlgorithm.replace);
    });
    var id = await batch.commit();
    debugPrint('hasil batch: ${id}');

    db.execute('''
      UPDATE t_d_jo_inspection_attachment SET is_active = 0 WHERE t_h_jo_id = $idJo AND id NOT IN (${id!.join(',')})
      ''');
  }

  static Future<void> updateActivity5(String stage, String activity, String vessel, String barge, String transhipment) async {
    final db = await SqlHelper.db();
    db.execute('''
      INSERT OR REPLACE INTO t_d_jo_inspection_activity_stages (t_h_jo_id, m_statusinspectionstages_id, trans_date, actual_qty, uom_id, remarks, code,  is_active, is_upload, created_by, created_at)
     VALUES $stage
    ''');
    db.execute('''
      INSERT OR REPLACE INTO t_d_jo_inspection_activity (t_h_jo_id, t_d_jo_inspection_activity_stages_id, start_activity_time, end_activity_time, activity, code, is_active, is_upload, created_by, created_at)
         VALUES $activity
    ''');
    db.execute('''
      INSERT OR REPLACE INTO t_d_jo_inspection_activity_vessel (t_h_jo_id, t_d_jo_inspection_activity_stages_id, vessel, code, is_active, is_upload, created_by, created_at)
        VALUES $vessel
    ''');
    if(barge != null){
      db.execute('''
      INSERT OR REPLACE INTO t_d_jo_inspection_activity_barge (t_h_jo_id, t_d_jo_inspection_activity_stages_id, barge, code, is_active, is_upload, created_by, created_at)
        VALUES $barge
    ''');
    }
    if(transhipment != null){
      db.execute('''
      INSERT OR REPLACE INTO t_d_jo_inspection_activity_transhipment (t_d_jo_inspection_stages_id, t_d_jo_inspection_activity_id, initial_date, final_date, date_arrive, delivery_qty, uom_id, jetty, code, is_active, is_upload, created_by, created_at)
        VALUES $transhipment
    ''');
    }
  }

  static Future<void> insertLaboratoryActivity(String stage, String activity) async {
    final db = await SqlHelper.db();
    db.execute('''
      INSERT INTO t_d_jo_laboratory_activity_stages (d_jo_laboratory_id, t_h_jo_id, m_statuslaboratoryprogres_id, trans_date, remarks, created_by, created_at, code, is_active, is_upload)
     VALUES $stage
    ''');
    db.execute('''
      INSERT INTO t_d_jo_laboratory_activity (t_d_jo_laboratory_activity_stages_id, t_d_jo_laboratory_id, start_activity_time, end_activity_time, activity, code, is_active, is_upload, created_by, created_at)
         VALUES $activity
    ''');
  }

  static Future<void> updateLaboratoryActivity(List<Map<String,dynamic>> labStageActivity, String activity, int idJo, int idLab, int stageProgres) async {
    final db = await SqlHelper.db();
    debugPrint('isi lab stage activity: ${jsonEncode(labStageActivity)}');

    Batch batch = db.batch();
    labStageActivity.forEach((item){
      batch.insert('t_d_jo_laboratory_activity_stages',item,conflictAlgorithm: ConflictAlgorithm.replace);
    });
    var id = await batch.commit();
    debugPrint('hasil batch: ${id}');

    // labStageActivity.forEach((stage) async {
    //   Map<String, dynamic> stageMap = {
    //     'id': stage.id,
    //     'd_jo_laboratory_id': stage.dJoLaboratoryId,
    //     't_h_jo_id': stage.tHJoId,
    //     'm_statuslaboratoryprogres_id': stage.mStatuslaboratoryprogresId,
    //     'trans_date': stage.transDate,
    //     'remarks': stage.remarks,
    //     'created_by': stage.createdBy,
    //     'updated_by': stage.updatedBy,
    //     'created_at': stage.createdAt,
    //     'updated_at': stage.updatedAt,
    //     'total_sample_received': stage.totalSampleReceived,
    //     'total_sample_analyzed': stage.totalSampleAnalyzed,
    //     'total_sample_preparation': stage.totalSamplePreparation,
    //     'code': stage.code,
    //     'is_active': stage.isActive,
    //     'is_upload': stage.isUpload,
    //   };
    //   var idStage = await db.insert('t_d_jo_laboratory_activity_stages',stageMap,conflictAlgorithm: ConflictAlgorithm.replace);
    //   stage.listLabActivity!.forEach((activity) async {
    //     Map<String, dynamic> activityMap = {
    //       'id' : activity.id ?? null,
    //       't_d_jo_laboratory_activity_stages_id' : activity.tDJoLaboratoryActivityStagesId ?? idStage,
    //       't_d_jo_laboratory_id' : activity.tDJoLaboratoryId,
    //       'start_activity_time' : activity.startActivityTime,
    //       'end_activity_time' : activity.endActivityTime,
    //       'activity' : activity.activity,
    //       'code' : activity.code,
    //       'is_active' : 1,
    //       'is_upload' : 0,
    //       'created_by' : activity.createdBy,
    //       'updated_by' : activity.id != null ? activity.updatedBy : null,
    //       'created_at' : activity.createdAt,
    //       'updated_at' : activity.id != null ? activity.updatedAt : null,
    //     };
    //     var idActivity = await db.insert('t_d_jo_laboratory_activity',activityMap,conflictAlgorithm: ConflictAlgorithm.replace);
    //     idActivities.add(idActivity);
    //   });
    //   idStages.add(idStage);
    // });

    // Batch batch = db.batch();
    // stage.forEach((item){
    //   batch.insert('t_d_jo_laboratory_activity_stages',item,conflictAlgorithm: ConflictAlgorithm.replace);
    // });
    // var id = await batch.commit();

    db.execute('''
      UPDATE t_d_jo_laboratory_activity_stages SET is_active = 0 WHERE t_h_jo_id = $idJo AND m_statuslaboratoryprogres_id = $stageProgres AND id NOT IN (${id.join(',')})
    ''');

    // db.execute('''
    //   UPDATE t_d_jo_laboratory_activity SET is_active = 0 WHERE  WHERE t_d_jo_laboratory_id = $idLab AND id NOT IN (${idActivities.join(',')})
    // ''');

    db.execute('''
      INSERT OR REPLACE INTO t_d_jo_laboratory_activity (id, t_d_jo_laboratory_activity_stages_id, t_d_jo_laboratory_id, start_activity_time, end_activity_time, activity, code, is_active, is_upload, created_by, updated_by, created_at, updated_at)
         VALUES $activity
    ''');

    // db.execute('''
    //   UPDATE t_d_jo_laboratory_activity SET is_active = 0 WHERE t_d_jo_laboratory_id = $idLab AND t_d_jo_laboratory_activity_stages_id NOT IN (${id!.join(',')})
    // ''');

    // db.execute('''
    //   INSERT OR REPLACE INTO t_d_jo_laboratory_activity_stages (id, d_jo_laboratory_id, t_h_jo_id, m_statuslaboratoryprogres_id, trans_date, remarks, created_by, created_at, code, is_active, is_upload)
    //  VALUES $stage
    // ''');

    // db.execute('''
    //   INSERT OR REPLACE INTO t_d_jo_laboratory_activity (id, t_d_jo_laboratory_activity_stages_id, t_d_jo_laboratory_id, start_activity_time, end_activity_time, activity, code, is_active, is_upload, created_by, created_at)
    //      VALUES $activity
    // ''');
  }

  static Future<void> insertLaboratoryActivity5(String stage, String activity) async {
    final db = await SqlHelper.db();
    db.execute('''
      INSERT INTO t_d_jo_laboratory_activity_stages (d_jo_laboratory_id, t_h_jo_id, m_statuslaboratoryprogres_id, trans_date, remarks, created_by, created_at, code, is_active, is_upload)
     VALUES $stage
    ''');
    db.execute('''
      INSERT INTO t_d_jo_laboratory_activity (t_d_jo_laboratory_activity_stages_id, t_d_jo_laboratory_id, start_activity_time, end_activity_time, activity, code, is_active, is_upload, created_by, created_at)
         VALUES $activity
    ''');
  }

  static Future<void> updateLaboratoryActivity5(String stage, String activity) async {
    final db = await SqlHelper.db();
    db.execute('''
      INSERT OR REPLACE INTO t_d_jo_laboratory_activity_stages (id, d_jo_laboratory_id, t_h_jo_id, m_statuslaboratoryprogres_id, trans_date, remarks, total_sample_received, total_sample_analyzed, total_sample_preparation, created_by, created_at, code, is_active, is_upload)
     VALUES $stage
    ''');
    db.execute('''
      INSERT OR REPLACE INTO t_d_jo_laboratory_activity (id, t_d_jo_laboratory_activity_stages_id, t_d_jo_laboratory_id, start_activity_time, end_activity_time, activity, code, is_active, is_upload, created_by, created_at)
         VALUES $activity
    ''');
  }

  static Future<void> insertLaboratoryActivity6(String stage, String activity, String? attachment) async {
    final db = await SqlHelper.db();
    db.execute('''
      INSERT INTO t_d_jo_laboratory_activity_stages (d_jo_laboratory_id, t_h_jo_id, m_statuslaboratoryprogres_id, trans_date, remarks, total_sample_received, total_sample_analyzed, total_sample_preparation, created_by, created_at, code, is_active, is_upload)
     VALUES $stage
    ''');
    db.execute('''
      INSERT INTO t_d_jo_laboratory_activity (t_d_jo_laboratory_activity_stages_id, t_d_jo_laboratory_id, start_activity_time, end_activity_time, activity, code, is_active, is_upload, created_by, created_at)
         VALUES $activity
    ''');
    if(attachment != null){
      db.execute('''
      INSERT INTO t_d_jo_laboratory_attachment (t_d_jo_laboratory_id, m_statuslaboratoryprogres_id, path_name, file_name, code, is_active, is_upload, created_by, created_at)
        VALUES $attachment
    ''');
    }
  }

  static Future<void> updateLaboratoryActivity6(String stage, String activity, List<Map<String,dynamic>> attachment) async {
    final db = await SqlHelper.db();
    db.execute('''
      INSERT OR REPLACE INTO t_d_jo_laboratory_activity_stages (id, d_jo_laboratory_id, t_h_jo_id, m_statuslaboratoryprogres_id, trans_date, remarks, created_by, updated_by, created_at, updated_at, code, is_active, is_upload)
     VALUES $stage
    ''');
    db.execute('''
      INSERT OR REPLACE INTO t_d_jo_laboratory_activity (id, t_d_jo_laboratory_activity_stages_id, t_d_jo_laboratory_id, start_activity_time, end_activity_time, activity, code, is_active, is_upload, created_by, updated_by, created_at, updated_at)
         VALUES $activity
    ''');

    if(attachment != null){
      Batch batch = db.batch();
      attachment.forEach((item){
        batch.insert('t_d_jo_laboratory_attachment',item,conflictAlgorithm: ConflictAlgorithm.replace);
      });
      var id = await batch.commit();
      debugPrint('hasil batch: ${id}');

      db.execute('''
      UPDATE t_d_jo_laboratory_attachment SET is_active = 0 WHERE id NOT IN (${id!.join(',')});
      ''');

      //   db.execute('''
      //   INSERT INTO t_d_jo_laboratory_attachment (t_d_jo_laboratory_id, m_statuslaboratoryprogres_id, path_name, file_name, code, is_active, is_upload, created_by, created_at)
      //     VALUES $attachment
      // ''');
    }
  }

  static Future<void> finishProgressJo(String query) async {
    final db = await SqlHelper.db();
    db.execute('''
      
    ''');
  }

}



