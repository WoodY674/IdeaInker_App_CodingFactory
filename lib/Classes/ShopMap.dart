class ShopMap {
  final int id;
  final int? manager_id;
  final int? salon_image_id;
  final String address;
  final String zip_code;
  final String city;
  final String created_at;
  final String? updated_at;
  final String? deleted_at;
  final String name;
  final String? coordinateStore;
  final String latitude;
  final String longitude;

  const ShopMap({
    required this.id,
    required this.manager_id,
    required this.salon_image_id,
    required this.address,
    required this.zip_code,
    required this.city,
    required this.created_at,
    required this.updated_at,
    required this.deleted_at,
    required this.name,
    required this.coordinateStore,
    required this.latitude,
    required this.longitude,
  });

  factory ShopMap.fromJson(Map<String, dynamic> json) {
    return ShopMap(
      id: json["id"],
      manager_id: json["manager"],
      salon_image_id: json["salonImage"],
      address: json["address"],
      zip_code: json["zipCode"],
      city: json["city"],
      created_at: json["createdAt"],
      updated_at: json["updatedAt"],
      deleted_at: json["deletedAt"],
      name: json["name"],
      coordinateStore: json["coordinateStore"],
      latitude: json["latitude"],
      longitude: json["longitude"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['manager'] = this.manager_id;
    data['salonImage'] = this.salon_image_id;
    data['address'] = this.address;
    data['zipCode'] = this.zip_code;
    data['city'] = this.city;
    data['createdAt'] = this.created_at;
    data['updatedAt'] = this.updated_at;
    data['deletedAt'] = this.deleted_at;
    data['name'] = this.name;
    data['coordinateStore'] = this.coordinateStore;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}