import 'package:flutter/material.dart';
import 'package:salon_manager/Client_managment/Client_Dao.dart';
import 'package:salon_manager/Client_managment/Client_Registration_Form.dart';

class SearchClient extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchClient();
}

class _SearchClient extends State<SearchClient> {
  final TextEditingController _controller = TextEditingController();
  Icon icon = Icon(Icons.search);
  Widget appBarTitle = Text("Search Clients...",style: TextStyle(fontSize: 40),);

  // will be fetched form firestore
 //List _clientList = ["aam", "bam", "cam", "sameer","aam", "bam", "cam", "sameer","aam", "bam", "cam", "sameer","aam", "bam", "cam", "sameer","aam", "bam", "cam", "sameer"];
   List  _clientList =["dummy"];
    List searchResult = [];
    
      bool isClientListLoaded=false;
 @override
  void initState() {
    // Call the fetch data method
   loadClientList  ();
print("init state called");
  }

loadClientList() async{
    _clientList=  await ClientDao().fetchClientList();
    setState(() {
     isClientListLoaded=true;
    });
     
 
}

  @override
  Widget build(BuildContext context) {
    print("build method");    
       
      return Scaffold(
        floatingActionButton:   FloatingActionButton(child: Icon(Icons.add,), onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  ClientRegistrationForm()) ); 
             },),
        appBar: buildAppBar(context),
        body: 
             
               Column(
            children: [  
              !isClientListLoaded  ?  SizedBox(
       height: MediaQuery.of(context).size.height / 1.3,
      child:  Center(widthFactor: double.infinity,child: CircularProgressIndicator(color: Colors.black,)) 
                             )               :   
            
              Flexible(
                  child:searchResult.isNotEmpty || _controller.text.isNotEmpty
                      ? ListView.builder(
                         itemCount: searchResult.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            String listData = searchResult[index];
                            print("in 1");
                            return ListTile(title: Text(listData.toString()));
                          })
                      : ListView.builder(
                          itemCount: _clientList.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            String listData = _clientList[index];
                            print("in 2 ${searchResult.isNotEmpty} ");

                            return ListTile(title: Text(listData.toString()),onTap: () {
                              print("tapped"+listData);
                            },);
                          })),
            
          
            ],
      )
      ) ;
  
  }

// when we start searching seacrhOperation is called
  void searchOperation(String searchText) {
    searchResult.clear();

    for (int i = 0; i < _clientList.length; i++) {
      String data = _clientList[i];
      if (data.toLowerCase().contains(searchText.toLowerCase())) {
        searchResult.add(data);
      }
    }

    print("$searchResult : $_clientList");
    setState(() {
      
    });
  }

  
  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "Search Clients...",
        style: new TextStyle(color: Colors.white),
      );
      //  _isSearching = false;
      _controller.clear();
    });
  }

  void handleSearchEnd() {

setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "Search Clients...",
        style: new TextStyle(color: Colors.white,fontSize: 40),
      );
         searchResult.clear();
       _controller.clear();
    });





  }

  buildAppBar(BuildContext context) {
    print("build bar");
    return AppBar(backgroundColor: Colors.black,
      centerTitle: true,
      title: appBarTitle,
      actions: <Widget>[
        IconButton(iconSize: 50,
            icon: icon,
            onPressed: () {
              setState(() {
                print("setstate");
                if (this.icon.icon == Icons.search) {
                  icon = Icon(Icons.close, color: Colors.white,size: 50,);
                  this.appBarTitle = TextField(
                    controller: _controller,
                    style: TextStyle(color: Colors.white,fontSize: 40),
                    decoration: InputDecoration(
                        prefixIcon:
                            Icon(color: Colors.white, Icons.search_rounded,size: 50,),
                        hintStyle: TextStyle(color: Colors.white ,fontSize: 40),
                        hintText: " Search Clients..." ),
                    onChanged: (value) => searchOperation(value),
                  );
                  // handleSearchStart();

                } else {
                  print("inelse");
                  handleSearchEnd();
                }
              });
            }),
      ],
    );
  }
}


// tasks remaining
 // change background color of tiles and make them beautiful
// increase size of search icon or provide tap facility to entire app bar 
 // action on tile tap
// crate a global field salonName and use it to call api
/// adjust text and icon size acording to screen size 
/// create service selection page and provide naviagtion on tile tap to that page with data 
/// salon selection page 