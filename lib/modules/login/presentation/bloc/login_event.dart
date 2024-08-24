part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class SignInWithGoogle extends LoginEvent {}

class ValidateOTP extends LoginEvent {
  final String verificationId;
  final String otp;

  ValidateOTP({
    required this.verificationId,
    required this.otp,
  });
}

class AssignVerificationCode extends LoginEvent {
  final String verificationCode;

  AssignVerificationCode({
    required this.verificationCode,
  });
}

class GenderSelected extends LoginEvent {
  final String gender;

  GenderSelected(this.gender);
}

class GenderContinueButtonClicked extends LoginEvent {}

class GenderPreferenceTapped extends LoginEvent {
  final String genderPreference;

  GenderPreferenceTapped(this.genderPreference);
}

class GenderPrefContinueButtonClicked extends LoginEvent {}

class LookingForOptionTapped extends LoginEvent {
  final String lookingForOption;

  LookingForOptionTapped(this.lookingForOption);
}

class LookingForContinueButtonClicked extends LoginEvent {}

class ReligionTapped extends LoginEvent {
  final String selectedReligion;

  ReligionTapped(
    this.selectedReligion,
  );
}

class StatusContinueBtnClicked extends LoginEvent {}

class StatusTapped extends LoginEvent {
  final String selectedStatus;

  StatusTapped(
    this.selectedStatus,
  );
}

class ReligionContinueBtnClicked extends LoginEvent {}
