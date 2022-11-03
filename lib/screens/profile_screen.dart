import "package:com_nicodevelop_dotmessenger/components/auth_component.dart";
import "package:com_nicodevelop_dotmessenger/components/buttons/delete_account_button_component.dart";
import "package:com_nicodevelop_dotmessenger/components/input_edit_field_component.dart";
import "package:com_nicodevelop_dotmessenger/components/responsive_component.dart";
import "package:com_nicodevelop_dotmessenger/screens/validate_account_screen.dart";
import "package:com_nicodevelop_dotmessenger/services/auth/logout/logout_bloc.dart";
import "package:com_nicodevelop_dotmessenger/services/auth/profile/profile_bloc.dart";
import "package:com_nicodevelop_dotmessenger/services/auth/update_profile/update_profile_bloc.dart";
import "package:com_nicodevelop_dotmessenger/utils/notice.dart";
import "package:com_nicodevelop_dotmessenger/widgets/input_decorator_widget.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  double _responsiveWidth(BuildContext context) {
    if (ResponsiveComponent.device == DeviceEnum.desktop) {
      return MediaQuery.of(context).size.width * 0.35;
    }

    if (ResponsiveComponent.device == DeviceEnum.tablet) {
      return MediaQuery.of(context).size.width * 0.25;
    }

    return 16.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: _responsiveWidth(context),
        ),
        child: BlocListener<UpdateProfileBloc, UpdateProfileState>(
          listener: (context, state) {
            if (state is UpdateProfileSuccessState) {
              return notice(
                context,
                "Votre profil a été mis à jour avec succès",
              );
            }

            if (state is UpdateProfileFailureState) {
              return notice(
                context,
                state.code,
              );
            }
          },
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              User? user = (state as ProfileSuccessState).user;

              _displayNameController.text = user.displayName ?? "";
              _emailController.text = user.email ?? "";

              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Profile",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const SizedBox(height: 20),
                      InputEditFieldComponent(
                        label: "Nom d'affichage",
                        controller: _displayNameController,
                        onSave: () => context.read<UpdateProfileBloc>().add(
                              OnUpdateProfileEvent(data: {
                                "displayName": _displayNameController.text,
                                "email": _emailController.text,
                              }),
                            ),
                      ),
                      if (!user.emailVerified)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                const Text(
                                  "Votre adresse email n'est pas vérifiée",
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () async => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ValidateAccountScreen(),
                                    ),
                                  ),
                                  child: const Text("Vérifier"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      InputEditFieldComponent(
                        label: "Email",
                        controller: _emailController,
                        onSave: () => context.read<UpdateProfileBloc>().add(
                              OnUpdateProfileEvent(data: {
                                "displayName": _displayNameController.text,
                                "email": _emailController.text,
                              }),
                            ),
                      ),
                      AuthComponent(
                        child: InputDecoratorWidget(
                          child: SizedBox(
                            width: double.infinity,
                            height: 40.0,
                            child: ElevatedButton(
                              child: const Text("Déconnexion"),
                              onPressed: () => context.read<LogoutBloc>().add(
                                    OnLogoutEvent(),
                                  ),
                            ),
                          ),
                        ),
                      ),
                      const InputDecoratorWidget(
                        child: DeleteAccountButtonComponent(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
