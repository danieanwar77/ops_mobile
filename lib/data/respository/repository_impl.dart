import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as net;
import 'package:ops_mobile/data/model/jo_daily_photo.dart';
import 'package:ops_mobile/data/model/jo_detail_model.dart';
import 'package:ops_mobile/data/model/jo_list_daily_activity.dart';
import 'package:ops_mobile/data/model/jo_list_daily_activity5.dart';
import 'package:ops_mobile/data/model/jo_list_daily_activity6.dart';
import 'package:ops_mobile/data/model/jo_list_daily_activity_lab.dart';
import 'package:ops_mobile/data/model/jo_list_daily_activity_lab5.dart';
import 'package:ops_mobile/data/model/jo_list_model.dart';
import 'package:ops_mobile/data/model/jo_pic_model.dart';
import 'package:ops_mobile/data/model/jo_response_delete_activity_photo.dart';
import 'package:ops_mobile/data/model/jo_send_model.dart';
import 'package:ops_mobile/data/model/login_data_model.dart';
import 'package:ops_mobile/data/model/login_model.dart';
import 'package:ops_mobile/data/model/response_gendata_file.dart';
import 'package:ops_mobile/data/model/response_jo_activity_photo.dart';
import 'package:ops_mobile/data/model/response_jo_change_status.dart';
import 'package:ops_mobile/data/model/response_jo_insert_activity.dart';
import 'package:ops_mobile/data/model/response_jo_insert_activity5.dart';
import 'package:ops_mobile/data/model/response_jo_insert_activity5_lab.dart';
import 'package:ops_mobile/data/model/response_jo_insert_activity_lab.dart';
import 'package:ops_mobile/data/model/response_jo_update_activiy_photo.dart';
import 'package:ops_mobile/data/model/response_register_device.dart';
import 'package:ops_mobile/data/model/user_model.dart';
import 'package:ops_mobile/data/network.dart';
import 'package:ops_mobile/data/respository/repository.dart';

class RepositoryImpl implements Repository {
  RepositoryImpl({required this.networkCore});

  NetworkCore networkCore;

  @override
  FutureOr<ResponseRegisterDevice> registerDevice(String employeeId, String uuid) async {
    late Response? response;
    try{
      response = await networkCore.postRequest('/api/registerdevice',
          body: {
            'e_number' : employeeId,
            'imei' : uuid
          },
          decoder: ResponseRegisterDevice.fromJson,
          headers: {
            'Content-Type': 'application/json'
          }
      );
    } on Exception catch(e) {
      debugPrint(e.toString());
      rethrow;
    }
    return response?.body;
  }

  FutureOr<ResponseGendataFile> getGenData(String employeeId) async {
    late Response? response;
    try{
      response = await networkCore.postRequest('/api/mobilegetfile',
          body: {
            'e_number': employeeId
          },
          decoder: ResponseGendataFile.fromJson,
          headers: {
            'Content-Type': 'application/json'
          }
      );
    } on Exception catch(e){
      debugPrint(e.toString());
      rethrow;
    }
    return response?.body;
  }

