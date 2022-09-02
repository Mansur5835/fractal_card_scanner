class FractalCardModel {
  final String cardNumber;
  final String cardDate;
  final String? bankName;
  final String? cardName;

  FractalCardModel(
      {required this.cardNumber,
      required this.cardDate,
      this.cardName,
      this.bankName});
}
