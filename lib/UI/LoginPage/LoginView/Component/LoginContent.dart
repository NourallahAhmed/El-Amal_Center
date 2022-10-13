import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/UI/HomePage/View/Component/HomePage.dart';
import 'package:untitled/UI/LoginPage/ViewModel/LoginViewModel.dart';
import 'package:untitled/utils/Shared.dart';
import '../../../../Services/PushNotifictionServices.dart';
import '../../../../utils/constants.dart';
import '../../../HomePage/View/homeScreen.dart';

enum Screens {
  createAccount,
  welcomeBack,
}

class Login_Content extends StatefulWidget {
  const Login_Content({Key? key}) : super(key: key);

  @override
  State<Login_Content> createState() => _Login_ContentState();
}

enum txtbutton<String> {
  SignUp,
  LogIn,
}

class _Login_ContentState extends State<Login_Content>
    with TickerProviderStateMixin {
  //todo ViewModel
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var userNameController = TextEditingController();
  var passIcon = Icon(Icons.visibility_off);
  var obscure = true;
  var isStored = false;

  var result = "";

  //todo input design

  Widget inputField(String hint, IconData iconData,
      TextEditingController txtController, TextInputType keyType) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
      child: SizedBox(
        height: 50,
        child: Material(
          elevation: 8,
          shadowColor: Colors.black87,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: TextField(
            keyboardType: keyType,
            controller: txtController,
            obscureText:
                keyType == TextInputType.visiblePassword ? obscure : !obscure,
            enableSuggestions:
                keyType == TextInputType.visiblePassword ? false : true,
            autocorrect:
                keyType == TextInputType.visiblePassword ? false : true,
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: hint,
              prefixIcon: Icon(iconData),
              suffixIcon: keyType == TextInputType.visiblePassword
                  ? IconButton(
                      onPressed: () {
                        print("object");
                        setState(() {
                          print(obscure);
                          obscure = !obscure;
                          print(obscure);
                        });
                      },
                      icon: Icon(
                        !obscure ? Icons.visibility : Icons.visibility_off,
                      ))
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  //todo button design

  // Widget loginButton(txtbutton title ) {
  //   return
  //     Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 135, vertical: 16),
  //       child: ElevatedButton(
  //         onPressed: () async {
  //           //todo SignUP
  //           if (title == txtbutton.SignUp) {
  //             if (emailController.text.isNotEmpty  & passwordController.text.isNotEmpty){
  //               var check = await loginVM.createAccount(emailController.text , passwordController.text );
  //               if (check) {
  //                 Navigator.pushReplacement(context,  MaterialPageRoute(
  //                     builder: (context) => const HomePageScreen()));
  //                 emailController.clear();
  //                 userNameController.clear();
  //                 passwordController.clear();
  //               }
  //             }
  //           }
  //
  //           //todo Login
  //           else {
  //             //MARK : already have an account
  //             if(title == txtbutton.LogIn){
  //               // not Empty
  //               print("to Login");
  //               if (emailController.text.isNotEmpty & passwordController.text.isNotEmpty) {
  //                 //Send to firebase Auth
  //                 var check = await loginVM.login(
  //                     emailController.text, passwordController.text);
  //
  //                 //todo check on the error and  stored data
  //                 if (check){
  //                   Navigator.pushReplacement(
  //                       context,
  //                       MaterialPageRoute(
  //                           builder: (context) => const HomePageScreen()));
  //                 }
  //                 emailController.clear();
  //                 userNameController.clear();
  //                 passwordController.clear();
  //
  //
  //               }
  //               // });
  //
  //             }
  //             else{
  //               print("nothing");
  //             }
  //           }
  //         },
  //         style: ElevatedButton.styleFrom(
  //           padding: const EdgeInsets.symmetric(vertical: 14),
  //           shape: const StadiumBorder(),
  //           primary: kSecondaryColor,
  //           elevation: 8,
  //           shadowColor: Colors.black87,
  //         ),
  //         child: Text(
  //           "\t ${title.name} \t",
  //           style: const TextStyle(
  //             fontSize: 18,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ),
  //     );
  // }

  //todo forget password

  Widget forgotPassword() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextButton(
        onPressed: () {},
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kSecondaryColor,
          ),
        ),
      ),
    );
  }

  //todo Divider
  Widget orDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 8),
      child: Row(
        children: [
          Flexible(
            child: Container(
              height: 1,
              color: kPrimaryColor,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'or',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(
            child: Container(
              height: 1,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  //todo fb and google logos

  Widget logos() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              print("facebook btn");
            },
            child: Image.asset('assets/images/facebook.png'),
          ),
          const SizedBox(width: 24),
          GestureDetector(
            onTap: () {
              // loginVM.loginGmail();
            },
            child: Image.asset('assets/images/google.png'),
          )
        ],
      ),
    );
  }

  //todo have account
  Widget alreadyHaveAcc() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextButton(
        onPressed: () {
          setState(() {
            isLogin ? isLogin = false : isLogin = true;
            isCreate ? isCreate = false : isCreate = true;
          });
        },
        child: const Text(
          'Already have account',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kSecondaryColor,
          ),
        ),
      ),
    );
  }

  //todo create account
  Widget createAccount() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextButton(
        onPressed: () {
          setState(() {
            isLogin ? isLogin = false : isLogin = true;
            isCreate ? isCreate = false : isCreate = true;
          });
        },
        child: const Text(
          'Create account',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kSecondaryColor,
          ),
        ),
      ),
    );
  }

  late final List<Widget> createAccountContent;
  late final List<Widget> loginContent;

  var isLogin = true;
  var isCreate = false;

  @override
  initState() {
    isStored = Provider.of<LoginViewModel>(context, listen: false).IsStored();

    createAccountContent = [
      inputField('Username', Icons.person_outline, userNameController,
          TextInputType.name),
      inputField('Email', Icons.mail_outline, emailController,
          TextInputType.emailAddress),
      inputField('Password', Icons.lock, passwordController,
          TextInputType.visiblePassword),


    ];
    loginContent = [
      inputField('Email', Icons.mail_outline, emailController,
          TextInputType.emailAddress),
      inputField('Password', Icons.lock, passwordController,
          TextInputType.visiblePassword),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("from build ${isStored}");
    return Consumer<LoginViewModel>(builder: (context ,provider , child)  {
        return

          SingleChildScrollView(
            child: Column(children: [
              const SizedBox(
                height: 100,
              ),

              Text(
                isLogin ? 'Create\nAccount' : 'Welcome\nBack',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(
                height: 50,
              ),

              Column(children: isCreate ? loginContent : createAccountContent),

              Column(
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 135, vertical: 16),
                    child: ElevatedButton(
                      onPressed: () async {
                        //todo SignUP
                        if (isCreate  == false) {
                          if (emailController.text.isNotEmpty &
                          passwordController.text.isNotEmpty) {
                            var check = await Provider.of<LoginViewModel>(context , listen: false).createAccount(
                                emailController.text, passwordController.text);
                            if (check) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (
                                          context) => const HomePageScreen()));
                              emailController.clear();
                              userNameController.clear();
                              passwordController.clear();
                            }
                          }
                        }

                        //todo Login
                        else {
                          //MARK : already have an account
                          if (isCreate) {
                            // not Empty
                            print("to Login");
                            if (emailController.text.isNotEmpty &
                            passwordController.text.isNotEmpty) {
                              //Send to firebase Auth
                              var check = await Provider.of<LoginViewModel>(context , listen: false).login(
                                  emailController.text,
                                  passwordController.text);

                              //todo check on the error and  stored data
                              if (Provider.of<LoginViewModel>(context , listen: false).check) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const HomePageScreen()));
                              }
                              emailController.clear();
                              userNameController.clear();
                              passwordController.clear();
                            }
                            // });

                          } else {
                            print("nothing");
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: const StadiumBorder(),
                        primary: kSecondaryColor,
                        elevation: 8,
                        shadowColor: Colors.black87,
                      ),
                      child:  Text(
                        isCreate ? "\t ${txtbutton.LogIn.name} \t" : "\t ${txtbutton.SignUp.name} \t",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),

              isCreate ?
              Column(
                children:  [ forgotPassword(), createAccount()]
              ) :  Column(
                  children:  [  orDivider(),
                    logos(),
                    alreadyHaveAcc()]
              ),


              //todo error
              CustomWidget(result: result),
            ]),
          );

      }
      );
  }
}

