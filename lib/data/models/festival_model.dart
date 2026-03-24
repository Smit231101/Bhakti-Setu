import '../../domain/entities/festival_entity.dart';

class FestivalModel extends FestivalEntity {
  FestivalModel({
    required super.name,
    required super.date,
    required super.type,
  });

  factory FestivalModel.fromJson(Map<String, dynamic> json) {
    return FestivalModel(
      name: json['name'] ?? '',
      date: json['date'] ?? '',
      type: json['type'] ?? '',
    );
  }
}