import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../authentication_utils/my_button.dart';
import '../authentication_utils/my_textfield.dart';
import '../authentication_utils/square_tile.dart';
import '../services/authservice.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  RegisterPage({super.key, @required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final emailnameController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmpasswordController = TextEditingController();

  // sign user in method
  void signUserUp() async {
    //show a loading circle

    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      if (passwordController.text == confirmpasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailnameController.text, password: passwordController.text);
          Navigator.pop(context);
      }
      else
        {
         // Navigator.pop(context);
          WrongConfirmPasswordMessage();
        }

    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == "user-not-found") {
        WrongEmailMessage();
      } else {
        WrongPasswordMessage();
      }
    }
  }

  void WrongEmailMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: AlertDialog(
              backgroundColor: Colors.grey.shade200,
              title: Center(child: Text("Incorrect Email")),
            ),
          );
        });
  }

  void WrongConfirmPasswordMessage(){
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: AlertDialog(
              backgroundColor: Colors.grey.shade200,
              title: Center(child: Text("Password\'s Mismatch")),
            ),
          );
        });
  }

  void WrongPasswordMessage() {
    showDialog(
        context: context,
        builder: (context) {
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
                  const SizedBox(height: 40),

                  // logo
                Image.asset("assets/images/Profile.gif",scale: 4,),


                  const SizedBox(height: 25),

                  // welcome back, you've been missed!
                  Text(
                    'Let\'s create your account!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
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

                  // password textfield
                  MyTextField(
                    controller: confirmpasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 25),

                  // sign in button
                  Mybutton(
                    onTap: signUserUp,
                    text: "Sign Up",
                  ),

                  const SizedBox(height: 30),

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

                  const SizedBox(height: 30),

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
                        'Already a member?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Login',
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
