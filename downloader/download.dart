#!/usr/bin/env dart
import "dart:io";
import "package:http/http.dart" as http;

var client = new http.Client();

main(List<String> args) {
  if (args.length != 2) {
    print("Usage: download.dart <url> <path>");
    exit(1);
  }
  var url = args[0];
  var output = new File(args[1]);
  
  output.create()
    .then((_) => client.get(url))
    .then((response) {
      if (response.statusCode != 200) {
        print("ERROR: Failed to Download File: Status Code: ${response.statusCode}");
        exit(1);
      }
      output.writeAsBytes(response.bodyBytes);
    });
}