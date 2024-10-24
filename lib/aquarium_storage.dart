import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';  
import 'fish.dart';

class AquariumStorage {
  Database? _database;


  Future<Database> get database async {
    if (_database != null) return _database!;

   
    _database = await initDatabase();
    return _database!;
  }

  
  Future<Database> initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "aquarium.db");

    return await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Fish (id INTEGER PRIMARY KEY, color INTEGER, speed REAL)');
    });
  }

  // Load fish
  Future<List<Fish>> loadFish() async {
    final db = await database;  
    final List<Map<String, dynamic>> fishes = await db.query('Fish');
    
   
    return fishes.map((f) => Fish(Color(f['color']), f['speed'])).toList();  
  }

 
  Future<void> saveFish(List<Fish> fishList) async {
    final db = await database;  
    await db.delete('Fish'); // Clear old data
    for (var fish in fishList) {
      await db.insert('Fish', {
        'color': fish.color.value,  // Store color 
        'speed': fish.speed,
      });
    }
  }
}
