import 'package:flutter/material.dart';


class TaskReviewForm extends StatefulWidget {
  TaskReviewForm({Key key}) : super(key: key);

  _TaskReviewFormState createState() => _TaskReviewFormState();
}

class _TaskReviewFormState extends State<TaskReviewForm> {
  
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form"),
      ),
      body: Container(
        padding: EdgeInsets.all(9),
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(

              ),
            ],
          ),
        ),
      ),
    );
  }
}