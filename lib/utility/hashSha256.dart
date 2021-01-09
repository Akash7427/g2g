import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

import 'package:g2g/constants.dart';
import 'package:tripledes/tripledes.dart';
Map<String, String>  hashSHA256(){
  String userID = 'WEBSERVICES';
  String password = 'G2GW3bs3rv1c35';
  String salt='';
  //Random _rnd = Random();
  var saltCharList = chars;
  saltCharList.shuffle();
  var sublist = saltCharList.sublist(0,10);
  salt = sublist.join();

  print('Salt: '+salt);

  String hash=  base64.encode(sha256.convert(utf8.encode(salt+userID+password+subscriberKey)).bytes);

  print('Hash: '+hash);

  return {'salt':salt,'hash':hash};
}
void tripleDES(){
  //var key = "#finPOWERTesting@!@#\$###";
  var key = "#finPOWERTesting@!@#\$##";
  var blockCipher =  BlockCipher(TripleDESEngine(), key);
  var message = "Good2Go Loans";
  var ciphertext = blockCipher.encodeB64(message);
  var decoded = blockCipher.decodeB64(ciphertext);
  print("Key: $key");
  print("RawString: $message");
  print('Mode: ECB');
  print('Block Size: ${TripleDESEngine().algorithmName}');
  print("EncryptedString (this is base64 encoded): $ciphertext");
  print("DecryptedString (this is base64 decoded): $decoded");
}
// void tripleDESNew()async{
//   var key = "#finPOWERTesting@!@#\$";
//   const string = "encryption";
//   // const key = "702040801020305070B0D1101020305070B0D1112110D0B0";
//   // const iv = "070B0D1101020305";
//
//   // var encrypt = await Flutter3des.encrypt(string, key, iv: iv);
//   // var decrypt = await Flutter3des.decrypt(encrypt, key, iv: iv);
//   // var encryptHex = await Flutter3des.encryptToHex(string, key, iv: iv);
//   // var decryptHex = await Flutter3des.decryptFromHex(encryptHex, key, iv: iv);
//   var encryptBase64 = await Flutter3des.encryptToBase64(string, key);
//   var decryptBase64 = await Flutter3des.decryptFromBase64(encryptBase64, key);
//   print(encryptBase64);
//   print(decryptBase64);
// }

String getEncryptPassword(String password){
  String key = "#finPOWERTesting@!@#\\\$##";
  var blockCipher = BlockCipher(TripleDESEngine(), key);
  var ciphertext = blockCipher.encodeB64(password);
  print(ciphertext);
  return ciphertext;
}