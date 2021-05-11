import 'package:unidelivery_mobile/Model/DTO/index.dart';

class BaseDAO{
  MetaDataDTO _metaDataDTO;

  MetaDataDTO get metaDataDTO => _metaDataDTO;

  set metaDataDTO(MetaDataDTO value) {
    _metaDataDTO = value;
  }
}