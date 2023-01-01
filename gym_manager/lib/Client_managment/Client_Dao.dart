// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_manager/Client_managment/Client_Registration_Form.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ClientDao{


get getDatabaseReference{
CollectionReference collectionRef = FirebaseFirestore.instance.collection("gyms/fitness storm/clients");

// now creating doc with client name
 
return collectionRef;
}

registerNewClient(ClientDetailsHolder newClientDetails) async {
 
 var ref=getDatabaseReference; 
    
 ref.doc('${newClientDetails.firstName}_${newClientDetails.mobileNo}') // <-- Document ID
    .set(newClientDetails.toMap()) // <-- Your data
    .then((_){
      print('Client Added succesfully');
       const AlertDialog(title: Text("Registration Successfull"),content: Text("Client Registered Succesfully"),);
    })
    .catchError((error) => print('Registration Failed $error'));




}


    
}
