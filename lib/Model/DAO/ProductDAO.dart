import 'package:dio/dio.dart';
import 'package:unidelivery_mobile/Constraints/constraints.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Utils/index.dart';
import 'index.dart';

class ProductDAO extends BaseDAO {
  Future<List<ProductDTO>> getProducts(
    int storeId,
    int supplierId,
    int menuId, {
    int page = 1,
    int size = 50,
    int type,
    Map<String, dynamic> params = const {},
  }) async {
    Response res;

    if (type != null) {
      res = await request.get(
          // 'stores/$storeId/suppliers/$supplierId/products?fields=ChildProducts&fields=CollectionId&fields=Extras&menu-id=${menuId}',
          'stores/${storeId}/suppliers/${supplierId}/products?menu-id=${menuId}',
          queryParameters: {
            // "page": page ?? 1,
            // "product-type-id": type,
            "size": size ?? DEFAULT_SIZE
          }..addAll(params));
    } else {
      res = await request.get(
        // 'stores/$storeId/suppliers/$supplierId/products?fields=ChildProducts&fields=CollectionId&fields=Extras&menu-id=${menuId}',
        'stores/${storeId}/suppliers/${supplierId}/products?menu-id=${menuId}',
        queryParameters: {"size": size ?? DEFAULT_SIZE}..addAll(params),
      );
    }

    //final res = await Dio().get("http://api.dominos.reso.vn/api/v1/products");
    final products = ProductDTO.fromList(res.data["data"]);
    metaDataDTO = MetaDataDTO.fromJson(res.data["metadata"]);
    return products;
  }

  Future<List<ProductDTO>> getGifts(
    int storeId,
    int menuId, {
    int page,
    int size,
    int type,
    Map<String, dynamic> params = const {},
  }) async {
    Response res = await request.get(
      'stores/$storeId/products',
      // 'areas/${storeId}/menus/${menuId}/products',
      queryParameters: {
        "page": page ?? 1,
        "size": size ?? DEFAULT_SIZE,
        "product-type-id": ProductType.GIFT_PRODUCT,
        "menu-id": menuId,
      }..addAll(params),
    );
    var jsonList = res.data["data"] as List;
    if (jsonList != null) {
      final products = ProductDTO.fromList(res.data["data"]);
      metaDataDTO = MetaDataDTO.fromJson(res.data["metadata"]);
      return products;
    }
    return null;
  }

  Future<List<ProductDTO>> getAllProductOfStore(int storeId, int menuID,
      {int page,
      int size,
      int type,
      Map<String, dynamic> params = const {}}) async {
    final query = convertToQueryParams({
      "page": (page ?? 1).toString(),
      "size": (size ?? DEFAULT_SIZE).toString(),
      "menu-id": menuID,
      "fields": ['ChildProducts', 'CollectionId', 'Extras']
    }..addAll(params));

    String queryStr = Uri(
      queryParameters: query,
    ).query;
    Response res = await request.get('stores/$storeId/products?$queryStr');

    final products = ProductDTO.fromList(res.data["data"]);
    metaDataDTO = MetaDataDTO.fromJson(res.data["metadata"]);
    return products;
  }

  Future<ProductDTO> getProductDetail(int id, int storeId, int menuId) async {
    final query = convertToQueryParams({
      "menu-id": menuId,
      "store-id": storeId,
      "fields": ['ChildProducts', 'CollectionId', 'Extras']
    });
    String queryStr = Uri(
      queryParameters: query,
    ).query;
    Response res = await request.get('products/$id?$queryStr');

    final products = ProductDTO.fromJson(res.data);
    return products;
  }

  Future<List<ProductDTO>> getListGiftMenus(
    int areaID, {
    int page,
    int size,
    int type,
    Map<String, dynamic> params = const {},
  }) async {
    // final res = await request.get(
    //   'stores/$areaID/gifts?menu-id=${}',
    //   queryParameters: {"page": page ?? 1, "size": size ?? DEFAULT_SIZE}
    //     ..addAll(params),
    // );
    // var jsonList = res.data["data"] as List;
    // //metaDataDTO = MetaDataDTO.fromJson(res.data["metadata"]);
    // if (jsonList != null) {
    //   final products = ProductDTO.fromList(res.data["data"]);
    // metaDataDTO = MetaDataDTO.fromJson(res.data["metadata"]);
    final products = null;
    return products;
    // }
    // return null;
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
