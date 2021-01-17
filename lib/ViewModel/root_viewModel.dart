import 'package:get/get.dart';
import 'package:unidelivery_mobile/Model/DAO/AccountDAO.dart';
import 'package:unidelivery_mobile/Model/DAO/StoreDAO.dart';
import 'package:unidelivery_mobile/Model/DTO/AccountDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/BlogDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/CartDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/StoreDTO.dart';
import 'package:unidelivery_mobile/ViewModel/base_model.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';

import '../constraints.dart';
import '../route_constraint.dart';

class RootViewModel extends BaseModel {
  static int ORDER_TIME = 11;
  AccountDAO _dao;
  AccountDTO currentUser;
  String error;
  static RootViewModel _instance;
  StoreDAO _storeDAO;
  bool _endOrderTime = false;
  bool get endOrderTime => _endOrderTime;
  DateTime orderTime = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, ORDER_TIME, 30);

  set endOrderTime(bool value) {
    _endOrderTime = value;
  }

  static RootViewModel getInstance() {

    if (_instance == null) {
      _instance = RootViewModel();
    }
    return _instance;
  }

  static void destroyInstance() {
    _instance = null;
  }

  bool changeAddress = false;

  StoreDTO currentStore, tmp;

  List<StoreDTO> campuses;
  List<StoreDTO> suppliers;
  List<BlogDTO> blogs;

  RootViewModel() {
    _dao = AccountDAO();
    _storeDAO = new StoreDAO();
    if (orderTime.isBefore(DateTime.now())) {
      _endOrderTime = true;
    }
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      setState(ViewStatus.Loading);
      final user = await _dao.getUser();
      currentUser = user;
      if(suppliers != null){
        setState(ViewStatus.Completed);
      }
    } catch (e) {
      bool result = await showErrorDialog();
      if (result) {
        await fetchUser();
      } else
        setState(ViewStatus.Error);
    }
  }

  Future<void> getSuppliers() async {
    try {
      setState(ViewStatus.Loading);
      currentStore = await getStore();

      if (currentStore == null) {
        List<StoreDTO> listStore = await _storeDAO.getStores();
        for (StoreDTO dto in listStore) {
          if (dto.id == UNIBEAN_STORE) {
            currentStore = dto;
            await setStore(dto);
          }
        }
      }

      suppliers = await _storeDAO.getSuppliers(currentStore.id);
      blogs = await _storeDAO.getBlogs(currentStore.id);
      await Future.delayed(Duration(microseconds: 500));
      // check truong hop product tra ve rong (do khong co menu nao trong TG do)
      if (suppliers.isEmpty || suppliers == null) {
        setState(ViewStatus.Empty);
      } else if(currentUser != null) {
        setState(ViewStatus.Completed);
      }
    } catch (e, stacktrace) {
      print("Excception: " + e.toString() + stacktrace.toString());
      bool result = await showErrorDialog();
      if (result) {
        await getSuppliers();
      } else
        setState(ViewStatus.Error);
    }
  }


  Future<void> signOut() async {
    await _dao.logOut();
    await removeALL();
  }

  Future<void> processSignout() async {
    int option = await showOptionDialog("Mình sẽ nhớ bạn lắm ó huhu :'(((");
    if (option == 1) {
      await signOut();
      destroyInstance();
      Get.offAllNamed(RouteHandler.LOGIN);
    }
  }

  Future<void> getLocation() async {
    currentStore = await getStore();
    notifyListeners();
  }

  Future<void> processChangeAddress() async {
    if (currentStore == null) {
      return;
    }
    changeAddress = true;
    tmp = currentStore;
    notifyListeners();
    showLoadingDialog();

    StoreDAO dao = new StoreDAO();
    campuses = await dao.getStores();
    Cart cart = await getCart();

    hideDialog();
    await changeAddressDialog(this, () async {
      hideDialog();
      if (tmp.id != this.currentStore.id) {
        int option = 0;

        if(cart != null){
          option = await showOptionDialog(
              "Bạn có chắc không? Đổi địa chỉ rồi là giỏ hàng m bị xóa đó :))");
        }

        if (option == 1 || cart == null) {
          print("Changing index...");
          currentStore = tmp;
          await deleteCart();
          await setStore(currentStore);
          await getSuppliers();
        }
      }
      changeAddress = false;
      notifyListeners();
    });
  }

  void changeLocation(int id) {
    for (StoreDTO dto in campuses) {
      if (dto.id == id) {
        tmp = dto;
      }
    }
    notifyListeners();
  }

}
