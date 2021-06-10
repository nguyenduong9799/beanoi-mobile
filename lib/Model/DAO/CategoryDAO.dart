import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Utils/index.dart';

class CategoryDAO {
  MetaDataDTO _metaDataDTO;

  MetaDataDTO get metaDataDTO => _metaDataDTO;

  Future<List<CategoryDTO>> getCategories({
    Map<String, dynamic> params = const {},
  }) async {
    Response res = await request.get(
      'categories',
      queryParameters: {}..addAll(params),
      options: buildCacheOptions(Duration(minutes: 5)),
    );

    //final res = await Dio().get("http://api.dominos.reso.vn/api/v1/products");
    final categories = CategoryDTO.fromList(res.data["data"]);
    // metaDataDTO = MetaDataDTO.fromJson(res.data["metadata"]);
    return categories;
  }

  set metaDataDTO(MetaDataDTO value) {
    _metaDataDTO = value;
  }
}
