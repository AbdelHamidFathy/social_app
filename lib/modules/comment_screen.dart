import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class CommentScreen extends StatelessWidget {
  final dynamic index;
  const CommentScreen({required this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        
        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var commentController = TextEditingController();
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                leading: back(context),
                titleSpacing: 0.0,
                title: Text(
                  'Comments',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              body: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    color: Colors.grey,
                    height: 0.5,
                    width: double.infinity,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, top: 8.0),
                              child:
                                  commentItem(context: context, index: index),
                            ),
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 5.0,
                            ),
                            itemCount: AppCubit.get(context).comments.length,
                          ),
                        ),
                        Container(
                          height: 0.5,
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: commentFormField(
                            context: context,
                            controller: commentController,
                            onPressed: () {
                              AppCubit.get(context).writeComment(
                                dateTime: '${DateFormat.yMMMd().format(DateTime.now()).toString()} at ${DateFormat('h:mm:ss a').format(DateTime.now())}',
                                postId: AppCubit.get(context).postsId[index],
                                comment: commentController.text,
                              );
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return '';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget commentFormField({
    required BuildContext context,
    required void Function()? onPressed,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: TextFormField(
        minLines: null,
        keyboardType: TextInputType.multiline,
        controller: controller,
        validator: validator,
        cursorColor: defaultColor,
        decoration: InputDecoration(
          fillColor: Colors.grey[300],
          filled: true,
          hintText: 'Write a comment...',
          hintStyle: Theme.of(context).textTheme.caption,
          border: InputBorder.none,
          suffixIcon: IconButton(
            onPressed: onPressed,
            icon: const Icon(
              IconBroken.Arrow___Right_Circle,
              color: Colors.grey,
              size: 35.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget commentItem({required BuildContext context, required index}) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(
              AppCubit.get(context).comments[index].profileImage),
          radius: 20.0,
        ),
        const SizedBox(
          width: 5.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left:5.0, right: 5.0),
              width: 100.0,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppCubit.get(context).comments[index].name,
                  ),
                  Text(
                    AppCubit.get(context).comments[index].text,
                  ),
                ],
              ),
            ),
            Text(
              AppCubit.get(context).comments[index].dateTime,
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ],
    );
  }
}
