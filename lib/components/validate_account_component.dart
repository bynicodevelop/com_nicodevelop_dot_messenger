import "package:com_nicodevelop_dotmessenger/components/responsive_component.dart";
import "package:com_nicodevelop_dotmessenger/models/user_model.dart";
import "package:com_nicodevelop_dotmessenger/screens/validate_account_screen.dart";
import "package:com_nicodevelop_dotmessenger/services/auth/email_verified/email_verified_bloc.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class ValidateAccountComponent extends StatelessWidget {
  final Widget child;
  const ValidateAccountComponent({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        BlocBuilder<EmailVerifiedBloc, EmailVerifiedState>(
          // bloc: context.read<ProfileBloc>()..add(OnProfileEvent()),
          builder: (context, state) {
            UserModel user = (state as EmailVerifiedInitialState).user;

            if (user.emailVerified) {
              return const SizedBox.shrink();
            }

            return Positioned(
              top: ResponsiveComponent.device != DeviceEnum.mobile ? 0 : null,
              left: 0,
              right: 0,
              bottom:
                  ResponsiveComponent.device == DeviceEnum.mobile ? 0 : null,
              child: Material(
                child: InkWell(
                  onTap: () async => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ValidateAccountScreen(),
                    ),
                  ),
                  child: Ink(
                    height: 50,
                    color: Colors.green[900],
                    child: const Center(
                      child: Text(
                        "Account is not validated",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
