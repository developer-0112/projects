import 'dart:collection';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickalert/quickalert.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salon_manager/Service_management/Service_Dao.dart';
import 'package:salon_manager/main.dart';

import '../Client_managment/Client_Dao.dart';

class ServiceSelection extends StatefulWidget {
  // holds Userid
  late String clientId;
  late String salonType;

  ServiceSelection({required this.clientId, required this.salonType});
  @override
  State<StatefulWidget> createState() => _ServiceSelection(clientId, salonType);
}

class _ServiceSelection extends State<ServiceSelection> {
  late String clientId;
  late String salonType;
  int serviceCount = 0;
  Map serviceTaken = {};

  ClientDao _clientDao = new ClientDao();
  ServiceDao _serviceDao = new ServiceDao();
  bool isServiceListAndUserDataLoaded = false;
  bool isServiceDataSaved = false;
  Map<String, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (TextEditingController controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  List allPaymentTypes = [
    "cash",
    "BharatPay",
    "phone pay",
    "Farzi Payment Method"
  ];

  Map allServices = {
    "hair cut": 100,
    "Moustache set": 500,
    "facial": 300,
    "Hair color": 890
  };

  num totalAmount = 0;

  Map _selectedPaymentTypes = {};

  int _dueAmount = 0;

  var clientData;

  //var finalAmount;

  _ServiceSelection(this.clientId, this.salonType);
  @override
  void initState() {
    super.initState();
    for (String key in allPaymentTypes) {
      _controllers[key] = TextEditingController();
    }
    loadServicesAndUserData();
    print("init state done ");
  }

  loadServicesAndUserData() async {
// checking salon type to load men or women services

    if (salonType.toUpperCase() == 'womenSalon'.toUpperCase()) {
      allServices = await _serviceDao.fetchWomenServices();
    } else {
      allServices = await _serviceDao.fetchMenServices();
    }
    clientData = await _clientDao.fetchClientUsingClientId("ram_1111111111");

    setState(() {
      isServiceListAndUserDataLoaded = true;
    });

    print("setstate called client id $clientId");
  }

  // save data on succesful service
  saveServiceData() async {
// save data in client section
//save data in today service section
    ServiceDetails(
        amount: totalAmount.toInt(),
        services: serviceTaken.keys.toString(),
        stylistName: "Ram Stylist",
        payType: _selectedPaymentTypes);

    // change this object to format and then send that
// add choose stylist at time of finalpopup

    await _clientDao.saveClientServiceDetails('rajesh_9165112041', "ss");
    print("data saved ");
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var cardSizeHeight = screenSize.height * 40 / 100;
    var cardSizeWidth = screenSize.width;

    print(" Service taken ${serviceTaken.keys.toString()} ");

    print("widget called");
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text((salonType.toUpperCase() == 'womenSalon'.toUpperCase())
                ? "Women Salon"
                : "Men Salon")),
        bottomNavigationBar: InkWell(
            child: Container(
                height: MediaQuery.of(context).size.height * 10 / 100,
                color: Colors.grey[350],
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          child: AutoSizeText(
                        "Services :${serviceTaken.length}  Amount: $totalAmount ",
                        style: TextStyle(fontSize: 30),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 40 / 100,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange),
                            onPressed: serviceTaken.length == 0
                                ? null
                                : () {
                                    //     finalAmount=totalAmount+clientData['previousDues'];

                                    // popup should open on submit with all selected service
                                    showFinalServiceTakenDialog();

                                    print("client $clientId");
                                    //  Navigator.push(context,
                                    //   MaterialPageRoute(builder: (context) => TotalService(clientId: clientId,)),);
                                  },
                            child: AutoSizeText(
                              "Submit",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 30),
                            )),
                      ),
                    ),
                  ],
                ))),
        body: !isServiceListAndUserDataLoaded
            ? SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                child: Center(
                    widthFactor: double.infinity,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    )))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: allServices.length,
                itemBuilder: ((context, index) {
                  return Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    height: cardSizeHeight,
                    width: cardSizeWidth,
                    child: Card(
                      elevation: 5,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    width: 2.0, color: Colors.black))),
                        child: Padding(
                          padding: EdgeInsets.all(7),
                          child: Stack(children: [
                            SizedBox(
                              width: cardSizeWidth * 70 / 100,
                              height: cardSizeHeight * 70 / 100,
                              child: AutoSizeText(
                                "${allServices.keys.elementAt(index)}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 40),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: SizedBox(
                                  width: cardSizeWidth * 20 / 100,
                                  height: cardSizeHeight * 20 / 100,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black),
                                      onPressed: serviceTaken.containsKey(
                                              allServices.keys.elementAt(index))
                                          ? null
                                          : () {
                                              setState(() {
                                                if (!serviceTaken.containsKey(
                                                    allServices.keys
                                                        .elementAt(index))) {
                                                  totalAmount = totalAmount +
                                                          allServices.values
                                                              .elementAt(index)
                                                      as int;
                                                  serviceTaken[allServices.keys
                                                          .elementAt(index)] =
                                                      allServices.values
                                                          .elementAt(index);
                                                }
                                              });
                                              print(
                                                  "service taken : $serviceTaken");
                                            },
                                      child: AutoSizeText(
                                        "Add+",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 40),
                                      )),
                                ),
                              ),
                            ),
                            SizedBox(
                              child: Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: SizedBox(
                                          height: cardSizeHeight * 25 / 100,
                                          width: cardSizeWidth,
                                          child: AutoSizeText(
                                            '\u{20B9}'
                                            "${allServices.values.elementAt(index)}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                                fontSize: 50),
                                          )))),
                            )
                          ]),
                        ),
                      ),
                    ),
                  );
                })));
  }

  showPaymentSummaryDialog() {
    var screenSize = MediaQuery.of(context).size;
    var cardSizeHeight = screenSize.height * 20 / 100;
    var cardSizeWidth = screenSize.width;

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
          
          return AlertDialog( 
              title: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1.5, color: Colors.grey))),
                child: Text(
                  " Payment Summary",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              content: Container(
                width: double.maxFinite,
                height: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                        height: screenSize.height * 5 / 100,
                        width: screenSize.width,
                        padding: EdgeInsets.all(4.0),
                        child: AutoSizeText(
                          "Total Amount : ${totalAmount}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 44),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton(
                          isExpanded: true,
                          icon: Icon(Icons.payment),
                          hint: Text("--Select Payment Method--"),
                          items: allPaymentTypes
                              .where((paymentType) =>
                                  !_selectedPaymentTypes.containsKey(paymentType))
                              .map((paymentType) {
                            return DropdownMenuItem(
                              value: paymentType,
                              child: Text(paymentType),
                            );
                          }).toList(),
                          onChanged: ((key) {
                            setState(() {
                              // adding value i.e cash or .. to map with defult value 0
          
                              if (!_selectedPaymentTypes.containsKey(key)) {
                                _selectedPaymentTypes[key!] = 0;
                              }
          
                              print(
                                  " Added selected payment type:   ${_selectedPaymentTypes}");
                              Navigator.pop(context);
                              showPaymentSummaryDialog();
                            });
                          })),
                    ),
                    Container(
                        width: double.maxFinite,
                        height: double.maxFinite,
                        child: ListView(
                          shrinkWrap: true,
                          children: _selectedPaymentTypes.keys
                              .map(
                                (key) => Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    child: TextField(
                                      controller: _controllers[key],
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: "$key",
                                        hintText: "Please enter amount",
                                        contentPadding: EdgeInsets.all(15.0),
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                      ),
                                      onChanged: (value) {
                                         
           setState(() {
             print("setstate called on changed ");
                
           });
          
                                      },
          //                                   onChanged: (value) {
          //     if (int.tryParse(value) != null && int.parse(value) > totalAmount ) {
          //          _controllers[key]!.text= '$totalAmount';
          
          //     }
          
          //     // adding all amount entered in textfield of selected payment
          
          //     print("Selectedpay : $_selectedPaymentTypes");
          //   num  tempValue= _selectedPaymentTypes.values.fold(0, (a,b) => (a + ( b is num ?b:double.parse(b) )) );
          
          //     print("check 2");
          
          //  if(int.tryParse(value) != null && ((int.parse(value)+tempValue)  > totalAmount ) ){
          //      print("in onchanged value : $value");
          //          _controllers[key]!.text= '${totalAmount-tempValue}';
          
          //   }
          
          //   },
                                      onEditingComplete: () {
                                        num enteredAmount =
                                            num.parse(_controllers[key]!.text);
          
                                        _selectedPaymentTypes[key] =
                                            enteredAmount;
          
                                        if (_controllers[key]!.text.isEmpty) {
                                          _selectedPaymentTypes[key] = 0;
                                          _controllers[key]!.text = '0';
                                        }
                                        print(
                                            'Selected Payment Types: $_selectedPaymentTypes');
                                        print(
                                            'Entered text for $key: $enteredAmount');
          
                                        setState(() {
                                          Navigator.pop(context);
                                          showPaymentSummaryDialog();
                                        });
                                      },
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                    )),
                              )
                              .toList(),
                        )),
                  ],
                ),
              ),
              actions: [
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1.5, color: Colors.grey))),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: _selectedPaymentTypes.isEmpty
                          ? null
                          : () {
                              setState(() {
                                _selectedPaymentTypes.clear();
                                Navigator.pop(context);
                                showPaymentSummaryDialog();
                              });
                            },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text("Clear All")),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          onPressed: 
                          serviceTaken.isNotEmpty &&
                                  ((_selectedPaymentTypes.values.fold(0, (a, b) {
                                        num tempValue =
                                            a + (b is num ? b : int.parse(b));
                                        return tempValue.toInt();
                                      })) ==
                                      totalAmount)
                              ? () {
                                  //             showPaymentSummaryDialog();
                                  //    QuickAlert.show(
                                  //     context: context,
                                  //     text: "Service Completed Successfully ",
                                  //     type: QuickAlertType.success,
                                  //     confirmBtnColor: Colors.amber,
                                  //     onConfirmBtnTap: () {
                                  //       saveServiceData();
          
                                  //       print("succes popup");
                                  //       Navigator.of(context).pushAndRemoveUntil(
                                  //           MaterialPageRoute(
                                  //               builder: (context) =>  Scaffold(appBar: AppBar(title: Text("dummy")),)),
                                  //           (Route route) => false);
                                  //     },
                                  //   );
                                }
                              : null,
                          child: Text(
                            "Mark Done ",
                            style: TextStyle(fontSize: 22),
                          )),
                    )
                  ],
                )
              ],
            );
            }
          );
        });
  }

  showFinalServiceTakenDialog() {
    var screenSize = MediaQuery.of(context).size;
    var cardSizeHeight = screenSize.height * 20 / 100;
    var cardSizeWidth = screenSize.width;

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                " Total Service ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                //clientData['previousDues']  ==0 ?
                Container(
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(width: 1.5, color: Colors.grey))),
                    height: screenSize.height * 5 / 100,
                    width: screenSize.width,
                    padding: EdgeInsets.all(4.0),
                    child: AutoSizeText(
                      "Total Amount : ${totalAmount}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 44),
                    )),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child:
                              Text("Cancel", style: TextStyle(fontSize: 22))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          onPressed: serviceTaken.length == 0
                              ? null
                              : () {
                                  showPaymentSummaryDialog();
                                  //    QuickAlert.show(
                                  //     context: context,
                                  //     text: "Service Completed Successfully ",
                                  //     type: QuickAlertType.success,
                                  //     confirmBtnColor: Colors.amber,
                                  //     onConfirmBtnTap: () {
                                  //       saveServiceData();

                                  //       print("succes popup");
                                  //       Navigator.of(context).pushAndRemoveUntil(
                                  //           MaterialPageRoute(
                                  //               builder: (context) =>  Scaffold(appBar: AppBar(title: Text("dummy")),)),
                                  //           (Route route) => false);
                                  //     },
                                  //   );
                                },
                          child: Text(
                            "Payments ",
                            style: TextStyle(fontSize: 22),
                          )),
                    )
                  ],
                )
              ],
              content: Scaffold(
                  body: serviceTaken.length == 0
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              Text("No Service Selected "),
                            ])
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: serviceTaken.length,
                          itemBuilder: ((context, index) {
                            print("reloaded show dialog ");
                            return Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              height: cardSizeHeight,
                              width: cardSizeWidth,
                              child: Card(
                                elevation: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              width: 2.0,
                                              color: Colors.black))),
                                  child: Padding(
                                    padding: EdgeInsets.all(7),
                                    child: Stack(children: [
                                      SizedBox(
                                        width: cardSizeWidth * 70 / 100,
                                        height: cardSizeHeight * 70 / 100,
                                        child: AutoSizeText(
                                          "${serviceTaken.keys.elementAt(index)}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 20),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: SizedBox(
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.red),
                                                onPressed: () {
                                                  setState(() {
                                                    totalAmount = totalAmount -
                                                        (serviceTaken.values
                                                            .elementAt(
                                                                index)) as int;

                                                    serviceTaken.remove(
                                                        serviceTaken.keys
                                                            .elementAt(index));
                                                    Navigator.pop(context);
                                                    showFinalServiceTakenDialog();
                                                  });

                                                  print(
                                                      "service taken : $serviceTaken");
                                                },
                                                child: AutoSizeText(
                                                  "Remove",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                )),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        child: Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Align(
                                                alignment: Alignment.bottomLeft,
                                                child: SizedBox(
                                                    height: cardSizeHeight *
                                                        25 /
                                                        100,
                                                    width: cardSizeWidth,
                                                    child: AutoSizeText(
                                                      '\u{20B9}'
                                                      "${serviceTaken.values.elementAt(index)}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.grey,
                                                          fontSize: 20),
                                                    )))),
                                      )
                                    ]),
                                  ),
                                ),
                              ),
                            );
                          }))));
        });
  }
}

class ServiceDetails {
  var stylistName = "stylist_Name";
  var services = "";
  late int amount = 0;
  late DateTime dateToday = DateTime.now();
  late Map payType = {};

  ServiceDetails(
      {required this.stylistName,
      required this.services,
      required this.amount,
      required this.payType});

  var serviceDetails = [
    {
      'sameer master': {
        "services": "chethe hair , faltu cutting",
        "amount": 300,
        "date": "2/1/2023"
      }
    }
  ];
}
// add custom service feature
// inititalize global variable salonName from firebase when login
// change all Text to AutoSizeText
// akh jpki nai chahye
// submit button functionality
// submit button ftra he
// succesful popup after service submited
//save service using staff id and in total service of day
//show total service  and to owner
// stylistName define krna hai
