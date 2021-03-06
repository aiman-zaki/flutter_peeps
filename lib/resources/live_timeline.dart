


import 'package:peeps/models/contribution.dart';
import 'package:peeps/models/timeline.dart';

import 'package:peeps/resources/socket_io.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

class LiveTimeline extends BaseSocketIO{
  @override
  LiveTimeline({
    @required namespace,
    @required room,
  }):super(namespace:namespace,room:room);

  List<ContributionModel> _timelines = [];
  BehaviorSubject _timelinesController;

  @override
  connect() async{
    await super.connect();
    _timelinesController = BehaviorSubject();
    this.streamData();
  }

  @override
  disconnect() async {
    super.disconnect();
    _timelinesController.close();

  }

  Sink get updateSink =>  _timelinesController.sink;

  Stream get timelineStream => _timelinesController.stream;

  List<ContributionModel> get timelines => _timelines;

  void initialTimelineData(List<ContributionModel> data){
    _timelines = data;
  }

  void sendData(ContributionModel timeline){
    socketIO.emit('send_data', [timeline.toJson()]);
  }

  void streamData(){
    socketIO.on('stream_data',(data){
      _timelines.add(ContributionModel.fromJson(data));
      updateSink.add(data);
    });
  }
}