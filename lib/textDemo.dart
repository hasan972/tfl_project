import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tfl_project/service.dart';
import 'dart:core';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class TextDemo extends StatefulWidget {
  const TextDemo({super.key});
  @override
  State<TextDemo> createState() => _TextDemoState();
}

class _TextDemoState extends State<TextDemo> {
  bool _isTimerRunning = false;
  Timer? _timer;
  String jsonData = '';
  String start = '';
  String last = '';
  String getData = '';
  List getPath = [];
  List getLastno = [];
  List<String> filelist = [];
  final _myBox = Hive.box('myBox');
  var data;

  void startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      _SubmitData();
    });
    print('BackGround Service is running');
  }

  void stopTimer() {
    start = 'BackGround Service is Stop';
    _timer?.cancel();
    print('BackGround Service is Stop');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DATA SYNC SERVICE - TFL (GULSHAN BRANCH)'),
        backgroundColor: const Color.fromARGB(255, 12, 83, 141),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Config',
            onPressed: _runConflig,
            hoverColor: Colors.black,
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: const Color.fromARGB(255, 181, 216, 245),
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
                        if (!_isTimerRunning) {
                          startTimer();
                          setState(() {
                            _isTimerRunning = true;
                          });
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 12, 83,
                                141)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Start',
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(width: 8.0),
                          Tooltip(
                            message: 'Start the Data Sync Service',
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.green,
                            ),
                          ),
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
                        if (_isTimerRunning) {
                          stopTimer();
                          setState(() {
                            _isTimerRunning = false;
                          });
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 12, 83, 141)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Stop',
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(width: 8.0),
                          Tooltip(
                            message: 'End the Data Sync Service',
                            child: Icon(
                              Icons.stop,
                              color: Colors.red,
                            ),
                          ),
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
                        _reset();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 12, 83, 141)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Reset',
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(width: 8.0),
                          Tooltip(
                            message: 'Reset the config information',
                            child: Icon(
                              Icons.refresh,
                              color: Colors.yellow,
                            ),
                          ),
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
                            const Color.fromARGB(255, 12, 83, 141)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Exit',
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(width: 8.0),
                          Tooltip(
                            message: 'Exit from the Data Sync Service',
                            child: Icon(
                              Icons.exit_to_app,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 230,
                      child: Image.asset(
                        'lib/images/TFL.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const VerticalDivider(),
          Expanded(
            flex: 9,
            child: Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                Container(
                  color: const Color.fromARGB(255, 227, 242, 252),
                  child: ListView(
                    children: start == 'config'
                        ? getPath.map((file) {
                            if (file is File) {
                              data = _myBox.get(basename(file.path));
                            }
                            return Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        style: const TextStyle(fontSize: 18),
                                        children: [
                                          const TextSpan(
                                            text: 'Directory Path :- ',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          TextSpan(
                                            text: '$file',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 12, 83, 141)),
                                          ),
                                          const TextSpan(
                                            text: ' = ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                          TextSpan(
                                            text: '$data',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 12, 83, 141)),
                                          ),
                                          const TextSpan(
                                            text: ' is the last number.',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ));
                          }).toList()
                        : start != '' && start != 'config'
                            ? [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            start,
                                            style: const TextStyle(
                                                fontSize: 21,
                                                color: Color.fromARGB(
                                                    255, 12, 83, 141),
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                            : start != '' &&
                                    start != 'config' &&
                                    start == 'BackGround Service is running'
                                ? [
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Text(
                                                  start,
                                                  style: const TextStyle(
                                                      fontSize: 21,
                                                      color: Color.fromARGB(
                                                          255, 12, 83, 141),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]
                                : [Container()],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        double fontSize = constraints.maxWidth < 600 ? 12 : 15;
                        String formattedDateTime =
                            DateFormat('yyyy-MM-dd HH:mm')
                                .format(DateTime.now());
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Date and Time :- $formattedDateTime',
                            style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 12, 83, 141)),
                          ),
                        );
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Powered By :- Transcom Technology',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 12, 83, 141)),
                      ),
                    )
                  ],
                ),
              ],
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
    final _myBox = Hive.box('myBox');
    setState(() {
      start = 'config';
      getPath = AllServices().getFilePath();
    });
  }

  Future<void> _reset() async {
    List getData = await AllServices().getFileData();
    await Future.forEach(getData, (posFilename) async {
      _myBox.put('$posFilename', 0);
      int x = _myBox.get('$posFilename');
      print(x);
    });
  }

  Future<void> _SubmitData() async {
    start = 'Background Service is running';
    List getData = await AllServices().getFileData();
    await Future.forEach(getData, (posFilename) async {
      List? finalList = AllServices().getFinalData(posFilename);

      var jsonData = jsonEncode(finalList[0]['transactions']);
      var fileName = finalList[0]['file_name'];
      var lastNumber = finalList[0]['last_line_number'];

      print(jsonData);
      if (finalList[0]['transactions'] != null &&
          finalList[0]['transactions'].isNotEmpty) {
        final response =
        await AllServices().submitData(finalList[0]['transactions']);

        print(jsonDecode(response.body));
        _myBox.put('$fileName', lastNumber);
        var last = _myBox.get('$fileName');
        print('Last Line number of $fileName: $last');
      }
      setState(() {});
    });
  }
}
