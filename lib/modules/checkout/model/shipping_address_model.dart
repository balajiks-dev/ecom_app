class Address {
  String name;
  String shippingAddress;
  String city;
  String state;
  String country;
  String pinCode;
  String phoneNumber;

  Address({
    required this.name,
    required this.shippingAddress,
    required this.city,
    required this.state,
    required this.country,
    required this.pinCode,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'shippingAddress': shippingAddress,
      'city': city,
      'state': state,
      'country': country,
      'pinCode': pinCode,
      'phoneNumber': phoneNumber,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      name: map['name'],
      shippingAddress: map['shippingAddress'],
      city: map['city'],
      state: map['state'],
      country: map['country'],
      pinCode: map['pinCode'],
      phoneNumber: map['phoneNumber'],
    );
  }
}
