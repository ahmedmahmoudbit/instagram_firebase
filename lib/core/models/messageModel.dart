class MessageModel {
  MessageModel({
    this.messageId,
    this.senderId,
    this.reciverId,
    this.message,
    this.time,});

  MessageModel.fromJson(dynamic json) {
    messageId = json['messageId'];
    senderId = json['senderId'];
    reciverId = json['reciverId'];
    message = json['message'];
    time = json['time'];
  }

  String? messageId;
  String? senderId;
  String? reciverId;
  String? message;
  String? time;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['messageId'] = messageId;
    map['senderId'] = senderId;
    map['reciverId'] = reciverId;
    map['message'] = message;
    map['time'] = time;
    return map;
  }
}