import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isoft/components/navigation_drawer.dart';
import 'package:isoft/l10n/language_constants.dart';
import 'package:isoft/models/product_model.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  DateTime timeBackPressed = DateTime.now();

  List<ProductModel> productList = [
    ProductModel(
        id: 1,
        code: '100.001',
        name: 'СОРОЧКИ трикотаж/шелк',
        remain: 5,
        price: 5.5),
    ProductModel(
        id: 2,
        code: '100.002',
        name: 'Милана штапель/тенсел',
        remain: 20,
        price: 35),
    ProductModel(
        id: 3, code: '100.003', name: 'Сара вельвет', remain: 0, price: 9),
    ProductModel(
        id: 4, code: '100.004', name: 'Намазник Капюшон', remain: 2, price: 4),
    ProductModel(
        id: 5,
        code: '100.005',
        name: 'Джинс Руб-Карман',
        remain: 65,
        price: 15),
    ProductModel(
        id: 6, code: '100.006', name: 'Аманиса Шерсть', remain: 3, price: 46),
    ProductModel(
        id: 7, code: '100.007', name: 'Венера Вельвет', remain: 20, price: 5),
    ProductModel(
        id: 8,
        code: '100.008',
        name: 'Екатерина Болдышева и группа Мираж - Море грёз',
        remain: -23,
        price: 20),
    ProductModel(
        id: 9,
        code: '100.009',
        name:
            'Была на ее концерте.Стояла у самой сцены,и не могла отвести от нее глаз. Завораживает как Сирена.',
        remain: 5,
        price: 10),
  ];

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
                  showSearch(context: context, delegate: CustomSearch());
                },
                icon: const Icon(Icons.search_outlined)),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.filter_center_focus_outlined)),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.filter_list_outlined)),
          ],
        ),
        drawer: NavigationDrawer(),
        body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: productList.length,
          itemBuilder: (BuildContext context, int index) {
            return buildCard(item: productList[index]);
          },
        ),
      ),
    );
  }

  Widget buildCard({required ProductModel item, Color color = Colors.white}) {
    return Card(
        color: color,
        child: ListTile(
          dense: true,
          title: Text(item.name),
          subtitle: Text(item.code),
          leading: Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: item.remain > 0
                    ? Colors.green
                    : item.remain < 0
                        ? Colors.red
                        : Colors.amber,
              ),
              child: Text(
                item.remain.toStringAsFixed(0),
                style: const TextStyle(fontSize: 12, color: Colors.white),
              )),
          trailing: Column(
            children: [
              Text(
                translation(context).product_price,
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                item.price.toStringAsFixed(2),
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ));
  }
}

class CustomSearch extends SearchDelegate {
  List<ProductModel> productList = [
    ProductModel(
        id: 1,
        code: '100.001',
        name: 'СОРОЧКИ трикотаж/шелк',
        remain: 5,
        price: 5.5),
    ProductModel(
        id: 2,
        code: '100.002',
        name: 'Милана штапель/тенсел',
        remain: 20,
        price: 35),
    ProductModel(
        id: 3, code: '100.003', name: 'Сара вельвет', remain: 0, price: 9),
    ProductModel(
        id: 4, code: '100.004', name: 'Намазник Капюшон', remain: 2, price: 4),
    ProductModel(
        id: 5,
        code: '100.005',
        name: 'Джинс Руб-Карман',
        remain: 65,
        price: 15),
    ProductModel(
        id: 6, code: '100.006', name: 'Аманиса Шерсть', remain: 3, price: 46),
    ProductModel(
        id: 7, code: '100.007', name: 'Венера Вельвет', remain: 20, price: 5),
    ProductModel(
        id: 8,
        code: '100.008',
        name: 'Екатерина Болдышева и группа Мираж - Море грёз',
        remain: -23,
        price: 20),
    ProductModel(
        id: 9,
        code: '100.009',
        name:
        'Была на ее концерте.Стояла у самой сцены,и не могла отвести от нее глаз. Завораживает как Сирена.',
        remain: 5,
        price: 10),
  ];

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
    List<ProductModel> matchQueries = [];
    for (var result in productList) {
      if (result.name.toLowerCase().contains(query.toLowerCase())) {
        matchQueries.add(result);
      }
    }
    return ListView.builder(
        itemCount: matchQueries.length,
        itemBuilder: (context, index) {
          var result = matchQueries[index];
          return ListTile(
            title: Text(result.name),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<ProductModel> matchQueries = [];
    for (var result in productList) {
      if (result.name.toLowerCase().contains(query.toLowerCase())) {
        matchQueries.add(result);
      }
    }
    return ListView.builder(
        itemCount: matchQueries.length,
        itemBuilder: (context, index) {
          var result = matchQueries[index];
          return ListTile(
            title: Text(result.name),
            onTap: () {
              close(context, result);
            },
          );
        });
  }
}
