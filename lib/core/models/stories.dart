class StoriesModel {
  String? username;
  String? userId;
  String? userImageUrl;
  String? storyImageUrl;
  String? storyTime;

  StoriesModel({
    this.username,
    this.userId,
    this.userImageUrl,
    this.storyImageUrl,
    this.storyTime,
  });

  StoriesModel.fromMap(Map<String, dynamic> json) {
    username = json['username'];
    userId = json['userId'];
    userImageUrl = json['userImageUrl'];
    storyImageUrl = json['storyImageUrl'];
    storyTime = json['storyTime'];
  }

  Map<String, dynamic> toMap() => {
    'username': username,
    'userId': userId,
    'userImageUrl': userImageUrl,
    'storyImageUrl': storyImageUrl,
    'storyTime': storyTime,
  };
}