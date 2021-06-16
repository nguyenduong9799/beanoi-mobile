import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Utils/index.dart';
import 'package:unidelivery_mobile/ViewModel/base_model.dart';

class ProductFilterViewModel extends BaseModel {
  List<ProductDTO> listProducts;
  ProductDAO _productDAO;

  ProductFilterViewModel() {
    _productDAO = ProductDAO();
  }

  Future getProductsWithFilter({Map<String, dynamic> params = const {}}) async {
    try {
      setState(ViewStatus.Loading);
      CampusDTO currentStore = await getStore();
      var products = await _productDAO.getAllProductOfStore(
        currentStore.id,
        currentStore.selectedTimeSlot,
        params: params,
      );
      listProducts = products;
      setState(ViewStatus.Completed);
    } catch (e) {
      setState(ViewStatus.Error, e.toString());
    }
  }
}
