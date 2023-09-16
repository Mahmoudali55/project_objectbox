// ignore_for_file: unused_field

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_objectbox/compent/addmodelBottensheet.dart';
import 'package:project_objectbox/entities.dart';
import 'package:project_objectbox/objectbox.g.dart';
import 'package:project_objectbox/order_date_tabel.dart';
import 'package:path/path.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final faker = Faker();
  late Store _store;
  bool hasBeenInitialized = false;
  late Customer _customer;
  late Stream<List<ShopOrder>> _stream;
  @override
  void initState() {
    super.initState();
    setNewCustomer();
    getApplicationDocumentsDirectory().then((dir) {
      _store = Store(
        getObjectBoxModel(),
        directory: join(dir.path, 'objectbox'),
      );
      setState(() {
        _stream = _store
            .box<ShopOrder>()
            .query()
            .watch(triggerImmediately: true)
            .map((query) => query.find());
        hasBeenInitialized = true;
      });
    });
  }

  @override
  void dispose() {
    _store.close();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              context: context,
              builder: (context) {
                return AddNoteBottomSheet();
              });
        },
        child: Icon(Icons.add),
      ),
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
      body: !hasBeenInitialized
          ? Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder<List<ShopOrder>>(
              stream: _stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return OrderDataTabel(
                  orders: snapshot.data!,
                  onSort: (columnIndex, ascending) {
                    final newQueryBuilder = _store.box<ShopOrder>().query();
                    final sortField =
                        columnIndex == 0 ? ShopOrder_.id : ShopOrder_.price;
                    newQueryBuilder.order(sortField,
                        flags: ascending ? 0 : Order.descending);
                    setState(() {
                      _stream = newQueryBuilder
                          .watch(triggerImmediately: true)
                          .map((query) => query.find());
                    });
                  },
                  store: _store,
                );
              }),
    );
  }

  void setNewCustomer() {
    _customer = Customer(name: faker.person.name());
  }

  void addFakerOrderForCurrenyCustomer() {
    final order = ShopOrder(price: faker.randomGenerator.integer(500, min: 10));
    order.customer.target = _customer;
    _store.box<ShopOrder>().put(order);
  }
}
