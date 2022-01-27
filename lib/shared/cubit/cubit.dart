import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/models/comment_model.dart';
import 'package:social_app/models/create_post_model.dart';
import 'package:social_app/models/messages_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/add_post_screen.dart';
import 'package:social_app/modules/feeds_screen.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/modules/notifications_screen.dart';
import 'package:social_app/modules/menu_screen.dart';
import 'package:social_app/modules/user_screen.dart';
import 'package:social_app/network/local/cache_helper.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:firebase_storage/firebase_storage.dart' ;
class AppCubit  extends Cubit<AppStates>{
  
  AppCubit() : super(InitiallState());

  static AppCubit get(context)=>BlocProvider.of(context);
  
  late UserModel userModel;
  void getUserData({
    required dynamic uId,
  }){
    emit(GetUserLoadingState());
    FirebaseFirestore.instance.collection('users')
    .doc(uId)
    .get()
    .then((value) {
      userModel=UserModel.fromJson(value.data()!);
      emit(GetUserSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(GetUserErrorState());
    });
  }
  List<UserModel> users=[];
  void getUsers(){
    users=[];
    emit(GetUsersLoadingState());
    FirebaseFirestore.instance
    .collection('users')
    .get().then((value) {
      value.docs.forEach((element) { 
        if(element.data()['uId']!=userModel.uId){
          users.add(UserModel.fromJson(element.data()));
        }
        emit(GetUsersSuccessState());
      });
    }).catchError((error){
      print(error.toString());
      emit(GetUsersErrorState());
    });
  }
  void sendMessage ({
    required String receiverId,
    required String message,
    required String dateTime,
  }){
    MessagesModel model = MessagesModel(
      text: message,
      senderId: userModel.uId,
      dateTime: dateTime,
      receiverId: receiverId,
    );
    FirebaseFirestore.instance
    .collection('users')
    .doc(userModel.uId)
    .collection('chats')
    .doc(receiverId)
    .collection('messages')
    .add(model.toMap()).then((value) {
      emit(MessageSendSuccessState());
    }).catchError((error){
      emit(MessageSendErrorState());
    });
    FirebaseFirestore.instance
    .collection('users')
    .doc(receiverId)
    .collection('chats')
    .doc(userModel.uId)
    .collection('messages')
    .add(model.toMap()).then((value) {
      emit(MessageSendSuccessState());
    }).catchError((error){
      emit(MessageSendErrorState());
    });
  }
  void sendImage({
    required String receiverId,
    required String image,
    required String dateTime,
  }){
    MessagesModel model = MessagesModel(
      text: '',
      image: image,
      senderId: userModel.uId,
      dateTime: dateTime,
      receiverId: receiverId,
    );
    FirebaseFirestore.instance
    .collection('users')
    .doc(userModel.uId)
    .collection('chats')
    .doc(receiverId)
    .collection('messages')
    .add(model.toMap()).then((value) {
      emit(ImageSendSuccessState());
    }).catchError((error){
      emit(ImageSendErrorState());
    });
    FirebaseFirestore.instance
    .collection('users')
    .doc(receiverId)
    .collection('chats')
    .doc(userModel.uId)
    .collection('messages')
    .add(model.toMap()).then((value) {
      emit(MessageSendSuccessState());
    }).catchError((error){
      emit(MessageSendErrorState());
    });
  }
  List<MessagesModel>messages=[]; 
  void getMessages({
    required String receiverId,
  }){
    FirebaseFirestore.instance
    .collection('users')
    .doc(userModel.uId)
    .collection('chats')
    .doc(receiverId)
    .collection('messages')
    .orderBy('dateTime')
    .snapshots()
    .listen((event) { 
      messages=[];
      event.docs.forEach((element) { 
        messages.add(MessagesModel.fromJson(element.data()));
        emit(GetMessagesSuccessState());
      });
    });
  }
  List<CreatePostModel> posts=[];
  List<String> postsId=[];
  List<int> likes=[];
  List<CommentModel> comments=[];
  void getPosts()
  {
    FirebaseFirestore.instance.collection('posts').get().then((value)
    {
      posts=[];
      value.docs.forEach((element)
      {
        element.reference
        .collection('likes')
        .get()
        .then((value)
        {
          likes.add(value.docs.length);
          postsId.add(element.id);
          posts.add(CreatePostModel.fromJson(element.data()));
          emit(GetPostsSuccessState());
        })
        .catchError((error){});
      });
    }).catchError((error) {
      print(error.toString());
      emit(GetPostsErrorState());
    });
  }
  List<CreatePostModel>myPosts=[];
  void getMyPosts(){
    FirebaseFirestore.instance
    .collection('posts')
    .orderBy('dateTime')
    .get().then((value) {
      myPosts=[];
      value.docs.forEach((element) {
        if (element['uId']==userModel.uId) {
         myPosts.add(CreatePostModel.fromJson(element.data())); 
        }
        emit(GetMyPostsSuccessState());
      });
    }).catchError((error){
      print(error.toString());
      emit(GetMyPostsErrorState());
    });
  }
  void likePost({
    required String postId,
  }){
    FirebaseFirestore.instance
    .collection('posts')
    .doc(postId)
    .collection('likes')
    .doc(userModel.uId)
    .set({
      'like':true,
    }).then((value) {
      emit(LikePostSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(LikePostErrorState());
    });
  }
  void writeComment({
    required String postId,
    required String comment,
    required String dateTime,
  }){
    CommentModel commentModel = CommentModel(
      name: userModel.name,
      uId: userModel.uId,
      profileImage: userModel.image!,
      text: comment,
      dateTime: dateTime,
    );
    FirebaseFirestore.instance
    .collection('posts')
    .doc(postId)
    .collection('comments')
    .add(commentModel.toMap()).then((value) {
      getComments(postId: postId);
      emit(WriteCommentSuccessState());
    }).catchError((error){
      print(error.toString());
      emit(WriteCommentErrorState());
    });
  }
  late CommentModel commentModel;
  Future <void> getComments({
    required postId,
  })async{
    emit(GetCommentsLoadingState());
    await FirebaseFirestore.instance
    .collection('posts')
    .doc(postId)
    .collection('comments')
    .orderBy('dateTime')
    .get().then((value) {
      comments=[];
      value.docs.forEach((element) { 
        comments.add(CommentModel.fromJson(element.data()));
        emit(GetCommentsSuccessState());
      });
    });
  }

  int currentIndex=0;
  List<Widget> screens=[
    const FeedsScreen(),
    const AddPostScreen(),
    const MenuScreen(),
  ];
  List<String> titles=[
    'Home',
    'Add Post',
    'Menu',
  ];
  void changeBottomNavBar({
    required int index,
    BuildContext? context,
  }){
    if (index==1) {
      navigateTo(
        context: context, 
        Widget: AddPostScreen(),
      );
    }
    else{
      currentIndex=index;
      emit(ChangeBottomNavBarState());
    }
  }
  dynamic profileImage;
  var picker = ImagePicker();
  Future<void> getProfileImage()async{
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery, 
    );
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(ProfileImagePickedSuccessState());
    }else
    {
      print('No image picked');
      emit(ProfileImagePickedErrorState());
    }
  }
  dynamic coverImage;
  Future<void> getCoverImage()async{
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery
    );
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(CoverImagePickedSuccessState());
    }else
    {
      print('No image Picked');
      emit(CoverImagePickedErrorState());
    }
  }
  dynamic postImage;
  Future<void> getPostImage()async{
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery
    );
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(PostImagePickedSuccessState());
    }else
    {
      print('No image Picked');
      emit(PostImagePickedErrorState());
    }
  }
  dynamic chatImage;
  Future<void> getChatImage()async{
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery, 
    );
    if (pickedFile != null) {
      chatImage = File(pickedFile.path);
      emit(ChatImagePickedSuccessState());
    }else
    {
      print('No image picked');
      emit(ChatImagePickedErrorState());
    }
  }
  String? profileImageUrl;
  void uploadProfileImage ({
    required String name,
    required String phone,
    required String bio,
    BuildContext? context,
    Widget? screen,

  }){
    FirebaseStorage.instance
    .ref()
    .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
    .putFile(profileImage!).then((value) {
      value.ref.getDownloadURL().then((value) {
        profileImageUrl=value;
      }).then((value) {
        updateUserData(
          name: name, 
          bio: bio, 
          phone: phone,
          context: context,
          screen: screen,
        );
      });
    });
  }
  void uploadChatImage ({
    required BuildContext context,
    required Widget screen,
    required String receiverId,
    required String dateTime,
  }){
    FirebaseStorage.instance
    .ref()
    .child('chats pic/${Uri.file(chatImage!.path).pathSegments.last}')
    .putFile(chatImage!).then((value) {
      value.ref.getDownloadURL().then((value) {
        sendImage(
          receiverId: receiverId, 
          image: value, 
          dateTime: dateTime,
        );
      }).then((value) {navigateTo(
        context: context, 
        Widget: screen,
      );
      });
    });
  }
  String? coverImageUrl;
  Future<void> uploadCoverImage ({
    required String name,
    required String bio,
    required String phone,
    BuildContext? context,
    Widget? screen,
  })async{
    await FirebaseStorage.instance
    .ref()
    .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
    .putFile(coverImage!).then((value){
      value.ref.getDownloadURL()
      .then((value) {
        coverImageUrl=value;
      }).then((value){
        updateUserData(
          name: name, 
          bio: bio, 
          phone: phone,
          context: context,
          screen: screen,
        );
      });
    });
  }
  void updateUserData({
    required String name,
    required String bio,
    required String phone,
    BuildContext? context,
    Widget? screen,
  }){

    emit(UpdateUserDataLoadingState());
      UserModel model=UserModel(
      email: userModel.email,
      name: name,
      bio: bio,
      uId: userModel.uId,
      phone: phone,
      image: profileImageUrl??userModel.image,
      cover: coverImageUrl??userModel.cover,
      isVerified: userModel.isVerified,
    );
    FirebaseFirestore.instance
    .collection('users')
    .doc(userModel.uId)
    .update(model.toMap()).then((value) {
    }).then((value) {
      getUserData(uId: uId);
    }).catchError((error){
      print(error.toString());
      emit(UpdateUserDataErrorState());
    }).then((value) {
      navigateAndFinish(context: context, Widget: screen);
    });
  }
  void createPost({
    required String text,
    required String dateTime,
    String? imagePost,
    required BuildContext context,
  }){

    emit(CreatePostLoadingState());
      CreatePostModel postModel=CreatePostModel(
      name: userModel.name,
      text: text,
      uId: userModel.uId,
      dateTime: dateTime,
      image: userModel.image!,
      postImage: imagePost??'',
    );
    FirebaseFirestore.instance
    .collection('posts')
    .add(postModel.toMap()).then((value) {
      getPosts();
      getMyPosts();
      Navigator.pop(context);
    }).then((value) {
    }).catchError((error){
      print(error.toString());
      emit(CreatePostErrorState());
    }).then((value) {
    });
  }
  void createPostWithPhoto({
    required String text,
    required String dateTime,
    required BuildContext context,
  }){
    FirebaseStorage.instance
    .ref()
    .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
    .putFile(postImage!).then((value){
      value.ref.getDownloadURL().then((value) {
        createPost(
          text: text,
          dateTime: dateTime,
          context: context,
          imagePost: value,
        );
      });
    });
  }
  void closePostImage(){
    postImage=null;
    emit(ClosePostImageState());
  }
  void logOut({
    required BuildContext context,
  }){
    FirebaseAuth.instance.signOut().then((value) {
      CacheHelper.removeData(key: 'uId');
      navigateAndFinish(
        context: context, 
        Widget: LoginScreen(),
      );
    });
  }
}