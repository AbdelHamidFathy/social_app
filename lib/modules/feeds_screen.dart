import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/create_post_model.dart';
import 'package:social_app/modules/comment_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var commentController = TextEditingController();
        return ConditionalBuilder(
          condition: AppCubit.get(context).posts.isNotEmpty,
          builder: (context) => RefreshIndicator(
            color: defaultColor,
            onRefresh: (){
              return Future.delayed(
                const Duration(seconds: 3),
                (){
                  AppCubit.get(context).getPosts();
                },
              );
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) => postBuilder(
                context,
                  AppCubit.get(context).posts[index],
                  index,
                  commentController),
              separatorBuilder: (context, index) =>
                const SizedBox(height: 5.0),
              itemCount: AppCubit.get(context).posts.length,
            ),
          ),
          fallback: (context) => const Center(
            child: CircularProgressIndicator(
            color: defaultColor,
          )
        ),
      );
    });
  }

  Widget postBuilder(
      context, CreatePostModel model, index, TextEditingController comment) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(model.image),
                  radius: 25.0,
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.name,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        model.dateTime,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(height: 1.0),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    IconBroken.More_Circle,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              model.text,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    height: 1.3,
                  ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 13.0,
            ),
            if (model.postImage != '')
              Image(
                height: 250.0,
                width: double.infinity,
                fit: BoxFit.cover,
                image: NetworkImage(
                  '${model.postImage}',
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MaterialButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      const Icon(
                        IconBroken.Heart,
                        size: 18.0,
                      ),
                      const SizedBox(
                        width: 3.0,
                      ),
                      Text(
                        ' ${AppCubit.get(context).likes[index]} ',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.zero,
                  minWidth: 1,
                  height: 1.0,
                ),
                const Spacer(),
                MaterialButton(
                  onPressed: () {
                    AppCubit.get(context).getComments(postId: AppCubit.get(context).postsId[index]).then((value) {
                      navigateTo(
                        context: context, 
                        Widget: CommentScreen(index: index),
                      );
                    });
                  },
                  child: Row(
                    children: [
                      const Icon(
                        IconBroken.Chat,
                        size: 18,
                      ),
                      const SizedBox(
                        width: 3.0,
                      ),
                      Text(
                        'comments',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                  height: 1,
                  minWidth: 0,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            Container(
              height: 0.5,
              width: double.infinity,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 13.0,
            ),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      NetworkImage('${AppCubit.get(context).userModel.image}'),
                  radius: 20.0,
                ),
                const SizedBox(
                  width: 5.0,
                ),
                InkWell(
                  onTap: () {
                    AppCubit.get(context).getComments(postId: AppCubit.get(context).postsId[index])
                    .then((value) {
                      navigateTo(
                        context: context, 
                        Widget: CommentScreen(index: index),
                      );
                    });
                  },
                  child: Text(
                    'Write a comment...',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
                const Spacer(),
                MaterialButton(
                  onPressed: () {
                    AppCubit.get(context)
                        .likePost(postId: AppCubit.get(context).postsId[index]);
                  },
                  child: Row(
                    children: [
                      const Icon(
                        IconBroken.Heart,
                        size: 20,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 3.0,
                      ),
                      Text(
                        'Like',
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(fontSize: 14.0),
                      ),
                    ],
                  ),
                  height: 1,
                  minWidth: 1,
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(
                  width: 20.0,
                ),
                /* MaterialButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      const Icon(
                        IconBroken.Upload,
                        size: 20,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 3.0,
                      ),
                      Text(
                        'Share',
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              fontSize: 14.0,
                            ),
                      ),
                    ],
                  ),
                  height: 1,
                  minWidth: 1,
                  padding: EdgeInsets.zero,
                ), */
              ],
            ),
          ],
        ),
      ),
    );
  }
}
