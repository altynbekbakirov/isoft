import 'package:flutter/material.dart';
import 'package:isoft/data/company_provider.dart';
import 'package:isoft/data/currency_provider.dart';
import 'package:isoft/data/db_helper.dart';
import 'package:isoft/data/shared_prefs.dart';
import 'package:isoft/models/currency_model.dart';
import 'package:provider/provider.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({Key? key, this.currency}) : super(key: key);
  final String? currency;

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  late Future<List<Currency>> currencies;

  Future<List<Currency>> getCurrencies() async {
    return await DatabaseHelper.instance
        .getAllCurrencies(context.watch<CompanyProvider>().activeCompany.id);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currencies = getCurrencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translation(context).currency),
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
      body: FutureBuilder<List<Currency>>(
        future: currencies,
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
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
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
    );
  }

  Widget buildList(List<Currency> items) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: ListView.separated(
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return buildCard(item: items[index]);
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 1,
              thickness: 1,
            );
          },
          itemCount: items.length),
    );
  }

  Widget buildCard({required Currency item, Color color = Colors.white}) {
    final isSelected =
        context.watch<CurrencyProvider>().activeCurrency.id == item.id;

    return ListTile(
      onTap: () async {
        await setActiveCurrency(item.id);
        context.read<CurrencyProvider>().setActiveCurrency(item);
        Navigator.of(context).pop('${item.curCode} - ${item.curName}');
      },
      title: Text(item.curCode,
          style: TextStyle(
              fontWeight: FontWeight.w600, color: Theme.of(context).hintColor)),
      subtitle: Text(
        item.curName,
        style: TextStyle(color: Theme.of(context).hintColor),
      ),
      leading: CircleAvatar(
        child: Icon(
          Icons.currency_exchange_outlined,
          color: Theme.of(context).bottomAppBarColor,
        ),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      trailing: isSelected
          ? Icon(
              Icons.task_alt_sharp,
              color: Theme.of(context).primaryColor,
            )
          : null,
      selected: isSelected,
      // selectedTileColor: Theme.of(context).dividerColor,
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
