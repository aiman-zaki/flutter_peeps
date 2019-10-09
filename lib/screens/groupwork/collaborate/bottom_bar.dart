import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:peeps/bloc/groupwork/bloc.dart';
import 'package:peeps/screens/groupwork/collaborate/forum.dart';

import 'user_joined.dart';


class CollaborateBottomBarView extends StatefulWidget {

  final userData;
  final course;

  CollaborateBottomBarView({
    Key key,
    @required this.userData,
    @required this.course,
    }) : super(key: key);

  _CollaborateBottomBarViewState createState() => _CollaborateBottomBarViewState();
}

class _CollaborateBottomBarViewState extends State<CollaborateBottomBarView> {

  var _userJoinedView;
  var _forumView;
  Widget _showPage = new UserJoinedCollaborateView();

  pageChooser(int index){
    switch(index){
      case(0):
        return _userJoinedView;
      case(1):
        return _forumView;
      default:
        return new Container(
          child: Center(child: Text("Not a valid Path"),),
        );
    }
  }

  @override
  void initState() {
    BlocProvider.of<CollaborateBloc>(context).dispatch(InitialCollaborateEvent(userData: widget.userData));
    BlocProvider.of<CollaborateForumBloc>(context).dispatch(LoadForumEvent());
    _forumView = new CollaborateForumView(course: widget.course);
    _userJoinedView = new UserJoinedCollaborateView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _bloc = BlocProvider.of<CollaborateBloc>(context);

    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        color: Theme.of(context).primaryColor,
        backgroundColor: Colors.black,
        buttonBackgroundColor: Colors.black,
        items: <Widget>[
          Icon(FontAwesomeIcons.solidObjectGroup),
          Icon(FontAwesomeIcons.forumbee),
        ],
        onTap: (index){
          setState(() {
            _showPage = pageChooser(index);
          });
        },
      ),
      body: _showPage,
    );
  }
}