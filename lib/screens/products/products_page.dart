import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isoft/components/navigation_drawer.dart';
import 'package:isoft/data/company_provider.dart';
import 'package:isoft/data/db_helper.dart';
import 'package:isoft/data/shared_prefs.dart';
import 'package:isoft/models/product_model.dart';
import 'package:provider/provider.dart';

late List<Product> productList;

Future<List<Product>> getProducts(BuildContext context) async {
  return await DatabaseHelper.instance
      .getAllProducts(context.watch<CompanyProvider>().activeCompany.id);
}

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  DateTime timeBackPressed = DateTime.now();
  late Future<List<Product>> products;

  void getStringList() async {
    productList = await products;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    products = getProducts(context);
    getStringList();
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
          title: Text(translation(context).products),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: ProductSearch());
                },
                icon: const Icon(Icons.search_outlined)),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.filter_center_focus_outlined)),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.filter_list_outlined)),
          ],
        ),
        drawer: NavigationDraw(),
        body: FutureBuilder<List<Product>>(
          future: products,
          builder: (context, snapshot) {
            final data = snapshot.data;
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.none:
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
                    return buildList(
                      items: data,
                    );
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

  Widget buildList({required List<Product> items}) {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return buildCard(item: items[index]);
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 0.5,
          thickness: 1,
        );
      },
    );
  }

  Widget buildCard({required Product item, Color color = Colors.white}) {
    return ListTile(
      dense: true,
      title: Text(
        '${item.code} - ${item.name}',
        style: TextStyle(
            fontWeight: FontWeight.w600, color: Theme.of(context).hintColor),
      ),
      subtitle: Row(
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            color: item.onHand! > 0
                ? Theme.of(context).primaryColor
                : item.onHand! < 0
                    ? Theme.of(context).errorColor
                    : Theme.of(context).hintColor,
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            item.onHand.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: item.onHand! > 0
                  ? Theme.of(context).primaryColor
                  : item.onHand! < 0
                      ? Theme.of(context).errorColor
                      : Theme.of(context).hintColor,
            ),
          ),
        ],
      ),
      leading: Icon(
        Icons.photo_camera_outlined,
      ),
      trailing: Column(
        children: [
          Text(
            translation(context).product_price,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            item.salePrice!.toStringAsFixed(2),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class ProductSearch extends SearchDelegate {
  List<Product> recentList = [];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            if (query.isNotEmpty) {
              query = '';
            } else {
              close(context, null);
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
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentList
        : productList.where((element) {
            return element.name.toLowerCase().contains(query.toLowerCase()) ||
                element.code.toLowerCase().contains(query.toLowerCase());
          }).toList();

    return ListView.separated(
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
      itemCount: suggestionList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: () {
            showResults(context);
          },
          dense: true,
          title: Text(
            '${suggestionList[index].code} - ${suggestionList[index].name}',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).hintColor),
          ),
          subtitle: Row(
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                color: suggestionList[index].onHand! > 0
                    ? Theme.of(context).primaryColor
                    : suggestionList[index].onHand! < 0
                        ? Theme.of(context).errorColor
                        : Theme.of(context).hintColor,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                suggestionList[index].onHand.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: suggestionList[index].onHand! > 0
                      ? Theme.of(context).primaryColor
                      : suggestionList[index].onHand! < 0
                          ? Theme.of(context).errorColor
                          : Theme.of(context).hintColor,
                ),
              ),
            ],
          ),
          leading: Icon(
            Icons.access_time_sharp,
          ),
          trailing: Column(
            children: [
              Text(
                translation(context).product_price,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                suggestionList[index].salePrice!.toStringAsFixed(2),
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 0.5,
          thickness: 1,
        );
      },
    );
  }
}
