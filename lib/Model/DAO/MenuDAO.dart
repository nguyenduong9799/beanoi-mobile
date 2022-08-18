import 'package:dio/dio.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Model/DTO/MenuDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Utils/index.dart';

import 'index.dart';

class MenuDAO extends BaseDAO {
  Future<List<MenuDTO>> getMenus({int areaID}) async {
    final res = await request.get('areas/$areaID/menus');
    var jsonList = res.data["data"] as List;
    //metaDataDTO = MetaDataDTO.fromJson(res.data["metadata"]);
    if (jsonList != null) {
      List<MenuDTO> list = jsonList.map((e) => MenuDTO.fromJson(e)).toList();
      return list;
    }
    return null;
  }
}