  FutureOr<UserModel?> getUser(int page) async {
    late Response? response;
    try {
      response = await networkCore.getRequest<UserModel>('/users',
          queryParameters: {
            'page': page.toString()
          },
          decoder: (val) => UserModel.fromJson(val),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          });
    } on Exception catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
    return response?.body;
  }

  FutureOr<JoListModel?> getJoList(int status, int employee) async {
    late Response? response;
    try{
      response = await networkCore.getRequest('/transaksi/jo/$status/1624',
          decoder: (val) => JoListModel.fromJson(val),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }
      );
    } on Exception catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
    return response?.body;
  }

  FutureOr<LoginModel?> login(String username, String password) async {
    var response;
    try{
      response = await net.post(Uri.parse('https://tbi-hris-dev.intishaka.com/backend/web/api/tbv1/login'),
          body: jsonEncode({'username': username, 'password': password, 'device_type_id': '1'}),
          headers: {'Accept': 'application/json', 'Content-Type' : 'application/json'},
          );
    } on Exception catch (e){
      debugPrint(e.toString());
      rethrow;
    }
    final body = LoginModel.fromJson(jsonDecode(response.body.toString()));
    return body;
  }

  FutureOr<LoginDataModel?> getEmployeeData(String token) async {
    var response;
    try{
      response = await net.post(Uri.parse('https://tbi-hris-dev.intishaka.com/backend/web/api/tbv1/employee'),
        headers: {'Accept': 'application/json', 'Content-Type' : 'application/json', 'Authorization' : 'bearer $token'},
      );
    } on Exception catch (e){
      debugPrint(e.toString());
      rethrow;
    }
    final body = LoginDataModel.fromJson(jsonDecode(response.body.toString()));
    return body;
  }

  FutureOr<JoDetailModel?> getJoDetail(int id)async{
    Response? response;
    try{
      response = await networkCore.getRequest('/transaksi/jo/$id',
          decoder: (val) => JoDetailModel.fromJson(val),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }
      );
    } on Exception catch(e){
      debugPrint(e.toString());
      rethrow;
    }

    return response?.body;
  }
  
  FutureOr<JoPicModel?> getJoPIC(int id)async{
    Response? response;
    try{
      response = await networkCore.getRequest('/transaksi/jo/pic/detail/$id',
          decoder: (val) => JoPicModel.fromJson(val),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }
      );
    } on Exception catch(e){
      debugPrint(e.toString());
      rethrow;
    }

    return response?.body;
  }

  FutureOr<JoDailyPhoto?> getJoDailyPhoto(int id)async{
    Response? response;
    try{
      response = await networkCore.getRequest('/transaksi/jo/progress_daily_activity/get_photo/$id',
          decoder: (val) => JoDailyPhoto.fromJson(val),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }
      );
    } on Exception catch(e){
      debugPrint(e.toString());
      rethrow;
    }

    return response?.body;
  }

  FutureOr<JoListDailyActivity?> getJoListDailyActivity(int id)async{
    Response? response;
    try{
      response = await networkCore.getRequest('/transaksi/jo/progress_daily_activity/activity/$id',
          decoder: (val) => JoListDailyActivity.fromJson(val),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }
      );
    } on Exception catch(e){
      debugPrint(e.toString());
      rethrow;
    }

    return response?.body;
  }

  FutureOr<JoListDailyActivity5?> getJoListDailyActivity5(int id)async{
    Response? response;
    try{
      response = await networkCore.getRequest('/transaksi/jo/progress_daily_activity/activity_5/$id',
          decoder: (val) => JoListDailyActivity5.fromJson(val),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }
      );
    } on Exception catch(e){
      debugPrint(e.toString());
      rethrow;
    }

    return response?.body;
  }

  FutureOr<JoListDailyActivity6?> getJoListDailyActivity6(int id)async{
    Response? response;
    try{
      response = await networkCore.getRequest('/transaksi/jo/progress_daily_activity/activity_6/$id',
          decoder: (val) => JoListDailyActivity6.fromJson(val),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }
      );
    } on Exception catch(e){
      debugPrint(e.toString());
      rethrow;
    }

    return response?.body;
  }

  FutureOr<JoListDailyActivityLab?> getJoListDailyActivityLab(int id, int labId)async{
    Response? response;
    try{
      response = await networkCore.getRequest('/transaksi/jo/progress_daily_laboratory/activity/$id/$labId',
          decoder: (val) => JoListDailyActivityLab.fromJson(val),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }
      );
    } on Exception catch(e){
      debugPrint(e.toString());
      rethrow;
    }

    return response?.body;
  }

  FutureOr<JoListDailyActivityLab5?> getJoListDailyActivityLab5(int id)async{
    Response? response;
    try{
      response = await networkCore.getRequest('/transaksi/jo/progress_daily_laboratory/activity_5/$id',
          decoder: (val) => JoListDailyActivityLab5.fromJson(val),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }
      );
    } on Exception catch(e){
      debugPrint(e.toString());
      rethrow;
    }

    return response?.body;
  }
  
  FutureOr<ResponseJoActivityPhoto?> insertActivityDailyPhoto(File photo, int id, String desc)async{
    Response? response;
    var filenameArr = photo.path.split('/');
    var filename = filenameArr.last;
    final List<int> image = await photo.readAsBytes();
    try{
      response = await networkCore.postRequest('/transaksi/jo/progress_daily_activity/send_photo',
          body: FormData({
            'photo': MultipartFile(image, filename: filename, contentType: 'image'),
            'joId': id,
            'description': desc
          }),
          decoder: (val) => ResponseJoActivityPhoto.fromJson(val),
      );
    } on Exception catch(e){
      debugPrint(e.toString());
      rethrow;
    }

    return response?.body;
  }

  FutureOr<ResponseJoUpdateActiviyPhoto?> updateActivityDailyPhoto(File photo, int id, String desc)async{
    Response? response;
    var filenameArr = photo.path.split('/');
    var filename = filenameArr.last;
    final List<int> image = await photo.readAsBytes();
    try{
      response = await networkCore.postRequest('/transaksi/jo/progress_daily_activity/update_photo',
        body: FormData({
          'photo': MultipartFile(image, filename: filename, contentType: 'image'),
          'photoId': id,
          'description': desc
        }),
        decoder: (val) => ResponseJoUpdateActiviyPhoto.fromJson(val),
      );
    } on Exception catch(e){
      debugPrint(e.toString());
      rethrow;
    }

    return response?.body;
  }

  FutureOr<JoResponseDeleteActivityPhoto?> deleteActivityPhoto(int id)async{
    Response? response;
    try{
      response = await networkCore.delete('/transaksi/jo/progress_daily_activity/delete_photo/$id',
          decoder: (val) => JoResponseDeleteActivityPhoto.fromJson(val),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }
      );

    } on Exception catch(e){
      debugPrint(e.toString());
      rethrow;
    }

    return response?.body;
  }

  FutureOr<ResponseJoChangeStatus> changeStatusJo(String id, String status)async{
    Response? response;
    try{
      response = await networkCore.postRequest('/transaksi/jo/change_status',
          body: {
            'joId' : id,
            'status' : status
          },
          decoder: (val) => ResponseJoChangeStatus.fromJson(val),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }
      );
    } on Exception catch(e){
      debugPrint(e.toString());
      rethrow;
    }

    return response?.body;
  }

  FutureOr<ResponseJoInsertActivity> insertActivityInspection(dynamic data)async{
    Response? response;
    try{
      response = await networkCore.postRequest('/transaksi/jo/progress_daily_activity/activity',
          body: {
            'formDataArray' : data
          },
          decoder: (val) => ResponseJoInsertActivity.fromJson(val),
          headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
              }
      );
    } on Exception catch(e){
      debugPrint(e.toString());
      rethrow;
    }

    return response?.body;
  }

  FutureOr<ResponseJoInsertActivity> updateActivityInspection(dynamic data, int id)async{
    final Response<dynamic>? response;
    try{
      response = await networkCore.putRequest('/transaksi/jo/progress_daily_activity/activity/$id',
          body: {
            'formDataArray' : data
          },
          decoder: ResponseJoInsertActivity.fromJson,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }
      );
    } on Exception catch(e){
      debugPrint(e.toString());
      rethrow;
    }

    return response?.body;
  }

  FutureOr<ResponseJoInsertActivity5> insertActivityInspection5(List<FormDataArray> data)async{
    Response? response;
    try{
      response = await networkCore.postRequest('/transaksi/jo/progress_daily_activity/inspection/activity_5',
          body: {
            'formDataArray' : data
          },
          decoder: (val) => ResponseJoInsertActivity5.fromJson(val),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }
      );
    } on Exception catch(e){
      debugPrint(e.toString());
      rethrow;
    }

    return response?.body;
  }

  FutureOr<ResponseJoInsertActivity5> updateActivityInspection5(List<FormDataArray> data, int id)async{
    Response? response;
    try{
      response = await networkCore.putRequest('/transaksi/jo/progress_daily_activity/inspection/activity_5/$id',
          body: {
            'formDataArray' : data
          },
          decoder: ResponseJoInsertActivity5.fromJson,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }
      );
    } on Exception catch(e){
      debugPrint(e.toString());
      rethrow;
    }

    return response?.body;
  }

  FutureOr<ResponseJoInsertActivity5> insertActivityInspection6(List<FormDataArray> data)async{
    Response? response;
    try{
      response = await networkCore.postRequest('/transaksi/jo/progress_daily_activity/inspection/activity_6',
          body: {
            'formDataArray' : data
          },
          decoder: (val) => ResponseJoInsertActivity5.fromJson(val),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }
      );
    } on Exception catch(e){
      debugPrint(e.toString());
      rethrow;
    }

    return response?.body;
  }

  FutureOr<ResponseJoInsertActivity5> updateActivityInspection6(List<FormDataArray> data, int id)async{
    Response? response;
    try{
      response = await networkCore.put('/transaksi/jo/progress_daily_activity/inspection/activity_6/$id',
          {
            'formDataArray' : data
          },
          decoder: (val) => ResponseJoInsertActivity5.fromJson(val),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }
      );
    } on Exception catch(e){
      debugPrint(e.toString());
      rethrow;
    }

    return response?.body;
  }

  FutureOr<ResponseJoInsertActivityLab> insertActivityLab(List<ActivityLab> data)async{
    Response? response;
    try{
      response = await networkCore.postRequest('/transaksi/jo/progress_daily_laboratory/activity',
          body: {
            'formDataArray' : data
          },
          decoder: (val) => ResponseJoInsertActivityLab.fromJson(val),
          headers: {
            'Content-Type': 'application/json'
          }
      );
    } on Exception catch(e){
      debugPrint(e.toString());
      rethrow;
    }

    return response?.body;
  }

  FutureOr<ResponseJoInsertActivity5Lab> insertActivity5Lab(List<ActivityAct5Lab> data)async{
    Response? response;
    try{
      response = await networkCore.postRequest('/transaksi/jo/progress_daily_laboratory/activity_5',
          body: {
            'formDataArray' : data
          },
          decoder: (val) => ResponseJoInsertActivity5Lab.fromJson(val),
          headers: {
            'Content-Type': 'application/json'
          }
      );
    } on Exception catch(e){
      debugPrint(e.toString());
      rethrow;
    }

    return response?.body;
  }
}
