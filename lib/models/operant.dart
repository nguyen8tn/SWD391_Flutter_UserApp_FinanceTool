class Operant {
  final String id;
  final String name;
  final double value;
  final int type;
  final String desc;
  final int sequence;
  final int baseFormula;

  Operant(
      {this.baseFormula,
      this.desc,
      this.id,
      this.name,
      this.sequence,
      this.type,
      this.value});

  factory Operant.fromJson(Map<String, dynamic> json) {
    return Operant(
        id: json["id"].toString(),
        name: json['name'],
        value: json['value'],
        baseFormula: json['baseFormulaID'],
        desc: json['description'],
        sequence: json['sequence'],
        type: json['type']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'value': value,
        'baseFormulaID': baseFormula,
        'description': desc,
        'sequence': sequence,
        'type': type
      };
}
