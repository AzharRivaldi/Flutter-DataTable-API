class ModelData {
  final int userId;
  final int id;
  final String title;

  ModelData({required this.userId, required this.id, required this.title});

  factory ModelData.fromJson(Map<String, dynamic> json) {
    return ModelData(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}
