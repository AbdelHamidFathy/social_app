class CreatePostModel {
  late String name;
  late String dateTime;
  late String text;
  late String uId;
  late String image;
  String? postImage;

  CreatePostModel({
    required this.name,
    required this.dateTime,
    required this.text,
    required this.uId,
    required this.image,
    this.postImage,
});

  CreatePostModel.fromJson(Map<String, dynamic>json){
    name=json['name'];
    text=json['text'];
    dateTime=json['dateTime'];
    uId=json['uId'];
    image=json['image'];
    postImage=json['postImage'];
  }

  Map<String, dynamic>toMap(){
    return {
      'name': name,
      'text':text,
      'dateTime':dateTime,
      'uId':uId,
      'image':image,
      'postImage':postImage,

    };
  }
}