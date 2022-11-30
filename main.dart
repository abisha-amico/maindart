import 'dart:convert';
import 'dart:core';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'glocation_dart.dart';
import 'loginpage_dart.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List categoriesList = [];
  List productsList = [];
  int productsListCount = 0;

  // String name = "";
  // String price = "";
  // String currency = "";

  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Search Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Text('Profile Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void initState() {
    getcategories();
    getproducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              RichText(
                text: TextSpan(
                  text: "Your location ",
                  children: [
                    WidgetSpan(
                      child: Icon(
                        Icons.location_on_outlined,
                        size: 13,
                      ),
                    ),
                  ],
                  style: TextStyle(color: Colors.black, fontSize: 12),
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => glocationpage()),
                      )
                    },
                ),
              ),
              Text(
                "New Delhi,North West Delhi",
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(15),
                    height: 295,
                    decoration: BoxDecoration(
                      // color: Colors.blueGrey[700],
                      color: Color.fromRGBO(10, 49, 93, 0.9),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "What would you like to rent?",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Font2',
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          // margin: EdgeInsets.all(6),
                          height: 60,
                          child: TextField(
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  // topLeft:Radius.circular(40),
                                  // topRight: Radius.circular(40),
                                  // bottomLeft: Radius.circular(40),
                                  // bottomRight: Radius.circular(40),

                                  borderSide: BorderSide(color: Colors.white60)),
                              hintText: "    Search  for  Stuff             ",
                              prefixIcon: Icon(
                                Icons.search,
                                size: 20,
                              ),
                              iconColor: Colors.white,
                            ),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Image(
                          image: NetworkImage(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTprii-l5EwicFj8wx6LoqWTKPMu5uwID2VB399-XGr3l16xTlcJ7aEy4mboNH8bosDOCU&usqp=CAU",
                              scale: 0.9),
                          height: 193,
                          //   width: 380,
                          // color: Colors.blueGrey[700])
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Categories",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.normal)),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "See all",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 90,
                child: Column(
                  children: [
                    Expanded(
                        flex: 1,
                        child: categoriesList.isNotEmpty
                            ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: categoriesList.length,
                          itemBuilder: (BuildContext context, int i) {
                            return Container(
                              padding: EdgeInsets.all(2.0),
                              child: Card(
                                child: Column(
                                  children: [
                                    Image.network(
                                      'https://anystuff.rent/file?url=' +
                                          categoriesList[i]["image"],
                                      scale: 2.9,
                                    ),
                                    Text(
                                      categoriesList[i]['name'],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                            : CircularProgressIndicator()),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Text("   Explore nearby",
                          style: TextStyle(color: Colors.black, fontSize: 13)),
                    ],
                  ),
                 Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                               width: double.infinity,
                               height: 200,
                              child: Column(
                                children: [
                                  Expanded(
                                      flex: 3,
                                      child: productsList.isNotEmpty ?
                                      GridView.builder(
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                        ),
                                            scrollDirection: Axis.vertical,
                                        physics: ScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: productsListCount,
                                        itemBuilder: (BuildContext context, int i) {
                                          return Card(
                                            // padding: EdgeInsets.all(2.0),
                                              child: Column(
                                                // mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Image.network(
                                                    'https://anystuff.rent/file?url='+productsList[i]["photos"][0].toString(),
                                                    scale: 0.9,
                                                  ),
                                                  Text(productsList[i]["name"].toString()),
                                                  Text(productsList[i]["price"].toString()),
                                                  Text(productsList[i]["currency"].toString()),
                                                ],
                                              ),
                                          );
                                        },
                                      )
                                          : CircularProgressIndicator()),
                                ],
                              ),
                            ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ],
          )),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                size: 35,
              ),
              label: (''),
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.card_giftcard,
                size: 35,
              ),
              label: (''),
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                size: 60,
                color: Colors.orange,
              ),
              label: '',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart_outlined,
                size: 35,
              ),
              label: (''),
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_pin, size: 40, color: Colors.cyan),
              label: '',
              backgroundColor: Colors.white60,
            ),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey[200],
          iconSize: 30,
          onTap: (_onItemTapped) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => loginpage()),
            );
          },
          elevation: 5),
    );
  }

  getcategories() async {
    categoriesList = [];
    var getcategoriesUrl = Uri.parse('https://anystuff.rent/api/category/list');
    await http.get(getcategoriesUrl, headers: {
      'Content-Type': 'application/json; charset=UTF-8'
    }).then((response) {
      setState(() {
        categoriesList = json.decode(response.body.toString());
      });
    });
  }
  getproducts() async {
    productsList = [];
    var getproductsListUrl =
    Uri.parse('https://anystuff.rent/api/products/list');
    print(getproductsListUrl);

    await http.post(getproductsListUrl, headers: {
      'Content-Type': 'application/json; charset=UTF-8'
    }).then((response) {
      // String Response
      setState(() {
        Map productsResponse = json.decode(response.body.toString());
        productsListCount = productsResponse["count"];
        productsList = productsResponse["list"];
      });
    });
  }
}
