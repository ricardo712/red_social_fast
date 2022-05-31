import 'package:equatable/equatable.dart';

class Comments extends Equatable{
    Comments({
      required  this.content,
      required  this.createTime,
      required  this.userId,
      required  this.uid,
      required  this.postId,
      required  this.publicUser,
    });

    String content;
    int createTime;
    String userId;
    String uid;
    String postId;
    PublicUsers? publicUser;

  @override
  // TODO: implement props
  List<Object?> get props => [content, userId, createTime, uid, postId, publicUser];
}

class PublicUsers {
    PublicUsers({
      required  this.userName,
      required  this.userId,
      required  this.photoUrl,
    });

    String userName;
    String userId;
    String photoUrl;
}
