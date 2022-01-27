import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_app/models/messages_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/send_image_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class ChatScreen extends StatelessWidget {
  final UserModel model;
  const ChatScreen({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        AppCubit.get(context).getMessages(receiverId: model.uId);
        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var messageController = TextEditingController();
            return Scaffold(
              backgroundColor: Colors.grey[200],
              appBar: AppBar(
                elevation: 3,
                leading:back(context),
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage('${model.image}'),
                    ),
                    Text(
                      model.name,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          var message = AppCubit.get(context).messages[index];      
                          if (AppCubit.get(context).userModel.uId ==
                              message.senderId) {
                            return senderMessage(message, context);
                          }return receiverMessage(message, context);
                        }, 
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 5.0),
                        itemCount: AppCubit.get(context).messages.length,
                      ),
                    ),
                  ),
                  messageTextField(
                    controller: messageController,
                    context: context,
                    onPressed: () {
                      AppCubit.get(context).sendMessage(
                        receiverId: model.uId,
                        message: messageController.text,
                        dateTime: '${DateFormat.yMMMd().format(DateTime.now()).toString()} at ${DateFormat('h:mm:ss a').format(DateTime.now())}',
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  Widget receiverMessage(MessagesModel model, context) {
    if (model.text != '') {
      return Align(
        alignment: Alignment.topLeft,
        child: Container(
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(7.0),
              topRight: Radius.circular(7.0),
              bottomRight: Radius.circular(7.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.text,
              ),
              Text(
                model.dateTime,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ),
      );
    }
    return FractionallySizedBox(
      widthFactor: 0.5,
      alignment: Alignment.topLeft,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.grey,
          border: Border.all(
            color: Colors.grey,
            width: 3.5,
          ),
          borderRadius:const BorderRadius.only(
            topRight: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
          ),
        ),
        child: Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image(
                fit: BoxFit.cover,
                image: NetworkImage(model.image.toString()),
              ),
              Text(
                model.dateTime,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget senderMessage(MessagesModel model, context) {
    if (model.text != '') {
      return Align(
        alignment: Alignment.topRight,
        child: Container(
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: defaultColor.withOpacity(0.5),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(7.0),
              topLeft: Radius.circular(7.0),
              topRight: Radius.circular(7.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.text,
              ),
              Text(
                model.dateTime,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ),
      );
    }
    return FractionallySizedBox(
      widthFactor: 0.5,
      alignment: Alignment.topRight,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: defaultColor,
          border: Border.all(
            color: defaultColor,
            width: 3.5,
          ),
          borderRadius:const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
          ),
        ),
        child: Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Image(
                fit: BoxFit.cover,
                image: NetworkImage(model.image.toString()),
              ),
              Text(
                model.dateTime,
                style: Theme.of(context).textTheme.caption!.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget messageTextField({
    required BuildContext context,
    required Function()? onPressed,
    required TextEditingController controller,
  }) {
    return Container(
      padding: const EdgeInsets.only(
        right: 10.0,
        top: 10.0,
        bottom: 10.0,
      ),
      height: 70.0,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              AppCubit.get(context).getChatImage().then((value) {
                navigateTo(
                  context: context,
                  Widget: SendImageScreen(
                    model: model,
                  ),
                );
              });
            },
            icon: Icon(
              IconBroken.Image_2,
              color: Colors.grey[700],
            ),
            padding: EdgeInsets.zero,
          ),
          Expanded(
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              padding: const EdgeInsets.only(left: 10.0),
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                  color: defaultColor,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      cursorColor: defaultColor,
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: 'Message',
                        hintStyle: Theme.of(context).textTheme.caption,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  MaterialButton(
                    height: 50.0,
                    elevation: 0.0,
                    minWidth: 20.0,
                    color: defaultColor,
                    onPressed: onPressed,
                    child: const Icon(
                      IconBroken.Send,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
