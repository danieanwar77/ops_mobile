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
        where username = $id''');
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
      select e.id, e.fullname, e.e_number, e.jabatan_id, e.division_id, e.superior_id from employee e
      join user u on u.username  = e.e_number
      where e.e_number = "$id"
    ''');
  }

  static Future<List<Map<String, dynamic>>> getListJo(String id, String status) async {
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
      WHERE a.m_statusjo_id = '$status' 
      AND a.pic_inspector = '$id' 
      OR a.pic_laboratory = '$id' 
    ''');
  }

  static Future<List<Map<String, dynamic>>> getDetailJo(String idJo) async {
    final db = await SqlHelper.db();
    return db.rawQuery(''' 
      SELECT
      a.id, b.so_code, a.code,
      a.canceled_date,
      b.created_at AS so_created_at, a.created_at AS jo_created_at, c.`name` AS status_jo, f.company_name,
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
      e.`name` as commodity_name, DATE_FORMAT(a.etta_vessel, '%d-%m-%Y') as etta_vessel,
      DATE_FORMAT(a.start_date_of_attendance, '%d-%m-%Y') as start_date_of_attendance, DATE_FORMAT(a.end_date_of_attendance, '%d-%m-%Y') as end_date_of_attendance, k.site_office as lokasi_kerja,
      
      a.pic_inspector as id_pic_inspector, a.pic_laboratory as id_pic_laboratory, y.fullname as pic_laboratory, z.fullname as pic_inspector, u.country as destination_country,
      v.name as destination_category_name, w.name as job_category_name, d1.`name`as kos_name,
      l1.vessel, l1.qty,
      c1.name as uom_name, a.created_at as jo_created_date,
      GROUP_CONCAT(c4.barge ORDER BY c4.barge ASC SEPARATOR '|') as barge, d11.`name`as market_segment_name,
      d12.`name`as sub_market_segment_name FROM
      `t_h_jo` AS a
      left join cbd_tb_dev.m_kos as d1 on d1.id = a.m_kindofservice_id JOIN cbd_tb_dev.t_h_so AS b ON a.t_so_id = b.id
      JOIN m_statusjo AS c ON a.m_statusjo_id = c.id join cbd_tb_dev.m_sbu as d on b.sbu_id = d.id
      left join cbd_tb_dev.m_commodity as e on b.commodity_id = e.id
      
      left join cbd_tb_dev.t_h_lead_account as f on f.id = b.company_acc_id left join cbd_tb_dev.m_client_category as g on g.id= b.client_category_id left join cbd_tb_dev.t_d_so_est_rev_ops as h on h.so_id = b.id
      left join hris_tb_dev.region as i on i.id = h.region_id left join hris_tb_dev.branch as j on j.id = h.branch_id
      left join hris_tb_dev.site_office as k on k.id = h.site_office_id
      
      left join cbd_tb_dev.t_d_so_survey_loc as l on l.so_id = b.id and l.flag_active = 1 left join hris_tb_dev.country as m on m.id = l.country_id
      left join hris_tb_dev.province as n on l.province_id = n.id left join hris_tb_dev.city as o on l.city_id = o.id
      
      left join cbd_tb_dev.t_d_so_discharge_port as p on p.so_id = b.id and p.flag_active = 1 left join hris_tb_dev.country as q on q.id = p.country_id
      left join hris_tb_dev.province as r on p.province_id = r.id left join hris_tb_dev.city as s on p.city_id = s.id
      
      left join cbd_tb_dev.t_d_so_others_ops as t on t.so_id = b.id and t.flag_active = 1 left join hris_tb_dev.country as u on u.id = t.dest_country_id
      left join cbd_tb_dev.m_destination_cat as v on v.id = t.dest_cat_id and v.flag_active = 1 left join cbd_tb_dev.m_job_cat as w on w.id = t.job_category_id and w.flag_active = 1 left join cbd_tb_dev.t_h_lead_account as x on x.id = t.end_buyer and x.flag_active = 1
      
      left join cbd_tb_dev.t_h_lead_account as x1 on x1.id = t.trader1 and x1.flag_active = 1 left join cbd_tb_dev.t_h_lead_account as x2 on x2.id = t.trader2 and x2.flag_active = 1 left join cbd_tb_dev.t_h_lead_account as x3 on x3.id = t.trader3 and x3.flag_active = 1 left join cbd_tb_dev.t_d_so_load_port as a1 on a1.so_id = b.id and a1.flag_active = 1 left join hris_tb_dev.country as a2 on a2.id = l.country_id
      left join hris_tb_dev.province as a3 on l.province_id = a3.id left join hris_tb_dev.city as a4 on l.city_id = a4.id
      
      left join cbd_tb_dev.t_d_so_kos l1 on a.t_so_id = l1.so_id and a.m_kindofservice_id = l1.kos_id
      left join cbd_tb_dev.t_d_so_kos_barge as c4 on c4.so_kos_id = l1.id and c4.flag_active = 1 left join cbd_tb_dev.m_uom c1 on c1.id = a.uom_id
      left join cbd_tb_dev.m_market_segment as d11 on d11.id = t.market_segment_id and d11.flag_active = 1
      left join cbd_tb_dev.m_submarket_segment as d12 on d12.id = t.submarket_segment_id and d12.flag_active = 1
      left join hris_tb_dev.employee as y on a.pic_laboratory = y.id left join hris_tb_dev.employee as z on a.pic_inspector = z.id
      
      WHERE
      a.id = ‘$idJo’
    ''');
  }

  static Future<List<Map<String, dynamic>>> getDailyPhoto(String idJo) async {
    final db = await SqlHelper.db();
    return db.rawQuery('''
      Select * from t_d_jo_inspection_pict where t_h_jo_id = ‘$idJo’
    ''');
  }

  static Future<List<Map<String, dynamic>>> getListActivity(String idJo) async {
    final db = await SqlHelper.db();
    return db.rawQuery('''
      SELECT
      a.id AS inspection_stages_id,
      b.id AS inspection_activity_id, a.t_h_jo_id, a.m_statusinspectionstages_id, c.`name` AS stages_name, a.trans_date,
      a.remarks, b.start_activity_time, b.end_activity_time, b.activity, a.actual_qty
      FROM t_d_jo_inspection_activity_stages AS a
      JOIN t_d_jo_inspection_activity AS b ON a.id = b.t_d_jo_inspection_activity_stages_id JOIN m_statusinspectionstages AS c ON c.id = a.m_statusinspectionstages_id
      WHERE a.t_h_jo_id = '$idJo'
    ''');
  }


}