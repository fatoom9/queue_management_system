class PersonDetails {
  final String id;
  final String fullName;
  final String phoneNumber;
  final int queueNumber;
  final int timestamp;
  final String? notes;
  final String addedBy;

  PersonDetails({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.queueNumber,
    required this.timestamp,
    this.notes,
    required this.addedBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'queue_number': queueNumber,
      'timestamp': timestamp,
      'notes': notes,
      'added_by': addedBy
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
        addedBy: map['added_by'] as String? ?? '');
  }
}
