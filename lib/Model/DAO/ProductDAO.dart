import 'package:unidelivery_mobile/Model/DTO/ProductDTO.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/utils/request.dart';

class ProductDAO {
  // 1. Get Product List from API
  Future<List<ProductDTO>> getProducts() async {
    final res = await request
        .get('/products', queryParameters: {"brand-id": UNIBEAN_STORE});
    final normalizedRes = normalizeProducts(res.data["data"]);
    final products = ProductDTO.fromList(normalizedRes);
    return products;
  }

  dynamic normalizeProducts(dynamic data) {
    final products = data["products"];
    final storeId = data["id"];
    final storename = data["name"];

    return products.map((e) {
      e['storeId'] = storeId;
      e['storeName'] = storename;
      return e;
    }).toList();
  }
}
