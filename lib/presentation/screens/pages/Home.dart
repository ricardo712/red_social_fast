import 'package:cached_network_image/cached_network_image.dart';
import 'package:clean_login/core/framework/colors.dart';
import 'package:clean_login/core/preferences/preferences.dart';
import 'package:clean_login/presentation/blocs/authBloc/auth_bloc.dart';
import 'package:clean_login/presentation/blocs/myuser_controller.dart';
import 'package:clean_login/presentation/blocs/providers/postProvider.dart';
import 'package:clean_login/presentation/screens/pages/friends/PageFriend.dart';
import 'package:clean_login/presentation/screens/pages/menu/menu.dart';
import 'package:clean_login/presentation/screens/pages/notifications/NotifiPage.dart';
import 'package:clean_login/presentation/screens/pages/post/Postview.dart';
import 'package:clean_login/presentation/screens/pages/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../../../injection_dependency.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  // final myuser = getIt<MyUserData>();
   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _preferences = getIt<Preferences>();
  var _currentIndex = 0;
  String iduser = "";
  static List<Widget> _widgetOptions = [
   PostView(),
   PageFriend(),
   NotificationsPage(),
  ];

  @override
  void initState() {
    super.initState();
    preferenciasDatos();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
     Provider.of<PostProvider>(context, listen: false).loadData(null, 5);
  });
  }

  Future preferenciasDatos() async {
    setState(() {
      Future<String> authToken = _preferences.getAuthToken();
      authToken.then((data) {
           getIt<MyUserData>().idUser = data;
        setState(() {
          iduser = data.toString();
          context.read<AuthBloc>().add(OnGetUser(id: iduser));

        });
      }, onError: (e) {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() {});
          _currentIndex = 0;
          return false;
        } else {
          return true;
        }
      },
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
            bottomNavigationBar: SalomonBottomBar(
              currentIndex: _currentIndex,
              onTap: (i) => setState(() => _currentIndex = i),
              items: [
                /// Home
                SalomonBottomBarItem(
                    icon: Icon(Ionicons.globe),
                    title: Text("Publicaciones"),
                    selectedColor: primary),
    
                /// Likes
                SalomonBottomBarItem(
                    icon: Icon(Ionicons.person_add),
                    title: Text("Amigos"),
                    selectedColor: primary),

                    SalomonBottomBarItem(
                    icon: Icon(Ionicons.notifications),
                    title: Text("Noficaciones"),
                    selectedColor: primary),
              ],
            ),
            drawer: Menu(),
            appBar: AppBar(
              
              leading: Builder(builder: (context) {
                return IconButton(
                  icon: Icon(Ionicons.log_out_outline),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                );
              }),
              iconTheme: IconThemeData(color: claro),
              elevation: 0,
              backgroundColor: primary,
              actions: [avatar()],
            ),
            
            body: Container(
              width: size.width,
              height: size.height,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      child: _widgetOptions.elementAt(_currentIndex),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  BlocBuilder avatar() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state)  {
        if (state is LoginLoaded) {
      
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Provider.of<PostProvider>(context, listen: false).loadDataPostProfile(state.user.id);
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileUser(user: state.user),)); },
              
              child: CircleAvatar(
                  backgroundColor: claro,
                  child: ClipOval(
                      child: CachedNetworkImage(
                        width: double.infinity,
                    imageUrl: "${state.user.image}",
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                        Center(
                      child: CircularProgressIndicator(
                          color: primary, value: downloadProgress.progress),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ))),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: CircularProgressIndicator(
              color: primary,
            ),
          );
        }
      },
    );
  }
}
