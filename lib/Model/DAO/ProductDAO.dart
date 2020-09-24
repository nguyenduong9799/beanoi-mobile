import 'package:unidelivery_mobile/Model/DTO/ProductDTO.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/utils/request.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';

class ProductDAO {
  // 1. Get Product List from API
  Future<List<ProductDTO>> getProducts() async {
    final res = await request
        .get('/products', queryParameters: {"brand-id": UNIBEAN_STORE});
    final normalizedRes = normalizeProducts(res.data["data"]);
    await setStore(
        {"id": res.data["data"]['id'], "name": res.data["data"]['name']});
    final products = ProductDTO.fromList(normalizedRes);
    return products;
  }

  Future<List<ProductDTO>> getExtraProducts(int cat_id) async {
    print("Category id: " + cat_id.toString());
    final res = await request.get('/extraproducts',
        queryParameters: {"brand-id": UNIBEAN_STORE, "cat-id": cat_id});
    final products = ProductDTO.fromList(res.data['data']);
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
