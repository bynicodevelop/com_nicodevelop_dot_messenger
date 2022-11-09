import "package:equatable/equatable.dart";

class UserModel extends Equatable {
  final String uid;
  final String displayName;
  final String email;
  final bool emailVerified;

  const UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.emailVerified,
  });

  static UserModel empty() => const UserModel(
        uid: "",
        displayName: "",
        email: "",
        emailVerified: false,
      );

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "displayName": displayName,
        "email": email,
        "emailVerified": emailVerified,
      };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        uid: map["uid"],
        displayName: map["displayName"],
        email: map["email"],
        emailVerified: map["emailVerified"],
      );

  UserModel copyWith({
    String? uid,
    String? displayName,
    String? email,
    bool? emailVerified,
  }) =>
      UserModel(
        uid: uid ?? this.uid,
        displayName: displayName ?? this.displayName,
        email: email ?? this.email,
        emailVerified: emailVerified ?? this.emailVerified,
      );

  @override
  List<Object?> get props => [
        uid,
        displayName,
        email,
        emailVerified,
      ];
}
