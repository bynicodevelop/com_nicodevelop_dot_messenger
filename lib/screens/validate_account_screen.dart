import "package:clipboard/clipboard.dart";
import "package:com_nicodevelop_dotmessenger/models/user_model.dart";
import "package:com_nicodevelop_dotmessenger/screens/home_screen.dart";
import "package:com_nicodevelop_dotmessenger/services/auth/email_verified/email_verified_bloc.dart";
import "package:com_nicodevelop_dotmessenger/services/auth/resend_confirm_mail/resend_confirm_mail_bloc.dart";
import "package:com_nicodevelop_dotmessenger/services/auth/validate_account/validate_account_bloc.dart";
import "package:com_nicodevelop_dotmessenger/utils/notice.dart";
import "package:flutter/services.dart";
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

  bool _loading = false;

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

  @override
  void dispose() {
    _controller0.dispose();
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();

    _focusNode0.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();

    super.dispose();
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
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ], // Only numbers can be entered
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.center,
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
                    BlocListener<EmailVerifiedBloc, EmailVerifiedState>(
                      listener: (context, state) async {
                        UserModel user =
                            (state as EmailVerifiedInitialState).user;

                        setState(() => _loading = false);

                        if (user.emailVerified) {
                          notice(
                            context,
                            "Account validated successfully",
                          );

                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      child: BlocListener<ValidateAccountBloc,
                          ValidateAccountState>(
                        listener: (context, state) async {
                          if (state is ValidateAccountFailureState) {
                            _controller0.clear();
                            _controller1.clear();
                            _controller2.clear();
                            _controller3.clear();

                            _focusNode0.requestFocus();

                            setState(() => _loading = false);

                            return notice(
                              context,
                              state.code,
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
                                  setState(() => _loading = true);

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
                        BlocListener<ResendConfirmMailBloc,
                            ResendConfirmMailState>(
                          listener: (context, state) {
                            setState(() => _loading = false);

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
                            onPressed: () {
                              setState(() => _loading = true);

                              context
                                  .read<ResendConfirmMailBloc>()
                                  .add(OnResendConfirmMailEvent());
                            },
                            child: Text(
                              "Resend",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
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
            if (_loading)
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.black.withOpacity(0.5),
                  child: CircularProgressIndicator(
                    color: Colors.grey[200],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
