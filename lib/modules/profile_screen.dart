import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/create_post_model.dart';
import 'package:social_app/modules/add_post_screen.dart';
import 'package:social_app/modules/edit_profile_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state){},
      builder: (context, state){
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            titleSpacing: 0.0,
            leading: back(context),
            title: Text(
              'Profile',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                          image: NetworkImage('${AppCubit.get(context).userModel.cover}'),
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
                Padding(
                  padding: const EdgeInsets.only(left:8.0,right: 8.0,
                  bottom: 8.0),
                  child: Column(
                    children: [
                      Text(
                        AppCubit.get(context).userModel.name,
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        '${AppCubit.get(context).userModel.bio}',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '${AppCubit.get(context).myPosts.length}',
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                Text(
                                  'Posts',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '10k',
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                Text(
                                  'Followers',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '1K',
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                Text(
                                  'Following',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: (){
                                navigateTo(
                                  context: context, 
                                  Widget: const AddPostScreen(),
                                );
                              }, 
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    IconBroken.Paper,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(
                                    width: 3.0,
                                  ),
                                  Text(
                                    'Add post',
                                    style: Theme.of(context).textTheme.subtitle1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: (){
                                navigateTo(
                                  context: context, 
                                  Widget: const EditProfileScreen(),
                                );
                              }, 
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    IconBroken.Edit,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(
                                    width: 3.0,
                                  ),
                                  Text(
                                    'Edit profile',
                                    style: Theme.of(context).textTheme.subtitle1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder:(context, index)=> postBuilder(context,AppCubit.get(context).myPosts[index],index), 
                        separatorBuilder: (context, index)=>const SizedBox(height: 5.0), 
                        itemCount: AppCubit.get(context).myPosts.length,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget postBuilder(
      context, CreatePostModel model, index, /* TextEditingController comment */) {
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
                  onPressed: () {},
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
                    navigateTo(
                      context: context,
                      Widget:Widget /* CommentScreen(index: index), */
                    );
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