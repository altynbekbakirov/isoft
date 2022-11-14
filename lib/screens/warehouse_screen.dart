import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isoft/components/navigation_drawer.dart';
import 'package:isoft/l10n/language_constants.dart';

class WarehouseScreen extends StatefulWidget {
  const WarehouseScreen({Key? key, this.warehouse}) : super(key: key);
  final String? warehouse;

  @override
  State<WarehouseScreen> createState() => _WarehouseScreenState();
}

class _WarehouseScreenState extends State<WarehouseScreen> {
  late String currentWarehouse;

  @override
  void initState() {
    super.initState();
    setState(() {
      currentWarehouse = widget.warehouse ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(translation(context).warehouse),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: CustomSearch());
              },
              icon: const Icon(Icons.search_outlined)),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.filter_list_outlined)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          buildCard(code: "100.001", name: "Main"),
          buildCard(
            code: "200.001",
            name: 'Warehouse Tunguch',
          ),
        ],
      ),
    );
  }

  Widget buildCard(
      {required String code,
      required String name,
      Color color = Colors.white}) {
    return Card(
        color: color,
        child: RadioListTile<String>(
          title: Text(name),
          value: name,
          groupValue: currentWarehouse,
          onChanged: (String? value) {
            setState(() {
              currentWarehouse = value!;
              Navigator.of(context).pop(currentWarehouse);
            });
          },
        ));
  }
}

class CustomSearch extends SearchDelegate {
  List<String> fruits = ['apple', 'bananas', 'grapes'];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQueries = [];
    for (var result in fruits) {
      if (result.toLowerCase().contains(query.toLowerCase())) {
        matchQueries.add(result);
      }
    }
    return ListView.builder(
        itemCount: matchQueries.length,
        itemBuilder: (context, index) {
          var result = matchQueries[index];
          return ListTile(
            title: Text(result),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQueries = [];
    for (var result in fruits) {
      if (result.toLowerCase().contains(query.toLowerCase())) {
        matchQueries.add(result);
      }
    }
    return ListView.builder(
        itemCount: matchQueries.length,
        itemBuilder: (context, index) {
          var result = matchQueries[index];
          return ListTile(
            title: Text(result),
            onTap: () {
              close(context, result);
            },
          );
        });
  }
}
