class UserModel {
  final String token;
  final String applicationUserId;
  final String? username;

  UserModel({
    required this.token,
    required this.applicationUserId,
    this.username,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'] ?? '',
      applicationUserId: json['applicationuserid'] ?? '',
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'applicationuserid': applicationUserId,
      if (username != null) 'username': username,
    };
  }
}
