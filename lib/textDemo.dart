import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:tfl_project/service.dart';

class TextDemo extends StatefulWidget {
  const TextDemo({super.key});
  @override
  State<TextDemo> createState() => _TextDemoState();
}

class _TextDemoState extends State<TextDemo> {
  String run = '';
  String filepath = '';
  String jsonData = '';
  String start = '';
 

  void initState() {
    Timer.periodic(const Duration(hours: 1), (timer) {
      _SubmitData();
    });
    print('BackGround Service is running');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DATA SYNC SERVICE - TFL'),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _runConflig,
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.grey[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: 150,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () async {
                        _SubmitData();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.blueGrey), // set your desired color here
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Start',
                            textAlign: TextAlign.center,

                          ),
                          SizedBox(
                              width: 8.0), 
                          Icon(Icons.play_arrow), 
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 150,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () async {
                        _exitApp();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.blueGrey), 
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'End',
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                              width:
                                  8.0), 
                          Icon(Icons.stop), 
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(),
          Expanded(
            flex: 9,
            child: Container(
              color: Colors.cyan[50], 
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 start =='config'? Center(child: Text('$filepath . $run', style: const TextStyle(fontSize: 18),),):start!='' && start != 'config'? Center(child: Text(start, style:  TextStyle(fontSize: 21),)):Container(),
                  
                  //CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _exitApp() {
    exit(0);
  }

  _runConflig() {
     final myBox5 = Hive.box('myBox');
    setState(() {
      start = 'config';
      filepath = 'File PathF:/textDemo.txt';
      run = myBox5.get('LASTNUMBER').toString();
            // run = 'Text File LastNumber : 192';
    });
  }

  _SubmitData() async {
    start  = 'App is running';
     //CircularProgressIndicator();
    var getData = await AllServices().getFileData();
    List? finalList = AllServices().getFinalData(getData);
    jsonData = jsonEncode(finalList);
    print(jsonData);
    if(finalList.isNotEmpty){
 final response = await AllServices().submitData(finalList);
 print(
      jsonDecode(response.body)
    );
  }
    setState(() {});
  }
}
