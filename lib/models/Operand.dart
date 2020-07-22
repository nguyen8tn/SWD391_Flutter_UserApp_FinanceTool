class Operand {
  final String id;
  final String name;
  final double value;
  final int type;
  final String desc;
  final int sequence;
  final int baseFormula;

  Operand(
      {this.baseFormula,
      this.desc,
      this.id,
      this.name,
      this.sequence,
      this.type,
      this.value});

  factory Operand.fromJson(Map<String, dynamic> json) {
    return Operand(
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
