import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:project_objectbox/order_date_tabel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final faker = Faker();
  @override
  void initState() {
    super.initState();
    setNewCustomer();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('orders'),
        actions: [
          IconButton(
              onPressed: setNewCustomer, icon: Icon(Icons.person_add_alt)),
          IconButton(
              onPressed: addFakerOrderForCurrenyCustomer,
              icon: Icon(Icons.attach_money)),
        ],
      ),
      body: OrderDataTabel(onSort: (columnIndex, ascending) {}),
    );
  }

  void setNewCustomer() {
    print('Name:${faker.person.name()}');
  }

  void addFakerOrderForCurrenyCustomer() {
    print('Name:${faker.randomGenerator.integer(500, min: 10)}');
  }
}
