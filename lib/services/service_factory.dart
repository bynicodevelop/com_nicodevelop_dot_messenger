import "package:com_nicodevelop_dotmessenger/repositories/chat_repository.dart";
import "package:com_nicodevelop_dotmessenger/repositories/group_repository.dart";
import "package:com_nicodevelop_dotmessenger/repositories/profile_repository.dart";
import "package:com_nicodevelop_dotmessenger/services/auth/delete_account/delete_account_bloc.dart";
import "package:com_nicodevelop_dotmessenger/services/auth/login/login_bloc.dart";
import "package:com_nicodevelop_dotmessenger/services/auth/logout/logout_bloc.dart";
import "package:com_nicodevelop_dotmessenger/services/auth/profile/profile_bloc.dart";
import "package:com_nicodevelop_dotmessenger/services/auth/register/register_bloc.dart";
import "package:com_nicodevelop_dotmessenger/services/auth/resend_confirm_mail/resend_confirm_mail_bloc.dart";
import "package:com_nicodevelop_dotmessenger/services/auth/update_profile/update_profile_bloc.dart";
import "package:com_nicodevelop_dotmessenger/services/auth/validate_account/validate_account_bloc.dart";
import "package:com_nicodevelop_dotmessenger/services/chat/load_messages/load_messages_bloc.dart";
import "package:com_nicodevelop_dotmessenger/services/groups/list_group/list_group_bloc.dart";
import "package:com_nicodevelop_dotmessenger/services/groups/open_group/open_group_bloc.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class ServiceFactory extends StatelessWidget {
  final GroupRepository groupRepository;
  final ChatRepository chatRepository;
  final ProfileRepository profileRepository;

  final Widget child;

  const ServiceFactory(
    this.groupRepository,
    this.chatRepository,
    this.profileRepository, {
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(
            profileRepository,
          ),
        ),
        BlocProvider<OpenGroupBloc>(
          create: (_) => OpenGroupBloc(),
        ),
        BlocProvider<ListGroupBloc>(
          lazy: true,
          create: (_) => ListGroupBloc(
            groupRepository,
          )..add(OnLoadListGroupEvent()),
        ),
        BlocProvider<LoadMessagesBloc>(
          lazy: true,
          create: (_) => LoadMessagesBloc(
            chatRepository,
          ),
        ),
        BlocProvider<UpdateProfileBloc>(
          create: (_) => UpdateProfileBloc(
            profileRepository,
          ),
        ),
        BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(
            profileRepository,
          ),
        ),
        BlocProvider<RegisterBloc>(
          create: (_) => RegisterBloc(
            profileRepository,
          ),
        ),
        BlocProvider<LogoutBloc>(
          create: (_) => LogoutBloc(
            profileRepository,
          ),
        ),
        BlocProvider<ValidateAccountBloc>(
          create: (_) => ValidateAccountBloc(
            profileRepository,
          ),
        ),
        BlocProvider<ResendConfirmMailBloc>(
          create: (_) => ResendConfirmMailBloc(
            profileRepository,
          ),
        ),
        BlocProvider<DeleteAccountBloc>(
          create: (_) => DeleteAccountBloc(
            profileRepository,
          ),
        ),
      ],
      child: child,
    );
  }
}
