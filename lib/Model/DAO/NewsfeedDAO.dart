import 'package:dio/dio.dart';
import 'package:unidelivery_mobile/Model/DTO/NewsfeedDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Utils/index.dart';

class NewsfeedDAO {
  MetaDataDTO _metaDataDTO;

  MetaDataDTO get metaDataDTO => _metaDataDTO;

  Future<List<NewsfeedDTO>> getNewsfeeds({
    Map<String, dynamic> params,
  }) async {
    Response res = await request.get(
      'newsfeed',
      queryParameters: params,
    );

    final newsfeed = NewsfeedDTO.fromList(res.data["data"]);

    print(newsfeed);
    return newsfeed;
  }

  set metaDataDTO(MetaDataDTO value) {
    _metaDataDTO = value;
  }
}
