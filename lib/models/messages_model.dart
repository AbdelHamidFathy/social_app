class MessagesModel {
  late String text;
  late String dateTime;
  late String senderId;
  late String receiverId;
  String? image;

  MessagesModel({
    required this.text,
    required this.dateTime,
    required this.senderId,
    required this.receiverId,
    this.image,
  });

  MessagesModel.fromJson(Map<String, dynamic>json){
    text=json['text'];
    dateTime=json['dateTime'];
    senderId=json['senderId'];
    receiverId=json['receiverId'];
    image=json['image'];
  }
  Map<String, dynamic>toMap(){
    return {
      'dateTime': dateTime,
      'text':text,
      'receiverId':receiverId,
      'senderId':senderId,
      'image':image,

    };
  }
}