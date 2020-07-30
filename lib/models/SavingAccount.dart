class SavingAccount {
  int id;
  int bankID;
  String uid;
  String name;
  double amount;
  DateTime startDate;
  int term;
  double interestRate;
  double freeInterestRate;
  int calculationDay;
  int type;
  DateTime createdDate;

  SavingAccount(
      {this.id,
      this.bankID,
      this.uid,
      this.name,
      this.amount,
      this.startDate,
      this.term,
      this.interestRate,
      this.freeInterestRate,
      this.calculationDay,
      this.type,
      this.createdDate});

  SavingAccount.smp(
      String name, double interestRate, DateTime startDate, double amount) {
    this.name = name;
    this.interestRate = interestRate;
    this.startDate = startDate;
    this.amount = amount;
  }

  SavingAccount.sa(
      this.id,
      this.bankID,
      this.uid,
      this.name,
      this.amount,
      this.startDate,
      this.term,
      this.interestRate,
      this.freeInterestRate,
      this.calculationDay,
      this.type,
      this.createdDate);

  SavingAccount.ms();

  factory SavingAccount.fromJson(Map<String, dynamic> json) {
    return SavingAccount(
        id: json['ID'],
        bankID: json['BankID'],
        uid: json['UID'],
        name: json['Name'],
        amount: json['Amount'],
        startDate: DateTime.parse(json['StartDate']),
        term: json['Term'],
        interestRate: json['InterestRate'],
        freeInterestRate: json['FreeInterestRate'],
        calculationDay: json['CalculationDay']);
  }
  Map<String, dynamic> toJson() => {
        'ID': id,
        'UID': uid,
        'BankID': bankID,
        'Name': name,
        'Amount': amount,
        'StartDate': startDate.toIso8601String(),
        'Term': term,
        'InterestRate': interestRate,
        'FreeInterestRate': freeInterestRate,
        'CalculationDay': calculationDay,
        'CreatedDate': createdDate.toIso8601String(),
        'Type': 1
      };
}
