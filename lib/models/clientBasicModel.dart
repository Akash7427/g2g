// To parse this JSON data, do
//
//     final clientBasicModel = clientBasicModelFromJson(jsonString);

import 'dart:convert';

ClientBasicModel clientBasicModelFromJson(String str) => ClientBasicModel.fromJson(json.decode(str));

String clientBasicModelToJson(ClientBasicModel data) => json.encode(data.toJson());

class ClientBasicModel {
  ClientBasicModel({
    this.clientId,
    this.name,
    this.contactMethodEmail,
    this.contactMethodEmailPk,
    this.contactMethodPhoneHome,
    this.contactMethodPhoneHomePk,
    this.contactMethodPhoneWork,
    this.contactMethodPhoneWorkPk,
    this.contactMethodMobile,
    this.contactMethodMobilePk,
    this.addressPhysicalFormatted,
    this.addressPhysical,
    this.addressPhysicalPk,
    this.addressPostalFormatted,
    this.addressPostal,
    this.addressPostalPk,
    this.dateOfBirth,
    this.gender,
  });

  String clientId;
  String name;
  String contactMethodEmail;
  int contactMethodEmailPk;
  dynamic contactMethodPhoneHome;
  dynamic contactMethodPhoneHomePk;
  dynamic contactMethodPhoneWork;
  dynamic contactMethodPhoneWorkPk;
  String contactMethodMobile;
  int contactMethodMobilePk;
  String addressPhysicalFormatted;
  AddressP addressPhysical;
  int addressPhysicalPk;
  String addressPostalFormatted;
  AddressP addressPostal;
  int addressPostalPk;
  DateTime dateOfBirth;
  String gender;

  factory ClientBasicModel.fromJson(Map<String, dynamic> json) => ClientBasicModel(
    clientId: json["ClientId"],
    name: json["Name"],
    contactMethodEmail: json["ContactMethodEmail"],
    contactMethodEmailPk: json["ContactMethodEmailPk"],
    contactMethodPhoneHome: json["ContactMethodPhoneHome"],
    contactMethodPhoneHomePk: json["ContactMethodPhoneHomePk"],
    contactMethodPhoneWork: json["ContactMethodPhoneWork"],
    contactMethodPhoneWorkPk: json["ContactMethodPhoneWorkPk"],
    contactMethodMobile: json["ContactMethodMobile"],
    contactMethodMobilePk: json["ContactMethodMobilePk"],
    addressPhysicalFormatted: json["AddressPhysicalFormatted"],
    addressPhysical: AddressP.fromJson(json["AddressPhysical"]),
    addressPhysicalPk: json["AddressPhysicalPk"],
    addressPostalFormatted: json["AddressPostalFormatted"],
    addressPostal: AddressP.fromJson(json["AddressPostal"]),
    addressPostalPk: json["AddressPostalPk"],
    dateOfBirth: DateTime.parse(json["DateOfBirth"]),
    gender: json["Gender"],
  );

  Map<String, dynamic> toJson() => {
    "ClientId": clientId,
    "Name": name,
    "ContactMethodEmail": contactMethodEmail,
    "ContactMethodEmailPk": contactMethodEmailPk,
    "ContactMethodPhoneHome": contactMethodPhoneHome,
    "ContactMethodPhoneHomePk": contactMethodPhoneHomePk,
    "ContactMethodPhoneWork": contactMethodPhoneWork,
    "ContactMethodPhoneWorkPk": contactMethodPhoneWorkPk,
    "ContactMethodMobile": contactMethodMobile,
    "ContactMethodMobilePk": contactMethodMobilePk,
    "AddressPhysicalFormatted": addressPhysicalFormatted,
    "AddressPhysical": addressPhysical.toJson(),
    "AddressPhysicalPk": addressPhysicalPk,
    "AddressPostalFormatted": addressPostalFormatted,
    "AddressPostal": addressPostal.toJson(),
    "AddressPostalPk": addressPostalPk,
    "DateOfBirth": dateOfBirth.toIso8601String(),
    "Gender": gender,
  };
}

class AddressP {
  AddressP({
    this.streetAddressFull,
    this.suburb,
    this.state,
    this.postcode,
    this.country,
  });

  String streetAddressFull;
  String suburb;
  String state;
  String postcode;
  String country;

  factory AddressP.fromJson(Map<String, dynamic> json) => AddressP(
    streetAddressFull: json["StreetAddressFull"],
    suburb: json["Suburb"],
    state: json["State"],
    postcode: json["Postcode"],
    country: json["Country"],
  );

  Map<String, dynamic> toJson() => {
    "StreetAddressFull": streetAddressFull,
    "Suburb": suburb,
    "State": state,
    "Postcode": postcode,
    "Country": country,
  };


}
