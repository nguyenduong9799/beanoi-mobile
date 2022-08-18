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
  MenuDTO currentMenu;
  ProductDTO nearlyGift;

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
      currentStore = root.currentStore;
      currentMenu = root.selectedMenu;
      if (root.status == ViewStatus.Error) {
        setState(ViewStatus.Error);
        return;
      }
      if (currentStore.selectedTimeSlot == null) {
        gifts = null;
        setState(ViewStatus.Completed);
        return;
      }
      gifts = await _productDAO.getGifts(currentStore.id, currentMenu.menuId);
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
      gifts += await _productDAO.getGifts(currentStore.id, currentMenu.menuId,
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

  Future<void> getNearlyGiftExchange() async {
    RootViewModel root = Get.find<RootViewModel>();
    CampusDTO currentStore = root.currentStore;
    currentMenu = root.selectedMenu;
    try {
      setState(ViewStatus.Loading);
      var nearLyGifts = await _productDAO.getGifts(
        currentStore.id,
        currentMenu.menuId,
        params: {"sortBy": "price asc"},
      );

      if (nearLyGifts.length > 0) {
        nearlyGift = nearLyGifts[0];
        for (int i = 1; i < nearLyGifts.length; i++) {
          if (nearlyGift.price > nearLyGifts[i].price) {
            nearlyGift = nearLyGifts[i];
          }
        }
      } else {
        nearlyGift = null;
      }
      setState(ViewStatus.Completed);
    } catch (e) {
      nearlyGift = null;
      print(e);
      setState(ViewStatus.Completed);
      // setState(ViewStatus.Error);
    }
  }
}
