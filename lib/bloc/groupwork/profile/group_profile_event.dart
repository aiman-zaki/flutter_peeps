import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class GroupProfileEvent extends Equatable {
  const GroupProfileEvent();
   @override
  List<Object> get props => [];
}

class UpdateGroupworkProfileEvent extends GroupProfileEvent{
  final data;
  UpdateGroupworkProfileEvent({
    @required this.data
  });

  @override
  String toString() => "UpdateGroupworkEvent";
}

class UploadGroupworkProfileImage extends GroupProfileEvent{
  final image;
  final groupId;

  UploadGroupworkProfileImage({
      @required this.image,
      @required this.groupId
    }
  );
  
  @override
  String toString() => "UploadProfileImage";
}


class UpdateAdminRoleEvent extends GroupProfileEvent{
  final data;
  UpdateAdminRoleEvent({
    @required this.data
  });

  @override
  String toString() => "UpdateAdminRoleEvent";
}

class DeleteMemberEvent extends GroupProfileEvent{
  final data;
  DeleteMemberEvent({
    @required this.data,
  });

  @override
  String toString() => "DeleteMemberEvent";
}


class UpdateTemplateRevision extends GroupProfileEvent{
  @override
  String toString() => "UpdateTemplateRevision";

  @override
  List<Object> get props => [];
  
}