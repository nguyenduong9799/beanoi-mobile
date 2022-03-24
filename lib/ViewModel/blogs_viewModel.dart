import 'package:get/get.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';

import 'index.dart';

class BlogsViewModel extends BaseModel {
  StoreDAO _storeDAO;
  List<BlogDTO> blogs;
  BlogDTO dialogBlog;

  BlogsViewModel() {
    _storeDAO = StoreDAO();
  }

  Future<void> getBlogs() async {
    try {
      setState(ViewStatus.Loading);
      // RootViewModel root = Get.find<RootViewModel>();
      // CampusDTO currentStore = root.currentStore;
      // if (root.status == ViewStatus.Error) {
      //   setState(ViewStatus.Error);
      //   return;
      // }
      if (blogs == null) {
        blogs = await _storeDAO.getBlogs(150);
      }
      await Future.delayed(Duration(microseconds: 500));
      // check truong hop product tra ve rong (do khong co menu nao trong TG do)
      setState(ViewStatus.Completed);
    } catch (e) {
      blogs = null;
      setState(ViewStatus.Completed);
    }
  }

  Future<void> getDialogBlog() async {
    try {
      setState(ViewStatus.Loading);
      if (blogs == null) {
        blogs = await _storeDAO.getBlogs(150);
        dialogBlog = blogs.firstWhere((element) => element.isDialog == true,
            orElse: () => null);
      } else {
        dialogBlog = blogs.firstWhere((element) => element.isDialog == true,
            orElse: () => null);
      }
      await Future.delayed(Duration(microseconds: 500));
      // check truong hop product tra ve rong (do khong co menu nao trong TG do)
      setState(ViewStatus.Completed);
    } catch (e) {
      dialogBlog = null;
      setState(ViewStatus.Completed);
    }
  }
}
