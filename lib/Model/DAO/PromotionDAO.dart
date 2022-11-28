import 'package:dio/dio.dart';
import 'package:unidelivery_mobile/Model/DTO/GiftDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Utils/index.dart';
import 'index.dart';

class PromotionDAO extends BaseDAO {
  Future<List<VoucherDTO>> getPromotions() async {
    List<VoucherDTO> vouchers;
    Response response = await request.get('promotions?promotion-type=2');
    // set access token
    if (response.statusCode == 200) {
      vouchers = VoucherDTO.fromList(response.data["data"]);
    }
    return vouchers;
  }

  Future<List<GiftDTO>> getMyPromotions() async {
    List<GiftDTO> myVouchers;
    Response response = await request.get('me/vouchers');
    // set access token
    if (response.statusCode == 200) {
      myVouchers = GiftDTO.fromList(response.data["data"]);
      print(myVouchers);
    }
    return myVouchers;
  }
}
