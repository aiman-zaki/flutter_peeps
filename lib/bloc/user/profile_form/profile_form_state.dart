import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ProfileFormState extends Equatable {
  const ProfileFormState();
  @override
  List<Object> get props => [];
}

class InitialProfileFormState extends ProfileFormState {
  @override
  String toString() => "InitialProfileFormState";
}

class UpdatingProfileState extends ProfileFormState{
  @override
  String toString() => "UpdatingProfileState";
}

class UpdatedProfileState extends ProfileFormState{
  @override
  String toString() => "UpdatedProfileState";
}

class UploadingProfilePictureState extends ProfileFormState{
  @override
  String toString() => "UploadingProfilePictureState";
}

class UploadedProfilePictureState extends ProfileFormState{
  @override
  String toString() => "UploadedProfilePictureState";
}

class UpdatingRoleState extends ProfileFormState{
  @override
  String toString() => "UpdatingRoleState";
}

class UpdatedRoleState extends ProfileFormState{
  @override
  String toString() => "UpdatedRoleState";
}

class PopState extends ProfileFormState{
  @override
  String toString() => "PopState";
}