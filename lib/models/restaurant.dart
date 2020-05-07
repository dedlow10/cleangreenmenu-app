class Restaurant {
  int id;
  String name;
  String code;
  String emailAddress;
  DateTime createdOn;

  Restaurant({this.id, this.name, this.code, this.emailAddress, this.createdOn});

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Restaurant(
      id: json['Id'],
      name: json['Name'],
      code: json['Code'],
      emailAddress: json["EmailAddress"],
      createdOn: DateTime.parse(json["CreatedOn"])
    );
  }
}