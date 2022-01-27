import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/profile_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/colors.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state){},
      builder: (contxet, state){
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: 
            [
              InkWell(
                onTap: (){
                  AppCubit.get(context).getMyPosts();
                  navigateTo(
                    context: context, 
                    Widget: const ProfileScreen(),
                  );
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage('${AppCubit.get(context).userModel.image}'),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppCubit.get(context).userModel.name,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(
                          'See your profile',
                          style: Theme.of(context).textTheme.caption!.copyWith(
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                child: OutlinedButton(
                    onPressed: (){
                      AppCubit.get(context).logOut(context: contxet);
                    },
                    child: Text(
                      'Log Out',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: defaultColor,
                      ),
                    ),
                  ),
              ),
            ],
          ),
        );
      },
    );
  }
}