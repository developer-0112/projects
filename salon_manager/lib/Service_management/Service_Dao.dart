import 'package:cloud_firestore/cloud_firestore.dart';

import '../globals.dart';

class ServiceDao {
  _getDocumentReference(String serviceType) {

    // getting document 
    DocumentReference<Map<String, dynamic>> documentRef =
        FirebaseFirestore.instance.doc('salons/wow/services/$serviceType');

    return documentRef;
  }

  _getCollectionReference() {

    // getting document 
    CollectionReference<Map<String, dynamic>> collectionRef =
        FirebaseFirestore.instance.collection('salons/wow/services/menService');

    return collectionRef;
  }

  fetchMenServices() async {
    Map serviceList={} ;

    try {
      var ref = await _getDocumentReference("menServices");

      await ref.get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          print('Men Services :: ${documentSnapshot.data() as Map}');

              serviceList=documentSnapshot.data() as Map;
     
        }
      });
    } catch (e) {
      print("Exception in ServiceDao : " + e.toString(  ));

      return {"Error":"Try Again ,No Service Found "};
    }

    print(" myServicelist : $serviceList");

    return serviceList;
  }


  fetchWomenServices() async {
  Map serviceList = {};

    try {
      var ref = await _getDocumentReference("womenServices");

      await ref.get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          print(
              'Women Services :: ${documentSnapshot.data()}');
      
      serviceList=documentSnapshot.data() as Map;

        } 
      });
    } catch (e) {
      print("Exception in ServiceDao : " + e.toString());

      return {"Error":"Try Again ,No Service Found "};
    }

    print(" myServicelist : $serviceList");
    return serviceList;
  }


}
