// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'airport_package.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AirportPackageAdapter extends TypeAdapter<AirportPackage> {
  @override
  final int typeId = 0;

  @override
  AirportPackage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AirportPackage(
      airportCode: fields[0] as String,
      airportName: fields[1] as String,
      country: fields[2] as String,
      currencyCode: fields[3] as String,
      exchangeRateToUSD: fields[4] as double,
      telecomOptions: (fields[5] as List).cast<TelecomOption>(),
      transportOptions: (fields[6] as List).cast<TransportOption>(),
      emergencyNumbers: (fields[7] as Map).cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, AirportPackage obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.airportCode)
      ..writeByte(1)
      ..write(obj.airportName)
      ..writeByte(2)
      ..write(obj.country)
      ..writeByte(3)
      ..write(obj.currencyCode)
      ..writeByte(4)
      ..write(obj.exchangeRateToUSD)
      ..writeByte(5)
      ..write(obj.telecomOptions)
      ..writeByte(6)
      ..write(obj.transportOptions)
      ..writeByte(7)
      ..write(obj.emergencyNumbers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AirportPackageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TelecomOptionAdapter extends TypeAdapter<TelecomOption> {
  @override
  final int typeId = 1;

  @override
  TelecomOption read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TelecomOption(
      companyName: fields[0] as String,
      bestPackage: fields[1] as String,
      price: fields[2] as String,
      counterLocation: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TelecomOption obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.companyName)
      ..writeByte(1)
      ..write(obj.bestPackage)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.counterLocation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TelecomOptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransportOptionAdapter extends TypeAdapter<TransportOption> {
  @override
  final int typeId = 2;

  @override
  TransportOption read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransportOption(
      type: fields[0] as String,
      estimatedCost: fields[1] as String,
      tips: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TransportOption obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.estimatedCost)
      ..writeByte(2)
      ..write(obj.tips);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransportOptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
