import "package:com_nicodevelop_dotmessenger/components/auth_component.dart";
import "package:com_nicodevelop_dotmessenger/components/inputs/email_input_component.dart";
import "package:com_nicodevelop_dotmessenger/components/inputs/password_input_component.dart";
import "package:com_nicodevelop_dotmessenger/components/responsive_component.dart";
import "package:com_nicodevelop_dotmessenger/screens/register_screen.dart";
import "package:com_nicodevelop_dotmessenger/services/auth/login/login_bloc.dart";
import "package:com_nicodevelop_dotmessenger/widgets/input_decorator_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter/material.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (kDebugMode) {
      _emailController.text = "john@domain.tld";
      _passwordController.text = "123456";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveComponent(
      builder: (context, device, constraints) {
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal:
                    ResponsiveComponent.device == DeviceEnum.mobile ? 20 : 200,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Login",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    EmailInputComponent(
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }

                        return null;
                      },
                    ),
                    PasswordInputComponent(
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        }

                        if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }

                        return null;
                      },
                    ),
                    AuthComponent(
                      child: SizedBox(
                        width: double.infinity,
                        height: 40.0,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<LoginBloc>().add(
                                    OnLoginEvent({
                                      "email": _emailController.text,
                                      "password": _passwordController.text,
                                    }),
                                  );
                            }
                          },
                          child: const Text("Connexion"),
                        ),
                      ),
                    ),
                    InputDecoratorWidget(
                      child: SizedBox(
                        child: TextButton(
                          onPressed: () async => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const RegisterScreen();
                              },
                              fullscreenDialog: true,
                            ),
                          ),
                          child: const Text("Créer un compte"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
