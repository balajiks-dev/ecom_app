part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoggedInSuccessful extends LoginState {
  final String? providerName;

  LoggedInSuccessful({this.providerName});
}

class FailureState extends LoginState with EquatableMixin {
  final String errorMessage;

  FailureState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage, identityHashCode(this)];
}

class OTPValidationSuccess extends LoginState {}

class VerificationCodeAssigned extends LoginState {
  final String verificationCode;

  VerificationCodeAssigned({
    required this.verificationCode,
  });
}

class NavigateToGenderPrefScreen extends LoginState {}

class GenderSelection extends LoginState {
  final bool isMaleSelected;
  final bool isFemaleSelected;
  final bool isOtherSelected;

  GenderSelection({
    required this.isMaleSelected,
    required this.isFemaleSelected,
    required this.isOtherSelected,
  });
}

class NavigateToLookingForScreen extends LoginState {}

class GenderPreferenceUpdated extends LoginState {
  final String selectedPreference;

  GenderPreferenceUpdated({
    required this.selectedPreference,
  });
}

class NavigateToHeightPickerScreenState extends LoginState {}

class LookingForOptionUpdated extends LoginState {
  final String selectedOption;

  LookingForOptionUpdated({
    required this.selectedOption,
  });
}
class NavigateToStatusScreen extends LoginState {}

class NavigateToReligionScreen extends LoginState {}

class NavigateToCommunityScreen extends LoginState {}

class ReligionSelected extends LoginState {
  final String selectedReligion;

  ReligionSelected({
    required this.selectedReligion,
  });
}

class StatusSelected extends LoginState {
  final String selectedStatus;

  StatusSelected({
    required this.selectedStatus,
  });
}
