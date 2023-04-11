// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salon_manager/Client_managment/Client_Registration_Form.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ClientDao{


_getCollectionReference(String path){
CollectionReference collectionRef = FirebaseFirestore.instance.collection("salons/wow/$path");

// now creating doc with client name
 
return collectionRef;
}



saveClientServiceDetails(clientId,serviceDetails) async {
 
 // should be assigned like this 
//  serviceDetails=[{
//   'sameer master':{
//    "services": "chethe hair , faltu cutting",
//       "amount": 300,
//       "date": "2/1/2023" 
//       }
//       }
      
//       ];
 var ref=_getCollectionReference("clients"); 
  
  // adds data to array automatically without specifyng index
 ref.doc(clientId).update({
  'services': FieldValue.arrayUnion(serviceDetails),
});

      //   await  ref.get().then((QuerySnapshot querySnapshot) {
 
      //   querySnapshot.docs.forEach((doc) {

      // if(clientId==doc.id){ print('Found Data for $clientId : ${doc.data()}');
 
      //   }}
      //   );

      //   });

}



registerNewClient(ClientDetailsHolder newClientDetails) async {
 
 var ref=_getCollectionReference("clients"); 
    
 ref.doc('${newClientDetails.firstName}_${newClientDetails.mobileNo}') // <-- Document ID
    .set(newClientDetails.toMap()) // <-- Your data
    .then((_){
      print('Client Added succesfully');
       const AlertDialog(title: Text("Registration Successfull"),content: Text("Client Registered Succesfully"),);
    })
    .catchError((error) => print('Registration Failed $error'));




}

// return client list
 fetchClientList() async{
              List clientList=[];

              try{
              var ref= await _getCollectionReference("clients");
              
         await  ref.get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          clientList.add(doc.id);
             print(doc.id);
        });
    });
              }catch(e){print("Exception in CLientDao : "+e.toString()); return ["Try Agaian ,No CLient Found "]; }

print(" mylist : $clientList");
return clientList;

}

fetchClientUsingClientId(clientId) async {
    var data=null;

   var clientData;
              try{
              var ref= await _getCollectionReference("clients");
              
         await  ref.get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
  
              if(clientId==doc.id){ print('Found Data for $clientId : ${doc.data()}');
               data= doc.data(); 
              }
        });
    });
              }catch(e){print("Exception in CLientDao : "+e.toString()); return ["Try Agaian ,No CLient Found "]; }


return data;
              

}

    
}
