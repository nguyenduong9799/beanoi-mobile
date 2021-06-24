import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Utils/index.dart';

class TransactionDAO extends BaseDAO {
  Future<List<TransactionDTO>> getTransactions(
      {int page, int size, DateTime fromDate, DateTime toDate}) async {
    Map<String, dynamic> query = {
      "size": size ?? DEFAULT_SIZE,
      "page": page ?? 1
    };
    if (fromDate != null) {
      query['from-date'] = fromDate;
    }
    if (toDate != null) {
      query['to-date'] = toDate;
    }
    final res = await request.get('me/transactions', queryParameters: query);
    List<TransactionDTO> list;
    if (res.statusCode == 200) {
      metaDataDTO = MetaDataDTO.fromJson(res.data["metadata"]);
      list = (res.data['data'] as List)
          .map((e) => TransactionDTO.fromJson(e))
          .toList();
    }
    return list;
  }
}
