import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/register/cubit/register_states.dart';
import 'package:social_app/shared/components/constants.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context)=>BlocProvider.of(context);

  bool isPass=true;

  void showPass(){
    isPass=!isPass;
    emit(RegisterChangePasswordVisibilityState());
  }

  void register({
    required String email,
    required String password,
    required String name,
    required String phone,
  }){
    emit(RegisterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email, 
      password: password,
    ).then((value) {
      createUser(
        name: name, 
        email: email, 
        phone: phone, 
        uId: value.user!.uid,
        isVerified: false,
        image: 'https://image.freepik.com/photos-gratuite/portrait-jeune-homme-africain-gai_171337-8907.jpg',
        bio: 'Write your bio',
        cover: 'https://image.freepik.com/photos-gratuite/portrait-jeune-homme-africain-gai_171337-8907.jpg',
      );
      emit(RegisterSuccessState(value.user!.uid));
    }).catchError((error){
      print(error.toString());
      emit(RegisterErrorState(error.toString()));
    });
  }
  void createUser ({
    required String name,
    required String email,
    required String phone,
    required String uId,
    required bool isVerified,
    required String image,
    required String cover,
    required String bio,
  }){
    UserModel model=UserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      isVerified: isVerified,
      image: image,
      cover: cover,
      bio: bio,
    );
    FirebaseFirestore.instance.collection('users').doc(uId).set(model.toMap()).then(
      (value) {
        emit(CreateUserSuccessState());
      }
    ).catchError((error){
      print(error.toString());
      emit(CreateUserErrorState(error));
    });
  }
}