import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_assign/InsuranceProd.dart';
import 'package:flutter_assign/InsuranceProd_List.dart';
import 'package:flutter_assign/HealthAdvisor.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_container/overlay_container.dart';
import 'package:percent_indicator/percent_indicator.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,

      ),
      home: MyHomePage(title: 'FlutterAssignment'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //TASK ONE CURRENT USER LOCATION
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress="Getting your location";

  //TASK TWO--CAPTURING PIC FROM CAMERA
  File _image;

  //TASK FOUR--PROGRESS BAR
  SwiperController controller;
  int   progressIndicator=0;

  //TASK FIVE--LAZY LOADING
  List<InsuranceProd> lazyitems =new List();
  bool isLoading = false;
  int counter=0;


  //TASK SIX--HOME SCREEN
  int _currentIndex=0;
  bool _dropdownShown = false;


  @override
  void initState() {
    super.initState();
    //TASK FIVE
    fetchTwo();

    //TASK ONE CURRENT USER LOCATION
    _getCurrentLocation();

    //TASK FOUR--PROGRESS BAR
    controller = new SwiperController();
    controller.addListener((){
      setState(() {
        progressIndicator=controller.index;
      });
    });

  }


  //APP EXIST
  Future<bool> _onBackPressed() {
    return showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.blue,
            title: Text("Are you sure you want to exit?", style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white),),
            actions: <Widget>[
              FlatButton(
                  child: Text("YES", style: TextStyle(fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
                  onPressed: () {
                    exit(0);
                  }
              ),
              FlatButton(
                child: Text("NO", style: TextStyle(fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
                onPressed: () {
                  Navigator.pop(context);
                },

              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          backgroundColor: Colors.white,
          //TASK ONE--APP BAR
          appBar: AppBar(
            leading: Icon(Icons.add_location, color: Colors.white,),
            //CURRENT USER LOCATION
            title: Text("${_currentAddress}", style: TextStyle(color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold),),
          ),

          //BODY OF THE SCREEN
          body: Container(
              constraints: new BoxConstraints.expand(),
              child: new Stack(
            children: <Widget>[
              new SingleChildScrollView(
              physics: ScrollPhysics(),
              child: new Container(
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      //TASK TWO--CAPTURING PIC FROM CAMERA
                      SizedBox(height: 10,),
                      getprofilePicture(),

                      //TASK THREE--MULTI SWIPE CARDS
                      SizedBox(height: 10,),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 5),
                        child: Text(
                          "Health Adivsor", textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),),
                      ),
                      SizedBox(height: 10,),
                      getHealthAdvisor(),

                      //TASK FOUR--PROGRESS BAR
                      SizedBox(height: 10,),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 5),
                        child: Text(
                          "Health Rewards", textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),),
                      ),
                      SizedBox(height: 10,),
                      getHealthRewards(),

                      //TASK FIVE--LISTVIEW
                      SizedBox(height: 10,),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 5),
                        child: Text("Explore our Insurance Products",
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),),
                      ),
                      getInsuranceProducts(),
                    ]
                ),
              )
          ),

            //TASK SIX--OVERLAY
            getOverlay(),
         ]
          )),

          bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped, // new
          currentIndex: _currentIndex, // new
          items: [
            new BottomNavigationBarItem(
              icon: Icon(Icons.book, color: Color.fromARGB(255, 0, 0, 0)),
              title: Text('My Policies',style: TextStyle(color: Colors.black),),
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.local_hospital, color: Color.fromARGB(255, 0, 0, 0)),
              title: Text('Locate Hospital',style: TextStyle(color: Colors.black),),
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Color.fromARGB(255, 0, 0, 0)),
              title: Text('Home',style: TextStyle(color: Colors.black),),
            ),
            new BottomNavigationBarItem(
                icon: Icon(Icons.assignment, color: Color.fromARGB(255, 0, 0, 0)),
              title: Text('Raise Claims',style: TextStyle(color: Colors.black),),
            ),
            new BottomNavigationBarItem(
                icon: Icon(Icons.perm_identity, color: Color.fromARGB(255, 0, 0, 0)),
              title: Text('Book Services',style: TextStyle(color: Colors.black),),
            )
          ],
        ),

    ));
  }


  //TASK ONE--CURRENT USER LOCATION
  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
        " ${place.subLocality},${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  //TASK TWO--CAPTURING PIC FROM CAMERA
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }


  Widget getprofilePicture() {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child:Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: Colors.grey,
                width: 0.5
            ),
            borderRadius: BorderRadius.circular(15.0),
            shape: BoxShape.rectangle,
          ),
          height: 150.0,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 120,
                width: MediaQuery.of(context).size.width * 0.4,
                child: FloatingActionButton(
                  onPressed: getImage,
                  tooltip: 'Pick Image',
                  child: _image== null?Icon(Icons.add_a_photo,size: 65,):   new Image.file(_image,height:90,width:80,fit: BoxFit.fill,),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 15,),
                  Text("Jennifer Wilson",textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,),),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.map,color: Colors.grey,size: 25,),
                      SizedBox(width: 10,),
                      Text("Mumbai, India",textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,),),
                    ],
                  ),
                  SizedBox(height: 15,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.calendar_today,color: Colors.grey,size: 25,),
                      SizedBox(width: 10,),
                      Text("28-12-2019",textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,),),
                    ],
                  )
                ],
              )

            ],
          ),
        ));
  }

  //TASK THREE--MULTI SWIPE CARDS
  Widget getHealthAdvisor(){
    return Padding(
        padding: EdgeInsets.only(left: 15,right: 15),
        child:SizedBox(
          child: new Swiper(
            controller: controller,
            //pagination: new SwiperPagination(),
            itemCount: insuranceprod.length,
            itemBuilder: (BuildContext context, int index) {
              progressIndicator=index;
              return HealthAdvisor(insuranceprod[index]);
            },
          ),
          height: 180.0,
        ));
  }

  //TASK FOUR--PROGRESS BAR
  Widget getHealthRewards(){
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: new LinearPercentIndicator(
        width: MediaQuery.of(context).size.width - 50,
        animation: true,
        lineHeight: 30.0,
        animationDuration: 2,
        percent: progressIndicator/insuranceprod.length ,
        center: Text("${progressIndicator/insuranceprod.length * 100} %"),
        linearStrokeCap: LinearStrokeCap.roundAll,
        progressColor: Colors.blue,
      ),
    );

  }

  //TASK FIVE--INSURANCE PRODUCTS
  Widget getInsuranceProducts() {
    return Center(
        child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!isLoading && scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                _loadData();
                // start loading data
                setState(() {
                  isLoading = true;
                });
              }
            },

            child: new ListView.builder(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.only(top: 10),
            itemCount: lazyitems.length,
            shrinkWrap: true,
            itemBuilder:
                (BuildContext context, int position) {
              InsuranceProd prod = lazyitems[position];
              return Padding(
                  padding: EdgeInsets.all(10.00),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: Colors.grey,
                            width: 0.5
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                        shape: BoxShape.rectangle,
                      ),
                      height: 100.0,
                      width: 100.0,
                      child: InsuranceProdList(prod)));
            })
    ));
  }
  Future _loadData() async {
    // perform fetching data delay
    await new Future.delayed(new Duration(seconds: 3));

    print("load more");
    // update data and loading status
    setState(() {
      if(counter<insuranceprod.length) {
        lazyitems.add(insuranceprod[counter++]);
        print('items: ' + lazyitems.toString());
        isLoading = false;
      }
    });

  }
  fetchTwo() {
    for (int i = 0; i < 2; i++) {
      lazyitems.add(insuranceprod[i]);
    }
    counter=lazyitems.length;
  }


  //TASK SIX--HOME SCREEN
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (_currentIndex ==2) {
      setState(() {
        _dropdownShown = !_dropdownShown;
      });
    }
  }
  Widget getOverlay() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          OverlayContainer(
            show: _dropdownShown,
            position: OverlayContainerPosition(
                -7, -330
            ),
            // The content inside the overlay.
            child: Container(
              height: 300,
              width: 370,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.elliptical(150, 150),
                    topRight: Radius.elliptical(150, 150)),
                color: Colors.blue[300],
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.blue[100],
                    blurRadius: 1,
                    spreadRadius: 2,
                  )
                ],
              ),

              child: Container(

                alignment: Alignment.center,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 50,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Material(
                                elevation: 5.0,
                                color: Colors.white,
                                child: MaterialButton(
                                  minWidth: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.4,
                                  padding: EdgeInsets.fromLTRB(
                                      30.0, 30.0, 30.0, 30.0),
                                  onPressed: () {},
                                  child: Text("Option 1",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )
                          ),
                          Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Material(
                                elevation: 5.0,
                                color: Colors.white,
                                child: MaterialButton(
                                  minWidth: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.4,
                                  padding: EdgeInsets.fromLTRB(
                                      30.0, 30.0, 30.0, 30.0),
                                  onPressed: () {},
                                  child: Text("Option 2",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )
                          ),

                        ],
                      ), Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Material(
                                elevation: 5.0,
                                color: Colors.white,
                                child: MaterialButton(
                                  minWidth: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.4,
                                  padding: EdgeInsets.fromLTRB(
                                      30.0, 30.0, 30.0, 30.0),
                                  onPressed: () {},
                                  child: Text("Option 3",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )
                          ),
                          Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Material(
                                elevation: 5.0,
                                color: Colors.white,
                                child: MaterialButton(
                                  minWidth: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.4,
                                  padding: EdgeInsets.fromLTRB(
                                      30.0, 30.0, 30.0, 30.0),
                                  onPressed: () {},
                                  child: Text("Option 4",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//STATIC DATA
  List<InsuranceProd> insuranceprod = [
    InsuranceProd("Health Insurance Redefined!",
        "Health insurance is a medical insurance policy that offers financial coverage for medical expenses when the policyholder is hospitalised.",
        "assets/techved.jpeg"),
    InsuranceProd("Health Insurance Redefined!",
        "Health insurance is a medical insurance policy that offers financial coverage for medical expenses when the policyholder is hospitalised.",
        "assets/techved.jpeg"),
    InsuranceProd("1Health Insurancex Redefined!",
        "Health insurance is a medical insurance policy that offers financial coverage for medical expenses when the policyholder is hospitalised.",
        "assets/techved.jpeg"),
    InsuranceProd("2Health Insurance Redefined!",
        "Health insurance is a medical insurance policy that offers financial coverage for medical expenses when the policyholder is hospitalised.",
        "assets/techved.jpeg"),
    InsuranceProd("3Health Insurance Redefined!",
        "Health insurance is a medical insurance policy that offers financial coverage for medical expenses when the policyholder is hospitalised.",
        "assets/techved.jpeg"),
  ];

}


