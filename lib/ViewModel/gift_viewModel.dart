import 'package:flutter/material.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/base_model.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';

import '../constraints.dart';

class GitfViewModel extends BaseModel {
  static GitfViewModel _instance;

  static GitfViewModel getInstance() {
    if (_instance == null) {
      _instance = GitfViewModel();
    }
    return _instance;
  }

  static void destroyInstance() {
    _instance = null;
  }

  ProductDAO _productDAO;
  ScrollController scrollController;
  List<ProductDTO> gifts;

  GitfViewModel() {
    scrollController = ScrollController();
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        int total_page = (_productDAO.metaDataDTO.total / DEFAULT_SIZE).ceil();
        if (total_page > _productDAO.metaDataDTO.page) {
          await getMoreGifts();
        }
      }
    });
    _productDAO = ProductDAO();
  }

  Future<void> getGifts() async {
    try {
      setState(ViewStatus.Loading);
      StoreDTO store = await getStore();
      if (store == null) {
        bool result = await showErrorDialog();
        if (result) {
          StoreDAO storeDAO = new StoreDAO();
          List<StoreDTO> listStore = await storeDAO.getStores();
          for (StoreDTO dto in listStore) {
            if (dto.id == UNIBEAN_STORE) {
              store = dto;
            }
          }
          await setStore(store);
        } else {
          setState(ViewStatus.Error);
          return;
        }
      }
      gifts = await _productDAO.getGifts(store.id);
      await Future.delayed(Duration(microseconds: 500));
      // check truong hop product tra ve rong (do khong co menu nao trong TG do)
      if (gifts.isEmpty || gifts == null) {
        setState(ViewStatus.Empty);
      } else {
        setState(ViewStatus.Completed);
      }
    } catch (e, stacktrace) {
      print("Excception: " + e.toString() + stacktrace.toString());
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
      StoreDTO store = await getStore();

      print("Get products...");
      gifts += await _productDAO.getGifts(store.id,
          page: _productDAO.metaDataDTO.page + 1);

      await Future.delayed(Duration(milliseconds: 1000));
      // check truong hop product tra ve rong (do khong co menu nao trong TG do)
      setState(ViewStatus.Completed);
    } catch (e, stacktrace) {
      print("Excception: " + e.toString() + stacktrace.toString());
      bool result = await showErrorDialog();
      if (result) {
        await getMoreGifts();
      } else
        setState(ViewStatus.Error);
    }
  }
}
