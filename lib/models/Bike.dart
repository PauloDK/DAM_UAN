class Bike {
  late String id;
  late String designacao;
  late String quilometragem;
  late String proprietario;
  late int preco;
  late String doca;
  late String tipologia;
  late String image;
  Bike(
      {required this.id,
      required this.designacao,
      required this.quilometragem,
      required this.proprietario,
      required this.preco,
      required this.doca,
      required this.tipologia,
      required this.image});
  factory Bike.fromJson(Map<String, dynamic> json) {
    return Bike(
      id: json['_id'],
      designacao: json['designacao'],
      quilometragem: json['quilometragem'],
      proprietario: json['proprietario']['nome']==Null?'in':json['proprietario']['nome'],
      preco: json['preco'].toInt(),
      doca: json['doca']['designacao']==Null?'':json['doca']['designacao'],
      tipologia: json['tipologia']['designacao']==Null?'in':json['tipologia']['designacao'],
      image: json['url']==Null?'in':json['url'],
    );
  }
}
