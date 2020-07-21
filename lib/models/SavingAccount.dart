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
      this.calculationDay});

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
      this.calculationDay);

  SavingAccount.ms();

  factory SavingAccount.fromJson(Map<String, dynamic> json) {
    return SavingAccount(
        id: json['id'],
        bankID: json['bankID'],
        uid: json['uid'],
        name: json['name'],
        amount: json['amount'],
        startDate: json['startDate'],
        term: json['term'],
        interestRate: json['interestRate'],
        freeInterestRate: json['freeInterestRate'],
        calculationDay: json['calculationDay']);
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'bankID': bankID,
        'name': name,
        'amount': amount,
        'startDate': startDate,
        'term': term,
        'interestRate': interestRate,
        'freeInterestRate': freeInterestRate,
        'calculationDay': calculationDay
      };
}
