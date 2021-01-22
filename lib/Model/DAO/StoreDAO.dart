import 'package:unidelivery_mobile/Model/DAO/BaseDAO.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/utils/request.dart';

class StoreDAO extends BaseDAO {
  // 1. Get Product List from API
  Future<List<StoreDTO>> getStores() async {
    final res = await request.get('stores', queryParameters: {
      "type": VIRTUAL_STORE_TYPE,
      "main-store": false,
      "has-menu": true
    });
    var jsonList = res.data["data"] as List;
    if (jsonList != null) {
      List<StoreDTO> list = jsonList.map((e) => StoreDTO.fromJson(e)).toList();
      return list;
    }
    return null;
  }

  Future<List<StoreDTO>> getSuppliers(int storeId, {int page, int size}) async {
    final res = await request.get('stores/$storeId/suppliers',
        queryParameters: {"size": size ?? DEFAULT_SIZE, "page": page ?? 1});
    var jsonList = res.data["data"] as List;
    //metaDataDTO = MetaDataDTO.fromJson(res.data["metadata"]);
    if (jsonList != null) {
      List<StoreDTO> list = jsonList.map((e) => StoreDTO.fromJson(e)).toList();
      return list;
    }
    return null;
  }

  Future<List<BlogDTO>> getBlogs(int store_id) async {
    final res = await request.get("/stores/${store_id}/blog_posts",
        queryParameters: {"active": true});
    if (res.data['data'] != null) {
      var listJson = res.data['data'] as List;
      return listJson.map((e) => BlogDTO.fromJson(e)).toList();
    }
    return null;
  }
}
