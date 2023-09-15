// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class OrderDataTabel extends StatefulWidget {
  final void Function(int columnIndex, bool ascending) onSort;
  const OrderDataTabel({super.key, required this.onSort});

  @override
  State<OrderDataTabel> createState() => _OrderDataTabelState();
}

class _OrderDataTabelState extends State<OrderDataTabel> {
  bool _sortAscending = true;
  int _sortColumnIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
          columns: [
            DataColumn(label: Text('Numder'), onSort: _onDataColumnSort),
            DataColumn(label: Text('Customer')),
            DataColumn(
                label: Text('Price'), numeric: true, onSort: _onDataColumnSort),
            DataColumn(label: Container()),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Text('ID')),
              DataCell(Text('CUSTOMER NAME'), onTap: () {}),
              DataCell(Text('\$PRICE')),
              DataCell(Icon(Icons.delete), onTap: () {}),
            ])
          ],
        ),
      ),
    );
  }

  void _onDataColumnSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
    widget.onSort(columnIndex, ascending);
  }
}
