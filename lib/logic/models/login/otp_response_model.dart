import 'package:vendor_catalogue_app/logic/models/login/user_model.dart';
import 'package:vendor_catalogue_app/logic/models/login/verify_otp_res_model.dart';

class OtpResponseModel extends VerifyOtpResModel<UserModel> {
  OtpResponseModel({
    required String message,
    required bool success,
    UserModel? data,
  }) : super(message: message, success: success, data: data);

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpResponseModel(
      message: json['message'] ?? '',
      success: json['success'] ?? false,
      data: json.containsKey('data') && json['data'] != null
          ? UserModel.fromJson(json['data'])
          : null,
    );
  }
}