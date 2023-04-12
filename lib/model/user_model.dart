class UserModel {
  int userId;
  String firstName;
  String lastName;
  String mobileNo;
  String profileImage;
  String email;
  int categoryId;

  UserModel({
    required this.categoryId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.mobileNo,
    required this.userId,
    required this.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        categoryId: json["category_id"],
        userId: json["user_id"],
        email: json["email"],
        lastName: json["last_name"],
        firstName: json["first_name"],
        mobileNo: json["mobile_no"],
        profileImage: json["profile_image"],
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "user_id": userId,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "mobile_no": mobileNo,
        "profile_image": profileImage,
      };
}
