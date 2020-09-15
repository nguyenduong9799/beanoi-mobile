import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/ProductDTO.dart';

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

}
