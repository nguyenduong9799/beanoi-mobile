import 'package:dio/dio.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Utils/index.dart';
import 'index.dart';

class ProductDAO extends BaseDAO {
  Future<List<ProductDTO>> getProducts(
    int storeId,
    int supplierId,
    TimeSlot timeSlot, {
    int page = 1,
    int size = 20,
    int type,
    Map<String, dynamic> params = const {},
  }) async {
    Response res;

    if (type != null) {
      res = await request.get(
          'stores/$storeId/suppliers/$supplierId/products?fields=ChildProducts&fields=CollectionId&fields=Extras&time-slot=${timeSlot.from.toString()}&time-slot=${timeSlot.to.toString()}',
          queryParameters: {
            "page": page ?? 1,
            "product-type-id": type,
            "size": size ?? DEFAULT_SIZE
          }..addAll(params));
    } else {
      res = await request.get(
        'stores/$storeId/suppliers/$supplierId/products?fields=ChildProducts&fields=CollectionId&fields=Extras&time-slot=${timeSlot.from.toString()}&time-slot=${timeSlot.to.toString()}',
        queryParameters: {"page": page ?? 1, "size": size ?? DEFAULT_SIZE}
          ..addAll(params),
      );
    }

    //final res = await Dio().get("http://api.dominos.reso.vn/api/v1/products");
    final products = ProductDTO.fromList(res.data["data"]);
    metaDataDTO = MetaDataDTO.fromJson(res.data["metadata"]);
    return products;
  }

  Future<List<ProductDTO>> getGifts(
    int storeId,
    TimeSlot timeSlot, {
    int page,
    int size,
    int type,
    Map<String, dynamic> params = const {},
  }) async {
    Response res = await request.get(
      'stores/$storeId/gifts?time-slot=${timeSlot.from.toString()}&time-slot=${timeSlot.to.toString()}',
      queryParameters: {"page": page ?? 1, "size": size ?? DEFAULT_SIZE}
        ..addAll(params),
    );

    //final res = await Dio().get("http://api.dominos.reso.vn/api/v1/products");
    final products = ProductDTO.fromList(res.data["data"]);
    metaDataDTO = MetaDataDTO.fromJson(res.data["metadata"]);
    return products;
  }

  Future<List<ProductDTO>> getAllProductOfStore(int storeId, TimeSlot timeSlot,
      {int page,
      int size,
      int type,
      Map<String, dynamic> params = const {}}) async {
    final query = convertToQueryParams({
      "page": (page ?? 1).toString(),
      "size": (size ?? DEFAULT_SIZE).toString(),
      "time-slot": [timeSlot.from.toString(), timeSlot.to.toString()],
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

  Future<ProductDTO> getProductDetail(int id) async {
    Response res = await request.get('products/$id');

    final products = ProductDTO.fromJson(res.data);
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
