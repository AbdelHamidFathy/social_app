import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/profile_preview_screen.dart';
import 'package:social_app/modules/cover_preview_screen.dart';
import 'package:social_app/modules/profile_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var phoneController = TextEditingController();
    var bioController = TextEditingController();
    var model = AppCubit.get(context).userModel;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state){},
      builder: (context, state){
        nameController.text = model.name;
        phoneController.text = model.phone;
        bioController.text = '${model.bio}';
        var profileImage = AppCubit.get(context).profileImage;
        var coverImage = AppCubit.get(context).coverImage;
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0.0,
            leading: back(context),
            title: Text(
              'Edit profile',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            actions: [
              IconButton(
                onPressed: (){
                  AppCubit.get(context).updateUserData(
                    phone: phoneController.text,
                    name: nameController.text,
                    bio: bioController.text,
                    screen: const ProfileScreen(),
                    context: context,
                  );
                }, 
                icon: const Icon(
                  IconBroken.Upload,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
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
                          image: coverImage == null ? NetworkImage('${AppCubit.get(context).userModel.cover}'):
                          FileImage(coverImage)as ImageProvider,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            radius: 15.0,
                            backgroundColor: Colors.grey[300],
                            child: IconButton(
                              onPressed: (){
                                AppCubit.get(context).getCoverImage().then((value) {
                                  navigateAndFinish(context: context, Widget: CoverPreviewScreen(
                                    name: nameController.text, 
                                    bio: bioController.text, 
                                    phone: phoneController.text,
                                  ),
                                  );
                                });
                              },
                              icon: const Icon(
                                IconBroken.Camera,
                                color: Colors.black,
                                size: 15.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 53.0,
                          ),
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 50.0,
                                backgroundImage: profileImage == null ? NetworkImage('${AppCubit.get(context).userModel.image}'):
                                FileImage(profileImage)as ImageProvider,
                              ),
                              CircleAvatar(
                                radius: 15.0,
                                backgroundColor: Colors.grey[300],
                                child: IconButton(
                                  onPressed: (){
                                    AppCubit.get(context).getProfileImage().then((value) {
                                      navigateAndFinish(context: context, Widget: ProfilePreviewScreen(
                                        name: nameController.text,
                                        phone: phoneController.text,
                                        bio: bioController.text,
                                      ));
                                    });
                                  }, 
                                  icon: const Icon(
                                    IconBroken.Camera,
                                    size: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Form(
                    child: Column(
                      children: [
                        textField(
                          controller: nameController, 
                          labelText: 'Name', 
                          prefixIcon: IconBroken.User,
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        textField(
                          controller: phoneController, 
                          labelText: 'Phone', 
                          prefixIcon: IconBroken.Call,
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        textField(
                          controller: bioController, 
                          labelText: 'Bio', 
                          prefixIcon: IconBroken.Document
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
  Widget textField({
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
    required IconData prefixIcon,
  }){
    return TextFormField(
      controller: controller,
      cursorColor: defaultColor,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: Colors.grey,
        ),
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.grey
        ),
      ),
      validator: validator,
    );
  }
}