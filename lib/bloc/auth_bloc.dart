import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LocalAuthentication _localAuth = LocalAuthentication();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthBloc() : super(AuthInitial()) {
    on<AuthenticateWithBiometrics>(_onAuthenticateWithBiometrics);
    on<SignInWithGoogle>(_onSignInWithGoogle);
  }

  Future<void> _onAuthenticateWithBiometrics(
      AuthenticateWithBiometrics event, Emitter<AuthState> emit) async {
    try {
      bool authenticated = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to sign in',
        options: const AuthenticationOptions(stickyAuth: true),
      );

      if (authenticated) {
        emit(BiometricAuthenticated());
      }
    } catch (e) {
      emit(AuthenticationFailed('Error during biometric authentication: $e'));
    }
  }

  Future<void> _onSignInWithGoogle(
      SignInWithGoogle event, Emitter<AuthState> emit) async {
    try {
      emit(GoogleSignInInProgress());

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        emit(GoogleSignInFailed('Google sign-in aborted by user.'));
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      emit(GoogleSignInSuccess(
        displayName: googleUser.displayName ?? 'No Name',
        photoUrl: googleUser.photoUrl ?? '',
      ));
    } catch (e) {
      emit(GoogleSignInFailed('Error during Google sign-in: $e'));
    }
  }
}