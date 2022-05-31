import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clean_login/core/framework/colors.dart';
import 'package:clean_login/domain/entities/user.dart';
import 'package:clean_login/injection_dependency.dart';
import 'package:clean_login/presentation/blocs/providers/friendProvider.dart';
import 'package:clean_login/presentation/blocs/providers/postProvider.dart';
import 'package:clean_login/presentation/screens/pages/profile/profile.dart';
import 'package:clean_login/theme.dart';
import 'package:flutter/material.dart';
import 'package:clean_login/presentation/blocs/myuser_controller.dart';
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';

class PageFriend extends StatefulWidget {
  const PageFriend({Key? key}) : super(key: key);

  @override
  State<PageFriend> createState() => _PageFriendState();
}

class _PageFriendState extends State<PageFriend> {
  @override
  void initState() {
    if (Provider.of<FriendProvider>(context, listen: false).item == null) {
      Provider.of<FriendProvider>(context, listen: false).loadData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<FriendProvider>(context);
    return Scaffold(
      body: data.item != null && !data.loading
          ? RefreshIndicator(
              color: primary,
              onRefresh: newsInfo,
              child: ListView.builder(
                itemCount: data.item!.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          height: 60,
                          width: 60,
                          child: CircleAvatar(
                            radius: 35,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                width: double.infinity,
                                height: double.infinity,
                                imageUrl: data.item![index].image,
                                fit: BoxFit.cover,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
                                  child: CircularProgressIndicator(
                                      color: primary,
                                      value: downloadProgress.progress),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              data.item![index].usuario,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Provider.of<PostProvider>(context, listen: false)
                                  .loadDataPostProfile(data.item![index].id);
                              Provider.of<FriendProvider>(context,
                                      listen: false)
                                  .getStateSolicitude(
                                      getIt<MyUserData>().idUser,
                                      data.item![index].id);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileUser(user: data.item![index]),
                                  ));
                            },
                            child: Text(
                              "Visitar",
                              style: TextStyle(color: primary),
                            ))
                      ],
                    ),
                  );
                },
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                color: primary,
              ),
            ),
      floatingActionButton: data.item != null && !data.loading
          ? FloatingActionButton(
            backgroundColor: primary,
              child: Icon(Icons.search, color: claro,),
              tooltip: 'Search people',
              onPressed: () => showSearch(
                context: context,
                delegate: SearchPage<UserEntities>(
                  barTheme: ThemeData(
                    primaryColor: primary,
                    textTheme: TextTheme() ,
                    
                    appBarTheme: AppBarTheme(backgroundColor: primary)
                  ),
                  items: data.item!,
                  searchLabel: 'Buscar Persona',
                  searchStyle: TextStyle(color: claro, backgroundColor: claro, decorationColor: claro),
                  suggestion: Center(
                    child: Text('Filtrar por nombre'),
                  ),
                  failure: Center(
                    child: Text('Persona no encontrada :('),
                  ),
                  filter: (person) => [
                    person.email,
                    person.usuario,
                  ],
                  builder: (person) => ListTile(
                    onTap: () {
                       Provider.of<PostProvider>(context, listen: false)
                                  .loadDataPostProfile(person.id);
                              Provider.of<FriendProvider>(context,
                                      listen: false)
                                  .getStateSolicitude(
                                      getIt<MyUserData>().idUser,
                                      person.id);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileUser(user: person),
                                  ));
                    },
                    title: Text(person.usuario),
                    subtitle: Text(person.email),
                    leading: Container(
                      width: 60,
                      height: 60,
                      child: CircleAvatar(
                        radius: 35,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            width: double.infinity,
                            height: double.infinity,
                            imageUrl: person.image,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
                              child: CircularProgressIndicator(
                                  color: primary,
                                  value: downloadProgress.progress),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Container(),
    );
  }

  Future<Null> newsInfo() async {
    final duration = Duration(seconds: 2);
    new Timer(duration, () {
      Provider.of<FriendProvider>(context, listen: false).item!.clear();
      Provider.of<FriendProvider>(context, listen: false).loadData();
    });

    return Future.delayed(duration);
  }
}
