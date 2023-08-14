import 'dart:convert';

import 'package:data_table/model_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

//get data API
Future<List<ModelData>> fetchData() async {
  var url = Uri.parse('https://jsonplaceholder.typicode.com/albums');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => ModelData.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter DataTable Example'),
        ),
        body: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.blue,
            boxShadow: [
              BoxShadow(
                color: Colors.blue,
                offset: Offset(0, 3),
                blurRadius: 6,
              ),
            ],
          ),
          child: FutureBuilder<List<ModelData>>(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: DataTable(
                    columnSpacing: 30,
                    columns: const [
                      DataColumn(
                          label: Text(
                            'USER ID',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ), textAlign: TextAlign.center,
                          ), numeric: true),
                      DataColumn(
                          label: Text(
                            'ID',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ), textAlign: TextAlign.center,
                          ), numeric: true),
                      DataColumn(
                        label: Text(
                          'TITLE',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ), textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                    rows: List.generate(
                      snapshot.data!.length,
                      (index) {
                        var data = snapshot.data![index];
                        return DataRow(
                            color: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                              return Colors.white;
                            }),
                            cells: [
                              DataCell(
                                Text(data.userId.toString()),
                              ),
                              DataCell(
                                Text(data.id.toString()),
                              ),
                              DataCell(
                                Text(data.title),
                              ),
                            ]);
                      },
                    ).toList(),
                    showBottomBorder: true,
                  ),
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return const Center(
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)));
            },
          ),
        ));
  }
}
