import "package:clipboard/clipboard.dart";
import "package:com_nicodevelop_dotmessenger/screens/home_screen.dart";
import "package:com_nicodevelop_dotmessenger/services/auth/resend_confirm_mail/resend_confirm_mail_bloc.dart";
import "package:com_nicodevelop_dotmessenger/services/auth/validate_account/validate_account_bloc.dart";
import "package:com_nicodevelop_dotmessenger/utils/notice.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter/material.dart";

class ValidateAccountScreen extends StatefulWidget {
  const ValidateAccountScreen({super.key});

  @override
  State<ValidateAccountScreen> createState() => _ValidateAccountScreenState();
}

class _ValidateAccountScreenState extends State<ValidateAccountScreen> {
  final TextEditingController _controller0 = TextEditingController();
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();

  final FocusNode _focusNode0 = FocusNode();
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();

  @override
  void initState() {
    super.initState();

    // ignore: discarded_futures
    FlutterClipboard.paste().then((value) {
      if (value.length == 4) {
        _controller0.text = value[0];
        _controller1.text = value[1];
        _controller2.text = value[2];
        _controller3.text = value[3];

        _focusNode3.unfocus();

        context.read<ValidateAccountBloc>().add(
              OnValidateAccountEvent(
                _controller0.text +
                    _controller1.text +
                    _controller2.text +
                    _controller3.text,
              ),
            );
      }
    });
  }

  final _defaultSpacing = 22.0;

  Widget _fieldBuilder(
    TextEditingController controller,
    FocusNode focusNode,
    Function(String value)? onChanged,
  ) {
    return SizedBox(
      width: 50,
      child: TextFormField(
        autofocus: true,
        controller: controller,
        focusNode: focusNode,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          counterText: "",
        ),
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
        ),
        maxLength: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Validate Account",
                style: Theme.of(context).textTheme.headlineLarge!,
              ),
              SizedBox(
                height: _defaultSpacing,
              ),
              BlocListener<ValidateAccountBloc, ValidateAccountState>(
                listener: (context, state) async {
                  if (state is ValidateAccountFailureState) {
                    return notice(
                      context,
                      state.code,
                    );
                  }

                  if (state is ValidateAccountSuccessState) {
                    notice(
                      context,
                      "Account validated successfully",
                    );

                    Future.delayed(
                      const Duration(
                        milliseconds: 1500,
                      ),
                      () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                          (route) => false,
                        );
                      },
                    );
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _fieldBuilder(
                      _controller0,
                      _focusNode0,
                      (String value) {
                        if (value.length == 1) {
                          _focusNode1.requestFocus();
                        }
                      },
                    ),
                    SizedBox(
                      width: _defaultSpacing,
                    ),
                    _fieldBuilder(
                      _controller1,
                      _focusNode1,
                      (String value) {
                        if (value.length == 1) {
                          _focusNode2.requestFocus();
                        }
                      },
                    ),
                    SizedBox(
                      width: _defaultSpacing,
                    ),
                    _fieldBuilder(
                      _controller2,
                      _focusNode2,
                      (String value) {
                        if (value.length == 1) {
                          _focusNode3.requestFocus();
                        }
                      },
                    ),
                    SizedBox(
                      width: _defaultSpacing,
                    ),
                    _fieldBuilder(
                      _controller3,
                      _focusNode3,
                      (String value) {
                        if (value.length == 1) {
                          context.read<ValidateAccountBloc>().add(
                                OnValidateAccountEvent(
                                  _controller0.text +
                                      _controller1.text +
                                      _controller2.text +
                                      _controller3.text,
                                ),
                              );
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: _defaultSpacing,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code?",
                    style: Theme.of(context).textTheme.bodyText1!,
                  ),
                  BlocListener<ResendConfirmMailBloc, ResendConfirmMailState>(
                    listener: (context, state) {
                      if (state is ResendConfirmMailFailureState) {
                        return notice(
                          context,
                          state.code,
                        );
                      }

                      if (state is ResendConfirmMailSuccessState) {
                        return notice(
                          context,
                          "The code has been sent to your email.",
                        );
                      }
                    },
                    child: TextButton(
                      onPressed: () => context
                          .read<ResendConfirmMailBloc>()
                          .add(OnResendConfirmMailEvent()),
                      child: Text(
                        "Resend",
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
