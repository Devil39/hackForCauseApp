class User{
  String uid;
  String name;
  String email;

  User({
    this.uid,
    this.name,
    this.email
  });

  factory User.fromJson(dynamic json){
    return User(
      uid: json["uid"],
      name: json["name"],
      email: json["email"]
    );
  }

  Map<String, dynamic> toJson()=>{
    "uid": uid,
    "name": name,
    "email": email
  };
}