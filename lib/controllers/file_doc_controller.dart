import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:g2g/utility/pref_helper.dart';
import 'package:http/http.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as io;

import '../constants.dart';

class FileDocController with ChangeNotifier {
  File _docFile;

  Future<File> fetchDoc(String accountId, String docPk, String fileName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result;

    print(
        '$apiBaseURL/custom/GetAccountDocument?AccountID=$accountId&ClientID=${prefs.getString(PrefHelper.Pref_CLIENT_ID)}&DocumentPk=$docPk');
    // http.Response response = await http.get(
    //     '$apiBaseURL/custom/GetAccountDocument?AccountID=$accountId&ClientID=${prefs.getString(PrefHelper.Pref_CLIENT_ID)}',
    //     headers: {
    //       'Content-Type': 'application/json',
    //       HttpHeaders.authorizationHeader:
    //           'AuthFinWs token="${prefs.getString(PrefHelper.PREF_SESSION_TOKEN)}"'
    //     });
print('$apiBaseURL/custom/GetAccountDocument?AccountID=$accountId&ClientID=${prefs.getString(PrefHelper.Pref_CLIENT_ID)}&DocumentPk=$docPk');
    var url =
        '$apiBaseURL/custom/GetAccountDocument?AccountID=$accountId&ClientID=${prefs.getString(PrefHelper.Pref_CLIENT_ID)}&DocumentPk=$docPk';
    var request = await HttpClient().getUrl(Uri.parse(url));
     request.headers.add('Connection', 'keep-alive');
      request.headers.add(HttpHeaders.authorizationHeader,
          'AuthFinWs token="${prefs.getString(PrefHelper.PREF_SESSION_TOKEN)}"');
      

    var response = await request.close();
   _docFile = await createFileOfPdfUrl(response, fileName);
   return _docFile;

    // HttpClient client = new HttpClient();
    // client.getUrl(Uri.parse(url)).then((HttpClientRequest request) {
    //   request.headers.add('Connection', 'keep-alive');
    //   request.headers.add(HttpHeaders.authorizationHeader,
    //       'AuthFinWs token="${prefs.getString(PrefHelper.PREF_SESSION_TOKEN)}"');
    //   return request.close();
    // }).then((HttpClientResponse response) {
    //   // Process the response.
    //   createFileOfPdfUrl(response, fileName).then((f) async {
    //     _docFile = f;
         
    //     return _docFile;


    //   });
    // });
    
  }

  Future<File> createFileOfPdfUrl(
      HttpClientResponse response, String fileName) async {
        File file;
        try{
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
     file = new File('$dir/$fileName');
    await file.writeAsBytes(bytes);
        }catch (error){
          print(error);
        }
    return file;
  }


  Future<File> viewFile(String fileName) async {
    File file;
    try{
   
    String dir = (await getApplicationDocumentsDirectory()).path;
    bool present = await io.File('$dir/$fileName').exists();
    if(present){
      file = io.File('$dir/$fileName');
    }
    
    
        }catch (error){
          print(error);
        }
        return file;

  }



  File get getDocFile {
    return _docFile;
  }
}
