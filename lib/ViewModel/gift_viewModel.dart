import 'package:flutter/material.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';
import '../constraints.dart';

class GiftViewModel extends BaseModel {
  static GiftViewModel _instance;

  static GiftViewModel getInstance() {
    if (_instance == null) {
      _instance = GiftViewModel();
    }
    return _instance;
  }

  static void destroyInstance() {
    _instance = null;
  }

  ProductDAO _productDAO;
  bool changeAddress = false;

  List<ProductDTO> gifts;
  ScrollController giftScrollController;

  GiftViewModel() {
    _productDAO = ProductDAO();

    giftScrollController = ScrollController();
    giftScrollController.addListener(() async {
      if (giftScrollController.position.pixels ==
          giftScrollController.position.maxScrollExtent) {
        int total_page = (_productDAO.metaDataDTO.total / DEFAULT_SIZE).ceil();
        if (total_page > _productDAO.metaDataDTO.page) {
          await getMoreGifts();
        }
      }
    });
  }

  Future<void> getGifts() async {
    try {
      if (status != ViewStatus.Loading) {
        setState(ViewStatus.Loading);
      }
      CampusDTO currentStore = RootViewModel.getInstance().currentStore;

      gifts = await _productDAO.getGifts(
          currentStore.id, currentStore.selectedTimeSlot);
      await Future.delayed(Duration(microseconds: 500));
      // check truong hop product tra ve rong (do khong co menu nao trong TG do)
      setState(ViewStatus.Completed);
    } catch (e, stacktrace) {
      print(stacktrace.toString());
      bool result = await showErrorDialog();
      if (result) {
        await getGifts();
      } else
        setState(ViewStatus.Error);
    }
  }

  Future<void> getMoreGifts() async {
    try {
      setState(ViewStatus.LoadMore);

      CampusDTO currentStore = RootViewModel.getInstance().currentStore;
      gifts += await _productDAO.getGifts(
          currentStore.id, currentStore.selectedTimeSlot,
          page: _productDAO.metaDataDTO.page + 1);

      await Future.delayed(Duration(milliseconds: 1000));
      // check truong hop product tra ve rong (do khong co menu nao trong TG do)
      setState(ViewStatus.Completed);
    } catch (e, stacktrace) {
      bool result = await showErrorDialog();
      if (result) {
        await getMoreGifts();
      } else
        setState(ViewStatus.Error);
    }
  }
}
