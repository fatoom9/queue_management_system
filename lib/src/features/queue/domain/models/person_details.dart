import 'package:flutter/material.dart';

@immutable
class PersonDetails {
  final String id;
  final String fullName;
  final String phoneNumber;
  final int queueNumber;
  final int timestamp;
  final String? notes;
  final String? addedBy;
  final int? completedAt;

  const PersonDetails({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.queueNumber,
    required this.timestamp,
    this.notes,
    this.addedBy,
    this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'queue_number': queueNumber,
      'timestamp': timestamp,
      'notes': notes,
      'added_by': addedBy,
      'completedAt': completedAt,
    };
  }

  factory PersonDetails.fromMap(Map<String, dynamic> map) {
    return PersonDetails(
        id: map['id'] as String? ?? '', // Ensuring it's a String
        fullName: map['full_name'] as String? ?? '',
        phoneNumber: map['phone_number'] as String? ?? '',
        queueNumber: (map['queue_number'] as int?) ?? 0, // Default to 0 if null
        timestamp: (map['timestamp'] as int?) ?? 0,
        notes: map['notes'] as String?, // Nullable string is okay
        addedBy: map['added_by'] as String? ?? '',
        completedAt: map['completedAt'] as int? ?? 0);
  }

  PersonDetails copyWith({
    String? id,
    String? fullName,
    String? phoneNumber,
    int? queueNumber,
    int? timestamp,
    String? notes,
    String? addedBy,
    int? completedAt,
  }) {
    return PersonDetails(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      queueNumber: queueNumber ?? this.queueNumber,
      timestamp: timestamp ?? this.timestamp,
      notes: notes ?? this.notes,
      addedBy: addedBy ?? this.addedBy,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  String toString() {
    return 'PersonDetails(id: $id, fullName: $fullName, phoneNumber: $phoneNumber, queueNumber: $queueNumber, timestamp: $timestamp, notes: $notes, addedBy: $addedBy, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PersonDetails) return false;
    return id == other.id &&
        fullName == other.fullName &&
        phoneNumber == other.phoneNumber &&
        queueNumber == other.queueNumber &&
        timestamp == other.timestamp &&
        notes == other.notes &&
        addedBy == other.addedBy &&
        completedAt == other.completedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fullName.hashCode ^
        phoneNumber.hashCode ^
        queueNumber.hashCode ^
        timestamp.hashCode ^
        notes.hashCode ^
        addedBy.hashCode ^
        completedAt.hashCode;
  }
}
