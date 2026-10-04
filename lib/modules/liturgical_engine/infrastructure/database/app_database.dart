import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// Copies the bundled feast database from assets to a writable
/// location, re-copying whenever [_dbVersion] is bumped (e.g. after
/// editing fixed_feasts.db with new/changed feast rows). A small
/// marker file next to the database records which version is
/// currently on-device, so unrelated app launches don't re-copy
/// every time — only when the bundled data has actually changed.
class AppDatabase {
  /// Bump this every time assets/data/fixed_feasts.db is edited.
  static const int _dbVersion = 2;  

  static Database? _db;

  static Future<Database> instance() async {
    if (_db != null) return _db!;

    final documentsDir = await getApplicationDocumentsDirectory();
    final dbPath = join(documentsDir.path, 'fixed_feasts.db');
    final versionFile = File(join(documentsDir.path, 'fixed_feasts.version'));

    final onDeviceVersion = await _readOnDeviceVersion(versionFile);
    final dbFile = File(dbPath);

    final needsCopy = onDeviceVersion != _dbVersion || !await dbFile.exists();

    if (needsCopy) {
      if (await dbFile.exists()) {
        await dbFile.delete();
      }
      final data = await rootBundle.load('assets/data/fixed_feasts.db');
      final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await dbFile.writeAsBytes(bytes, flush: true);
      await versionFile.writeAsString('$_dbVersion');
    }

    _db = await openDatabase(dbPath, readOnly: true);
    return _db!;
  }

  static Future<int?> _readOnDeviceVersion(File versionFile) async {
    if (!await versionFile.exists()) return null;
    final content = await versionFile.readAsString();
    return int.tryParse(content.trim());
  }
}
