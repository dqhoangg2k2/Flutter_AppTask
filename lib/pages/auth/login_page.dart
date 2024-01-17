import 'package:flutter/material.dart';
import 'package:task_api_adv/components/button/td_elevated_button.dart';
import 'package:task_api_adv/components/snack_bar/td_snack_bar.dart';
import 'package:task_api_adv/components/snack_bar/top_snack_bar.dart';
import 'package:task_api_adv/components/text_field/td_text_field.dart';
import 'package:task_api_adv/components/text_field/td_text_field_password.dart';
import 'package:task_api_adv/gen/assets.gen.dart';
import 'package:task_api_adv/pages/auth/forgot_password_page.dart';
import 'package:task_api_adv/pages/auth/register_page.dart';
import 'package:task_api_adv/pages/main_page.dart';
import 'package:task_api_adv/resources/app_color.dart';
import 'package:task_api_adv/services/remote/auth_services.dart';
import 'package:task_api_adv/services/remote/body/login_body.dart';
import 'package:task_api_adv/utils/validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.email});

  final String? email;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthServices authServices = AuthServices();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;// cái quay quay khi nhấn nút login , truyền email khi đk thôi , còn thì ko có email

  @override
  void initState() {
    super.initState();
    emailController.text = widget.email ?? '';
    // hiện ra email đã đk rồi trên giao diện luôn
    //// hiện ra khi có rồi , ko có thì để rỗng
    ///// khi logout quay lại trang lgin để rỗng
  }

  Future<void> _submitLogin() async {
    if (formKey.currentState!.validate() == false) {
       // email , password nếu sai
      //nếu sai validator , ko chạy mấy cái dưới
      return; //retrurn thoát method ( ko làm gì )   return ko chạy dưới
    }

    setState(() => isLoading = true);  // do gọi api  bấm vào nút xoay
    await Future.delayed(const Duration(milliseconds: 1200));

    LoginBody body = LoginBody() // gọi method  LoginBody ko tham số ,
      ..email = emailController.text.trim()  // rồi thêm thuộc tính tương tác người dùng
      ..password = passwordController.text;

    authServices.login(body).then((_) {  // xét chức năng bên kia rồi 
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const MainPage(
            title: 'Tasks',
          ),
        ),
        (Route<dynamic> route) => false,
      );
    }).catchError((onError) {
      String? error = onError.message;
      showTopSnackBar(
        context,
        TDSnackBar.error(
          message: error ?? 'Server error 😐',
        ),
      );
      setState(() => isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0).copyWith(
                top: MediaQuery.of(context).padding.top + 38.0, bottom: 16.0),
            children: [
              const Center(
                child: Text(
                  'Sign in',
                  style: TextStyle(color: AppColor.red, fontSize: 26.0),
                ),
              ),
              const SizedBox(height: 32.0),
              Center(
                child: Image.asset(Assets.images.todoIcon.path,
                    width: 90.0, fit: BoxFit.cover),
              ),
              const SizedBox(height: 36.0),
              TdTextField(
                controller: emailController,
                hintText: 'Email',
                prefixIcon: const Icon(Icons.email, color: Colors.orange),
                validator: Validator.emailValidator,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20.0),
              TdTextFieldPassword(
                controller: passwordController,
                hintText: 'Password',
                validator: Validator.passwordValidator,
                onFieldSubmitted: (_) => _submitLogin(),
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    )),
                    child: const Text(
                      'Register',
                      style: TextStyle(color: AppColor.red, fontSize: 16.0),
                    ),
                  ),
                  const Text(
                    ' | ',
                    style: TextStyle(color: AppColor.orange, fontSize: 16.0),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ForgotPasswordPage(),
                    )),
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: AppColor.brown, fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60.0),
              TdElevatedButton(
                onPressed: _submitLogin,
                text: 'Sign in',
                isDisable: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
