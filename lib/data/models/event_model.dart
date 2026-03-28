class EventModel {
  final String title;
  final String description;
  final String venue;
  final String date;
  final bool isImportant;

  EventModel({
    required this.title,
    required this.description,
    required this.venue,
    required this.date,
    required this.isImportant,
  });

  factory EventModel.fromFirebase(Map<String, dynamic> data) {
    return EventModel(
      title: data["title"] ?? "",
      description: data["description"] ?? "",
      venue: data["venue"] ?? "",
      date: data["date"] ?? "",
      isImportant: data["isImportant"] ?? "",
    );
  }
}
