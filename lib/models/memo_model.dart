class Memo {
  final String id;
  final String memoTitle;
  final String from;
  final String memoDescription;
  final String memoFileUrl;
  final String status;
  final String createdBy;
  final int viewCount;
  final DateTime createdAt;


  Memo({
    required this.id,
    required this.memoTitle,
    required this.from,
    required this.memoDescription,
    required this.memoFileUrl,
    required this.status,
    required this.createdBy,
    this.viewCount = 0,
    required this.createdAt
  });

  Map<String, dynamic> toMap() {
    return {
      'memoTitle': memoTitle,
      'from': from,
      'memoDescription': memoDescription,
      'memoFileUrl': memoFileUrl,
      'status': status,
      'createdBy': createdBy,
      'viewCount': viewCount,
      'createdAt' : createdAt.toIso8601String()

    };
  }

  factory Memo.fromMap(Map<String, dynamic> map, String id) {
    return Memo(
      id: id,
      memoTitle: map['memoTitle'] ?? '',
      from: map['from'] ?? '',
      memoDescription: map['memoDescription'] ?? '',
      memoFileUrl: map['memoFileUrl'] ?? '',
      status: map['status'] ?? 'not viewed',
      createdBy: map['createdBy'] ?? '',
      viewCount: map['viewCount'] ?? 0,
      createdAt: DateTime.parse(map['createdAt'])
    );
  }
}







