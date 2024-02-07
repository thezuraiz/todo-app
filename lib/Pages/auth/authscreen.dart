import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:todo_app/Functions/AuthFunctions.dart';

class LoginSignUpPage extends StatefulWidget {
  const LoginSignUpPage({super.key});

  @override
  State<LoginSignUpPage> createState() => _LoginSignUpPageState();
}

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  bool isSignup = true;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    isValidate() {
      if (formKey.currentState!.validate()) {
        FocusManager.instance.primaryFocus?.unfocus();
        formKey.currentState!.save();
        isSignup
            ? signup(
                nameController.text.toString(),
                emailController.text.toString(),
                passwordController.text.toString())
            : login(emailController.text.toString(),
                passwordController.text.toString());
      }
    }

    final requiredValidator = MultiValidator(
        [RequiredValidator(errorText: 'this field is required')]);
    final emailValidator = MultiValidator([
      RequiredValidator(errorText: 'this field is required'),
      EmailValidator(errorText: "Invalid Email")
    ]);

    return Scaffold(
      appBar: AppBar(
        title: Text(isSignup ? "SignUp Page" : "Login"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          key: formKey,
          child: ListView(
            children: [
              const Icon(
                Icons.flutter_dash,
                size: 300,
              ),
              isSignup
                  ? TextFormFieldWid("Enter Name", nameController,
                      Icons.drive_file_rename_outline, requiredValidator)
                  : Container(),
              TextFormFieldWid(
                "Enter Email",
                emailController,
                Icons.email_outlined,
                emailValidator,
              ),
              TextFormFieldWid("Enter Password", passwordController,
                  Icons.password, requiredValidator,
                  showPassword: false),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: isValidate,
                  child: Text(isSignup ? 'Sign Up' : 'Login'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  isSignup = !isSignup;
                  setState(() {});
                },
                child: Text(isSignup
                    ? "Already Signed Up? Login"
                    : "Already Login In? SignUp"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget TextFormFieldWid(
      String labelText,
      TextEditingController textEditingController,
      IconData icon,
      String? Function(String?) validator,
      {bool showPassword = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        controller: textEditingController,
        obscureText: !showPassword,
        validator: validator,
      ),
    );
  }
}
