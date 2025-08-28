class VerifyOtpResModel<T> {
  final String message;
  final bool success;
  final T? data;

  VerifyOtpResModel({
    required this.message,
    required this.success,
    this.data,
  });

  factory VerifyOtpResModel.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic> json)? dataFromJson,
      ) {
    return VerifyOtpResModel(
      message: json['message'] ?? '',
      success: json['success'] ?? false,
      data: json.containsKey('data') && json['data'] != null && dataFromJson != null
          ? dataFromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T)? dataToJson) {
    final map = {
      'message': message,
      'success': success,
    };

    if (data != null && dataToJson != null) {
      map['data'] = dataToJson(data as T);
    }

    return map;
  }
}
