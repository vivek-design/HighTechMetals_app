import 'package:flutter/material.dart';
import 'package:basic/Uitilities/col.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class csvfiledownload extends StatefulWidget {
  const csvfiledownload({super.key});

  @override
  State<csvfiledownload> createState() => _csvfiledownloadState();
}

Future<void> exportToCsv(List<List<dynamic>> rows) async {
  List<List<dynamic>> csvData = List.from(rows);
  String csv = const ListToCsvConverter().convert(csvData);

  final String dir = (await getExternalStorageDirectory())!.path;
  final String path = '$dir/data.csv';

  File file = File(path);
  await file.writeAsString(csv);

  // Optionally, you can open the file using a file explorer app
  // on the device:
  // await OpenFile.open(path);
}


class _csvfiledownloadState extends State<csvfiledownload> {
  @override
  Widget build(BuildContext context) {
     var size = MediaQuery.of(context).size;
    var heigh = size.height;
    var widt = size.width;
    return FutureBuilder(
        future: cal2(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
          
              return Scaffold(
                appBar: AppBar(
                  title: Text('Filter result'),
                  backgroundColor: rang.always,
                ),
                body: RefreshIndicator(
                  onRefresh: () {
                  
                    return Future.delayed(Duration(seconds: 1), () {
                      setState(() {});
                    });
                  },
                  child: SingleChildScrollView(
                    child: Container(
                      height: heigh,
                      width: widt,
                      child: Center(
                        child: Text(
                          "Nothing to show",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }


              return Scaffold(
                appBar: AppBar(
                  title: Text('Filter result'),
                  backgroundColor: rang.always,
                ),
                body: RefreshIndicator(
                  onRefresh: () {
                  
                    return Future.delayed(Duration(seconds: 1), () {
                      setState(() {});
                    });
                  },
                  child: SingleChildScrollView(
                    child: Container(
                      height: heigh,
                      width: widt,
                      child: Center(
                        child: Text(
                          "Nothing to show",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            
          
        });
  }
}