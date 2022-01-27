import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/chats_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class HomeLayout extends StatelessWidget {
  dynamic index;
  HomeLayout({this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        index = AppCubit.get(context).currentIndex;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              cubit.titles[cubit.currentIndex],
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  IconBroken.Search,
                  color: Colors.grey,
                ),
              ),
              IconButton(
                onPressed: () {
                  AppCubit.get(context).getUsers();
                  navigateTo(
                    context: context,
                    Widget: const ChatsScreen(),
                  );
                },
                icon: const Icon(
                  IconBroken.Chat,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: bottomNavigationBar(context),
        );
      },
    );
  }

  Widget bottomNavigationBar(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 0.5,
          width: double.infinity,
          color: Colors.grey,
        ),
        BottomNavigationBar(
          onTap: (index) {
            AppCubit.get(context)
                .changeBottomNavBar(index: index, context: context);
          },
          currentIndex: AppCubit.get(context).currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                IconBroken.Home,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(IconBroken.Plus),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                IconBroken.Category,
              ),
              label: '',
            ),
          ],
        ),
      ],
    );
  }
}
/* Column(
            children: 
            [
              Container(
                height: 50.0,
                width: double.infinity,
                color: Colors.amber.withOpacity(0.4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: 
                  // ignore: prefer_const_literals_to_create_immutables
                  [
                    const Icon(
                      IconBroken.Info_Circle,
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    const Text(
                      'Please verify your email',
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    defaultTextButton(
                      text: 'Send an email', 
                      onPressed: (){
                        FirebaseAuth.instance.currentUser!.sendEmailVerification()
                        .then((value) {
                          toast(
                            msg: 'Check your mail', 
                            state: ToastStates.SUCCESS,
                          );
                        }).catchError((error){
                          print(error.toString());
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ), */