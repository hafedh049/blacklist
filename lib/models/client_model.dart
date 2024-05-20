class ClientModel {
  String clientName;
  String clientCIN;
  DateTime clientBirthdate;
  String clientPhone;
  String clientQrCode;

  ClientModel({
    required this.clientQrCode,
    required this.clientName,
    required this.clientCIN,
    required this.clientBirthdate,
    required this.clientPhone,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      clientQrCode: json['clientQrCode'],
      clientName: json['clientName'],
      clientCIN: json['clientCIN'],
      clientBirthdate: json['clientBirthdate'].toDate(),
      clientPhone: json['clientPhone'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'clientQrCode': clientQrCode,
      'clientName': clientName,
      'clientCIN': clientCIN,
      'clientBirthdate': clientBirthdate.toIso8601String(),
      'clientPhone': clientPhone,
    };
  }
}
