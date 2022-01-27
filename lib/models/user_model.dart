class UserModel {
  late String name;
  late String email;
  late String phone;
  late String uId;
  late bool isVerified;
  String? image;
  String? cover;
  String? bio;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.uId,
    required this.isVerified,
    this.image,
    this.cover,
    this.bio,
});

  UserModel.fromJson(Map<String, dynamic>json){
    name=json['name'];
    email=json['email'];
    phone=json['phone'];
    uId=json['uId'];
    isVerified=json['isVerified'];
    image=json['image'];
    cover=json['cover'];
    bio=json['bio'];
  }

  Map<String, dynamic>toMap(){
    return {
      'name': name,
      'email':email,
      'phone':phone,
      'uId':uId,
      'isVerified':isVerified,
      'image':image,
      'cover':cover,
      'bio':bio,

    };
  }
}