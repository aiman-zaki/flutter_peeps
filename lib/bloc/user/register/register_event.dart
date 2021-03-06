import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
  @override
  List<Object> get props => [];
}

class RegisterButtonClickedEvent extends RegisterEvent{
  final email;
  final password;
  final image;

  RegisterButtonClickedEvent({
    @required this.email,
    @required this.password,
    @required this.image,
  });
  @override
  String toString() => "RegisterButtonClickedEvent";
}

class UpdateProfileButtonClickedEvent extends RegisterEvent{
  @override
  String toString() => "UpdateProfileButtonClickedEvent";
}