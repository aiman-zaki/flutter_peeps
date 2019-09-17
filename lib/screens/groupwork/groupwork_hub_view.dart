import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peeps/bloc/bloc.dart';
import 'package:peeps/models/assignment.dart';
import 'package:peeps/models/groupwork.dart';
import 'package:peeps/models/member.dart';
import 'package:peeps/models/members.dart';
import 'package:peeps/models/user.dart';
import 'package:peeps/screens/common/custom_milestone.dart';
import 'package:peeps/screens/groupwork/invite_members.dart';

import 'assignment_form.dart';
import 'group_chat.dart';
import 'groupwork_profile.dart';
import 'kanban.dart';

class GroupworkHubView extends StatefulWidget {
  final GroupworkModel groupData;
  final UserModel userData;
  GroupworkHubView({Key key, this.groupData, this.userData}) : super(key: key);

  _GroupworkHubViewState createState() => _GroupworkHubViewState();
}

class _GroupworkHubViewState extends State<GroupworkHubView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _groupChatBloc = BlocProvider.of<GroupChatBloc>(context);
    final _assignmentBloc = BlocProvider.of<AssignmentBloc>(context);
    final _taskBloc = BlocProvider.of<TaskBloc>(context);
    final _membersBloc = BlocProvider.of<MembersBloc>(context);
    final _groupProfileBloc = BlocProvider.of<GroupProfileBloc>(context);
    _stashOverview() {
      return Card(
        elevation: 8,
        color: Colors.grey[850],
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(flex: 3, child: Text('Stash')),
                  Expanded(
                    flex: 1,
                    child: FlatButton(
                      onPressed: () {},
                      child: Text(
                        'Add',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
    }

    //TODO : Brainstorm Feature
    _brainstorm() {}
    _buildMembersList(List<MemberModel> data) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context,index){
          return ListTile(
          leading: Icon(Icons.search),
            title: Text(data[index].email),
          trailing: InkWell(onTap:(){},child: Text("Chat"),),
          );
        }
      );
    }

    //TODO : Members
    _members() {
      return Card(
        elevation: 8,
        color: Colors.grey[850],
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(flex: 3, child: Text('Members')),
                  Expanded(
                    flex: 1,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  BlocProvider<MembersBloc>.value(
                                      value: _membersBloc,
                                      child: InviteMembersView()),
                              fullscreenDialog: true),
                        );
                      },
                      child: Text(
                        'Invite',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
              BlocBuilder<MembersBloc, MembersState>(
                bloc: _membersBloc,
                builder: (context, state) {
                  if (state is InitialMembersState) {
                    _membersBloc.dispatch(
                        LoadMembersEvent(groupId: widget.groupData.id));
                    return Container();
                  }
                  if (state is LoadingMembersState) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state is LoadedMembersState) {
                    return _buildMembersList(state.data);
                  }
                  return Container();
                },
              ),
              SizedBox(
                  width: double.maxFinite,
                  child: RaisedButton(
                    child: Text("Group Chat"),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          child: GroupChatView(
                            room: widget.groupData.id,
                            user: widget.userData,
                          ),
                          value: _groupChatBloc,
                        ),
                      ));
                    },
                  ))
            ],
          ),
        ),
      );
    }

    _buildAssignmentList(List<AssignmentModel> data) {
      return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BlocProvider<TaskBloc>.value(
                  value: _taskBloc,
                  child: KanbanBoardView(
                    data: data[index],
                    groupId: widget.groupData.id,
                  ),
                ),
              ));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Divider(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text(
                        data[index].title,
                        style: TextStyle(color: Colors.blue[700]),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: data[index].status != null
                          ? Text(data[index].status)
                          : Text(""),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text('Latest Task'),
                    ),
                    Expanded(
                      flex: 2,
                      child: data[index].todo.isNotEmpty
                          ? Text(data[index].todo.first.task)
                          : Text("No"),
                    )
                  ],
                )
              ],
            ),
          );
        },
      );
    }

    _buildAssignmentOverview() {
      return Card(
        elevation: 8,
        color: Colors.grey[850],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: <Widget>[
                          Text('Assigment Overview '),
                          InkWell(
                              onTap: () {
                                _assignmentBloc.dispatch(LoadAssignmentEvent(
                                    groupId: widget.groupData.id));
                              },
                              child: Icon(Icons.refresh)),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                  value: _assignmentBloc,
                                  child: AssignmentForm(
                                    groupId: widget.groupData.id,
                                  )),
                              fullscreenDialog: true,
                            ));
                          },
                          child: Text(
                            "New",
                            textAlign: TextAlign.center,
                          )),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(9),
                child: BlocBuilder<AssignmentBloc, AssignmentState>(
                  builder: (BuildContext context, AssignmentState state) {
                    if (state is InitialAssignmentState) {
                      _assignmentBloc.dispatch(
                          LoadAssignmentEvent(groupId: widget.groupData.id));
                      return Container();
                    }
                    if (state is LoadingAssignmentState) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is LoadedAssignmentState) {
                      return _buildAssignmentList(state.data);
                    }
                  },
                ),
              )
            ],
          ),
        ),
      );
    }

    _buildMilestone() {
      return Card(
          elevation: 8,
          color: Colors.grey[850],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Milestone',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: FlatButton(
                          onPressed: () {},
                          child: Text("More", textAlign: TextAlign.center),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                CustomMilestone(
                  totalGoals: 5,
                  completedGoals: 2,
                  icon: Icons.check_circle_outline,
                  completedIcon: Icons.check,
                ),
                SizedBox(
                  height: 2,
                ),
              ],
            ),
          ));
    }

    _buildHeader() {
      return Card(
          elevation: 8,
          color: Colors.grey[850],
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Hero(
                        tag: 'dp',
                        child: CircleAvatar(
                          radius: 30,
                          child: FadeInImage.assetNetwork(
                            image: widget.groupData.profilePicturerUrl,
                            placeholder: "assets/images/male.png",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    //TODO : Hero Bugged , remove the singlescrollview
                    Expanded(
                      flex: 3,
                      child: Hero(
                          flightShuttleBuilder: (flightContext, animation,
                              direction, fromContext, toContext) {
                            return DefaultTextStyle(
                              style: DefaultTextStyle.of(toContext).style,
                              child: SingleChildScrollView(
                                  child: toContext.widget),
                            );
                          },
                          tag: widget.groupData.id,
                          child: Column(
                            children: <Widget>[
                              Builder(
                                builder: (context) => GestureDetector(
                                  child: Text(
                                    "id : ${widget.groupData.id}",
                                    style: TextStyle(
                                        fontSize: 11, color: Colors.cyan[300]),
                                  ),
                                  onLongPress: () {
                                    Clipboard.setData(ClipboardData(
                                        text: widget.groupData.id));
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text("Copied to Clipboard"),
                                    ));
                                  },
                                ),
                              ),
                              Text(
                                "${widget.groupData.name}",
                                style: TextStyle(fontSize: 22),
                              ),
                            ],
                          )),
                    )
                  ],
                ),
                SizedBox(height: 10),
                FlatButton(
                  child: Text("More"),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                              value: _groupProfileBloc,
                              child: GroupworkProfile(
                                data: widget.groupData,
                              )),
                          fullscreenDialog: true),
                    );
                  },
                )
              ],
            ),
          ));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Groupwork Hub"),
          elevation: 0.00,
          backgroundColor: Theme.of(context).backgroundColor,
        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.grey[900]),
          padding: const EdgeInsets.all(5.0),
          child: ListView(
            children: <Widget>[
              _buildHeader(),
              _buildMilestone(),
              _buildAssignmentOverview(),
              _members(),
              _stashOverview(),
            ],
          ),
        ));
  }
}
