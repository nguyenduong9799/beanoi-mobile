import 'package:unidelivery_mobile/Model/DTO/StoreDTO.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/utils/request.dart';

class StoreDAO {
  // 1. Get Product List from API
  Future<List<StoreDTO>> getStores() async {
    final res = await request.get('/stores', queryParameters: {
      "type": VIRTUAL_STORE_TYPE,
      "main-store": false,
      "has-menu": true
    });
    var jsonList = res.data["data"] as List;
    if(jsonList != null){
      List<StoreDTO> list = jsonList.map((e) => StoreDTO.fromJson(e)).toList();
      return list;
    }
    return null;
  }

  Future<List<StoreDTO>> getSuppliers(int storeId) async {
    final res = await request.get('/stores/$storeId/suppliers');
    var jsonList = res.data["data"] as List;
    if(jsonList != null){
      List<StoreDTO> list = jsonList.map((e) => StoreDTO.fromJson(e)).toList();
      return list;
    }
    return null;
  }

}
