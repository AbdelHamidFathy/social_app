import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_layout.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chat_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: back(context),
            titleSpacing: 0.0,
            title: Text(
              'Chats',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) =>
                        chatItem(context, AppCubit.get(context).users[index]),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 8.0,
                    ),
                    itemCount: AppCubit.get(context).users.length,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget chatItem(
    BuildContext context,
    UserModel model,
  ) {
    return InkWell(
      onTap: () {
        navigateTo(
          context: context,
          Widget: ChatScreen(
            model: model,
          ),
        );
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage('${model.image}'),
          ),
          const SizedBox(
            width: 8.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.name,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Text(
                'Message',
                style: Theme.of(context).textTheme.caption!.copyWith(
                      height: 1.0,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
