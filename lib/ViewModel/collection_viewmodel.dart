import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';

import 'index.dart';

class HomeCollectionViewModel extends BaseModel {
  CollectionDAO _collectionDAO;
  List<CollectionDTO> homeCollections;

  HomeCollectionViewModel() {
    _collectionDAO = CollectionDAO();
  }

  Future<void> getCollections() async {
    try {
      setState(ViewStatus.Loading);
      RootViewModel root = Get.find<RootViewModel>();
      var currentStore = root.currentStore;
      MenuDTO currentMenu = root.selectedMenu;
      if (root.status == ViewStatus.Error) {
        setState(ViewStatus.Error);
        return;
      }
      if (currentMenu == null) {
        homeCollections = null;
        setState(ViewStatus.Completed);
        return;
      }
      homeCollections = await _collectionDAO
          .getCollections(currentMenu.menuId, params: {"show-on-home": true});
      await Future.delayed(Duration(microseconds: 500));
      setState(ViewStatus.Completed);
    } catch (e) {
      homeCollections = null;
      setState(ViewStatus.Completed);
    }
  }
}
