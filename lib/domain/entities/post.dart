import 'package:equatable/equatable.dart';

class PostData extends Equatable{
  
    PostData({
      required  this.active,
      required  this.attachments,
      required  this.comment,
      required  this.content,
      required  this.createTime,
      required  this.like,
      required  this.publicUser,
      required  this.uid,
      required  this.userId,
    });

   bool active;
   String attachments;
   Comment comment;
   String content;
   int createTime;
   Like like;
   PublicUser publicUser;
   String uid;
   String userId;

  @override
  // TODO: implement props
  List<Object?> get props => [active, attachments,comment,content,createTime,like,publicUser,uid,userId];
}

class Comment extends Equatable{
    Comment({
       required this.quantityComments,
    });

    int quantityComments;

  @override
  // TODO: implement props
  List<Object?> get props => [quantityComments];
}

class Like extends Equatable{
    Like({
      required  this.itsYouLike,
      required  this.quantityLike,
    });

    bool itsYouLike;
    int quantityLike;

  @override
  List<Object?> get props => [itsYouLike, quantityLike];
}

class PublicUser extends Equatable {
    PublicUser({
      required  this.photoUrl,
      required  this.userId,
      required  this.userName,
    });

    String photoUrl;
    String userId;
    String userName;

  @override
  List<Object?> get props => [photoUrl, userId, userName];
}
