import 'package:get/get.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';

import 'index.dart';

class BlogsViewModel extends BaseModel {
  StoreDAO _storeDAO;
  List<BlogDTO> blogs;

  BlogsViewModel() {
    _storeDAO = StoreDAO();
  }

  Future<void> getBlogs() async {
    try {
      setState(ViewStatus.Loading);
      RootViewModel root = Get.find<RootViewModel>();
      // await root.fetchStore();
      CampusDTO currentStore = root.currentStore;
      if (root.status == ViewStatus.Error) {
        setState(ViewStatus.Error);
        return;
      }
      if (blogs == null) {
        blogs = await _storeDAO.getBlogs(currentStore.id);
      }
      await Future.delayed(Duration(microseconds: 500));
      // check truong hop product tra ve rong (do khong co menu nao trong TG do)
      setState(ViewStatus.Completed);
    } catch (e) {
      blogs = null;
      setState(ViewStatus.Completed);
    }
  }
}
