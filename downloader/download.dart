#!/usr/bin/env dart
import "dart:io";
import "package:http/http.dart" as http;
import "package:args/args.dart";

var client = new http.Client();

var parser = new ArgParser();

main(List<String> args) {

  parser.addOption("url", abbr: "u", help: "URL to Download");
  parser.addOption("output", abbr: "o", help: "File to Output To"); 
  
  var opts = parser.parse(args);

  if (opts["url"] == null || opts["output"] == null) {
    print_usage();
    exit(1);
  }

  download_file(opts["url"], new File(opts["output"]));
}

print_usage() {
  print("Usage: downloader <options>");
  print(parser.getUsage());
}

download_file(String url, File outputFile) {
  outputFile.create()
    .then((_) => client.get(url))
    .then((response) {
      if (response.statusCode != 200) {
        print("ERROR: Failed to Download File: Status Code: ${response.statusCode}");
        exit(1);
      }
      outputFile.writeAsBytes(response.bodyBytes);
    });
}