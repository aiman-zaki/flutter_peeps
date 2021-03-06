import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:peeps/resources/user_repository.dart';
import 'package:peeps/resources/users_repository.dart';
import '../bloc.dart';

class InboxBloc extends Bloc<InboxEvent, InboxState> {
  final UserRepository repository;
  final ProfileBloc profileBloc;
  InboxBloc({@required this.repository, @required this.profileBloc}):assert(repository != null);
  
  @override
  InboxState get initialState => InitialInboxState();

  @override
  Stream<InboxState> mapEventToState(
    InboxEvent event,
  ) async* {
    if(event is LoadInboxEvent){
      yield LoadingInboxState();
      List data = await repository.readGroupInvitationInbox();
      if(data.isEmpty){
        yield NoInvitationState();
      }
      else{
        yield LoadedInboxState(data: data);
      }
    }
    if(event is ReplyInvitationEvent){
      await repository.updateGroupInvitationInbox(data: {
        'answer':event.reply,
        'group_id':event.groupId,
      });
      profileBloc.add(LoadProfileEvent());
    }
  }
}
