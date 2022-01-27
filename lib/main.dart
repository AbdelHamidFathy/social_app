import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_layout.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/network/local/cache_helper.dart';
import 'package:social_app/shared/bloc_observer.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  FirebaseMessaging.onMessage.listen((event) { 
    print('success');
  }).onError((error){
    print(error.toString());
  });

  await CacheHelper.init();
  Bloc.observer = MyBlocObserver();
  uId=CacheHelper.getData(key: 'uId');
  Widget startScreen;
  if (uId!=null) {
    startScreen= HomeLayout();
  }else{
    startScreen=const LoginScreen();
  }
  runApp(MyApp(startScreen));
}

class MyApp extends StatelessWidget {
  final Widget home;
  const MyApp(this.home, {Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>AppCubit()..getPosts()..getUserData(uId: uId)
      ..getUsers()..getMyPosts(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state){},
        builder :(context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            home: home,
          );
        },
      ),
    );
  }
}