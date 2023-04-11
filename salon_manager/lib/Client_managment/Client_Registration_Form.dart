 
import 'dart:io';
import 'Client_Dao.dart'; 
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart'; 
import 'package:date_time_picker/date_time_picker.dart';

class ClientRegistrationForm extends StatefulWidget {
  const ClientRegistrationForm({super.key});

  @override
  State<ClientRegistrationForm> createState() => _ClientRegistationForm();
}

class _ClientRegistationForm extends State<ClientRegistrationForm> {
  // this key is used to uniquely identify this form
  final _formKey = GlobalKey<FormState>();

  ClientDetailsHolder clientDetailsHolder = ClientDetailsHolder();
  ClientDao clientDao = new ClientDao();
// storage instance to store image in cloud storage
  final storageRef = FirebaseStorage.instance;

  String _selectedGender = "M";

  @override
  Widget build(BuildContext context) {
    DateTime dateToday = new DateTime.now();

    return Scaffold(
      appBar: AppBar(title: Text("Client Registration"),backgroundColor: Colors.black), 
      body: Form(
          autovalidateMode: AutovalidateMode.always,
          key: _formKey,
          child: ListView(children: [
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
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                ),
                Text(
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    "Gender"),
              ],
            ),
            ListTile(
              title: Text("Male"),
              leading: Radio(
                value: "M",
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                    clientDetailsHolder.gender = _selectedGender;
                  });
                  print("$value selected");
                },
              ),
            ),
            ListTile(
              title: Text("Female"),
              leading: Radio(
                value: "F",
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                    clientDetailsHolder.gender = _selectedGender;
                  });
                  print("$value selected");
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
            Container(padding: EdgeInsets.all(8.0),
              child: DateTimePicker(
                type: DateTimePickerType.date,
                firstDate: DateTime(1930),
                onChanged: (value) {
                  clientDetailsHolder.dob = DateTime.parse(value);
                  print("selected Date of birth : ${clientDetailsHolder.dob}");
                },validator: (value) {
                   return (value!.length ==0 )?"Please choose date" :null;  
                   }
                 ,
                decoration: InputDecoration(  contentPadding: EdgeInsets.all(15.0),
                    hintText: "Date Of Birth",
                    icon: Icon(
                      Icons.date_range,
                      color: Colors.black,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200]),
                lastDate: DateTime(2100),
              ),
            ),
            Container(padding: EdgeInsets.all(8.0),
              child: DateTimePicker(
                type: DateTimePickerType.date,
                firstDate: DateTime(1930),
                onChanged: (value) {
                  clientDetailsHolder.marriageAnniversary = DateTime.parse(value);
                  print(
                      "selected anniversary Date : ${clientDetailsHolder.marriageAnniversary}");
                },validator: (value) {
                   return (value!.length ==0 )?"Please choose date" :null;  
                   },
                lastDate: DateTime(2100),
                 decoration: InputDecoration(  contentPadding: EdgeInsets.all(15.0),
                    hintText: "Marriage Anniversary",
                    icon: Icon(
                      Icons.date_range,
                      color: Colors.black,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200]),
                  
              ),
            ),
            Container(
              height: 20,
            ),
            Center(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: ElevatedButton(
                    onPressed: () async {
                      print("Register button pressed");
                      const AlertDialog(
                        title: Text("Registration Successfull"),
                        content: Text("Client Registered Succesfully"),
                      );
    
                      print("Register button pressed");
                      if (_formKey.currentState!.validate()) {
                        print("calling all save()");
                        _formKey.currentState!.save();
    
                        clientDao.registerNewClient(clientDetailsHolder);
                      }
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
            Container(
              height: 20,
            )
          ])),
    );
  }
}

// THIS CLASS HOLDS CLIENT DATA AND REPRESENT CLIENT IN FIRESTORE
class ClientDetailsHolder {
  String firstName = "";
  String lastName = "";
  int mobileNo = 0000;


// pasisa changed to amount
  // Map service = {
  //   "Ramesh stylist": {
  //     "services": "hair spa",
  //     "amount": 100,
  //     "date": "2/1/2023"
  //   }
  // } as Map;

// service ko map  s array bnare hai
  List service = [
{
      "Ramesh stylist": {
      "services": "hair spa",
      "amount": 100,
      "date": "2/1/2023"
    }
}

   ] ;




// Task
// default values to dob and MaterialPage
// customer search activity
// popup after succesful regist and back to search activity
// married not married 


  int previousDues=0;
  late DateTime dob;
  late DateTime marriageAnniversary;

// DateTime marriageAnniversary=new DateTime.utc(0000,0,0);

  String gender ='M';

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'mobileNo': mobileNo,
      'service': service,
      'dob': dob,
      'gender': gender,
      'previousDues':previousDues,
      'marriageAnniversary': marriageAnniversary
    };
  }
}
