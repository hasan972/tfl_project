import 'dart:convert';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:core';
import 'package:path_provider/path_provider.dart';

class AllServices {
  //......Access the data ...........Using readAsLines......//
  Future<List<String>> getFileData() async {
    final file = File('F:/textDemo.txt');
    List<String> lines = await file.readAsLines();
    return lines;
    //....Another Way To read the data......//
    // final file = File('F:/textDemo.txt');
    // String fileData = await file.readAsString();

    // String fileData = await rootBundle.loadString('F:/textDemo.txt');
    // List<String> lines = fileData.split('\n');
    // return lines;
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
  List getFinalData(List<String> lines) {
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
//........Store the data into this list............//
    List transactions = [];

    var lastNumber = lines.length;

    final _myBox = Hive.box('myBox');
    int startNumber = _myBox.get('LASTNUMBER') ?? 0;

    for (int i = startNumber; i < lastNumber; i++) {
      if (lines[i].contains('Chk ')) {
        chkNo = lines[i].replaceAll('\r', '');
        if (lines[i].indexOf('Chk') == 0) {
          chkNo = lines[i];
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
          List<String> emp = employeeInfo.replaceAll(RegExp(r'\s+'), ' ').trim().split(' ');
          employeeID = emp[0];
          epmployeeName = emp[1];
          terminal_id = emp[2];
          
          //Order Type//
          order_type = lines[i + 5].trim();

          // Subtotal//
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

          //VAT //
          for (int k = i + 1; k < nextChk; k++) {
            if (lines[k].contains('VAT')) {
              List<String> ValueAddedTax =
                  lines[k].replaceAll(RegExp(r'\s+'), ' ').trim().split(' ');
              vat = ValueAddedTax[1];
              break;
            }
          }

          // SD //
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

          // Item //
          var itemList = [];
          for (int k = i + 1; k < nextChk; k++) {
            if (countLeadingWhitespace(lines[k]) == 2) {
              List<String> itm =
                  lines[k].replaceAll(RegExp(r'\s+'), ' ').trim().split(' ');
              item_price = itm[itm.length - 1];
              itm.removeLast();
              item_name = itm.join(' ');

              itemList.add({'name': item_name, 'price': item_price});
            }
          }

          // Discount//

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

          // Tax Info List
          var taxes = [];
          taxes.add({'vat': vat, 'sd': sd});

          //Payment Info List
          var payments = [];
          payments.add({'payment_type': paymentMode, 'payment_amount': subTotal});

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
    final myBox5 = Hive.box('myBox');
    _myBox.put('LASTNUMBER', lastNumber);
    var last = _myBox.get('LASTNUMBER');
    print('Text File lastNumber:$last');

    //   //..........Hive part finish........//

    if (transactions.isNotEmpty) {
      return transactions;
    } else {
      return transactions;
    }

    //..Here is the code for pass the data in Api li
  }

  Future<http.Response> submitData(jsondata) async {
    http.Response response;

    var username = 'apiuser';
    var password = 'itsaDrill007';
    print('Basic ${base64.encode(utf8.encode('$username:$password'))}');

    response = await http.post(
        Uri.parse('http://w011.yeapps.com/tfl/api_tfl/receive_to_tfl'),
        headers: <String, String>{
          'Authorization':'Basic ${base64.encode(utf8.encode('$username:$password'))}'
        },
        body: jsonEncode(jsondata));
    return response;
  }
}
