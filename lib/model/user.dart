class User {
  static final db_displayName = "displayName";
  static final db_email = "email";
  static final db_id = "id";
  static final db_photoUrl = "photoUrl";
  static final db_serverAuthCode = "serverAuthCode";

  String? displayName, email, photoUrl, serverAuthCode;

  double id;

  User(
      {this.displayName,
      this.email,
      required this.id,
      this.photoUrl,
      this.serverAuthCode});

  User.fromMap(Map<String, dynamic> map)
      : this(
          displayName: map[db_displayName],
          email: map[db_email],
          id: map[db_id],
          photoUrl: map[db_photoUrl],
          serverAuthCode: map[db_serverAuthCode],
        );

  // Currently not used
  Map<String, dynamic> toMap() {
    return {
      db_displayName: displayName,
      db_photoUrl: photoUrl,
      db_id: id,
      db_email: email,
      db_serverAuthCode: serverAuthCode,
    };
  }
}
