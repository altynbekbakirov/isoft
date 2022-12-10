import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isoft/components/navigation_drawer.dart';
import 'package:isoft/data/shared_prefs.dart';

class PurchasesInvoicesPage extends StatefulWidget {
  const PurchasesInvoicesPage({Key? key}) : super(key: key);

  @override
  State<PurchasesInvoicesPage> createState() => _PurchasesInvoicesPageState();
}

class _PurchasesInvoicesPageState extends State<PurchasesInvoicesPage> {
  DateTime timeBackPressed = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackPressed);
        final isExitWarning = difference >= const Duration(seconds: 2);
        timeBackPressed = DateTime.now();
        if (isExitWarning) {
          Fluttertoast.showToast(
              msg: translation(context).press_back_again_to_exit, fontSize: 14);
          return false;
        } else {
          Fluttertoast.cancel();
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(translation(context).purchases_invoices),
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
        drawer: NavigationDrawer(),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.event_note_outlined,
                size: 144,
                color: Theme.of(context).primaryColor.withOpacity(0.3),
              ),
              Text(
                translation(context).no_data,
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add_outlined),
        ),
      ),
    );
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
