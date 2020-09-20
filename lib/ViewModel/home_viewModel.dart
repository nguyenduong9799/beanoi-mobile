import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Model/DTO/CartDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/ProductDTO.dart';
import 'package:unidelivery_mobile/utils/enum.dart';
import 'package:unidelivery_mobile/utils/request.dart';

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
  List<ProductDTO> products;
  Cart cart = Cart();
  Status status;

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
    if (products != null && products.length != 0) return products;

    try {
      status = Status.Loading;
      notifyListeners();
      final res = await request.get('products');
      if (res.statusCode == 200) {
        products = ProductDTO.fromList(res.data);
      } else {
        print('Fetch products error');
      }
      notifyListeners();
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

  // 3. Get Product Detail

  // 4. Add item to cart
  Future<void> updateItemInCart(ProductDTO masterProduct,
      List<ProductDTO> productsChild, int quantity) async {
    if (cart == null) {
      cart = Cart();
    }
    cart.addItem(CartItem(
      masterProduct,
      quantity,
      productsChild,
    ));
    notifyListeners();
  }
}
