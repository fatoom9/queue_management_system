class PersonDetails {
  final int? id;
  final String fullName;
  final String phoneNumber;
  final int queueNumber;
  final int timestampAdded;
  final String? notes;
  final String timestamp; // Store timestamp as a string

  // Constructor
  PersonDetails({
    this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.queueNumber,
    required this.timestampAdded,
    this.notes,
    required this.timestamp, // Ensure timestamp is passed when creating a PersonDetails object
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'queue_number': queueNumber,
      'timestamp_added': timestampAdded,
      'notes': notes,
      'timestamp': timestamp, // Include timestamp when converting to map
    };
  }

  factory PersonDetails.fromMap(Map<String, dynamic> map) {
    return PersonDetails(
      id: map['id'],
      fullName: map['full_name'],
      phoneNumber: map['phone_number'],
      queueNumber: map['queue_number'],
      timestampAdded: map['timestamp_added'],
      notes: map['notes'],
      timestamp:
          map['timestamp'] ?? '', // Safely handle missing timestamp in map
    );
  }
}
