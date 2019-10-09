import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:peeps/bloc/bloc.dart';
import 'package:peeps/configs/theme.dart';
import 'package:peeps/models/user.dart';
import 'package:peeps/router/navigator_args.dart';
import 'package:peeps/routing_constant.dart';
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerView extends StatefulWidget {
  DrawerView({Key key}) : super(key: key);

  _DrawerViewState createState() => _DrawerViewState();
}

class _DrawerViewState extends State<DrawerView> {
  UserModel currentUser;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileBloc>(context).dispatch(LoadProfileEvent());
    currentUser = UserModel.defaultConst();
  }

  @override
  Widget build(BuildContext context) {
    final _authBloc = BlocProvider.of<AuthenticationBloc>(context);
    final _profileBloc = BlocProvider.of<ProfileBloc>(context);

    _theme() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      return preferences.getBool('theme') != null ? preferences.getBool('theme') : true;
    }

    _themeSwitch() {
      return FutureBuilder(
        future: _theme(),
        builder: (context, theme) {
          if (theme.connectionState == ConnectionState.done) {
            return Container(
              child: Switch(
                value: theme.data,
                onChanged: (val) {
                  setState(() {
                    ThemeController.setTheme(val);
                  });
                },
              ),
            );
          }
          return Container();
        },
      );
    }

    Drawer _drawerContent(BuildContext context, user) {
      DrawerHeader header = new DrawerHeader(
        child: Column(
          children: <Widget>[
            Text(user.email),
            _themeSwitch(),
          ],
        ),
      );

      ListTile item(IconData icon, String title, String routeName) {
        return new ListTile(
          leading: new Icon(icon),
          title: new Text(title),
          onTap: () {
            if (routeName == "/") {
              Navigator.pushReplacementNamed(context, routeName);
            } else if (routeName == AccountViewRoute ||
                routeName == GroupsViewRoute) {
              Navigator.pushNamed(context, routeName,
                  arguments:
                      NavigatorArguments(bloc: _profileBloc, data: user));
            } else {
              Navigator.pushNamed(context, routeName);
            }
          },
        );
      }

      List<StatelessWidget> drawerChildren = [
        header,
        item(Icons.mail, "Inbox", InboxBottomBarViewRoute),
        item(Icons.group, "Groups", GroupsViewRoute),
        item(Icons.search, "Groups Search", SearchViewRoute),
      ];


      _supervisorDrawer(){
        if(user.role == 1){
          return Column(
            children: <Widget>[
              Divider(),
              item((FontAwesomeIcons.markdown), "Marking", "routeName")
            ],
          );
        }
        return Container();
      }


      Widget _footerDrawer() {
        return Container(
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: Container(
              child: Column(
                children: <Widget>[
       
                  Divider(),
                  item(Icons.account_box, "Account", AccountViewRoute),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('Logout'),
                    onTap: () {
                      Navigator.pop(context);
                      _authBloc.dispatch(LoggedOut());
                    },
                  )
                ],
              ),
            ),
          ),
        );
      }

      ListView listView = new ListView(children: drawerChildren);

      return new Drawer(
        child: new Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: listView,
            ),
            Expanded(
              flex: 2,
              child: _supervisorDrawer(),
            ),
            _footerDrawer(),
          ],
        ),
      );
    }

  
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: new AppBar(
        title: new Text("Home"),
      ),
      body: BlocListener(
        bloc: _profileBloc,
        listener: (context, state) {
          if (state is ProfileLoading) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Loading User Information"),
            ));
          }
          if (state is ProfileLoaded) {
            setState(() {
              currentUser = state.data;
            });
            Scaffold.of(context).removeCurrentSnackBar();
            Scaffold.of(context).showSnackBar(
              SnackBar(
                duration: Duration(seconds: 2),
                content: Text("User Information Loaded"),
              ),
            );
          }
        },
        child: new SingleChildScrollView(
          child: HomeView(),
        ),
      ),
      drawer: _drawerContent(context, currentUser),
    );
  }
}