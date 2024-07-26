import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';
import 'bloc/auth_state.dart';
import 'home_page.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sign In'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is BiometricAuthenticated) {
                Fluttertoast.showToast(
                  msg: "Fingerprint authentication successful!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              } else if (state is AuthenticationFailed) {
                debugPrint(state.error);
                Fluttertoast.showToast(
                  msg: state.error,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              } else if (state is GoogleSignInFailed) {
                debugPrint(state.error);
                Fluttertoast.showToast(
                  msg: state.error,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              } else if (state is GoogleSignInSuccess) {
                Fluttertoast.showToast(
                  msg: "Google sign-in successful!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                Future.delayed(Duration(seconds: 2), () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => HomePage(
                        displayName: state.displayName,
                        photoUrl: state.photoUrl,
                      ),
                    ),
                  );
                });
              }
            },
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: state is BiometricAuthenticated
                            ? null
                            : () {
                          context
                              .read<AuthBloc>()
                              .add(AuthenticateWithBiometrics());
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              state is BiometricAuthenticated
                                  ? Icons.check_circle
                                  : Icons.fingerprint,
                              color: state is BiometricAuthenticated
                                  ? Colors.green
                                  : null,
                            ),
                            SizedBox(width: 8),
                            Text(state is BiometricAuthenticated
                                ? 'Fingerprint authenticated'
                                : 'Sign in with Biometrics'),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: state is BiometricAuthenticated
                              ? Colors.grey
                              : null,
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: state is GoogleSignInInProgress
                            ? null
                            : () {
                          if (state is BiometricAuthenticated) {
                            context.read<AuthBloc>().add(SignInWithGoogle());
                          } else {
                            Fluttertoast.showToast(
                              msg: "You should login with fingerprint first",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.blue,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (state is GoogleSignInInProgress)
                              CircularProgressIndicator(),
                            SizedBox(width: 8),
                            Text(state is GoogleSignInSuccess
                                ? 'Google authenticated'
                                : 'Sign in with Google'),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: state is GoogleSignInSuccess
                              ? Colors.grey
                              : null,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}