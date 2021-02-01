import 'package:unidelivery_mobile/Model/DTO/CollectionDTO.dart';
import 'package:unidelivery_mobile/utils/request.dart';

class CollectionDAO{

  Future<List<CollectionDTO>> getCollections(int storeId, int supplier_id) async {
    final res = await request.get('stores/${storeId}/suppliers/$supplier_id/collections');
    //final res = await Dio().get("http://api.dominos.reso.vn/api/v1/products");
    final categories = CollectionDTO.fromList(res.data["data"]);
    return categories;
  }

}