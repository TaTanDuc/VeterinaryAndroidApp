class Comment {
  final int? commentID;
  final String profileIMG;
  final String profileNAME;
  final DateTime commentDATE;
  final int commentRATING;
  final String CONTENT;

  Comment({
    required this.commentID,
    required this.profileIMG,
    required this.profileNAME,
    required this.commentDATE,
    required this.commentRATING,
    required this.CONTENT,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentID: json['commentID'] ?? 0, // Provide default values if necessary

      profileIMG: json['profileIMG'] ?? '',
      profileNAME: json['profileNAME'] ?? 'Anonymous',
      commentDATE: json['commentDATE'] != null
          ? DateTime.tryParse(json['commentDATE']) ??
              DateTime.now() // Handle parsing
          : DateTime.now(),
      commentRATING: json['commentRATING'] ?? 0,
      CONTENT: json['CONTENT'] ?? '',
    );
  }
  @override
  String toString() {
    return 'Comment(commentID: $commentID, profileIMG: $profileIMG, profileNAME: $profileNAME, commentDATE: $commentDATE, commentRATING: $commentRATING, CONTENT: $CONTENT)';
  }
}
