import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DAO/NewsfeedDAO.dart';
import 'package:unidelivery_mobile/Model/DTO/NewsfeedDTO.dart';
import 'package:unidelivery_mobile/ViewModel/base_model.dart';

class NewsfeedViewModel extends BaseModel {
  NewsfeedDAO newsfeedDAO;

  List<NewsfeedDTO> newsfeeds;

  NewsfeedViewModel() {
    newsfeedDAO = NewsfeedDAO();
  }

  Future getNewsfeed({Map<String, dynamic> params}) async {
    try {
      setState(ViewStatus.Loading);
      newsfeeds = await newsfeedDAO.getNewsfeeds(params: params);
      setState(ViewStatus.Completed);
    } catch (e) {
      print(e);
      setState(ViewStatus.Error);
    }
  }
}
