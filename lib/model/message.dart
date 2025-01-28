import 'package:flutter/material.dart';

class Message {
  int? _id; // ID auto-incrémenté
  String? _libelle;
  String _message;
  double _latitude;

  set message(String value) {
    _message = value;
  }

  double _longitude;
  String _phoneNumber;
  DateTime? _date;
  double _radius;

  @override
  String toString() {
    return 'Message{_id: $_id, _libelle: $_libelle, _message: $_message, _latitude: $_latitude, _longitude: $_longitude, _phoneNumber: $_phoneNumber, _date: $_date, _radius: $_radius}';
  }

  Message({
    int? id, // ID optionnel
    String? libelle, // Libellé optionnel
    String? message, // Message obligatoire
    required double latitude, // Latitude obligatoire
    required double longitude, // Longitude obligatoire
    String? phoneNumber, // Numéro de téléphone obligatoire
    DateTime? date, // Date optionnelle
    double radius = 30.0, // Rayon par défaut à 10.0
  })  : _id = id,
        _libelle = libelle,
        _message = message ?? '',
        _latitude = latitude,
        _longitude = longitude,
        _phoneNumber = phoneNumber ?? '',
        _date = date,
        _radius = radius;

  // Getters
  int? get id => _id;
  String? get libelle => _libelle;
  String get message => _message;
  double get latitude => _latitude;
  double get longitude => _longitude;
  String get phoneNumber => _phoneNumber;
  DateTime? get date => _date;
  double get radius => _radius;

  // Setters
  set libelle(String? value) {
    _libelle = value;
  }

  set date(DateTime? value) {
    _date = value;
  }

  // Convertit un Message en Map (pour SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'latitude': latitude,
      'longitude': longitude,
      'phoneNumber': phoneNumber,
      'date': date,
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

  set latitude(double value) {
    _latitude = value;
  }

  set longitude(double value) {
    _longitude = value;
  }

  set phoneNumber(String value) {
    _phoneNumber = value;
  }

  set radius(double value) {
    _radius = value;
  }
}
