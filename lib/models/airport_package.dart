import 'package:hive/hive.dart';

part 'airport_package.g.dart';

@HiveType(typeId: 0)
class AirportPackage extends HiveObject {
  @HiveField(0)
  final String airportCode;

  @HiveField(1)
  final String airportName;

  @HiveField(2)
  final String country;

  @HiveField(3)
  final String currencyCode;

  @HiveField(4)
  final double exchangeRateToUSD;

  @HiveField(5)
  final List<TelecomOption> telecomOptions;

  @HiveField(6)
  final List<TransportOption> transportOptions;

  @HiveField(7)
  final Map<String, String> emergencyNumbers;

  AirportPackage({
    required this.airportCode,
    required this.airportName,
    required this.country,
    required this.currencyCode,
    required this.exchangeRateToUSD,
    required this.telecomOptions,
    required this.transportOptions,
    required this.emergencyNumbers,
  });
}

@HiveType(typeId: 1)
class TelecomOption extends HiveObject {
  @HiveField(0)
  final String companyName;

  @HiveField(1)
  final String bestPackage;

  @HiveField(2)
  final String price;

  @HiveField(3)
  final String counterLocation;

  TelecomOption({
    required this.companyName,
    required this.bestPackage,
    required this.price,
    required this.counterLocation,
  });
}

@HiveType(typeId: 2)
class TransportOption extends HiveObject {
  @HiveField(0)
  final String type;

  @HiveField(1)
  final String estimatedCost;

  @HiveField(2)
  final String tips;

  TransportOption({
    required this.type,
    required this.estimatedCost,
    required this.tips,
  });
}