enum CurrencyType { VND, USD, EUR }

extension currencyExtension on CurrencyType {
  int get id {
    switch (this) {
      case CurrencyType.VND:
        return 0;
      case CurrencyType.USD:
        return 1;
      case CurrencyType.EUR:
        return 2;
      default:
        return null;
    }
  }

  String get name {
    switch (this) {
      case CurrencyType.VND:
        return 'VND';
      case CurrencyType.USD:
        return 'USD';
      case CurrencyType.EUR:
        return 'EUR';
      default:
        return null;
    }
  }

  void talk() {
    print('meow');
  }
}

class BankPackage {
  final int id;
  final String name;
  final int currencyType;
  final double value;
  final double bankID;

  BankPackage({this.bankID, this.currencyType, this.id, this.name, this.value});

  factory BankPackage.fromJson(Map<String, dynamic> json) {
    return BankPackage(
        bankID: json['bankID'],
        currencyType: json['currencyType'],
        id: json['id'],
        name: json['name'],
        value: json['value']);
  }
}
