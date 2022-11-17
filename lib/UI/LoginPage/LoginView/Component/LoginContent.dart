import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:untitled/UI/LoginPage/ViewModel/LoginViewModel.dart';
import 'package:untitled/utils/Shared.dart';
import '../../../../Services/PushNotifictionServices.dart';
import '../../../../utils/Constants.dart';
import '../../../HomePage/View/home_screen.dart';
import '../../../PatientScreens/AddingClient/View/Component/InputFeild.dart';

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

  var result = "";

  //todo input design


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

  Widget forgotPassword( LoginViewModel provider) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextButton(
        onPressed: () {

          provider.forgetPassword();
        },
        child:  Text(
          'Forgot Password?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Constants.kSecondaryColor,
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
              color: Constants.kPrimaryColor,
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
              color: Constants.kPrimaryColor,
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
        child:  Text(
          'Already have account',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Constants.kSecondaryColor,
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
        child:  Text(
          'Create account',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Constants.kSecondaryColor,
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


    createAccountContent = [
      InputFeild(  label: 'Username', iconData: Icons.person_outline,
        keyType:TextInputType.name, txtController: userNameController , hint: "name" ),
      InputFeild( label: 'Email', iconData: Icons.mail_outline, txtController: emailController,
          keyType:TextInputType.emailAddress ,  hint: "name@elamalcenter.com"),
      InputFeild( label: 'Password', iconData:Icons.lock, txtController: passwordController,
          keyType:TextInputType.visiblePassword,hint: '*******',),


    ];
    loginContent = [
      InputFeild( label: 'Email', iconData: Icons.mail_outline, txtController: emailController,
        keyType: TextInputType.emailAddress , hint: "name@elamalcenter.com"),
      InputFeild( label: 'Password', iconData: Icons.lock,txtController: passwordController,
          keyType:TextInputType.visiblePassword, hint: '*******',),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<LoginViewModel>(builder: (context ,provider , child)  {
        return

          SingleChildScrollView(
            child: Column(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
              const SizedBox(
                height: 200,
              ),

             const  Text(
                'Welcome Back',
                style:  TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(
                height: 50,
              ),

              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:  loginContent ),


              //MARK Button
             Column(
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 135, vertical: 16),
                    child: ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: const StadiumBorder(),
                        primary: Constants.kSecondaryColor,
                        elevation: 8,
                        shadowColor: Colors.black87,
                      ),
                      child:  Text(
                         "\t ${txtbutton.LogIn.name} \t",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),


             Column(
                children:  [
                  forgotPassword(provider),
                ]
              ) ,


              //todo error
              Text(Provider.of<LoginViewModel>(context , listen: false).erroeMsg , style:  TextStyle(
                color: Constants.errorColor,
                fontSize: 15,

              ),),
            ]),
          );

      }
      );
  }




  login() async {
    if (emailController.text.isNotEmpty &
    passwordController.text.isNotEmpty) {
      //Send to firebase Auth
      await Provider.of<LoginViewModel>(context , listen: false).login(
          emailController.text,
          passwordController.text);

      var check = Provider.of<LoginViewModel>(context , listen: false).check ;


      //todo check on the error and  stored data
      if (check) {

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
          shape:  StadiumBorder(),
          primary: Constants.kSecondaryColor,
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

