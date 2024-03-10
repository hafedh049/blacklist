class ClientModel {
  List<String> storesID;
  String clientName;
  String clientCIN;
  DateTime clientBirthdate;
  String clientPhone;
  String clientQrCode;

  ClientModel({
    required this.clientQrCode,
    required this.storesID,
    required this.clientName,
    required this.clientCIN,
    required this.clientBirthdate,
    required this.clientPhone,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      clientQrCode: json['clientQrCode'],
      storesID: List<String>.from(json['storesID']),
      clientName: json['clientName'],
      clientCIN: json['clientCIN'],
      clientBirthdate: json['clientBirthdate'].toDate(),
      clientPhone: json['clientPhone'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'clientQrCode': clientQrCode,
      'storesID': storesID,
      'clientName': clientName,
      'clientCIN': clientCIN,
      'clientBirthdate': clientBirthdate.toIso8601String(),
      'clientPhone': clientPhone,
    };
  }
}
