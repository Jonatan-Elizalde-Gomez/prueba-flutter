class Firma {
  int? id;
  String dataBase64;

  Firma({this.id, required this.dataBase64});

  // Convertir un objeto Firma a Map. Útil para insertar datos en la base de datos.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dataBase64': dataBase64,
    };
  }

  // Crear un objeto Firma desde un Map. Útil para leer datos de la base de datos.
  factory Firma.fromMap(Map<String, dynamic> map) {
    return Firma(
      id: map['id'],
      dataBase64: map['dataBase64'],
    );
  }
}
