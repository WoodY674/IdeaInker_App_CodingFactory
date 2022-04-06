class CoordinatesStore{

  late int id;
  late String company;
  late String latitude;
  late String longitude;
  late String salon;


  CoordinatesStore(Map map){
    id = map["id"];
    company = map["company"];
    latitude = map["latitude"];
    longitude = map["longitude"];
    salon = map["salon"];
  }
}