class LogoButtons extends StatelessWidget {
  const LogoButtons({
    Key? key,
    required this.loginVM,
    required this.emailController,
    required this.passwordController,
    required this.context,
    required this.userNameController,
    required this.title,
  }) : super(key: key);

  final LoginViewModel loginVM;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final BuildContext context;
  final TextEditingController userNameController;
  final String title;

  initState() {
    PNServices.initInfo();
  }

  @override
  Widget build(BuildContext context) {
    print("in Loginbuttons Class");
    print(loginVM.isStored);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 135, vertical: 16),
      child: ElevatedButton(
        onPressed: () async {
          //todo SignUP
          if (title == txtbutton.SignUp.name) {
            print("signup");
            loginVM.createAccount(
                emailController.text, passwordController.text);

            if (emailController.text.isNotEmpty &
                passwordController.text.isNotEmpty) {
              print(" in delayed ${loginVM.isStored}");
              print(loginVM.isStored);

              if (loginVM.isStored) {
                print(SharedPref.email);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomePageScreen()));
                emailController.clear();
                userNameController.clear();
                passwordController.clear();
              }
            }
          }

          //todo Login
          else {
            //MARK : already have an account
            if (title == txtbutton.LogIn.name) {
              // not Empty
              print("to Login");
              if (emailController.text.isNotEmpty &
                  passwordController.text.isNotEmpty) {
                //Send to firebase Auth
                var check = await loginVM.login(
                    emailController.text, passwordController.text);

                //todo check on the error and  stored data
                if (check) {
                  //todo we need token and  title and  body for sending notification
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePageScreen()));
                }
                emailController.clear();
                userNameController.clear();
                passwordController.clear();
              }
              // });

            } else {
              print("nothing");
            }
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: const StadiumBorder(),
          primary: kSecondaryColor,
          elevation: 8,
          shadowColor: Colors.black87,
        ),
        child: Text(
          "\t ${title} \t",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class CustomWidget extends StatelessWidget {
  const CustomWidget({
    Key? key,
    required this.result,
  }) : super(key: key);

  final String result;

  @override
  Widget build(BuildContext context) {
    return Text(result);
  }
}
