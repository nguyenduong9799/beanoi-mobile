import 'package:get/get.dart';
import 'package:unidelivery_mobile/Accessories/dialog.dart';
import 'package:unidelivery_mobile/Constraints/route_constraint.dart';
import 'package:unidelivery_mobile/Enums/view_status.dart';
import 'package:unidelivery_mobile/Model/DAO/PromotionDAO.dart';
import 'package:unidelivery_mobile/Model/DTO/CartDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/GiftDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/VoucherDTO.dart';
import 'package:unidelivery_mobile/Utils/shared_pref.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'index.dart';

class PromoViewModel extends BaseModel {
  List<VoucherDTO> vouchers;
  List<GiftDTO> myVouchers;
  List<bool> selections = [true, false];
  PromotionDAO promoDao;

  PromoViewModel() {
    promoDao = new PromotionDAO();
  }

  Future<void> changeStatus(int index) async {
    selections = selections.map((e) => false).toList();
    selections[index] = true;
    notifyListeners();
    if (selections[0] == true) {
      await getMyVouchers();
    }

    await getVouchers();
  }

  Future<void> getMyVouchers() async {
    setState(ViewStatus.Loading);
    final myVoucherList = await promoDao.getMyPromotions();
    myVouchers = myVoucherList;
    setState(ViewStatus.Completed);
  }

  Future<void> getVouchers() async {
    setState(ViewStatus.Loading);
    final voucherList = await promoDao.getPromotions();
    vouchers = voucherList;
    setState(ViewStatus.Completed);
  }
}
