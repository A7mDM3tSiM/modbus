import 'package:flutter/material.dart';
import 'package:modbus_app/resources/sqflite_helper/sqflite_helper.dart';

class HistoryLocalDatasource {
  final DatabaseHelper _databaseHelper;
  const HistoryLocalDatasource(this._databaseHelper);

  Future<int?> saveRequest(Map<String, dynamic> request) async {
    try {
      // Save the request to the database
      final db = await _databaseHelper.database;
      final id = await db.insert('modbus_requests', request);

      return id;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<int?> updateRequest(Map<String, dynamic> request) async {
    try {
      final db = await _databaseHelper.database;

      // Update the request in the database
      await db.update(
        'modbus_requests',
        request,
        where: 'id = ?',
        whereArgs: [request['id']],
      );

      // Return the id of the updated request
      return request['id'];
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<int?> deleteRequest(int id) async {
    try {
      final db = await _databaseHelper.database;

      // Delete the request from the database
      await db.delete('modbus_requests', where: 'id = ?', whereArgs: [id]);

      // Return the id of the deleted request
      return id;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchRequests() async {
    try {
      final db = await _databaseHelper.database;

      // Fetch all requests from the database
      final requests = await db.query('modbus_requests');

      return {'requests': requests};
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
