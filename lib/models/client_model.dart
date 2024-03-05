class ClientModel {
  List<String> storesID;
  String clientName;
  String clientCIN;
  DateTime clientBirthdate;
  String clientPhone;

  // Constructor
  ClientModel({
    required this.storesID,
    required this.clientName,
    required this.clientCIN,
    required this.clientBirthdate,
    required this.clientPhone,
  });

  // Method to deserialize JSON
  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      storesID: List<String>.from(json['storesID']),
      clientName: json['clientName'],
      clientCIN: json['clientCIN'],
      clientBirthdate: json['clientBirthdate'].toDate(),
      clientPhone: json['clientPhone'],
    );
  }

  // Method to serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'storesID': storesID,
      'clientName': clientName,
      'clientCIN': clientCIN,
      'clientBirthdate': clientBirthdate.toIso8601String(),
      'clientPhone': clientPhone,
    };
  }
}
