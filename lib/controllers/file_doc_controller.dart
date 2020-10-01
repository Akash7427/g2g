import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_plugin.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:g2g/utility/pref_helper.dart';
import 'package:http/http.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class FileDocController with ChangeNotifier {
  File _docFile;

  Future<void> fetchDoc(String accountId, String docPk, String fileName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print(
        '$apiBaseURL/custom/GetAccountDocument?AccountID=$accountId&ClientID=${prefs.getString(PrefHelper.Pref_CLIENT_ID)}&DocumentPk=$docPk');
    // http.Response response = await http.get(
    //     '$apiBaseURL/custom/GetAccountDocument?AccountID=$accountId&ClientID=${prefs.getString(PrefHelper.Pref_CLIENT_ID)}',
    //     headers: {
    //       'Content-Type': 'application/json',
    //       HttpHeaders.authorizationHeader:
    //           'AuthFinWs token="${prefs.getString(PrefHelper.PREF_SESSION_TOKEN)}"'
    //     });

    var url =
        '$apiBaseURL/custom/GetAccountDocument?AccountID=$accountId&ClientID=${prefs.getString(PrefHelper.Pref_CLIENT_ID)}&DocumentPk=$docPk';

    HttpClient client = new HttpClient();
    client.getUrl(Uri.parse(url)).then((HttpClientRequest request) {
      request.headers.add('Content-Type', 'application/json');
      request.headers.add(HttpHeaders.authorizationHeader,
          'AuthFinWs token="${prefs.getString(PrefHelper.PREF_SESSION_TOKEN)}"');
      return request.close();
    }).then((HttpClientResponse response) {
      // Process the response.
      createFileOfPdfUrl(response, fileName).then((f) async {
        _docFile = f;
        await OpenFile.open(_docFile.path);

        notifyListeners();
      });
    });
  }

  Future<File> createFileOfPdfUrl(
      HttpClientResponse response, String fileName) async {
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$fileName');
    await file.writeAsBytes(bytes);
    return file;
  }

  File get getDocFile {
    return _docFile;
  }
}
