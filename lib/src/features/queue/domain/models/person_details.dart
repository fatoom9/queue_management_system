class PersonDetails {
  final String fullName;
  final String phoneNumber;
  final int queueNumber;
  final int timestampAdded;
  final String? notes;

  // Constructor
  PersonDetails({
    required this.fullName,
    required this.phoneNumber,
    required this.queueNumber,
    required this.timestampAdded,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'full_name': fullName,
      'phone_number': phoneNumber,
      'queue_number': queueNumber,
      'timestamp_added': timestampAdded,
      'notes': notes,
    };
  }

  factory PersonDetails.fromMap(Map<String, dynamic> map) {
    return PersonDetails(
      fullName: map['full_name'],
      phoneNumber: map['phone_number'],
      queueNumber: map['queue_number'],
      timestampAdded: map['timestamp_added'],
      notes: map['notes'],
    );
  }
}
