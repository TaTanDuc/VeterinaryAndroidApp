class Comment {
  final int? userID;
  final int? commentID;
  final String profileIMG;
  final String profileNAME;
  final DateTime commentDATE;
  final int commentRATING;
  final String CONTENT;

  Comment({
    required this.userID,
    required this.commentID,
    required this.profileIMG,
    required this.profileNAME,
    required this.commentDATE,
    required this.commentRATING,
    required this.CONTENT,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      userID: json['userID'] ?? 0, // Provide default values if necessary
      commentID: json['commentID'] ?? 0,
      profileIMG: json['profileIMG'] ?? '',
      profileNAME: json['profileNAME'] ?? '',
      commentDATE: json['commentDATE'] != null
          ? DateTime.tryParse(json['commentDATE']) ??
              DateTime.now() // Handle parsing
          : DateTime.now(),
      commentRATING: json['commentRATING'] ?? 0,
      CONTENT: json['CONTENT'] ?? '',
    );
  }
  // @override
  // String toString() {
  //   return 'Pet(userID: $userID, petID: $petID, petIMAGE: $petIMAGE, petSPECIE: $petSPECIE, petNAME: $petNAME, petAGE: $petAGE)';
  // }
}
