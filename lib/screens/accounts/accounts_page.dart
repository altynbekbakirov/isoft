import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isoft/components/navigation_drawer.dart';
import 'package:isoft/data/company_provider.dart';
import 'package:isoft/data/db_helper.dart';
import 'package:isoft/data/shared_prefs.dart';
import 'package:isoft/models/account_model.dart';
import 'package:provider/provider.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({Key? key}) : super(key: key);

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  DateTime timeBackPressed = DateTime.now();
  late Future<List<Account>> accounts;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    accounts = getAccounts();
  }

  Future<List<Account>> getAccounts() async {
    return await DatabaseHelper.instance
        .getAllAccounts(context.watch<CompanyProvider>().activeCompany.id);
  }

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
        drawer: NavigationDraw(),
        body: FutureBuilder<List<Account>>(
          future: accounts,
          initialData: [],
          builder: (context, snapshot) {
            final data = snapshot.data;
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.done:
              default:
                if (snapshot.hasData) {
                  if (data!.isEmpty) {
                    return Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.event_note_outlined,
                            size: 144,
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.3),
                          ),
                          Text(
                            translation(context).no_data,
                          )
                        ],
                      ),
                    );
                  } else {
                    return buildList(data);
                  }
                } else if (snapshot.hasError) {
                  return Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline_sharp,
                          color: Theme.of(context).errorColor,
                          size: 36,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(translation(context).error_occurred),
                      ],
                    ),
                  );
                } else {
                  return Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.event_note_outlined,
                          size: 144,
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.3),
                        ),
                        Text(
                          translation(context).no_data,
                        )
                      ],
                    ),
                  );
                }
            }
          },
        ),
      ),
    );
  }

  Widget buildList(List<Account> items) {
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          return buildCard(item: items[index]);
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 0.5,
            thickness: 1,
          );
        },
        itemCount: items.length);
  }

  Widget buildCard({required Account item, Color color = Colors.white}) {
    return ListTile(
      dense: true,
      title: Text(item.name,
          style: TextStyle(
              fontWeight: FontWeight.w600, color: Theme.of(context).hintColor)),
      subtitle: Text(
        item.code,
        style: TextStyle(color: Theme.of(context).hintColor),
      ),
      leading: CircleAvatar(
        child: Icon(
          Icons.account_circle_outlined,
          color: Theme.of(context).hintColor,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      trailing: Column(
        children: [
          Text(
            translation(context).account_balance,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            item.balance.toStringAsFixed(2),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
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
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
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
