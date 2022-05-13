import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_firebase/core/network/local/cache_helper.dart';

class Post {
  late String postId;
  late String userId;
  late String username;
  late String userImageUrl;
  final String postContent;
  late String postImageUrl;
  final double latitude;
  final double longitude;
  final String locationName;
  int? type;
  bool isLiked = false;
  int likeCount = 0;

  Post({
    required this.postContent,
    this.username = "",
    this.postImageUrl = "",
    this.postId = "",
    this.userId = "",
    this.userImageUrl = "",
    this.locationName = "Meeru island resort & spa",
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.type = 1,
  }) {

    // if type is 0 (share post) else comment don't get postId
    if (type == 0) {
      var usrId= FirebaseAuth.instance.currentUser!.uid;
      postId = DateTime.now().toString().replaceAll(" ", "") + usrId;
      userId = usrId;
      username = CacheHelper.getData(key: 'username');
      userImageUrl = CacheHelper.getData(key: 'image');
    }
  }

  Post.fromJson(Map<String, dynamic> json)
      : this(
    postId: json['postId']! as String,
    userId: json['userId']! as String,
    username: json['username']! as String,
    userImageUrl: json['userImageUrl']! as String,
    postContent: json['postContent']! as String,
    postImageUrl: json['postImageUrl']! as String,
    locationName: json['locationName']! as String,
    latitude: json['latitude']! as double,
    longitude: json['longitude']! as double,
  );

  Map<String, Object?> toJson() {
    return {
      'postId': postId,
      'userId': userId,
      'username': username,
      'userImageUrl': userImageUrl,
      'postContent': postContent,
      'postImageUrl': postImageUrl,
      'locationName': locationName,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}