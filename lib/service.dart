import 'dart:convert';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'package:path/path.dart';

class AllServices {
  Future<List<String>> getFileData() async {
    List<String> allFiles = [];
    var folderDir = Directory('D:/FileRead');
    List files = folderDir.listSync();

    allFiles.clear();
    for (var file in files) {
      if (file is File) {
        allFiles.add(basename(file.path));
      }
    }
    return allFiles;
  }

  List getFilePath() {
    var folderDir = Directory('D:/FileRead');
    List files = folderDir.listSync();
    return files;
  }

  //.....Count Leading Whitespace............//
  int countLeadingWhitespace(String a) {
    int count = 0;
    for (int i = 0; i < a.length; i++) {
      if (a[i] == ' ') {
        count++;
      } else {
        break;
      }
    }
    return count;
  }

  List getFinalData(String fileName) {
    String path = 'D:/FileRead/' + fileName;
    final file = File(path);
    List<String> lines = file.readAsLinesSync();

    String subTotal = '';
    String chkNo = '';
    String employeeInfo = '';
    String epmployeeName = '';
    String employeeID = '';
    String vat = '';
    String paymentMode = '';
    String sd = '';
    String order_type = '';
    String terminal_id = '';
    String item = '';
    String item_name = '';
    String item_price = '';
    int nextChk = 0;
    int increment = 0;
    String discount = '';
    bool nextChkFound;
    bool sdFound;
    //last update//
    bool vatFound;
    bool subTotalFound;
    bool discountFound;
    String chkopenTime = '';
//........Store the data into this list............//
    List transactions = [];
    var lastNumber = lines.length;

    final _myBox = Hive.box('myBox');
    //_myBox.put('LASTNUMBER', 0);
    int startNumber = _myBox.get('$fileName') ?? 0;

    for (int i = startNumber; i < lastNumber; i++) {
      if (lines[i].contains('Chk ')) {
        // chkNo = lines[i].replaceAll('\r', '');
        if (lines[i].indexOf('Chk') == 0) {
          //  chkNo = lines[i];
          List<String> chk =
              lines[i].replaceAll(RegExp(r'\s+'), ' ').trim().split(' ');
          chkNo = chk[0] + ' ' + chk[1];

          // Next chk line
          nextChkFound = false;
          for (int z = (i + 1); z < lastNumber; z++) {
            if (lines[z].contains('Chk ')) {
              chkNo = lines[i].replaceAll('\r', '');
              if (lines[z].indexOf('Chk') == 0) {
                nextChk = z;
                nextChkFound = true;
                break;
              }
            }
          }
          if (!nextChkFound) {
            nextChk = lines.length;
          }

          //Employee Info//
          employeeInfo = lines[i + 1];
          List<String> emp =
              employeeInfo.replaceAll(RegExp(r'\s+'), ' ').trim().split(' ');
          employeeID = emp[0];
          epmployeeName = emp[1];
          terminal_id = emp[2];

          order_type = lines[i + 5].trim();

          //last update
          List<String> openTime =
              lines[i + 3].replaceAll(RegExp(r'\s+'), ' ').trim().split(' ');
          chkopenTime = openTime[3];

          // Subtotal//
          subTotalFound = false;
          for (int j = i + 1; j < nextChk; j++) {
            if (lines[j].contains('Subtotal')) {
              List<String> SubTot =
                  lines[j].replaceAll(RegExp(r'\s+'), ' ').trim().split(' ');
              subTotal = SubTot[1];

              //Payment Mode//
              List<String> pm = lines[j - 1]
                  .replaceAll(RegExp(r'\s+'), ' ')
                  .trim()
                  .split(' ');
              paymentMode = pm[0];
              break;
            }
          }
          if (!subTotalFound) {
            subTotal = '0';
            paymentMode = '';
          }

          //VAT //
          vatFound = false;
          for (int k = i + 1; k < nextChk; k++) {
            if (lines[k].contains('VAT')) {
              List<String> ValueAddedTax =
                  lines[k].replaceAll(RegExp(r'\s+'), ' ').trim().split(' ');
              vat = ValueAddedTax[1];
              break;
            }
          }
           if (!vatFound) {
            vat = '0';
          }

          // SD //
          sdFound = false;
          for (int l = i + 1; l < nextChk; l++) {
            if (lines[l].contains('SD')) {
              List<String> sd_value =
                  lines[l].replaceAll(RegExp(r'\s+'), ' ').trim().split(' ');
              sd = sd_value[1];
              break;
            } else {
              sd = '0';
            }
          }
          if (!sdFound) {
            sd = '0';
          }

          // Item //
          var itemList = [];
          for (int k = i + 1; k < nextChk; k++) {
            if (countLeadingWhitespace(lines[k]) == 2) {
              List<String> itm =
              lines[k].replaceAll(RegExp(r'\s+'), ' ').trim().split(' ');
              item_price = itm[itm.length - 1].replaceAll(RegExp(r'[^.0-9]'), '');
              itm.removeLast();
              item_name = itm.join(' ');
              itemList.add({'name': item_name, 'price': item_price});
            }
          }

          // Discount//
          discountFound = false;
          for (int p = i + 1; p < nextChk; p++) {
            if (lines[p].contains('DIS-')) {
              List<String> discountAmt =
                  lines[p].replaceAll(RegExp(r'\s+'), ' ').trim().split(' ');
              discount =
                  discountAmt[discountAmt.length - 1].replaceAll('-', '');
              break;
            } else {
              discount = '0';
            }
          }
          if (!discountFound) {
              discount = '0';
            }

          // Tax Info List
          var taxes = [];
          taxes.add({'vat': vat, 'sd': sd});

          //Payment Info List
          var payments = [];
          payments
              .add({'payment_type': paymentMode, 'payment_amount': subTotal});

          // Discount Info List
          var discountDetails = [];
          discountDetails.add({'id': '', 'name': '', 'amount': discount});

          transactions.add({
            'storeId': '',
            'check_number': chkNo,
            'employee_id': employeeID,
            'employee_name': epmployeeName,
            'terminal_id': terminal_id,
            'checkOpenTime': '',
            'checkCloseTime': '',
            'order_type': order_type,
            'items': itemList,
            'discountDetails': discountDetails,
            'taxes': taxes,
            'payments': payments,
            'subtotal': subTotal,
          });
        }
      }
    }
    //............Hive.............//
    // _myBox.put('$fileName', lastNumber);
    // var last = _myBox.get('$fileName');
    // print('Last Line number of $fileName: $last');
    //   //..........Hive part finish........//

    // if (transactions.isNotEmpty) {
    //   return transactions;
    // } else {
    //   return transactions;
    // }
    //..Here is the code for pass the data in Api link
    var finalData = [];
    finalData.add({
      'transactions': transactions,
      'file_name': fileName,
      'last_line_number': lastNumber
    });
    return finalData;
  }

  Future<http.Response> submitData(jsondata) async {
    http.Response response;

    // var username = 'apiuser';
    // var password = 'itsaDrill007';
    // print('Basic ${base64.encode(utf8.encode('$username:$password'))}');

    response = await http.post(
        //Uri.parse('http://w011.yeapps.com/tfl/api_tfl/receive_to_tfl'),
Uri.parse('http://10.168.27.168/tfl/api_tfl_insert/_entry'),
        // headers: <String, String>{
        //   'Authorization':
        //       'Basic ${base64.encode(utf8.encode('$username:$password'))}'
        // },
        body: jsonEncode(jsondata));

    return response;
  }
}
