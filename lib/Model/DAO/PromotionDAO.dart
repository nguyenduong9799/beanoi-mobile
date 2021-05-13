import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Utils/index.dart';
import 'index.dart';


class PromotionDAO extends BaseDAO {
  Future<List<VoucherDTO>> getPromotions() async {
    List<VoucherDTO> vouchers;
    Response response = await request.get('/promotions',
        options: buildCacheOptions(Duration(minutes: 30)));
    // set access token
    if (response.statusCode == 200) {
      vouchers = VoucherDTO.fromList(response.data["data"]);
    }
    return vouchers;
  }
}
