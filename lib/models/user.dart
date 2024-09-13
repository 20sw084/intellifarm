import 'land.dart';

class User {
  String? email;
  String? phone;
  String? password;
  List<Land>? land;
  User({required this.email, required this.phone, required this.password, this.land});

  User.fromJson(Map<String, Object?> json)
      : this(
    email: json['email']! as String,
    phone: json['phone']! as String,
    password: json['password']! as String,
  );

  Map<String, Object?> toJson() {
    return {
      'email': email,
      'phone': phone,
      'password': password,
    };
  }
}
