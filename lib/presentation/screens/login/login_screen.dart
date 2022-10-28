import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:pitjarusstore/helpers/colors.dart';
import 'package:pitjarusstore/logic/blocs/login/login_bloc.dart';
import 'package:pitjarusstore/presentation/screens/loading/loading_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _checked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Login')),
      resizeToAvoidBottomInset: false,
      body: BlocListener<LoginBloc, LoginState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == FormzStatus.submissionInProgress) {
            Navigator.of(context).pushNamed(LoadingScreen.routeName);
          }
          if (state.status == FormzStatus.submissionSuccess) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Berhasil login!'),
                  duration: Duration(seconds: 2),
                ),
              );
          }
          if (state.status == FormzStatus.submissionFailure) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(
                  content: Text('${state.error}'),
                  duration: const Duration(seconds: 2),
                ),
              );
          }
        },
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      BlocBuilder<LoginBloc, LoginState>(
                        buildWhen: (previous, current) =>
                            previous.usernameField != current.usernameField,
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r"[a-zA-Z0-9@.]")),
                              ],
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(11.0),
                                labelText: 'Username',
                                prefixIcon: Icon(
                                  Icons.account_circle,
                                  color: MyColors.pallete,
                                ),
                              ),
                              onChanged: (value) => context
                                  .read<LoginBloc>()
                                  .add(LoginUsernameChanged(value)),
                              validator: (value) => state.usernameField.error,
                            ),
                          );
                        },
                      ),
                      BlocBuilder<LoginBloc, LoginState>(
                        buildWhen: (previous, current) =>
                            previous.passwordField != current.passwordField,
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              obscureText: true,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(11.0),
                                labelText: 'Password',
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: MyColors.pallete,
                                ),
                              ),
                              onChanged: (value) {
                                context
                                    .read<LoginBloc>()
                                    .add(LoginPasswordChanged(value));
                              },
                              validator: (value) => state.passwordField.error,
                            ),
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                height: 28.0,
                                width: 28.0,
                                child: Checkbox(
                                  fillColor: MaterialStateColor.resolveWith(
                                    (states) => MyColors.pallete,
                                  ),
                                  value: _checked,
                                  onChanged: (value) {
                                    setState(() {
                                      _checked = value ?? false;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 4.0),
                              const Text(
                                'Keep Username',
                                style: TextStyle(
                                  color: MyColors.pallete,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: const [
                              Icon(Icons.download, color: MyColors.pallete),
                              SizedBox(width: 4.0),
                              Text(
                                'Check Update',
                                style: TextStyle(
                                  color: MyColors.pallete,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 36.0),
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: state.saveButtonActive
                                ? () => context
                                    .read<LoginBloc>()
                                    .add(LoginFormSubmitted())
                                : null,
                            style: ElevatedButton.styleFrom(
                              elevation: 6.0,
                            ),
                            child: const Text('LOGIN'),
                          );
                        },
                      ),
                      const SizedBox(height: 36.0),
                      const Text(
                        'App Ver 1.0.0 - MBP',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                padding: const EdgeInsets.only(bottom: 50),
                color: MyColors.pallete,
                height: MediaQuery.of(context).size.height * 0.2,
                alignment: Alignment.center,
              ),
            ),
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: RotatedBox(
                quarterTurns: 2,
                child: ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 50),
                    color: MyColors.pallete,
                    height: MediaQuery.of(context).size.height * 0.2,
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
      size.width * 0.02,
      size.height,
      size.width * 0.06,
      size.height * 0.8,
    );
    path.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.25,
      size.width * 0.5,
      size.height * 0.4,
    );
    path.quadraticBezierTo(
      size.width * 0.96,
      size.height * 0.5,
      size.width,
      0,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
