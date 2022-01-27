import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/profile_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class ProfilePreviewScreen extends StatelessWidget {
  final String name;
  final String bio;
  final String phone;
  const ProfilePreviewScreen ({
    required this.name,
    required this.bio,
    required this.phone,
    Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state){},
      builder: (context, state){
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: (){
                AppCubit.get(context).getProfileImage();
              },
              icon: const Icon(
                IconBroken.Arrow___Left_2,
                color: Colors.grey,
              ),
            ),
            titleSpacing: 0.0,
            title: Text(
              'Preview Profile Picture',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            actions: [
              defaultTextButton(
                text: 'save', 
                onPressed: (){
                  AppCubit.get(context).uploadProfileImage(
                    name: name, 
                    phone: phone, 
                    bio: bio,
                    context: context,
                    screen: const ProfileScreen(),
                  );
                }
              ),
            ],
          ),
          body: Column(
            children: 
            [
              Container(
                clipBehavior: Clip.antiAlias,
                height: MediaQuery.of(context).size.height /2 ,
                width: MediaQuery.of(context).size.width /1 ,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image(
                  image: FileImage(AppCubit.get(context).profileImage),
                  fit: BoxFit.cover,
                ),
              ),
              /* defaultButton(text: 'Upload', 
              onPressed: (){
                AppCubit.get(context).uploadProfileImage(
                  name: name, 
                  phone: phone, 
                  bio: bio,
                  context: context,
                  screen: const ProfileScreen(),
                );
              }), */
            ],
          ),
        );
      },
    );
  }
}