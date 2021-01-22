import 'package:dio/dio.dart';
import 'package:unidelivery_mobile/Model/DAO/BaseDAO.dart';
import 'package:unidelivery_mobile/Model/DTO/MetaDataDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/ProductDTO.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/utils/request.dart';

class ProductDAO extends BaseDAO {
  // 1. Get Product List from API
  Future<List<ProductDTO>> getProducts(int store_id, int supplier_id,
      {int page, int size, int type}) async {
    Response res;
    if (type != null) {
      res = await request.get(
          'stores/$store_id/suppliers/$supplier_id/products?fields=ChildProducts&fields=CollectionId&fields=Extras',
          queryParameters: {"page": page ?? 1, "product-type-id": type});
    } else {
      res = await request.get(
          'stores/$store_id/suppliers/$supplier_id/products?fields=ChildProducts&fields=CollectionId&fields=Extras',
          queryParameters: {"page": page ?? 1});
    }

    //final res = await Dio().get("http://api.dominos.reso.vn/api/v1/products");
    final products = ProductDTO.fromList(res.data["data"]);
    metaDataDTO = MetaDataDTO.fromJson(res.data["metadata"]);
    return products;
  }

  Future<List<ProductDTO>> getGifts(int store_id,
      {int page, int size, int type}) async {
    Response res = await request.get('stores/$store_id/gifts',
        queryParameters: {"page": page ?? 1, "size": size ?? DEFAULT_SIZE});

    //final res = await Dio().get("http://api.dominos.reso.vn/api/v1/products");
    final products = ProductDTO.fromList(res.data["data"]);
    metaDataDTO = MetaDataDTO.fromJson(res.data["metadata"]);
    return products;
  }

  // Future<List<ProductDTO>> getExtraProducts(
  //     int cat_id, String sup_id, int store_id) async {
  //   print("Category id: " + cat_id.toString());
  //   final res = await request.get('/extra-products', queryParameters: {
  //     "brand-id": UNIBEAN_BRAND,
  //     "cat-id": cat_id,
  //     "store-id": store_id,
  //     "supplier-id": sup_id,
  //   });
  //   final products = ProductDTO.fromList(res.data['data']);
  //   return products;
  // }

  // dynamic normalizeProducts(dynamic data) {
  //   final products = data["products"];
  //   final storeId = data["id"];
  //   final storename = data["name"];
  //
  //   return products.map((e) {
  //     e['storeId'] = storeId;
  //     e['storeName'] = storename;
  //     return e;
  //   }).toList();
  // }
}
