import 'package:cached_network_image/cached_network_image.dart';
import 'package:clean_login/core/framework/colors.dart';
import 'package:clean_login/domain/entities/user.dart';
import 'package:clean_login/injection_dependency.dart';
import 'package:clean_login/presentation/blocs/myuser_controller.dart';
import 'package:clean_login/presentation/blocs/providers/friendProvider.dart';
import 'package:clean_login/presentation/blocs/providers/postProvider.dart';
import 'package:clean_login/presentation/screens/pages/post/CreatePost.dart';
import 'package:clean_login/presentation/screens/pages/post/Postview.dart';
import 'package:clean_login/presentation/screens/pages/profile/EditProfile.dart';
import 'package:clean_login/presentation/screens/pages/profile/widget/btn_stateFriends.dart';
import 'package:clean_login/presentation/screens/widget/back_buttom.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class ProfileUser extends StatefulWidget {
  const ProfileUser({Key? key, required this.user}) : super(key: key);
  final UserEntities user;

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  @override
  void initState() {
    Provider.of<FriendProvider>(context, listen: false).zisefriends = 0;
    Provider.of<FriendProvider>(context, listen: false).sizeFriends(widget.user.id);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final datapost = Provider.of<PostProvider>(context);
    final size = Provider.of<FriendProvider>(context).zisefriends;
    return Scaffold(
      floatingActionButton: widget.user.id == getIt<MyUserData>().idUser
          ? FloatingActionButton(
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
              child: Icon(Ionicons.add_circle_outline,
                  color: Colors.white, size: 30),
            )
          : Container(),
      body: SafeArea(
          child: Container(
              color: claro,
              width: double.infinity,
              height: double.infinity,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Row(
                      children: [
                        BackButtomContainer(),
                        Spacer(),
                        Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              "Perfil",
                              style: TextStyle(
                                color: primary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                        widget.user.id == getIt<MyUserData>().idUser
                            ? IconButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile(user: widget.user),));
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: primary,
                                ))
                            : Container()
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      width: double.infinity,
                      height: 250,
                      color: primary.withOpacity(0.5),
                      child: Stack(children: [
                        Center(
                          child: CircleAvatar(
                              radius: 80,
                              backgroundColor: claro,
                              child: ClipOval(
                                  child: CachedNetworkImage(
                                    width: double.infinity,
                                imageUrl: widget.user.image,
                                fit: BoxFit.cover,
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
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              widget.user.usuario,
                              style: TextStyle(
                                color: claro,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ]),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      child: Row(
                        children: [
                           Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Amigos", style: TextStyle(color: primary, fontSize: 18, fontWeight: FontWeight.bold),),
                              Text(size.toString() , style: TextStyle(color: primary, fontSize: 18, fontWeight: FontWeight.bold),),
                            ],
                          ),
                             Spacer(),
                        widget.user.id != getIt<MyUserData>().idUser ? BtnState(friendId: widget.user.id): Container(),
                              widget.user.id != getIt<MyUserData>().idUser ?  Spacer(): Container(),
                        ],
                      ),
                    ),
                  ),
                  datapost.itemPostUser != null && !datapost.loadingPostUser
                      ? datapost.itemPostUser!.length > 0
                          ? SliverList(
                              delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return CardPost(
                                    data: datapost.itemPostUser![index]);
                              },
                              childCount: datapost.itemPostUser!.length,
                            ))
                          : SliverToBoxAdapter(
                              child: Center(
                                child: Text("No hay publicaciones"),
                              ),
                            )
                      : SliverToBoxAdapter(
                          child: Container(
                            margin: EdgeInsets.all(20),
                            child: Center(
                              child: CircularProgressIndicator(color: primary,),
                            ),
                          ),
                        )
                ],
              ))),
    );
  }
}

class ListPostProfile extends StatelessWidget {
  const ListPostProfile({
    Key? key,
    required this.datapost,
  }) : super(key: key);

  final PostProvider datapost;

  @override
  Widget build(BuildContext context) {
    return datapost.itemPostUser != null && !datapost.loadingPostUser
        ? datapost.itemPostUser!.length > 0
            ? SliverList(
                delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return CardPost(data: datapost.itemPostUser![index]);
                },
                childCount: datapost.itemPostUser!.length,
              ))
            : Center(
                child: Text("No hay publicaciones"),
              )
        : Center(
            child: CircularProgressIndicator(color: primary,),
          );
  }
}
