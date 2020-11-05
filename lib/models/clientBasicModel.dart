class ClientBasicModel{
  String clientId ,name,contactMethodEmail,contactMethodPhoneHome,
  contactMethodPhoneWork,contactMethodMobile,
  addressPhysicalFormatted,addressPhysical,streetAddressFull,suburb,city,postCode,
  dateOfBirth,gender;

  int contactMethodPhoneHomePk,contactMethodEmailPk,contactMethodMobilePk,contactMethodPhoneWorkPk,addressPhysicalPk;

  ClientBasicModel.fromJson(Map<String, dynamic> json)
      :

   clientId = json["ClientId"],
   name = json["Name"] ,
    contactMethodEmail=json["ContactMethodEmail"] ,
     contactMethodEmailPk=json["ContactMethodEmailPk"] ,
    contactMethodPhoneHome= json["ContactMethodPhoneHome"] ,
   contactMethodPhoneHomePk= json["ContactMethodPhoneHomePk"] ,
 contactMethodPhoneWork= json["ContactMethodPhoneWork"] ,
  contactMethodPhoneWorkPk=json["ContactMethodPhoneWorkPk"] ,
  contactMethodMobile=json["ContactMethodMobile"],
 contactMethodMobilePk= json["ContactMethodMobilePk"],
  addressPhysicalFormatted= json["AddressPhysicalFormatted"],
  streetAddressFull = json["AddressPhysical"]["StreetAddressFull"],
  suburb=json["AddressPhysical"]["Suburb"]  ,
  city = json["AddressPhysical"]["City"]    ,
  postCode = json["AddressPhysical"]["Postcode"]    ,
 addressPhysicalPk =  json["AddressPhysicalPk"]   ,
  dateOfBirth = json["DateOfBirth"] ,
  gender = json["Gender"];

  Map<String, dynamic> toJson() => {
    "ClientId":clientId,
    "Name":name,
    "ContactMethodEmail":contactMethodEmail,
    "ContactMethodEmailPk":contactMethodEmailPk,
    "ContactMethodPhoneHome":contactMethodPhoneHome,
    "ContactMethodPhoneHomePk":contactMethodPhoneHomePk,
    "ContactMethodPhoneWork":contactMethodPhoneWork,
    "ContactMethodPhoneWorkPk":contactMethodPhoneWorkPk,
    "ContactMethodMobile":contactMethodMobile,
    "ContactMethodMobilePk":contactMethodMobilePk,
    "AddressPhysicalFormatted":addressPhysicalFormatted,
    "AddressPhysical":{"StreetAddressFull":streetAddressFull,
      "Suburb":suburb,
      "City":city,
      "Postcode":postCode},
    "AddressPhysicalPk":addressPhysicalPk,
    "DateOfBirth":dateOfBirth,
    "Gender":gender
  };
}