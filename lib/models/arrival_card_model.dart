class ArrivalCardModel {
  final String flightNo;
  final String arrivingFrom;
  final String passportNumber;
  final String nationality;
  final String surname;
  final String forenames;
  final String dateOfBirth;
  final String addressInEgypt;
  final String purposeOfVisit;
  final String accompaniedChildren;
  final String date;

  ArrivalCardModel({
    required this.flightNo,
    required this.arrivingFrom,
    required this.passportNumber,
    required this.nationality,
    required this.surname,
    required this.forenames,
    required this.dateOfBirth,
    required this.addressInEgypt,
    required this.purposeOfVisit,
    this.accompaniedChildren = 'N/A',
    required this.date,
  });
}