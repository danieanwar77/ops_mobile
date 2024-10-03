import 'dart:async';
import 'dart:io';

import 'package:ops_mobile/data/model/jo_assigned_model.dart';
import 'package:ops_mobile/data/model/jo_daily_photo.dart';
import 'package:ops_mobile/data/model/jo_detail_model.dart';
import 'package:ops_mobile/data/model/jo_list_daily_activity.dart';
import 'package:ops_mobile/data/model/jo_list_daily_activity5.dart';
import 'package:ops_mobile/data/model/jo_list_daily_activity6.dart';
import 'package:ops_mobile/data/model/jo_list_daily_activity_lab.dart';
import 'package:ops_mobile/data/model/jo_list_daily_activity_lab5.dart';
import 'package:ops_mobile/data/model/jo_list_model.dart';
import 'package:ops_mobile/data/model/jo_pic_model.dart';
import 'package:ops_mobile/data/model/jo_send_model.dart';
import 'package:ops_mobile/data/model/login_data_model.dart';
import 'package:ops_mobile/data/model/login_model.dart';
import 'package:ops_mobile/data/model/response_jo_activity_photo.dart';
import 'package:ops_mobile/data/model/response_jo_change_status.dart';
import 'package:ops_mobile/data/model/response_jo_insert_activity.dart';
import 'package:ops_mobile/data/model/response_jo_insert_activity5.dart';
import 'package:ops_mobile/data/model/response_jo_insert_activity5_lab.dart';
import 'package:ops_mobile/data/model/response_jo_insert_activity_lab.dart';
import 'package:ops_mobile/data/model/response_jo_update_activiy_photo.dart';
import 'package:ops_mobile/data/model/user_model.dart';

abstract interface class Repository {
  FutureOr<UserModel?> getUser(int page);
  FutureOr<JoListModel?> getJoList(int status, int employee);
  FutureOr<LoginModel?> login(String username, String password);
  FutureOr<LoginDataModel?> getEmployeeData(String token);
  FutureOr<JoDetailModel?> getJoDetail(int id);
  FutureOr<JoPicModel?> getJoPIC(int id);
  FutureOr<JoDailyPhoto?> getJoDailyPhoto(int id);
  FutureOr<JoListDailyActivity?> getJoListDailyActivity(int id);
  FutureOr<JoListDailyActivity5?> getJoListDailyActivity5(int id);
  FutureOr<JoListDailyActivity6?> getJoListDailyActivity6(int id);
  FutureOr<JoListDailyActivityLab?> getJoListDailyActivityLab(int id, int labId);
  FutureOr<JoListDailyActivityLab5?> getJoListDailyActivityLab5(int id);
  FutureOr<ResponseJoActivityPhoto?> insertActivityDailyPhoto(File photo, int id, String desc);
  FutureOr<ResponseJoUpdateActiviyPhoto?> updateActivityDailyPhoto(File photo, int id);
  FutureOr<ResponseJoChangeStatus> changeStatusJo(String id, String status);
  FutureOr<ResponseJoInsertActivity> insertActivityInspection(dynamic data);
  FutureOr<ResponseJoInsertActivity5> insertActivityInspection5(List<FormDataArray> data);
  FutureOr<ResponseJoInsertActivityLab> insertActivityLab(List<ActivityLab> data);
  FutureOr<ResponseJoInsertActivity5Lab> insertActivity5Lab(List<ActivityAct5Lab> data);
}
