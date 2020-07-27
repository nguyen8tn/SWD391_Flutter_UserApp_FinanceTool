class LoanAccount {
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

  LoanAccount(
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

  LoanAccount.smp(
      String name, double interestRate, DateTime startDate, double amount) {
    this.name = name;
    this.interestRate = interestRate;
    this.startDate = startDate;
    this.amount = amount;
  }

  LoanAccount.sa(
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

  LoanAccount.ms();

  factory LoanAccount.fromJson(Map<String, dynamic> json) {
    return LoanAccount(
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
        'startDate': startDate.toIso8601String(),
        'term': term,
        'interestRate': interestRate,
        'freeInterestRate': freeInterestRate,
        'calculationDay': calculationDay
      };
}
