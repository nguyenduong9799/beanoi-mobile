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
  List<MenuDTO> listGiftMenu;
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
      currentMenu = root.selectedMenu;
      currentStore = root.currentStore;
      gifts = await _productDAO.getListGiftMenus(currentStore.id);
      if (root.status == ViewStatus.Error) {
        setState(ViewStatus.Error);
        return;
      }
      if (currentMenu == null) {
        gifts = null;
        setState(ViewStatus.Completed);
        return;
      }
      gifts =
          await _productDAO.getGifts(currentStore.id, listGiftMenu[0].menuId);
      await Future.delayed(Duration(microseconds: 500));
      // check truong hop product tra ve rong (do khong co menu nao trong TG do)
      setState(ViewStatus.Completed);
    } catch (e) {
      gifts = null;
      setState(ViewStatus.Completed);
    }
  }

  Future<void> getMoreGifts() async {
    RootViewModel root = Get.find<RootViewModel>();
    currentMenu = root.selectedMenu;
    gifts = await _productDAO.getListGiftMenus(currentStore.id);
    try {
      setState(ViewStatus.LoadMore);
      gifts += await _productDAO.getGifts(
          currentStore.id, listGiftMenu[0].menuId,
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
    gifts = await _productDAO.getListGiftMenus(currentStore.id);

    try {
      setState(ViewStatus.Loading);
      var nearLyGifts = await _productDAO.getGifts(
        currentStore.id,
        listGiftMenu[0].menuId,
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
