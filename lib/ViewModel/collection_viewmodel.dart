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
      if (root.status == ViewStatus.Error) {
        setState(ViewStatus.Error);
        return;
      }
      if (currentStore.selectedTimeSlot == null) {
        homeCollections = null;
        setState(ViewStatus.Completed);
        return;
      }
      homeCollections = await _collectionDAO.getCollections(
          currentStore.selectedTimeSlot,
          params: {"show-on-home": true});
      await Future.delayed(Duration(microseconds: 500));
      setState(ViewStatus.Completed);
    } catch (e) {
      homeCollections = null;
      setState(ViewStatus.Completed);
    }
  }
}
