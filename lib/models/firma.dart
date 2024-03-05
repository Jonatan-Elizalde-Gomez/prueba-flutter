class Firma {
  int? id;
  String dataBase64;

  Firma({this.id, required this.dataBase64});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dataBase64': dataBase64,
    };
  }

  factory Firma.fromMap(Map<String, dynamic> map) {
    return Firma(
      id: map['id'],
      dataBase64: map['dataBase64'],
    );
  }
}
