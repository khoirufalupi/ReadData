import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Dsn>> fetchDsns(http.Client client) async {
  final response =
      await client.get('https://khoirufalupi.000webhostapp.com/readDatajson3.php');

  // Use the compute function to run parseDsns in a separate isolate.
  return compute(parseDsns, response.body);
}

// A function that converts a response body into a List<Dsn>.
List<Dsn> parseDsns(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Dsn>((json) => Dsn.fromJson(json)).toList();
}

class Dsn {
  final String nip;
  final String nama_pegawai;
  final String dapatemen;
  final String jabatan;
  final String pendidikan_terakhir;

  Dsn({this.nip, this.nama_pegawai, this.dapatemen, this.jabatan, this.pendidikan_terakhir});

  factory Dsn.fromJson(Map<String, dynamic> json) {
    return Dsn(
      nip: json['nip'] as String,
      nama_pegawai: json['nama_pegawai'] as String,
      dapatemen: json['dapatemen'] as String,
      jabatan: json['jabatan'] as String,
      pendidikan_terakhir: json['pendidikan_terakhir'] as String,
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Data Mahasiswa';

    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Dsn>>(
        future: fetchDsns(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? DsnsList(DsnData: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class DsnsList extends StatelessWidget {
  final List<Dsn> DsnData;

  DsnsList({Key key, this.DsnData}) : super(key: key);



Widget viewData(var data,int index)
{
return Container(
    width: 200,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.green,
      elevation: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
            //ClipRRect(
              //      borderRadius: BorderRadius.only(
                //      topLeft: Radius.circular(8.0),
                  //    topRight: Radius.circular(8.0),
                   // ),
                   // child: Image.network(
                    //    "https://elearning.binadarma.ac.id/pluginfile.php/1/theme_lambda/logo/1602057627/ubd_logo.png"
                    //    width: 100,
                     //   height: 50,
                        //fit:BoxFit.fill

                   // ),
                 // ),
            
          ListTile(
           //leading: Image.network(
             //   "https://elearning.binadarma.ac.id/pluginfile.php/1/theme_lambda/logo/1602057627/ubd_logo.png",
             // ),
            title: Text(data[index].nip, style: TextStyle(color: Colors.white)),
            subtitle: Text(data[index].nama_pegawai, style: TextStyle(color: Colors.white)),
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('Edit', style: TextStyle(color: Colors.white)),
                  onPressed: () {},
                ),
                FlatButton(
                  child: const Text('Delete', style: TextStyle(color: Colors.white)),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: DsnData.length,
      itemBuilder: (context, index) {
        return viewData(DsnData,index);
      },
    );
  }
}