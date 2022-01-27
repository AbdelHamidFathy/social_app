import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/messages_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chat_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class SendImageScreen extends StatelessWidget {
  final UserModel model;
  const SendImageScreen({required this.model,Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state){},
      builder: (context, state){
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0.0,
            leading: back(context),
          ),
          body: Center(
            child: Column(
              children: [
                Expanded(
                  child: Image(
                    image: FileImage(
                      AppCubit.get(context).chatImage,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: CircleAvatar(
                      backgroundColor: defaultColor,
                      child: IconButton(
                        onPressed: (){
                          AppCubit.get(context).uploadChatImage(
                            context: context,
                            receiverId: model.uId, 
                            dateTime: DateTime.now().toString(),
                            screen: ChatScreen(model: model)
                          );
                        }, 
                        icon: const Icon(
                          IconBroken.Send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}