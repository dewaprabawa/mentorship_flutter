import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';

class Transaction {
  int id;
  String name;
  List<Order> orders;
  Transaction(this.id, this.name, this.orders);

  factory Transaction.fromMap(Map<String, dynamic> map) {
    List<Order> orders = List.from(map["orders"])
        .map((element) => Order.fromMap(element))
        .toList();

    return Transaction(map["id"], map["name"], orders);
  }
}

class Order {
  int id;
  List<Item> items;
  Order(this.id, this.items);

  factory Order.fromMap(Map<String, dynamic> map) {
    List<Item> items = List.from(map["items"])
        .map((element) => Item.fromMap(element))
        .toList();
    return Order(map["id"], items);
  }
}

class Item {
  String name;
  Item(
    this.name,
    // this.details,
  );
  // List<Detail> details;

  factory Item.fromMap(Map<String, dynamic> map) {
    // List<Detail> details =
    //     List.from(map['details']).map((e) => Detail.fromMap(e)).toList();
    return Item(map['name']);
  }
}

class Detail {
  String name;
  String ukuran;
  Detail(this.name, this.ukuran);

  factory Detail.fromMap(Map<String, dynamic> map) {
    return Detail(
      map['name'],
      map['ukuran'],
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
  /*
   class Person {
    String name;
    int age;
    Person(this.name, this.age);
   }

  final alice = Person('Alice', 30);
  
  ***Serialize the person object to a JSON string

  final jsonString = jsonEncode(person);
  print(jsonString);
  
  ***Deserialize the JSON string back into a Person object

  final json = jsonDecode(jsonString);
  final person2 = Person.fromJson(json);
  print(person2.name);
  print(person2.age);

  */

  Future<void> _getCustomerData() async {
    // Load the contents of the customer.json file from the assets folder
    String jsonString =
        await rootBundle.loadString('assets/transaction_list.json');

    // Delay the function invocation to simulate real https request
    await Future.delayed(const Duration(microseconds: 2000));

    // Decode the JSON string into a Map or List (depending on the JSON structure)
    final data = jsonDecode(jsonString);

    var transactionList = List<Map<String, dynamic>>.from(data);
    List<Transaction> list =
        transactionList.map((e) => Transaction.fromMap(e)).toList();
    print(list[0].name);

    // for (Order order in transaction.orders) {
    //   for (Item item in order.items) {
    //     for (Detail detail in item.details) {
    //       print('${detail.name}\n${detail.ukuran}');
    //     }
    //   }
    // }

    // for(dynamic order in orders){
    //   for(dynamic item in order["items"]){
    //     print(item);
    //   }
    // }

    // List.from(data["orders"]).map((element) => print(element["items"])).toList();

    // Print the data to the console
  }

  @override
  void initState() {
    // get();
    // post();
    _getCustomerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
    );
  }

  Future<void> get() async {
    try {
      Dio dio = Dio(); // Create a new Dio instance
      Response response = await dio.get(
          'https://jsonplaceholder.typicode.com/posts'); // Make a GET request
      final map =
          List.from(response.data) // Convert the response data to a list
              .map((e) => Map.from(e)) // Convert each item in the list to a map
              .toList(); // Convert the entire list to a list of maps
      for (Map item in map) {
        // Loop through the list of maps and print the title of each item
        print(item["title"]);
      }
    } catch (e) {
      print(e
          .toString()); // Print any error that occurs during the network request
    }
  }

  Future<void> post() async {
    try {
      Dio dio = Dio();
      Response response = await dio.post(
          'https://jsonplaceholder.typicode.com/posts',
          data: {'title': 'foo', 'body': 'bar', 'userId': 1});
      debugPrint(response.data);
    } catch (e) {
      print(e.toString());
    }
  }
}
