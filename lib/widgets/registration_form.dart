import 'dart:math';

import 'package:college_notice/utils/validators.dart';
import 'package:college_notice/widgets/text_form_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegistrationForm extends StatefulWidget {
  final String title;
  final List<Widget>? prefix;
  final Function(String email, String password, VoidCallback onComplete)?
      onRegister;
  final VoidCallback onLoginHerePressed;

  const RegistrationForm({
    super.key,
    this.title = "Register",
    this.onRegister,
    this.prefix,
    required this.onLoginHerePressed,
  });

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  int state = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            width: min(MediaQuery.of(context).size.width, 400),
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
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 72,
                  ),
                  if (widget.prefix != null) ...widget.prefix!,
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
                    textInputAction: TextInputAction.next,
                    obsecureText: true,
                    validator: Validator.passowrd,
                    enabled: state == 0,
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  AppTextFormField(
                    label: "Re-enter password",
                    obsecureText: true,
                    validator: _rePasswordValidator,
                    textInputAction: TextInputAction.done,
                    enabled: state == 0,
                    maxLines: 1,

                    onFieldSubmitted: (value) => _onRegisterPressed(),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    onPressed: state == 0 ? _onRegisterPressed : null,
                    child: state == 0
                        ? const Text("Register")
                        : const SizedBox(
                            width: 24,
                            height: 24,
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
                          text: "Alreadey registered? ",
                          style: Theme.of(context).textTheme.labelMedium),
                      TextSpan(
                        text: "Login here",
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: state == 0
                                      ? Theme.of(context).colorScheme.secondary
                                      : Theme.of(context).disabledColor,
                                  fontWeight: FontWeight.bold,
                                ),
                        recognizer: state == 0
                            ? (TapGestureRecognizer()
                              ..onTap = widget.onLoginHerePressed)
                            : null,
                      )
                    ]),
                  ),
                  const SizedBox(
                    height: 56,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onRegisterPressed() {
    if (formKey.currentState?.validate() ?? false) {
      setState(() {
        state = 1;
      });
      widget.onRegister?.call(emailController.text, passwordController.text,
          _onRegisterProcessComplete);
    }
  }

  void _onRegisterProcessComplete() {
    setState(() {
      state = 0;
    });
  }

  String? _rePasswordValidator(String? value) {
    if (Validator.passowrd(value) != null) {
      return Validator.passowrd(value);
    }

    if (value != passwordController.text) {
      return "Password do not match";
    }

    return null;
  }
}
