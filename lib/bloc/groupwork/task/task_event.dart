import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:peeps/models/changed_status.dart';

@immutable
abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}


class LoadTaskEvent extends TaskEvent{

  @override
  String toString()=> "LoadTaskEvent";
}
class AddNewTaskEvent extends TaskEvent{
  final groupId;
  final assignment;
  final task;
  AddNewTaskEvent({
    @required this.groupId,
    @required this.assignment,
    @required this.task
  });

  @override
  String toString() => "AddNewTaskEvent";
}

class UpdateTaskStatus extends TaskEvent{
  final assignmentId;
  final List<ChangedStatus> tasks;

  UpdateTaskStatus({
    @required this.tasks,
    @required this.assignmentId,
  });

  @override
  String toString() => "UpdateTaskStatus";
}

class UpdateTaskEvent extends TaskEvent{
  final data;
  UpdateTaskEvent({
    @required this.data
  });

  @override
  String toString() => "UpdateTaskEvent";
}

class DeleteTaskButtonClickedEvent extends TaskEvent{
  final taskId;
  DeleteTaskButtonClickedEvent({
    @required this.taskId
  });

  @override
  String toString() => "DeleteButtonEvent";
}

class DeleteTaskEvent extends TaskEvent{
  final assignmentId;
  final taskId;
  DeleteTaskEvent({
    @required this.assignmentId,
    @required this.taskId,
  });
  @override
  String toString() => "DeleteTaskEvent";

}

class RefreshAssignmentEvent extends TaskEvent{
  final groupId;
  final assignmentId;

  RefreshAssignmentEvent({
    @required this.groupId,
    @required this.assignmentId
  });
  
  @override
  String toString() => "RefreshAssignmentEvent";
}

class RequestChangeAssignTo extends TaskEvent{
  final data;
  RequestChangeAssignTo({
    @required this.data
  });

  @override
  String toString() => "RequestChangeAssignTo";
}


