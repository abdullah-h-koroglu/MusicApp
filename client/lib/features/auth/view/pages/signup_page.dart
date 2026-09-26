import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/auth/view/pages/login_page.dart';
import 'package:client/features/auth/view/pages/widgets/auth_gradient_button.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final isLoading = ref.watch(authViewModelProvider.select((val) => val?.isLoading)) == true;
    
    ref.listen(authViewModelProvider, (_,next){
      next?.when(
        data: (data ){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Account created successfully"))
          );
          Navigator.push(context, MaterialPageRoute(builder: (constext) => const LoginPage()));
        },
        error: (error,st) {
          showSnackBar(context, error.toString());
        },
        loading: () {

        }
        );
    });

    return Scaffold(
      appBar: AppBar(),
      body: isLoading ? const Loader()
      : Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Sign up",style: TextStyle(fontSize: 50,fontWeight: FontWeight.w500)),
             CustomField(hintText: "Name", controller: nameController),
             SizedBox(height: 30),
             CustomField(hintText: "Email",controller: emailController),
             SizedBox(height: 30),
             CustomField(hintText: "Password",controller: passwordController,isObsecureText: true),
             SizedBox(height: 30),
             AuthGradientButton(
              buttonText: "Sign Up",
              onTap: () async {
                if(formKey.currentState!.validate()) {
                  await ref.read(
                    authViewModelProvider.notifier)
                      .signUpUser(
                        email: emailController.text, 
                        password: passwordController.text,
                        username: nameController.text
                    );
                }else{
                  showSnackBar(context, "Please fill all fields");
                }
              },
             ),
             SizedBox(height: 20),
             GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              child:RichText(text: TextSpan(
              text: "Already have an account? ",
              style: Theme.of(context).textTheme.titleMedium,
              children: [
                TextSpan(text: "Sign In",
                style: TextStyle(color: Pallete.gradient2,fontWeight: FontWeight.bold))
              ]
             ))
             )
            ],
          ),
        ),
      ),
    );
  }
}