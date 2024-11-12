import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:traveldiary/model/travel_destination.dart';

class DBHelper {
  DBHelper._();
  static final DBHelper getInstance = DBHelper._();
  Database? myDB;
  static const TRAVEL_TABLE = 'travel_table';
  static const COLUMN_TRAVEL_SNO = 'id';
  static const COLUMN_TRAVEL_TITLE = 'title';
  static const COLUMN_TRAVEL_DESC = 'desc';
  static const COLUMN_TRAVEL_MEDIA = 'mediaPaths';
  static const COLUMN_TRAVEL_CREATED_AT = 'createdAt';
  static const COLUMN_TRAVEL_UPDATED_AT = 'updatedAt';

  Future<Database> getDB() async {
    if (myDB != null) {
      return myDB!;
    } else {
      myDB = await openDB();
      return myDB!;
    }
  }

  Future<Database> openDB() async {
    Directory dbDir = await getApplicationDocumentsDirectory();
    final path = join(dbDir.path, 'traveldiary.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        // db.execute(
        //     'create table $TRAVEL_TABLE($COLUMN_TRAVEL_SNO integer primary key autoincrement, $COLUMN_TRAVEL_TITLE text, $COLUMN_TRAVEL_DESC text, $COLUMN_TRAVEL_IMAGES text, $COLUMN_TRAVEL_VIDEOS text)');

        //updated code
        db.execute(
            'create table $TRAVEL_TABLE($COLUMN_TRAVEL_SNO integer primary key autoincrement, $COLUMN_TRAVEL_TITLE text, $COLUMN_TRAVEL_DESC text, $COLUMN_TRAVEL_MEDIA text, $COLUMN_TRAVEL_CREATED_AT text, $COLUMN_TRAVEL_UPDATED_AT text)');
      },
    );
  }

  // CRUD OPERATIONS
  //create -> insert data

  Future<void> insertEntry(TravelDestination destination) async {
    var db = await getDB();
    try {
      await db.insert(
        TRAVEL_TABLE,
        destination.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('inserted data with id $COLUMN_TRAVEL_SNO');
    } catch (e) {
      debugPrint('Error inserting entry:$e');
    }
  }

  //read -> get data
  Future<List<TravelDestination>> getEntries() async {
    var db = await getDB();
    final List<Map<String, dynamic>> destinations =
        await db.query(TRAVEL_TABLE);
    return List.generate(
      destinations.length,
      (index) {
        return TravelDestination.fromMap(destinations[index]);
      },
    );
  }

  //update -> update details
  Future<void> updateEntries() async {}

  //delete -> delete entry
  Future<int> deleteEntry(TravelDestination destination) async {
    var db = await getDB();
    return await db.delete(TRAVEL_TABLE,
        where: '$COLUMN_TRAVEL_SNO = ?', whereArgs: [destination.id]);
  }
}
