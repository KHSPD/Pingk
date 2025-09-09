import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'item_info.dart';

part 'local_db.g.dart';

// ====================================================================================================
// FavoriteTable 정의
// ====================================================================================================
class FavoriteTable extends Table {
  TextColumn get id => text().withLength(min: 13, max: 13)();
  TextColumn get brand => text().withLength(min: 1, max: 100)();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  IntColumn get price => integer().withDefault(Constant(0))();
  IntColumn get originPrice => integer().withDefault(Constant(0))();
  TextColumn get category => text().withLength(min: 1, max: 50)();

  @override
  Set<Column> get primaryKey => {id};
}

// ====================================================================================================
// 데이터베이스 클래스
// ====================================================================================================
@DriftDatabase(tables: [FavoriteTable])
class LocalDatabase extends _$LocalDatabase {
  static final LocalDatabase _instance = LocalDatabase._privateConstructor();
  factory LocalDatabase() => _instance;
  LocalDatabase._privateConstructor() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // ----- 모든 찜 목록 조회 -----
  Future<List<AlwayslItem>> getAllFavorites() async {
    final query = select(favoriteTable);
    final results = await query.get();
    return results
        .map((data) => AlwayslItem(id: data.id, brand: data.brand, title: data.title, price: data.price, originPrice: data.originPrice, category: data.category))
        .toList();
  }

  // ----- 찜 아이템 추가 -----
  Future<void> insertFavorite(AlwayslItem item) async {
    await into(favoriteTable).insert(
      FavoriteTableCompanion(
        id: Value(item.id),
        brand: Value(item.brand),
        title: Value(item.title),
        price: Value(item.price),
        originPrice: Value(item.originPrice),
        category: Value(item.category),
      ),
      onConflict: DoNothing(),
    );
  }

  // ----- 찜 아이템 삭제 -----
  Future<void> deleteFavorite(String id) async {
    await (delete(favoriteTable)..where((t) => t.id.equals(id))).go();
  }

  /*
  // ----- 찜 아이템 존재 여부 확인 -----
  Future<bool> isFavorite(String id) async {
    final query = select(favoriteTable)..where((t) => t.id.equals(id));
    final result = await query.getSingleOrNull();
    return result != null;
  }

  // ----- 찜 아이템 토글 (있으면 삭제, 없으면 추가) -----
  Future<void> toggleFavorite(AlwayslItem item) async {
    final exists = await isFavorite(item.id);
    if (exists) {
      await deleteFavorite(item.id);
    } else {
      await insertFavorite(item);
    }
  }
  */

  // 모든 찜 목록 삭제
  Future<void> deleteAllFavorites() async {
    await delete(favoriteTable).go();
  }
}

// ====================================================================================================
// 데이터베이스 연결 설정
// ====================================================================================================
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'pingk.db'));
    return NativeDatabase.createInBackground(file);
  });
}
