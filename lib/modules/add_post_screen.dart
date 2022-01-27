import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_app/layout/home_layout.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class AddPostScreen extends StatelessWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textController = TextEditingController();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var postImage = AppCubit.get(context).postImage;
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0.0,
            leading: back(context),
            title: Text(
              'Create post',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            actions: [
              defaultTextButton(
                text: 'Post',
                onPressed: () {
                  if(postImage==null) {
                    AppCubit.get(context).createPost(
                    text: textController.text,
                    dateTime: '${DateFormat.yMMMd().format(DateTime.now()).toString()} at ${DateFormat('h:mm a').format(DateTime.now())}',
                    context: context,
                  );
                  }
                  if(postImage!=null) {
                    AppCubit.get(context).createPostWithPhoto(
                    text: textController.text, 
                    dateTime: '${DateFormat.yMMMd().format(DateTime.now()).toString()} at ${DateFormat('h:mm a').format(DateTime.now())}',
                    context: context,
                    );
                  }
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            '${AppCubit.get(context).userModel.image}'),
                        radius: 25.0,
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                        child: Text(
                          AppCubit.get(context).userModel.name,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    controller: textController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'What is in your mind?',
                      hintStyle: Theme.of(context).textTheme.caption,
                    ),
                  ),
                ),
                if(postImage!=null)
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Image(
                      image: FileImage(postImage),
                      width: double.infinity,
                      height: 250.0,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: IconButton(
                        onPressed: (){
                          AppCubit.get(context).closePostImage();
                        },
                        icon: const Icon(
                          IconBroken.Close_Square,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Container(
                  color: Colors.grey,
                  width: double.infinity,
                  height: 0.5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                    onPressed: (){
                      AppCubit.get(context).getPostImage();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          IconBroken.Image_2,
                          color: Colors.green,
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'Add photo',
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.green,
                          ),
                        ),
                      ],
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
