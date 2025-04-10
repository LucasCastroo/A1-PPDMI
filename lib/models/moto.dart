class Moto {
  final int id;
  final String modelo;
  final String marca;
  final int ano;
  final String? imagemUrl;

  Moto({
    required this.id,
    required this.modelo,
    required this.marca,
    required this.ano,
    this.imagemUrl,
  });

  factory Moto.fromJson(Map<String, dynamic> json) {
    return Moto(
      id: json['id'],
      modelo: json['modelo'],
      marca: json['marca'],
      ano: json['ano'],
      imagemUrl: json['imagemUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'modelo': modelo,
      'marca': marca,
      'ano': ano,
      'imagemUrl': imagemUrl,
    };
  }
}
