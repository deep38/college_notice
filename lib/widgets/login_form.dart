import 'dart:math';

import 'package:college_notice/utils/validators.dart';
import 'package:college_notice/widgets/text_form_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  final int minPasswordLength;
  final int maxPasswordLength;
  final Function(String email, String password, VoidCallback onComplete)?
      onLogin;
  final String notRegisteredMessage;
  final String registerHereMessage;
  final VoidCallback onRegisterherePressed;

  const LoginForm({
    super.key,
    this.minPasswordLength = 8,
    this.maxPasswordLength = 32,
    this.notRegisteredMessage = "Not registered?",
    this.registerHereMessage = "Register here",
    this.onLogin,
    required this.onRegisterherePressed,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  int state = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: formKey,
          child: Center(
            child: Container(
              width: min(MediaQuery.of(context).size.width, 400),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32.0),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      offset: const Offset(1, 1),
                      spreadRadius: 4,
                      blurRadius: 56,
                      color: Theme.of(context).colorScheme.surface,
                    )
                  ],
                ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Login",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 72,
                  ),
                  AppTextFormField(
                    label: "Email",
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    controller: emailController,
                    validator: Validator.email,
                    enabled: state == 0,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  AppTextFormField(
                    label: "Password",
                    controller: passwordController,
                    textInputAction: TextInputAction.done,
                    obsecureText: true,
                    validator: Validator.passowrd,
                    enabled: state == 0,
                    maxLines: 1,
                    onFieldSubmitted: (value) => onLoginPressed(),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: state == 0 ? onForgotPasswordPressed : null,
                      child: const Text(
                        "Forgot passowrd?",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    onPressed: state == 0 ? onLoginPressed : null,
                    child: state == 0
                        ? const Text("Log in")
                        : const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(),
                          ),
                  ),
                  const SizedBox(
                    height: 56,
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "${widget.notRegisteredMessage} ",
                          style: Theme.of(context).textTheme.labelMedium),
                      TextSpan(
                        text: widget.registerHereMessage,
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: state == 0
                                      ? Theme.of(context).colorScheme.secondary
                                      : Theme.of(context).disabledColor,
                                  fontWeight: FontWeight.bold,
                                ),
                        recognizer: state == 0
                            ? (TapGestureRecognizer()
                              ..onTap = widget.onRegisterherePressed)
                            : null,
                      )
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onForgotPasswordPressed() {}

  void onLoginPressed() {
    if (formKey.currentState?.validate() ?? false) {
      setState(() {
        state = 1;
      });
      widget.onLogin
          ?.call(emailController.text, passwordController.text, onComplete);
    }
  }

  void onComplete() {
    setState(() {
      state = 0;
    });
  }
}
