class CommentModel {
  late String text;
  late String name;
  late String profileImage;
  late String uId;
  late String dateTime;

  CommentModel({
    required this.text,
    required this.name,
    required this.profileImage,
    required this.uId,
    required this.dateTime,
  });

  CommentModel.fromJson(Map<String, dynamic>json){
    text=json['text'];
    name=json['name'];
    profileImage=json['profileImage'];
    uId=json['uId'];
    dateTime=json['dateTime'];
  }
  Map<String, dynamic>toMap(){
    return {
      'name': name,
      'text':text,
      'uId':uId,
      'profileImage':profileImage,
      'dateTime':dateTime,

    };
  }
}