import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:sample_ecommerce/modules/login/auth_service/auth_service.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<SignInWithGoogle>(_onSignInWithGoogle);
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogle event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginInitial());
    try {
      final user = await AuthService.loginWithGoogle();
      if (user != null) {
        emit(LoggedInSuccessful());
      }
    } on FirebaseAuthException catch (error) {
      emit(FailureState(errorMessage: "Something went wrong"));
    } catch (error) {
      emit(FailureState(errorMessage: "Something went wrong"));
    }
  }
}
