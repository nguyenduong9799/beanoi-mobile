import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DAO/CategoryDAO.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Utils/index.dart';
import 'package:unidelivery_mobile/ViewModel/base_model.dart';

class ProductFilterViewModel extends BaseModel {
  List<ProductDTO> listProducts;
  ProductDAO _productDAO;
  CategoryDAO _categoryDAO = CategoryDAO();
  List<CategoryDTO> categories;

  // PARAM
  // PRODUCT-NAME
  // CATEGORY
  // COLLECTION

  Map<String, dynamic> _params = {};

  ProductFilterViewModel() {
    _productDAO = ProductDAO();
  }

  Map<String, dynamic> get params => _params;
  List get categoryParams => _params['category-id'] ?? [];

  setParam(Map<String, dynamic> param) {
    _params.addAll(param);
    print(_params);
    notifyListeners();
  }

  Future getCategories() async {
    try {
      categories = await _categoryDAO.getCategories();
      setState(ViewStatus.Completed);
    } catch (e) {
      setState(ViewStatus.Error, e.toString());
    }
  }

  Future getProductsWithFilter() async {
    try {
      print("Filter param");
      print(params);
      setState(ViewStatus.Loading);
      CampusDTO currentStore = await getStore();
      var products = await _productDAO.getAllProductOfStore(
        currentStore.id,
        currentStore.selectedTimeSlot,
        params: this.params,
      );
      listProducts = products;
      setState(ViewStatus.Completed);
    } catch (e) {
      setState(ViewStatus.Error, e.toString());
    }
  }
}
