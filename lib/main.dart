import 'package:clean_login/presentation/blocs/myuser_controller.dart';
import 'package:clean_login/presentation/blocs/providers/commetsProvider.dart';
import 'package:clean_login/presentation/blocs/providers/friendProvider.dart';
import 'package:clean_login/presentation/blocs/providers/postProvider.dart';
import 'package:clean_login/presentation/routes/app_acreens.dart';
import 'package:clean_login/presentation/routes/app_routes.dart';
import 'package:clean_login/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'injection_dependency.dart';
import 'presentation/blocs/authBloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  configureDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => getIt<AuthBloc>(),
        ),
      ],
      
        child: MultiProvider(
          providers: [
            
                ChangeNotifierProvider<PostProvider>(
              create: (context) => PostProvider()),

                ChangeNotifierProvider<FriendProvider>(
              create: (context) => FriendProvider()),

               ChangeNotifierProvider<MyUserData>(
              create: (context) => MyUserData()),

              ChangeNotifierProvider<CommentsProvider>(
              create: (context) => CommentsProvider()),
          ],
          child: MaterialApp(
              title: 'Red social',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.buildTheme(),
              initialRoute: Routes.INITIAL,
              routes: AppPages.routes),
        ),
      
    );
  }
}
