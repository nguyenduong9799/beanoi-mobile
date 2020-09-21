import 'package:unidelivery_mobile/Model/DTO/ProductDTO.dart';
import 'package:unidelivery_mobile/utils/request.dart';

class ProductDAO {
  // 1. Get Product List from API
  Future<List<ProductDTO>> getProducts() async {
    final res = await request.get('/products');
    final products = ProductDTO.fromList(res.data);
    return products;
  }
}
