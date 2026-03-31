class DonorModel {
  String name;
  int amount;
  String date;

  DonorModel({required this.name, required this.amount, required this.date});

  factory DonorModel.fromFirestore(Map<String, dynamic> data) {
    return DonorModel(
      name: data["name"] ?? "",
      amount: data["amount"] ?? "",
      date: data["date"] ?? "",
    );
  }
}
