import 'dart:collection';
import 'dart:io';
import 'Client_Dao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:extended_image/extended_image.dart';

class ClientRegistrationForm extends StatefulWidget {
  const ClientRegistrationForm({super.key});

  @override
  State<ClientRegistrationForm> createState() => _ClientRegistationForm();
}

class _ClientRegistationForm extends State<ClientRegistrationForm> {
  // this key is used to uniquely identify this form
  final _formKey = GlobalKey<FormState>();
  var selectedFitnessGoal = "Muscle Gain";
  ClientDetailsHolder clientDetailsHolder = ClientDetailsHolder();
  ClientDao clientDao = new ClientDao();
// storage instance to store image in cloud storage
  final storageRef = FirebaseStorage.instance;
  
  var imageFileBytes;
  var _imageFile;
  var imageFileName="default_Image_name";
  
  String? imageFileExtension;

  @override
  Widget build(BuildContext context) {
    DateTime dateToday = new DateTime.now();
    // String dateToday = now.toString().substring(0, 10);
    //var dateToday=Timestamp.fromDate(now);
    print("current date :  ${dateToday}");

    clientDetailsHolder.joiningDate = dateToday;
    return Form(
        autovalidateMode: AutovalidateMode.always,
        key: _formKey,
        child: ListView(
          children: [
            Container(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "First Name",
                  labelText: "First Name",
                  contentPadding: EdgeInsets.all(15.0),
                  icon: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (String? value) {
                  return (value!.isEmpty) ? "Enter First Name " : null;
                },
                onSaved: (newValue) {
                  clientDetailsHolder.firstName = newValue!;
                  print("firstName : ${clientDetailsHolder.firstName}");
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Last Name",
                  labelText: "Last Name",
                  contentPadding: EdgeInsets.all(15.0),
                  icon: Icon(
                    Icons.person_outline_sharp,
                    color: Colors.black,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (String? value) {
                  return (value!.isEmpty) ? 'Enter Last Name' : null;
                },
                onSaved: (newValue) {
                  clientDetailsHolder.lastName = newValue!;
                  print("lastname : ${clientDetailsHolder.lastName}");
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Mobile No.",
                  labelText: "Mobile No.",
                  contentPadding: EdgeInsets.all(15.0),
                  icon: Icon(
                    Icons.phone_android,
                    color: Colors.black,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                onSaved: (newValue) {
                  clientDetailsHolder.mobileNo = int.parse(newValue!);
                  print("Mobile No.: ${clientDetailsHolder.mobileNo}");
                },
                validator: (value) {
                  String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                  RegExp regExp = new RegExp(patttern);
                  if (value!.length == 0) {
                    return 'Please enter mobile number';
                  } else if (!regExp.hasMatch(value!)) {
                    return 'Please enter valid mobile number';
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Row(children: [
                Icon(Icons.photo),Container(width: 7,),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: imageFileBytes!=null? Image.memory(imageFileBytes,width: 70,
                    height: 70,):Image.network(
                    clientDetailsHolder.clientImage,
                    width: 70,
                    height: 70,
                    //fit: BoxFit.fill,
                    //cancelToken: cancellationToken,
                  ),
                ),
                  
                   SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: FloatingActionButton(

                        onPressed: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['jpg', 'jpeg', 'png'],
                          );
                          if (result != null) {
                            imageFileBytes = result.files.first.bytes;
                             imageFileExtension = result.files.first.extension;
                           
                          } else {
                            // User canceled the picker
                          }
                          setState(() {
                            
                          });
                         },
                        child: Icon(Icons.add_a_photo),
                      )),
                
              ]),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Address",
                  labelText: "Address",
                  contentPadding: EdgeInsets.all(15.0),
                  icon: Icon(
                    Icons.home,
                    color: Colors.black,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (String? value) {
                  
                  if (value!.isEmpty) return "please enter address";
                  return null;
                },
                onSaved: (newValue) {
                  clientDetailsHolder.address = newValue!;
                  print("Address: ${clientDetailsHolder.address}");
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: "${dateToday.toString().substring(0, 10)}",
                  contentPadding: EdgeInsets.all(15.0),
                  icon: Icon(Icons.date_range_outlined, color: Colors.black),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.all(8.0),
                child: Row(children: [
                  Icon(Icons.fitness_center_outlined),
                  Container(width: 20),
                  Text(
                    "Fitness Goal  ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  DropdownButton(
                    hint: const Text("Fitness Goal"),
                    value: selectedFitnessGoal,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedFitnessGoal = newValue!;
                        clientDetailsHolder.fitnessGoal = newValue;
                        print(
                            "FItness goal ${clientDetailsHolder.fitnessGoal}");
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        child: Text("Muscle Gain"),
                        value: "Muscle Gain",
                      ),
                      DropdownMenuItem(
                          child: Text("Weight Loss"), value: "Weight Loss"),
                      DropdownMenuItem(
                          child: Text("Weight Gain"), value: "Weight Gain")
                    ],
                  )
                ])),
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                onSaved: (newValue) {
                  clientDetailsHolder.monthlyFees = int.parse(newValue!);
                  print(
                      "monthly_monthlyFees : ${clientDetailsHolder.monthlyFees} \n fitness Goal: ${clientDetailsHolder.fitnessGoal}");
                },
                validator: (value) {
                  String patttern = r'(^\d+$)';
                  RegExp regExp = new RegExp(patttern);
                  if (value!.length == 0) {
                    return 'Please enter valid Monthly Fees';
                  } else if (!regExp.hasMatch(value!)) {
                    return 'Please enter valid Monthly Fees';
                  }
                  if (int.parse(value) < 100) {
                    return "Please input Correct Monthly Fees";
                  }

                  return null;
                },
                decoration: InputDecoration(
                  hintText: "monthly fees",
                  labelText: "monthly fees",
                  contentPadding: EdgeInsets.all(15.0),
                  icon: Icon(Icons.payment_sharp, color: Colors.black),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            Container(
              height: 20,
            ),  Center(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: ElevatedButton(
                    onPressed: ()async {
                      print("Register button pressed");
                      const AlertDialog(title: Text("Registration Successfull"),content: Text("Client Registered Succesfully"),);
                        
                      print("Register button pressed");
                      if (_formKey.currentState!.validate()) {
                        print("calling all save()");
                        _formKey.currentState!.save();
                     
                            
        imageFileName= "${clientDetailsHolder.firstName}_${clientDetailsHolder.mobileNo}.$imageFileExtension";
                             
 print("Chosen a Image file  $imageFileName ");
                            try {
                              TaskSnapshot snapshot = await storageRef
                                  .ref("FitnessStorm_client_Images/$imageFileName")
                                  .putData(imageFileBytes!);

                              if (snapshot.state == TaskState.success) {
                                final String downloadUrl =
                                    await snapshot.ref.getDownloadURL();
                                clientDetailsHolder.clientImage = downloadUrl;
                                print(
                                    "sucessfuly stored image to cloud storage");
                              }
                            } on Exception catch (e) {
                              // ...
                              print("unable to add aimage $e");
                            }
 
                         clientDao.registerNewClient(clientDetailsHolder);
                     
                     
                      }
                    },
                    child: Text(
                      "Register",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
            Container(
              height: 20,
            )
          ],
        ));
  }
}

// for holding client data
class ClientDetailsHolder {
  String firstName = "";
  String lastName = "";
  int mobileNo = 0000;
// will store the image in cloudstorage and download the url and then store that url into firestore
//https://sanjeepan23.medium.com/adding-images-to-firebase-storage-and-cloud-firestore-in-flutter-6f0a09de4a5e#:~:text=you%20can%20add%20images%20by,simply%20copy%2Dpaste%20the%20images.&text=For%20the%20above%20changes%20to,yaml%20file.

  String clientImage = "https://cdn.pixabay.com/photo/2017/02/23/13/05/avatar-2092113_1280.png";
  String address = "";
  late DateTime joiningDate;
  String fitnessGoal = "Muscle Gain";
  int monthlyFees = 0000;
  // when we register new user at that time this two attendance will be empty and when we mark attendance we will add field ie. date=0 or 1, 0 for absent and 1 for present, 22=1,which means present on 22
  Map<int, int> currentMonthAttendance = new HashMap();
  Map<int, int> lastMonthAttendance = new HashMap();
//ClientDetailsHolder(this.firstName,this.lastName,this.mobileNo,this.address,this.joiningDate,this.fitnessGoal,this.monthlyFees);
  //String annualPlanFees=0;

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'mobileNo': mobileNo,
      'clientImage': clientImage,
      'address': address,
      'joiningDate': joiningDate,
      'fitnessGoal': fitnessGoal,
      'monthlyFees': monthlyFees,
      'currentMonthAttendance': currentMonthAttendance,
      'lastMonthAttendance': lastMonthAttendance,
    };
  }
}
