import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';

class Filter {
  final int id;
  final String name;
  bool isSelected;
  bool isMultiple;

  Filter(this.id, this.name,
      {this.isSelected = false, this.isMultiple = false});
}

class HomeViewModel extends Model {
  static HomeViewModel _instance;

  ProductDAO _dao = ProductDAO();
  dynamic error;
  List<ProductDTO> products;
  List<ProductDTO> _cachedProduct;
  ViewStatus status;
  bool _isFirstFetch = true;
  List<Filter> filterType = [
    Filter(47, 'Tất cả', isSelected: true),
    Filter(48, 'Gần đây'),
    Filter(49, 'Mới'),
  ];

  List<Filter> filterCategories = [
    Filter(44, 'Cơm', isMultiple: true),
    Filter(45, 'Món nước', isMultiple: true),
    Filter(46, 'Thức uống', isMultiple: true),
  ];

  HomeViewModel() {
    status = ViewStatus.Loading;
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
      status = ViewStatus.Loading;
      notifyListeners();
      if (_isFirstFetch) {
        products = await _dao.getProducts();
        _cachedProduct = products.sublist(0);
        // products.insertAll(0, products);
        _isFirstFetch = false;
      } else {
        // change filter

        // 1. Filter by type (All,New,History)
        // 2. Filter by Categories
        products = _cachedProduct.where((prod) {
          if (filterCategories.every((category) => !category.isSelected))
            return true;
          bool isInFilter = filterCategories.any((category) =>
              prod.catergoryId == category.id && category.isSelected);
          return isInFilter;
        }).toList();
        // do something with products
        print("Fetch prodyuct with filter");
        // products = products.sublist(2)..shuffle();
        // products = products.sublist(0)..shuffle();
      }
      // check truong hop product tra ve rong (do khong co menu nao trong TG do)
      if (products.isEmpty || products == null) {
        status = ViewStatus.Empty;
      } else {
        status = ViewStatus.Completed;
      }
      notifyListeners();
    } catch (e, stacktrace) {
      print("EXCEPTION $stacktrace");
      status = ViewStatus.Error;
      error = e.toString();
      notifyListeners();
    } finally {
      // notifyListeners();
    }

    return products;
  }

  // 2. Change filter

  Future<void> updateFilter(int filterId, bool isMultiple) async {
    if (isMultiple)
      await updateFilterCategories(filterId);
    else
      await updateFilterType(filterId);
    // Update Product List
    await getProducts();
  }

  Future<void> updateFilterType(int filterId) async {
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

  Future<void> updateFilterCategories(int filterId) async {
    filterCategories = filterCategories.map((filter) {
      if (filter.id == filterId) {
        filter.isSelected = !filter.isSelected;
      }
      return filter;
    }).toList();
    notifyListeners();
  }
}
