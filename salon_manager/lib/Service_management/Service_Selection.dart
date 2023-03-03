import 'dart:collection';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salon_manager/Service_management/Service_Dao.dart';

class ServiceSelection extends StatefulWidget {
  // holds Userid
  late String userId;

  late String salonType;

  ServiceSelection(this.userId, this.salonType);
  @override
  State<StatefulWidget> createState() => _ServiceSelection(userId, salonType);
}

class _ServiceSelection extends State<ServiceSelection> {
  late String userId;
  late String salonType;
  int serviceCount = 0;
 Map serviceTaken={};

  ServiceDao _serviceDao = new ServiceDao();
  bool isServiceListLoaded = false;

  Map allServices = {
    "hair cut": 100,
    "Moustache set": 500,
    "facial": 300,
    "Hair color": 890
  };

  _ServiceSelection(this.userId, this.salonType);
  @override
  void initState() {
    // TODO: implement initState
    loadServices();
    print("init state done ");
  }

  loadServices() async {
// checking salon type to load men or women services

    if (salonType.toUpperCase() == 'womenSalon'.toUpperCase()) {
      allServices = await _serviceDao.fetchWomenServices();
    } else {
      allServices = await _serviceDao.fetchMenServices();
    }
    setState(() {
      isServiceListLoaded = true;
    });

    print("setstate called ");
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var cardSizeHeight = screenSize.height * 40 / 100;
    var cardSizeWidth = screenSize.width;

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
                        "Total Service :${serviceTaken.length}",
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
                            onPressed: () {

                           // popup should open on submit with all selected service
             showFinalServiceTakenDialog();
         
    
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
        body: !isServiceListLoaded
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
                                      onPressed: () {
                                       
                                        setState(() {
                                        serviceCount++;
                                          serviceTaken[allServices.keys.elementAt(index)]=allServices.values.elementAt(index);
                                        });
                                         print("service taken : $serviceTaken");
                                        
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
                }))
                );
  }
showFinalServiceTakenDialog(){
   var screenSize = MediaQuery.of(context).size;
    var cardSizeHeight = screenSize.height * 40 / 100;
    var cardSizeWidth = screenSize.width;

  showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(

                    content: Scaffold(body: ListView.builder(
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
                                    width: 2.0, color: Colors.black))),
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
                                          backgroundColor: Colors.black),
                                      onPressed: () {
                                       
                                        setState(() {
                                          
                                          serviceCount--;
                                          serviceTaken.remove(serviceTaken.keys.elementAt(index));
                                           Navigator.pop(context);
                                           showFinalServiceTakenDialog();

                                           
                                        });

                                         print("service taken : $serviceTaken");
                                        
                                      },
                                      child: AutoSizeText(
                                        "Remove",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
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
                                          height: cardSizeHeight * 25 / 100,
                                          width: cardSizeWidth,
                                          child: AutoSizeText(
                                            '\u{20B9}'
                                            "${serviceTaken.values.elementAt(index)}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                                fontSize: 20),
                                          )))),
                            )
                          ]),
                        ),
                      ),
                    ),
                  );
                }))
                    )
                    );         

                            });
                     


}



}

// add to  cart
//add dunctionaity to add button
// add custom service feature
// inititalize global variable salonName from firebase when login
// add condition for loading specific list by creating a variable
// change all Text to AutoSizeText
// akh jpki nai chahye 
// cross button 
// 
