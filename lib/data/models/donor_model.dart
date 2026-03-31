class DonorModel {
  String name;
  int amount;
  String date;
  String category;

  DonorModel({required this.name, required this.amount, required this.date, required this.category});

  factory DonorModel.fromFirestore(Map<String, dynamic> data) {
    return DonorModel(
      name: data["name"] ?? "",
      amount: data["amount"] ?? "",
      date: data["date"] ?? "",
      category: data["category"] ?? "",
    );
  }
}
