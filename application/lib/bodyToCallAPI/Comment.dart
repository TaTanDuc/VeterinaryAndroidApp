class Comment {
  final int? serviceCommentID;
  final String profileIMG;
  final String profileName;
  final String commentTime;
  final int serviceRating;
  final String content;

  Comment({
    required this.serviceCommentID,
    required this.profileIMG,
    required this.profileName,
    required this.commentTime,
    required this.serviceRating,
    required this.content,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      serviceCommentID:
          json['serviceCommentID'] ?? 0, // Provide default values if necessary

      profileIMG: json['profileIMG'] ?? '',
      profileName: json['profileName'] ?? 'Anonymous',
      commentTime: json['commentTime'] != null
          ? json['commentTime'].toString()
          : DateTime.now().toString(),
      serviceRating: json['serviceRating'] ?? 0,
      content: json['content'] ?? '',
    );
  }
  @override
  String toString() {
    return 'Comment(commentID: $serviceCommentID, profileIMG: $profileIMG, profileNAME: $profileName, commentDATE: $commentTime, commentRATING: $serviceRating, CONTENT: $content)';
  }
}
