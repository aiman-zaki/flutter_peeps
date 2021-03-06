

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:peeps/bloc/bloc.dart';
import 'package:peeps/models/user.dart';

import 'package:peeps/screens/common/custom_search.dart';


class SearchView extends StatefulWidget {
  SearchView({Key key}) : super(key: key);

  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {

  Widget build(BuildContext context) {
    final _bloc = BlocProvider.of<SearchGroupsBloc>(context);
    final _profileBloc = BlocProvider.of<ProfileBloc>(context);

    UserModel currentUser = (_profileBloc.state as ProfileLoaded).data;

    List datas = [];
    
    _dataFromState(){
      var currentState = _bloc.state;
      if(currentState is LoadedGroupsState){
        return currentState.data;
      }
    }

    datas = _dataFromState();

    _buildRequestButton(groupwork){
      return RaisedButton(
        onPressed: (){
          Map<String,dynamic> data = {
            "group_id":groupwork.id,
            "request_date":DateTime.now().toString(),
          };
          _bloc.add(RequestGrouptEvent(data: data));
        },
        child: Text("Request to join"),
      );
    }

    Widget _listViewChild(groupwork){
      return Slidable(
        actionPane: SlidableScrollActionPane(),
        secondaryActions: <Widget>[
          IconSlideAction(
            icon: Icons.fast_forward,
            color: Colors.blue,
            caption: "Request to Join",
            onTap: (){
              _bloc.add(RequestGrouptEvent(data: {
                "group_id":groupwork.id,
                "request_date":DateTime.now().toString(),
              }));
            },
          ),
          IconSlideAction(
            icon: Icons.explicit,
            color: Colors.orange,
            caption: "Superise",
            onTap: (){
              //TODO 
              _bloc.add(RequestSuperviseGroupEvent(data: {}));
            },
          )
        ],
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListTile(
              title: Text(groupwork.name),
            ),
          ),
        ),
      );
    }

    _searchInput(String searchIn){
      _bloc.add(SearchGroupsButtonClickedEvent(data: searchIn.toUpperCase()));
    }

    _showLoadingDialog(){
      showDialog(
        context: context,
        builder: (context){
          return SimpleDialog(
            children: <Widget>[
              Center(child: CircularProgressIndicator())
            ],
          );
        }
      );
    }


    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: BlocListener(
        bloc: _bloc,
        listener: (context,state){
          if(state is LoadingGroupsState){
            _showLoadingDialog();
          }
          if(state is LoadedGroupsState){
            Navigator.pop(context);
            setState(() {
              
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomSearch(
            searchInput: _searchInput,
            data: datas,
            listViewChild: _listViewChild,
            textInputLabel: "Code",
          ),
        )
      ),
    );
    
  }
}

