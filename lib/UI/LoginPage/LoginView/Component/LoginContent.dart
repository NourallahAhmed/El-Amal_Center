
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/UI/LoginPage/ViewModel/LoginViewModel.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/HelperFunctions.dart';
import '../animations/ChangeScreenAnimation.dart';
import 'bottom_text.dart';
import 'top_text.dart';


enum Screens {
  createAccount,
  welcomeBack,
}

class Login_Content extends StatefulWidget {
  const Login_Content({Key? key}) : super(key: key);

  @override
  State<Login_Content> createState() => _Login_ContentState();
}

enum txtbutton<String>{
  SignUp,

  LogIn,

}
class _Login_ContentState extends State<Login_Content>  with TickerProviderStateMixin {
  //todo ViewModel

  var loginVM = LoginViewModel();

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var userNameController = TextEditingController();
  var passIcon = Icon(Icons.visibility_off);
  var obscure = true;
  //todo input design

  Widget inputField(String hint, IconData iconData , TextEditingController txtController , TextInputType keyType) {
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
            obscureText: keyType == TextInputType.visiblePassword ?  obscure : !obscure,
            enableSuggestions: keyType == TextInputType.visiblePassword ?  false : true,
            autocorrect: keyType == TextInputType.visiblePassword ?  false : true,
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
              suffixIcon: keyType == TextInputType.visiblePassword ?
              IconButton(onPressed: () {
                print("object");
                setState(() {
                  print(obscure);
                  obscure = !obscure;
                  print(obscure);
                });
              }, icon:  Icon( !obscure ?  Icons.visibility
                : Icons.visibility_off,)
              )  : null ,


            ),
          ),
        ),
      ),
    );
  }


  //todo button design

  Widget loginButton(txtbutton title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 135, vertical: 16),
      child: ElevatedButton(
        onPressed: () {
          if (title == txtbutton.SignUp) {


            loginVM.createAccount(emailController.text , passwordController.text );
            print(loginVM.erroeMsg);

            emailController.clear();
            userNameController.clear();
            passwordController.clear();
          }
          else {
            if(title == txtbutton.LogIn){
              loginVM.login(emailController.text , passwordController.text );
              print(loginVM.erroeMsg);


              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(loginVM.erroeMsg)));
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("No link available"),
                  ));
              emailController.clear();
              userNameController.clear();
              passwordController.clear();
            }
            else{
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
          "\t ${title.name} \t",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }


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
            onTap:() {
              print("facebook btn");
            },
            child: Image.asset('assets/images/facebook.png'),

          ),



          const SizedBox(width: 24),

          GestureDetector(

            onTap: () {
              loginVM.loginGmail();
            },
            child: Image.asset('assets/images/google.png'),
          )


        ],
      ),
    );
  }


  //todo have account
  Widget alreadyHaveAcc () {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextButton(
        onPressed: () {
          setState((){
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
  Widget createAccount () {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextButton(
        onPressed: () {
          setState((){
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

    createAccountContent = [
      inputField('Username', Icons.person_outline , userNameController , TextInputType.name),
      inputField('Email', Icons.mail_outline , emailController , TextInputType.emailAddress),
      inputField('Password', Icons.lock  , passwordController , TextInputType.visiblePassword),
      loginButton(txtbutton.SignUp),
      orDivider(),
      logos(),
      alreadyHaveAcc()


    ];

    loginContent = [
      inputField('Email', Icons.mail_outline  , emailController , TextInputType.emailAddress),
      inputField('Password', Icons.lock , passwordController , TextInputType.visiblePassword),
      loginButton(txtbutton.LogIn),
      forgotPassword(),
      createAccount()
    ];



    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return
        SingleChildScrollView(
          child: Column(
            
            
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              const SizedBox(
                height: 100,
              ),
              Text(
                isLogin
                    ? 'Create\nAccount'
                    : 'Welcome\nBack',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Column (
                children:
                    isCreate ?
                    loginContent : createAccountContent
            ),
              Text(loginVM.erroeMsg),
            ]
          ),
        );


  }
}