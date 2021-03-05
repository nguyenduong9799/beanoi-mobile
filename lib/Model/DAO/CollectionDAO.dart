import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/utils/request.dart';

class CollectionDAO {
  Future<List<CollectionDTO>> getCollections(
      int storeId, int supplier_id, TimeSlot time_slot) async {
    final res = await request.get(
        'stores/${storeId}/suppliers/$supplier_id/collections?time-slot=${time_slot.from.toString()}&time-slot=${time_slot.to.toString()}');
    //final res = await Dio().get("http://api.dominos.reso.vn/api/v1/products");
    final categories = CollectionDTO.fromList(res.data["data"]);
    return categories;
  }
}
