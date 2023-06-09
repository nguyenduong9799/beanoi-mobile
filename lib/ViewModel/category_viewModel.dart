import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DAO/CategoryDAO.dart';
import 'package:unidelivery_mobile/Model/DTO/CategoryDTO.dart';
import 'package:unidelivery_mobile/ViewModel/base_model.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';

class CategoryViewModel extends BaseModel {
  CategoryDAO _categoryDAO;

  List<CategoryDTO> categories;

  CategoryViewModel() {
    _categoryDAO = CategoryDAO();
  }

  Future getCategories({Map<String, dynamic> params}) async {
    try {
      setState(ViewStatus.Loading);
      categories = await _categoryDAO.getCategories(params: params);
      setState(ViewStatus.Completed);
    } catch (e) {
      print(e);
      setState(ViewStatus.Error);
    }
  }
}
