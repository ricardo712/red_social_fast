import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clean_login/core/framework/colors.dart';
import 'package:clean_login/injection_dependency.dart';
import 'package:clean_login/presentation/blocs/providers/commetsProvider.dart';
import 'package:clean_login/presentation/blocs/providers/friendProvider.dart';
import 'package:clean_login/presentation/blocs/providers/postProvider.dart';
import 'package:clean_login/presentation/screens/pages/post/DetailPost.dart';
import 'package:clean_login/presentation/screens/pages/profile/profile.dart';
import 'package:clean_login/presentation/screens/widget/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clean_login/presentation/blocs/myuser_controller.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    // if (Provider.of<PostProvider>(context, listen: false).notifications ==
    //     null) {
    // }
      Provider.of<PostProvider>(context, listen: false)
          .loadDataNotification(getIt<MyUserData>().idUser);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<PostProvider>(context);
    return Scaffold(
      body: data.notifications != null && !data.loadingNotifi
          ? data.notifications!.length > 0
              ? RefreshIndicator(
                color: primary,
                onRefresh: newsInfo ,
                child: ListView.builder(
                    itemCount: data.notifications!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (data.notifications![index].type == "addLike") {
                            if (data.notifications![index].post! != null) {
                              Provider.of<CommentsProvider>(context,
                                      listen: false)
                                  .loadData(data.notifications![index].post!.uid);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPost(
                                        data: data.notifications![index].post!),
                                  ));
                            } else {
                              showSnackBar(
                                  context, "Publicación", "No encontrada");
                            }
                          }
                          if (data.notifications![index].type == "addComment") {
                            if (data.notifications![index].post! != null) {
                              Provider.of<CommentsProvider>(context,
                                      listen: false)
                                  .loadData(data.notifications![index].post!.uid);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPost(
                                        data: data.notifications![index].post!),
                                  ));
                            } else {
                              showSnackBar(
                                  context, "Publicación", "No encontrada");
                            }
                          }
                          if (data.notifications![index].type == "addFriend") {
                            Provider.of<PostProvider>(context, listen: false)
                                .loadDataPostProfile(
                                    data.notifications![index].user!.id);
                            Provider.of<FriendProvider>(context, listen: false)
                                .getStateSolicitude(getIt<MyUserData>().idUser,
                                    data.notifications![index].user!.id);
                            // if(data.notifications![index].post! != null){
                            //  Provider.of<CommentsProvider>(context, listen: false).loadData(data.notifications![index].post!.uid);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileUser(
                                      user: data.notifications![index].user!),
                                ));
                          }
              
                          if (data.notifications![index].type == "acceptFriend") {
                            Provider.of<PostProvider>(context, listen: false)
                                .loadDataPostProfile(
                                    data.notifications![index].user!.id);
                            Provider.of<FriendProvider>(context, listen: false)
                                .getStateSolicitude(getIt<MyUserData>().idUser,
                                    data.notifications![index].user!.id);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileUser(
                                      user: data.notifications![index].user!),
                                ));
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(2),
                          width: double.infinity,
                          height: 100,
                          child: Card(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                        radius: 25,
                                        backgroundColor: claro,
                                        child: ClipOval(
                                            child: CachedNetworkImage(
                                          imageUrl: data
                                              .notifications![index].user!.image,
                                          progressIndicatorBuilder:
                                              (context, url, downloadProgress) =>
                                                  Center(
                                            child: CircularProgressIndicator(
                                                color: primary,
                                                value: downloadProgress.progress),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ))),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                              margin: EdgeInsets.all(8),
                                              child: Center(
                                                  child: Text(
                                                data.notifications![index].user!
                                                    .usuario,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold),
                                              ))),
                                          Container(
                                            child: Center(
                                                child: Text(type(data
                                                    .notifications![index]
                                                    .type))),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              )
              : Center(
                  child: Text("No hay notificaciones"),
                )
          : Center(
              child: CircularProgressIndicator(color: primary,),
            ),
    );
  }
  Future<Null> newsInfo() async {
    final duration = Duration(seconds: 2);
    new Timer(duration, () {
      Provider.of<PostProvider>(context, listen: false).notifications!.clear();
      Provider.of<PostProvider>(context, listen: false).loadDataNotification(getIt<MyUserData>().idUser);
    });

    return Future.delayed(duration);
  }

  String type(String type) {
    if (type == "addLike") {
      return "Ha dado me gusta a tu publicación";
    } else if (type == "addComment") {
      return "Ha comentado tu publicación";
    } else if (type == "addFriend") {
      return "Te ha enviado la solocitud de amistad";
    } else if (type == "acceptFriend") {
      return "Ha aceptado la solicitud de amistad";
    } else {
      return "";
    }
  }
}
