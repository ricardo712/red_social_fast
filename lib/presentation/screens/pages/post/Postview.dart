import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clean_login/core/framework/colors.dart';
import 'package:clean_login/data/models/post_model.dart';
import 'package:clean_login/injection_dependency.dart';
import 'package:clean_login/presentation/blocs/providers/commetsProvider.dart';
import 'package:clean_login/presentation/blocs/providers/postProvider.dart';
import 'package:clean_login/presentation/screens/pages/post/CreatePost.dart';
import 'package:clean_login/presentation/screens/pages/post/DetailPost.dart';
import 'package:clean_login/presentation/screens/pages/post/EditarPost.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:clean_login/presentation/blocs/myuser_controller.dart';

class PostView extends StatefulWidget {
  const PostView({Key? key}) : super(key: key);

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  final controller = ScrollController();
  int ultimo = 0;

  onlistener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        Provider.of<PostProvider>(context, listen: false).loading == false  ) {
      Provider.of<PostProvider>(context, listen: false).loadDataPaginacion(
          Provider.of<PostProvider>(context, listen: false)
              .data
              .last
              .createTime,
          5);
    }
  }

  @override
  void initState() {
    controller.addListener((onlistener));
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener((onlistener));
    super.dispose();
  }

  Widget build(BuildContext context) {
    final _postProvider = Provider.of<PostProvider>(context, listen: true);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreatePost(),
                ));
          },
          backgroundColor: primary,
          hoverColor: primary.withOpacity(0.5),
          elevation: 0,
          child:
              Icon(Ionicons.add_circle_outline, color: Colors.white, size: 30),
        ),
        body: AnimatedBuilder(
            animation: _postProvider,
            builder: (_, __) {
              return (!_postProvider.loading)
                  ? Column(
                      children: [
                        Expanded(
                          child: RefreshIndicator(
                            color: primary,
                            onRefresh: newsInfo,
                            child: ListView.builder(
                              controller: controller,
                              itemCount: _postProvider.data.length,
                              itemBuilder: (context, index) {
                                return CardPost(
                                    data: _postProvider.data[index]);
                              },
                            ),
                          ),
                        ),
                        _postProvider.loadingpaginacion
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Container()
                      ],
                    )
                  : Center(
                      child: CircularProgressIndicator(color: primary,),
                    );
            }));
  }

  Future<Null> newsInfo() async {
    final duration = Duration(seconds: 2);
    new Timer(duration, () {
      Provider.of<PostProvider>(context, listen: false).data.clear();
      Provider.of<PostProvider>(context, listen: false).loadData(null, 5);
    });

    return Future.delayed(duration);
  }
}

class CardPost extends StatelessWidget {
  final PostData data;
  const CardPost({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        children: [
          data.attachments != ""
              ? Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: CachedNetworkImage(
                    fit: BoxFit.contain,
                    imageUrl: data.attachments,
                    fadeInDuration: Duration(milliseconds: 300),
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                      child: CircularProgressIndicator(
                          color: primary, value: downloadProgress.progress),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ))
              : Container(),
          Container(
            height: data.content.length > 100 ? 150 : 120,
            width: double.infinity,
            child: Card(
              color: claro,
              elevation: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                            radius: 16,
                            backgroundColor: claro,
                            child: ClipOval(
                                child: CachedNetworkImage(
                              imageUrl: data.publicUser!.photoUrl!,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Center(
                                child: CircularProgressIndicator(
                                    color: primary,
                                    value: downloadProgress.progress),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ))),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(data.publicUser!.userName!,
                              maxLines: 1,
                              textAlign: TextAlign.start,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    getIt<MyUserData>().idUser == data.userId ?  PopupMenuButton(
                        onSelected: (value) async {
                          if(value == 1){
                             Navigator.push(context, MaterialPageRoute(builder: (context) => EditarPost(data: data),));
                          }else{
                            await _showMyDialog(context);
                          }
                        },
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: Text("Editar"),
                                  value: 1,
                                ),
                                PopupMenuItem(
                                  child: Text("Eliminar"),
                                  value: 2,
                                )
                              ]) : Container()
                    ],
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(data.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        LikeButton(
                          onTap: (isLiked) async {
                            if (isLiked) {
                              Provider.of<PostProvider>(context, listen: false)
                                  .removeLikePost(data.uid);
                            } else {
                              Provider.of<PostProvider>(context, listen: false)
                                  .likePost(data.uid, data);
                            }
                            return !isLiked;
                          },
                          isLiked: data.like!.itsYouLike,
                          size: 30,
                          circleColor: CircleColor(
                              start: Color(0xFF004D35), end: Color(0xFF004D35)),
                          bubblesColor: BubblesColor(
                            dotPrimaryColor: Color(0xFFFFA721),
                            dotSecondaryColor: Color(0xFFFFA721),
                          ),
                          likeBuilder: (bool isLiked) {
                            return Icon(
                              Icons.favorite,
                              color: isLiked ? primary : Colors.grey,
                              size: 30,
                            );
                          },
                          likeCount: data.like!.quantityLike ?? 0,
                        ),
                        IconButton(
                            onPressed: () {
                              Provider.of<CommentsProvider>(context, listen: false).loadData(data.uid);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPost(data: data),));
                            },
                            icon: Icon(
                              Icons.message,
                              size: 30,
                              color: Colors.grey,
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('¿ Desea elimiar esta publicación?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Eliminar'),
            onPressed: () {
              Provider.of<PostProvider>(context, listen: false).removePosts(data.uid);
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
}
