
import 'package:peeps/models/discussion.dart';
import 'package:peeps/resources/base_respository.dart';
import 'package:peeps/resources/common_repo.dart';
import 'package:meta/meta.dart';


class ForumRepository extends BaseRepositry{


  ForumRepository({
    @required namespace,
    @required data,
  }):super(namespace:namespace,data:data);

  @override
  create(data) async {
    await super.create(data.toJson());
  }

  @override
  delete() {
    // TODO: implement delete
    return null;
  }

  @override
  read() async {
    List discussions = [];
    var data = await super.read();
    for(Map<String,dynamic> discussion in data['discussions']){
      discussions.add(DiscussionModel.fromJson(discussion));
    }
    return discussions;
  }

  @override
  update() {
    // TODO: implement update
    return null;
  }

  
}