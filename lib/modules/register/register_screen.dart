import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_layout.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/modules/register/cubit/register_cubit.dart';
import 'package:social_app/modules/register/cubit/register_states.dart';
import 'package:social_app/network/local/cache_helper.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var nameController =TextEditingController();
    var emailController =TextEditingController();
    var phoneController =TextEditingController();
    var passwordController =TextEditingController();
    var confirmPasswordController =TextEditingController();
    var formKey =GlobalKey<FormState>();
    return BlocProvider(
      create: (context)=>RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state){
          if (state is RegisterSuccessState) {
              navigateAndFinish(
                context: context, 
                Widget: const LoginScreen(),
              );
          }
        },
        builder:(context, state)=> Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    }, 
                    icon: const Icon(
                      IconBroken.Arrow___Left_2,
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: 
                        [
                          Text(
                            'REGISTER',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: /* RegisterCubit.get(context).isDark ? Colors.white :  */Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          const Text(
                            'Complete your details',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              underLine(
                                width: 120.0,
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              underLine(
                                width: 30.0
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          defaultTextForm(
                            context: context,
                            keyboardType: TextInputType.name, 
                            preIcon: IconBroken.User, 
                            hint: 'Name', 
                            controller: nameController, 
                            validate: (value){
                              if (value!.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            }
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          defaultTextForm(
                            context: context,
                            keyboardType: TextInputType.emailAddress, 
                            preIcon: IconBroken.Message, 
                            hint: 'Email', 
                            controller: emailController, 
                            validate: (value){
                              if (value!.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          defaultTextForm(
                            context: context,
                            keyboardType: TextInputType.phone, 
                            preIcon: IconBroken.Call, 
                            hint: 'Phone', 
                            controller: phoneController, 
                            validate: (value){
                              if (value!.isEmpty) {
                                return 'Please enter your phone';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          defaultTextForm(
                            context: context,
                            isPassword: RegisterCubit.get(context).isPass,
                            keyboardType: TextInputType.visiblePassword, 
                            preIcon: IconBroken.Lock, 
                            sufIcon: RegisterCubit.get(context).isPass ? IconBroken.Show :
                            IconBroken.Hide,
                            suffixOnPressed: (){
                              RegisterCubit.get(context).showPass();
                            },
                            hint: 'Password', 
                            controller: passwordController, 
                            validate: (value){
                              if (value!.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          defaultTextForm(
                            isPassword: RegisterCubit.get(context).isPass,
                            hint: 'Confirm password',
                            context: context, 
                            keyboardType: TextInputType.visiblePassword, 
                            preIcon: IconBroken.Lock, 
                            sufIcon: RegisterCubit.get(context).isPass ? IconBroken.Show :
                            IconBroken.Hide,
                            suffixOnPressed: (){
                              RegisterCubit.get(context).showPass();
                            },
                            controller: confirmPasswordController, 
                            validate: (value){
                              if (value!.isEmpty) {
                                return 'Please enter your password';
                              }/* else if(value!=passwordController){
                                return 'Password doesn\'t matched';
                              } */return null;
                            },
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          ConditionalBuilder(
                            condition: state is! RegisterLoadingState,
                            builder:(context)=> defaultButton(
                              text: 'register', 
                              onPressed: (){
                                if (formKey.currentState!.validate()) {
                                  RegisterCubit.get(context).register(
                                    name: nameController.text, 
                                    email: emailController.text, 
                                    phone: phoneController.text, 
                                    password: passwordController.text,
                                  );
                                }
                              },
                            ),
                            fallback: (context)=> const Center(child: CircularProgressIndicator(color: defaultColor),),
                          ),  
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}