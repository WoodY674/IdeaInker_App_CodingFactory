class infosUser{

  late String firstName;
  late String lastName;
  late String password;
  late String? zipCode;
  late String? address;
  late String? city;
  late DateTime? birthday;


  infosUser(Map map){
    firstName = map["firstName"];
    lastName = map["lastName"];
    password = map["password"];
    zipCode = map["zipCode"];
    address = map["address"];
    city = map["city"];
    birthday = map["birthday"];
  }
}