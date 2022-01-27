import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_layout.dart';
import 'package:social_app/modules/feeds_screen.dart';
import 'package:social_app/modules/login/cubit/login_cubit.dart';
import 'package:social_app/modules/login/cubit/login_states.dart';
import 'package:social_app/modules/register/register_screen.dart';
import 'package:social_app/network/local/cache_helper.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({ Key? key }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    var formKey=GlobalKey<FormState>();
    var emailController =TextEditingController();
    var passwordController=TextEditingController();
    return BlocProvider(
      create: (context)=>LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state){
          if (state is LoginSuccessState) {
            CacheHelper.saveData(key: 'uId',value: state.uId).then((value){
              AppCubit.get(context).getUserData(uId: state.uId);
              navigateAndFinish(
                context: context, 
                Widget: HomeLayout(),
              );
            });
          }else if (state is LoginErrorState) {
            toast(
              msg: state.error, 
              state: ToastStates.ERROR,
            );
          }
        },
        builder: (context, state){
          return Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                      const Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 36.0,
                          fontWeight: FontWeight.bold,
                          color: /* AppCubit.get(context).isDark ? Colors.white : */ Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const Text(
                        'Login to your account',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          underLine(width: 140.0),
                          const SizedBox(
                            width: 5.0,
                          ),
                          underLine(width: 30),
                        ],
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      defaultTextForm(
                        context: context,
                        controller: emailController,
                        validate: (value){
                          if (value!.isEmpty) {
                              return 'Please enter your email';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress, 
                        preIcon: IconBroken.Message, 
                        hint: 'Email',
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      defaultTextForm(
                        context: context,
                        onSubmitted: (value){
                          if (formKey.currentState!.validate()) {
                            LoginCubit.get(context).login(
                              email: emailController.text, 
                              password: passwordController.text,
                            );
                          }
                        },
                        controller: passwordController,
                        validate: (value){
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          }  
                          return null;
                        },
                        sufIcon:LoginCubit.get(context).isPass? IconBroken.Show : 
                        IconBroken.Hide,
                        suffixOnPressed: (){
                          LoginCubit.get(context).showPass();
                        },
                        isPassword: LoginCubit.get(context).isPass,
                        keyboardType: TextInputType.visiblePassword, 
                        preIcon: IconBroken.Password, 
                        hint: 'Password',
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      ConditionalBuilder(
                        condition: state is! LoginLoadingState, 
                        builder: (context)=>
                        defaultButton(
                          text: 'login', 
                          onPressed: (){
                            if (formKey.currentState!.validate()) {
                              LoginCubit.get(context).login(
                                email: emailController.text, 
                                password: passwordController.text,
                              );
                            }
                          },
                        ), 
                        fallback: (context)=>const Center(child: CircularProgressIndicator(color: defaultColor,)),
                      ),
                        const SizedBox(
                          height: 50.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                            [
                              defaultTextButton(
                                text: 'register'.toUpperCase(), 
                                onPressed: (){
                                  navigateTo(context: context ,Widget: const RegisterScreen());
                                },
                              ),
                              const Text(
                                'If you don\'t have an account',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}