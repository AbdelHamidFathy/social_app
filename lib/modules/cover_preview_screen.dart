import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/profile_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class CoverPreviewScreen extends StatelessWidget {
  final String name;
  final String bio;
  final String phone;
  const CoverPreviewScreen ({
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
                AppCubit.get(context).getCoverImage();
              },
              icon: const Icon(
                IconBroken.Arrow___Left_2,
                color: Colors.grey,
              ),
            ),
            titleSpacing: 0.0,
            title: Text(
              'Preview Cover Picture',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            actions: [
              defaultTextButton(
                text: 'save', 
                onPressed: (){
                  AppCubit.get(context).uploadCoverImage(
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
                height: 150.0,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Image(
                        height: 100.0,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        image: FileImage(AppCubit.get(context).coverImage),
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 53.0,
                        ),
                        CircleAvatar(
                          radius: 50.0,
                          backgroundImage: NetworkImage('${AppCubit.get(context).userModel.image}'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}