import 'package:bhakti_setu/domain/entities/festival_entity.dart';

class FestivalModel extends FestivalEntity {
  FestivalModel({
    required super.data,
    required super.name,
    required super.type,
  });

  factory FestivalModel.fromjson(Map<String, dynamic> json) {
    return FestivalModel(
      data: json["data"] ?? "",
      name: json["name"] ?? "",
      type: json["type"] ?? "",
    );
  }
}
