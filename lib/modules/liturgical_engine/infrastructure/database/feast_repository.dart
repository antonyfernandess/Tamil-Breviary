import 'app_database.dart';
import 'feast_row.dart';

class FeastRepository {
  List<FeastRow>? _cache;

  Future<List<FeastRow>> loadAll() async {
    if (_cache != null) return _cache!;

    final db = await AppDatabase.instance();
    final rows = await db.query('feasts');
    _cache = rows.map(FeastRow.fromMap).toList();
    return _cache!;
  }
}
