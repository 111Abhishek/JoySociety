import 'package:flutter/material.dart';
import 'package:joy_society/data/model/body/login_model.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/localization/language_constants.dart';
import 'package:joy_society/provider/auth_provider.dart';
import 'package:joy_society/provider/splash_provider.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/dimensions.dart';
import 'package:joy_society/view/basewidget/button/custom_button.dart';
import 'package:joy_society/view/basewidget/textfield/custom_password_textfield.dart';
import 'package:joy_society/view/basewidget/textfield/custom_textfield.dart';
import 'package:joy_society/view/screen/auth/forget_password_screen.dart';
import 'package:joy_society/view/screen/auth/sign_up_screen.dart';
import 'package:joy_society/view/screen/auth/widget/mobile_verify_screen.dart';
import 'package:joy_society/view/screen/auth/widget/social_login_widget.dart';
import 'package:joy_society/view/screen/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'otp_verification_screen.dart';

class SignInWidget extends StatefulWidget {
  @override
  _SignInWidgetState createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  late GlobalKey<FormState> _formKeyLogin;

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailController?.text = Provider.of<AuthProvider>(context, listen: false).getUserEmail();
    _passwordController?.text = Provider.of<AuthProvider>(context, listen: false).getUserPassword();
  }

  @override
  void dispose() {
    _emailController?.dispose();
    _passwordController?.dispose();
    super.dispose();
  }

  FocusNode _emailNode = FocusNode();
  FocusNode _passNode = FocusNode();
  LoginModel loginBody = LoginModel();

  void loginUser() async {
    /*Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => DashBoardScreen()),
            (route) => false);*/

    if (_formKeyLogin.currentState!.validate()) {
      _formKeyLogin.currentState?.save();

      String _email = _emailController!.text.trim();
      String _password = _passwordController!.text.trim();

      if (_email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(getTranslated('EMAIL_MUST_BE_REQUIRED', context)),
          backgroundColor: Colors.red,
        ));
      } else if (_password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(getTranslated('PASSWORD_MUST_BE_REQUIRED', context)),
          backgroundColor: Colors.red,
        ));
      } else {

        if (Provider.of<AuthProvider>(context, listen: false).isRemember) {
          Provider.of<AuthProvider>(context, listen: false).saveUserEmail(_email, _password);
        } else {
          Provider.of<AuthProvider>(context, listen: false).clearUserEmailAndPassword();
        }

        loginBody.username = _email;
        loginBody.password = _password;
        await Provider.of<AuthProvider>(context, listen: false).login(loginBody, route);
      }
    }
  }

  route(bool isRoute, String token, String temporaryToken, ErrorResponse? errorResponse) async {
    if (isRoute) {
      if(token==null || token.isEmpty){
        /*if(Provider.of<SplashProvider>(context,listen: false).configModel!.emailVerification!){
          Provider.of<AuthProvider>(context, listen: false).checkEmail(_emailController!.text.toString(),
              temporaryToken).then((value) async {
            if (value.isSuccess!) {
              Provider.of<AuthProvider>(context, listen: false).updateEmail(_emailController!.text.toString());
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => VerificationScreen(
                  temporaryToken,'',_emailController!.text.toString())), (route) => false);

            }
          });
        }else if(Provider.of<SplashProvider>(context,listen: false).configModel!.phoneVerification!){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MobileVerificationScreen(
              temporaryToken)), (route) => false);
        }*/
      }
      else{
        //await Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => DashBoardScreen()), (route) => false);
      }
    } else {
      String? errorDescription = errorResponse?.errorDescription;
      if(errorResponse?.non_field_errors != null) {
        errorDescription = errorResponse?.non_field_errors![0];
      } else {
        if (errorDescription == null) {
          dynamic usernameError = errorResponse?.errorJson["username"];
          dynamic passwordError = errorResponse?.errorJson["password"];

          if (usernameError != null && usernameError.length > 0) {
            errorDescription = usernameError![0]!;
          } else if (passwordError != null && passwordError.length > 0) {
            errorDescription = passwordError![0]!;
          } else {
            errorDescription = 'Technical error, Please try again later!';
          }
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorDescription!), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false).isRemember;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.MARGIN_SIZE_LARGE),
      child: Form(
        key: _formKeyLogin,
        child: Column(
          children: [
            SizedBox(height: 34),

            Center(child: Text(getTranslated('LOG_IN', context),
                style: poppinsBold.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE))),

            SizedBox(height: 27),

            // for Email
            Container(
                margin: EdgeInsets.only(bottom: Dimensions.MARGIN_SIZE_SMALL),
                child: CustomTextField(
                  hintText: getTranslated('EMAIL_OR_MOBILE_NUMBER', context),
                  focusNode: _emailNode,
                  nextNode: _passNode,
                  textInputType: TextInputType.emailAddress,
                  controller: _emailController,
                )),

            // for Password
            Container(
                margin:
                EdgeInsets.only(bottom: Dimensions.MARGIN_SIZE_DEFAULT),
                child: CustomPasswordTextField(
                  hintTxt: getTranslated('PASSWORD', context),
                  textInputAction: TextInputAction.done,
                  focusNode: _passNode,
                  controller: _passwordController,
                )),

            // for remember and forgetpassword
            Container(
              margin: EdgeInsets.only(right: Dimensions.MARGIN_SIZE_SMALL),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible: false,
                    child: Row(
                      children: [
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) => Checkbox(
                            checkColor: ColorResources.WHITE,
                            activeColor: Theme.of(context).primaryColor,
                            value: authProvider.isRemember,
                            onChanged: authProvider.updateRemember,
                          ),
                        ),

                        Text(getTranslated('REMEMBER', context), style: titilliumRegular),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ForgetPasswordScreen())),
                    child: Text(getTranslated('FORGOT_PASSWORD?', context), style: poppinsRegular.copyWith(
                        color: ColorResources.getTextGrey(context), fontSize: Dimensions.FONT_SIZE_LARGE)),
                  ),
                ],
              ),
            ),

            // for signin button
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 30),
              child: Provider.of<AuthProvider>(context).isLoading
                  ? Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              )
                  : CustomButton(onTap: loginUser, buttonText: getTranslated('SUBMIT', context)),
            ),

            SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_LARGE),

            Center(child: Text(getTranslated('OR', context),
                style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE))),

            //SocialLoginWidget(),

            SizedBox(width: 20),

            //for order as guest
            GestureDetector(
              onTap: () {
                if (!Provider.of<AuthProvider>(context, listen: false).isLoading) {
                  //Provider.of<CartProvider>(context, listen: false).getCartData();
                  /*Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => DashBoardScreen()),
                          (route) => false);*/
                  Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpScreen()));
                }
              },
              child: Container(
                width: double.infinity,
                height: 40,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(getTranslated('NOT_A_MEMBER', context),
                        style: poppinsRegular.copyWith(color: ColorResources.BLACK, fontSize: Dimensions.FONT_SIZE_LARGE)),
                    Text(getTranslated('CREATE_ACCOUNT', context),
                        style: poppinsBold.copyWith(color: ColorResources.DASHBOARD_BOTTOM_BAR_COLOR, fontSize: Dimensions.FONT_SIZE_LARGE)),

                  ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
