class Salon{

  late int? id;
  late int? manager_id;
  late int? salon_image_id;
  late String address;
  late String zip_code;
  late String city;
  late String created_at;
  late String? updated_at;
  late String? deleted_at;
  late String name;
  late String? coordinateStore;

  Salon(Map map){
    id = map["id"];
    manager_id = map["manager"];
    salon_image_id = map["salonimage"];
    address = map["address"];
    zip_code = map["zipCode"];
    city = map["city"];
    created_at = map["createdAt"];
    updated_at = map["updatedAt"];
    deleted_at = map["deletedAt"];
    name = map["name"];
    coordinateStore = map["coordinateStore"];
  }
}