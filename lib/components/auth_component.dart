import "package:com_nicodevelop_dotmessenger/screens/home_screen.dart";
import "package:com_nicodevelop_dotmessenger/screens/login_screen.dart";
import "package:com_nicodevelop_dotmessenger/services/auth/login/login_bloc.dart";
import "package:com_nicodevelop_dotmessenger/services/auth/logout/logout_bloc.dart";
import "package:com_nicodevelop_dotmessenger/services/auth/register/register_bloc.dart";
import "package:com_nicodevelop_dotmessenger/utils/notice.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class AuthComponent extends StatelessWidget {
  final Widget child;

  const AuthComponent({
    Key? key,
    required this.child,
  }) : super(key: key);

  void _gotToHome(BuildContext context) async => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) {
          return const HomeScreen();
        }),
        (route) => false,
      );

  void _gotToLogin(BuildContext context) async => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) {
          return const LoginScreen();
        }),
        (route) => false,
      );

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<RegisterBloc, RegisterState>(
            listener: (context, state) async {
          if (state is RegisterFailureState) {
            return notice(
              context,
              state.code,
            );
          }

          if (state is RegisterSuccessState) {
            _gotToHome(context);
          }
        }),
        BlocListener<LoginBloc, LoginState>(listener: (context, state) async {
          if (state is LoginFailureState) {
            return notice(
              context,
              state.code,
            );
          }

          if (state is LoginSuccessState) {
            _gotToHome(context);
          }
        }),
        BlocListener<LogoutBloc, LogoutState>(listener: (context, state) async {
          if (state is LogoutSuccessState) {
            _gotToLogin(context);
          }
        }),
      ],
      child: child,
    );
  }
}
