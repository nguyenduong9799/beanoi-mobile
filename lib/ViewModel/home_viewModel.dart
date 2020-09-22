import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Model/DAO/ProductDAO.dart';
import 'package:unidelivery_mobile/Model/DTO/CartDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/ProductDTO.dart';
import 'package:unidelivery_mobile/utils/enum.dart';
import 'package:unidelivery_mobile/utils/request.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';

class Filter {
  final String id;
  final String name;
  bool isSelected;
  bool isMultiple;

  Filter(this.id, this.name,
      {this.isSelected = false, this.isMultiple = false});
}

class HomeViewModel extends Model {
  static HomeViewModel _instance;

  ProductDAO _dao = ProductDAO();

  List<ProductDTO> products;
  Status status;
  bool _isFirstFetch = true;
  List<Filter> filterType = [
    Filter('All', 'Tất cả', isSelected: true),
    Filter('Previous', 'Gần đây'),
    Filter('New', 'Mới'),
  ];

  List<Filter> filterCategories = [
    Filter('com', 'Cơm', isMultiple: true),
    Filter('nuoc', 'Món nước', isMultiple: true),
    Filter('drink', 'Thức uống', isMultiple: true),
  ];

  HomeViewModel() {
    status = Status.Loading;
    // getProducts();
  }

  Future<Cart> get cart async {
    return await getCart();
  }


  static HomeViewModel getInstance() {
    if (_instance == null) {
      _instance = HomeViewModel();
    }
    return _instance;
  }

  static void destroyInstance() {
    _instance = null;
  }

  // 1. Get ProductList with current Filter
  Future<List<ProductDTO>> getProducts() async {
    try {
      status = Status.Loading;
      notifyListeners();
      if (_isFirstFetch) {
        products = await _dao.getProducts();
        _isFirstFetch = false;
        notifyListeners();
      } else {
        // change filter
        // do something with products
        print("Fetch prodyuct with filter");
        products = products.sublist(2)..shuffle();
        notifyListeners();
      }
    } on Exception catch (e) {
      print("EXCEPTION $e");
    } finally {
      status = Status.Completed;
      notifyListeners();
    }

    return products;
  }

  // 2. Change filter

  Future<void> updateFilter(String filterId, bool isMultiple) async {
    if (isMultiple)
      await updateFilterCategories(filterId);
    else
      await updateFilterType(filterId);
    // Update Product List
    await getProducts();
  }

  Future<void> updateFilterType(String filterId) async {
    filterType = filterType.map((filter) {
      if (filter.id == filterId) {
        filter.isSelected = true;
      } else {
        filter.isSelected = false;
      }
      return filter;
    }).toList();
    notifyListeners();
  }

  Future<void> updateFilterCategories(String filterId) async {
    filterCategories = filterCategories.map((filter) {
      if (filter.id == filterId) {
        filter.isSelected = !filter.isSelected;
      }
      return filter;
    }).toList();
    notifyListeners();
  }
}
