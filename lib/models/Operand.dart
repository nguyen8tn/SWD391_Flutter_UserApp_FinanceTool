class Operand {
  String id;
  String name;
  double value;
  int type;
  String desc;
  int sequence;
  int baseFormula;
  String expression;
  int operandID;

  Operand(
      {this.baseFormula,
      this.desc,
      this.id,
      this.name,
      this.sequence,
      this.type,
      this.value,
      this.expression,
      this.operandID});

  factory Operand.fromJson(Map<String, dynamic> json) {
    return Operand(
      id: json["id"].toString(),
      name: json['name'],
      value: json['value'],
      type: json['type'],
      desc: json['description'],
      sequence: json['sequence'],
      baseFormula: json['BaseFormulaID'],
      expression: json['expression'],
      operandID: json['OperandID'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'value': value,
        'type': type,
        'description': desc,
        'sequence': sequence,
        'baseFormulaID': baseFormula,
        'expression': expression,
        'OperandID': operandID
      };
}
