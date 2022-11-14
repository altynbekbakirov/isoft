import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isoft/components/navigation_drawer.dart';
import 'package:isoft/l10n/language_constants.dart';
import 'package:isoft/models/account_model.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({Key? key}) : super(key: key);

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(translation(context).accounts),
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
          buildCard(
              model:
                  AccountModel(id: 1, code: '100.001', name: 'Azamat Astana')),
          buildCard(
              model: AccountModel(
                  id: 2, code: '100.004', name: 'Daniyar Kyzyl-Kiya')),
          buildCard(
              model: AccountModel(
                  id: 3, code: '100.005', name: 'Shurik Karaganda')),
          buildCard(
              model: AccountModel(
                  id: 4, code: '100.006', name: 'Alibek Kostanay')),
        ],
      ),
    );
  }

  Widget buildCard({required AccountModel model, Color color = Colors.white}) {
    return Card(
        color: color,
        child: ListTile(
          title: Text(model.name),
          leading: const Icon(Icons.account_circle_outlined),
          subtitle: Text(model.code),
          onTap: () {
            Navigator.of(context).pop({"account": model});
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
