import 'package:flutter/material.dart';

class Message {
  final int? id; // ID auto-incrémenté
  final String message;
  final double latitude;
  final double longitude;
  final String phoneNumber;
  final DateTime date;

  Message({
    this.id,
    required this.message,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
    required this.date,
  });

  // Convertit un Message en Map (pour SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'latitude': latitude,
      'longitude': longitude,
      'phoneNumber': phoneNumber,
      'date': date.toIso8601String(),
    };
  }

  // Convertit un Map de SQLite en objet Message
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      message: map['message'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      phoneNumber: map['phoneNumber'],
      date: DateTime.parse(map['date']),
    );
  }
}
