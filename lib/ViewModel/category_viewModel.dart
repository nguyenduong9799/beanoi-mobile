import 'package:get/get.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DAO/CategoryDAO.dart';
import 'package:unidelivery_mobile/Model/DTO/CampusDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/CategoryDTO.dart';
import 'package:unidelivery_mobile/Utils/index.dart';
import 'package:unidelivery_mobile/ViewModel/base_model.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';

class CategoryViewModel extends BaseModel {
  CategoryDAO _categoryDAO;

  List<CategoryDTO> categories;

  CategoryViewModel() {
    _categoryDAO = CategoryDAO();
  }

  Future getCategories() async {
    RootViewModel root = Get.find<RootViewModel>();
    CampusDTO currentCampus = await getStore();
    try {
      setState(ViewStatus.Loading);

      categories = await _categoryDAO.getCategories(
        currentCampus.id,
        currentCampus.selectedTimeSlot,
      );
      setState(ViewStatus.Completed);
    } catch (e) {
      print(e);
      setState(ViewStatus.Error);
    }
  }
}
