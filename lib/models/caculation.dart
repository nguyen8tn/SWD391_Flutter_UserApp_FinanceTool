
class BaseFormula {
  int id;
  String name;
  String formula;

  BaseFormula({this.id, this.name, this.formula});

  factory BaseFormula.fromJson(Map<String, dynamic> json) {
    return BaseFormula(
      id: json['id'],
      name: json['name'],
      formula: json['formula']
    );
  }

}
