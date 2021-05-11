import 'package:dio/dio.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Utils/index.dart';

import 'index.dart';


class StoreDAO extends BaseDAO {
  // 1. Get Product List from API
  Future<List<CampusDTO>> getStores({int id}) async {
    Response res;
    if(id != null){
      res = await request.get('stores', queryParameters: {
        "type": VIRTUAL_STORE_TYPE,
        "main-store": false,
        "has-menu": true,
        "id" : id
      });
    }else{
      res = await request.get('stores', queryParameters: {
        "type": VIRTUAL_STORE_TYPE,
        "main-store": false,
        "has-menu": true,
      });
    }
    var jsonList = res.data["data"] as List;
    if (jsonList != null) {
      List<CampusDTO> list =
          jsonList.map((e) => CampusDTO.fromJson(e)).toList();
      return list;
    }
    return null;
  }

  Future<List<SupplierDTO>> getSuppliers(int storeId, TimeSlot time_slot,
      {int page, int size}) async {
    final res = await request.get(
        'stores/$storeId/suppliers?time-slot=${time_slot.from.toString()}&time-slot=${time_slot.to.toString()}',
        queryParameters: {"size": size ?? DEFAULT_SIZE, "page": page ?? 1});
    var jsonList = res.data["data"] as List;
    //metaDataDTO = MetaDataDTO.fromJson(res.data["metadata"]);
    if (jsonList != null) {
      List<SupplierDTO> list =
          jsonList.map((e) => SupplierDTO.fromJson(e)).toList();
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

  Future<List<LocationDTO>> getLocations(int storeId) async {
    final res = await request.get('stores/$storeId/locations');
    var jsonList = res.data["data"] as List;
    //metaDataDTO = MetaDataDTO.fromJson(res.data["metadata"]);
    if (jsonList != null) {
      List<LocationDTO> list =
          jsonList.map((e) => LocationDTO.fromJson(e)).toList();
      return list;
    }
    return null;
  }
}
