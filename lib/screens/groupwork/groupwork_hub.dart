import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peeps/bloc/bloc.dart';
import 'package:peeps/models/groupwork.dart';
import 'package:peeps/models/user.dart';
import 'package:peeps/resources/assignment_repository.dart';
import 'package:peeps/resources/chat.dart';
import 'package:peeps/screens/common/custom_milestone.dart';
import 'package:peeps/screens/groupwork/assignment_form.dart';
import 'package:peeps/screens/groupwork/group_chat.dart';
import 'package:peeps/screens/groupwork/groupwork_hub_view.dart';

class GroupworkHub extends StatefulWidget {
  final GroupworkModel groupData;
  final UserModel userData;
  GroupworkHub({Key key, this.groupData,this.userData}) : super(key: key);

  _GroupworkHubState createState() => _GroupworkHubState();
}

class _GroupworkHubState extends State<GroupworkHub> with SingleTickerProviderStateMixin{
  TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this); 

    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
      providers: [
        BlocProvider<GroupChatBloc>(builder: (context) => GroupChatBloc(chat: ChatResources(),)),
        BlocProvider<KanbanBoardBloc>(builder: (context) => KanbanBoardBloc(),),
        BlocProvider<StashBloc>(builder: (context) => StashBloc()),
        BlocProvider<AssignmentBloc>(builder: (context) => AssignmentBloc(repository: AssignmentRepository(),))
      ],
      child: GroupworkHubView(groupData:widget.groupData,userData:widget.userData)
    );
  }
}