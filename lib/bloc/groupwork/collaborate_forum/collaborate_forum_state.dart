import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';


abstract class CollaborateForumState extends Equatable {
  const CollaborateForumState();
}

class InitialCollaborateForumState extends CollaborateForumState {
  @override
  List<Object> get props => [];
}


class LoadingForumState extends CollaborateForumState{
  @override
  String toString() => "LoadingForumState";

  @override
  List<Object> get props => [];
}

class LoadedForumState extends CollaborateForumState{
  final data;

  @override
  LoadedForumState({
    @required this.data
  });
  
  @override
  String toString() => "LoadedForumState";

  @override
  List<Object> get props =>[data];
}

class MessageForumState extends CollaborateForumState{
  final message;
  MessageForumState({
    @required this.message
  });
  
  @override
  String toString() => "MessageForumState";

  @override
  List<Object> get props => [];
}
