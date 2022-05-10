class User{

  late String firstName;
  late String lastName;
  late String password;
  late String? zipCode;
  late String? adress;
  late String? city;
  late DateTime? birthday;
  late String pseudo;
  late String? profileImage;



  User(Map map){
    firstName = map["firstName"];
    lastName = map["lastName"];
    password = map["password"];
    zipCode = map["zipCode"];
    adress = map["adress"];
    city = map["city"];
    birthday = map["birthday"];
    pseudo = map["pseudo"];
    profileImage = map["profileImage"];
  }
}