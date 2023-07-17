import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habittracker/services/authservice.dart';
import '../authentication_utils/my_button.dart';
import '../authentication_utils/my_textfield.dart';
import '../authentication_utils/square_tile.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, @required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailnameController = TextEditingController();

  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() async {
    //show a loading circle
    showDialog(context: context, builder: (context) {
      return Center(child: CircularProgressIndicator(),);
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailnameController.text, password: passwordController.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch(e)
    {
      Navigator.pop(context);
      if(e.code == "user-not-found"){
        WrongEmailMessage();
      }
      else{
        WrongPasswordMessage();
      }
    }

  }

  void WrongEmailMessage(){
    showDialog(context: context, builder: (context) {

     return  Center(
       child: AlertDialog(
         backgroundColor: Colors.grey.shade200,
          title: Center(child: Text("Incorrect Email")),
        ),
     );
    });
  }

  void WrongPasswordMessage(){
    showDialog(context: context, builder: (context)
    {
      return Center(
        child: AlertDialog(
          backgroundColor: Colors.grey.shade200,
          title: Center(child: Text("Incorrect Password")),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [Colors.green.shade50, Colors.green.shade300])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: PageScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),

                  // logo
                   Image.asset("assets/images/Profile.gif",scale: 4,),

                  const SizedBox(height: 30),

                  // welcome back, you've been missed!
                  Text(
                    'Welcome back you\'ve been missed!',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // username textfield
                  MyTextField(
                    controller: emailnameController,
                    hintText: 'Username',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // password textfield
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  // forgot password?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // sign in button
                  Mybutton(
                    onTap: signUserIn,
                    text: "Sign In",
                  ),

                  const SizedBox(height: 50),

                  // or continue with
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or continue with',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  // google + apple sign in buttons
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // google button
                      SquareTile(imagePath: 'assets/images/google.png',onTap: () => AuthService().signINWIthGoogle(),),

                      SizedBox(width: 25),

                      // apple button
                      SquareTile(imagePath: 'assets/images/apple.png',onTap: () => AuthService().signINWIthGoogle(),)
                    ],
                  ),

                  const SizedBox(height: 50),

                  // not a member? register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Register now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
