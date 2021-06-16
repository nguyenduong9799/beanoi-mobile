import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';

import 'index.dart';

class GiftViewModel extends BaseModel {
  ProductDAO _productDAO;
  List<ProductDTO> gifts;
  ScrollController giftScrollController;
  CampusDTO currentStore;

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
      setState(ViewStatus.Loading);
      RootViewModel root = Get.find<RootViewModel>();
      await root.fetchStore();
      currentStore = root.currentStore;
      if (root.status == ViewStatus.Error) {
        setState(ViewStatus.Error);
        return;
      }
      if (currentStore.selectedTimeSlot == null) {
        gifts = null;
        setState(ViewStatus.Completed);
        return;
      }
      gifts = await _productDAO.getGifts(
          currentStore.id, currentStore.selectedTimeSlot);
      await Future.delayed(Duration(microseconds: 500));
      // check truong hop product tra ve rong (do khong co menu nao trong TG do)
      setState(ViewStatus.Completed);
    } catch (e) {
      gifts = null;
      setState(ViewStatus.Completed);
    }
  }

  Future<void> getMoreGifts() async {
    try {
      setState(ViewStatus.LoadMore);
      gifts += await _productDAO.getGifts(
          currentStore.id, currentStore.selectedTimeSlot,
          page: _productDAO.metaDataDTO.page + 1);

      await Future.delayed(Duration(milliseconds: 1000));
      // check truong hop product tra ve rong (do khong co menu nao trong TG do)
      setState(ViewStatus.Completed);
    } catch (e) {
      bool result = await showErrorDialog();
      if (result) {
        await getMoreGifts();
      } else
        setState(ViewStatus.Error);
    }
  }
}
