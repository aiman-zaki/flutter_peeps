import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:peeps/resources/user_repository.dart';
import 'package:peeps/resources/users_repository.dart';
import '../bloc.dart';

class ProfileFormBloc extends Bloc<ProfileFormEvent, ProfileFormState> {
  final UserRepository repository;
  final ProfileBloc bloc;

  ProfileFormBloc({
    @required this.repository,
    @required this.bloc
  });
  
  @override
  ProfileFormState get initialState => InitialProfileFormState();

  @override
  Stream<ProfileFormState> mapEventToState(
    ProfileFormEvent event,
  ) async* {
    if(event is UpdateProfileEvent){
      yield UpdatingProfileState();
      await repository.updateProfile(data: event.data);
      yield PopState();
      bloc.add(LoadProfileEvent());
      yield UpdatedProfileState(); 
      yield InitialProfileFormState();   
    }
    if(event is UpdateRoleEvent){
      yield UpdatingRoleState();
      await repository.updateRole(data:event.data);
      bloc.add(LoadProfileEvent());
      yield UpdatedRoleState();
    }
    if(event is UploadProfilePictureEvent){
      yield UploadingProfilePictureState();
      await repository.updatePicture(image:event.image,id:event.userId);
      yield UploadedProfilePictureState();
    }
  }
}
