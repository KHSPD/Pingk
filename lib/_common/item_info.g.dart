// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_info.dart';

class AlwayslItemAdapter extends TypeAdapter<AlwayslItem> {
  @override
  final int typeId = 0;

  @override
  AlwayslItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read()};
    return AlwayslItem(
      id: fields[0] as String,
      brand: fields[1] as String,
      title: fields[2] as String,
      originPrice: fields[3] as int,
      price: fields[4] as int,
      category: fields[5] as String,
      isFavorite: fields[6] as bool,
      status: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AlwayslItem obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.brand)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.originPrice)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.isFavorite)
      ..writeByte(7)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AlwayslItemAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
