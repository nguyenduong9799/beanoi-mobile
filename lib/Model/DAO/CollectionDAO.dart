import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/utils/request.dart';

class CollectionDAO {
  Future<List<CollectionDTO>> getCollectionsOfSupplier(
      int storeId, int supplierId, TimeSlot timeSlot,
      {Map<String, dynamic> params = const {}}) async {
    final res = await request.get(
      'stores/$storeId/suppliers/$supplierId/collections?time-slot=${timeSlot.from.toString()}&time-slot=${timeSlot.to.toString()}',
      queryParameters: params,
    );
    //final res = await Dio().get("http://api.dominos.reso.vn/api/v1/products");
    final categories = CollectionDTO.fromList(res.data["data"]);
    return categories;
  }

  Future<List<CollectionDTO>> getCollections(TimeSlot timeSlot,{
    Map<String, dynamic> params = const {}
  }) async {
    final res = await request.get(
      'collections?time-slot=${timeSlot.from.toString()}&time-slot=${timeSlot.to.toString()}',
      queryParameters: params,
    );
    final collections = CollectionDTO.fromList(res.data["data"]);
    return collections;
  }
}
