import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isoft/components/navigation_drawer.dart';
import 'package:isoft/l10n/language_constants.dart';
import 'package:isoft/models/product_model.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key, this.items}) : super(key: key);
  final List<ProductModel>? items;

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final formKey = GlobalKey<FormState>();
  final productTotalController = TextEditingController();
  final productCountController = TextEditingController();
  final productPriceController = TextEditingController();

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
        remain: 23,
        price: 20),
    ProductModel(
        id: 9,
        code: '100.009',
        name:
            'Была на ее концерте.Стояла у самой сцены,и не могла отвести от нее глаз. Завораживает как Сирена.',
        remain: 5,
        price: 10),
  ];

  List<ProductModel> itemsSelected = [];

  @override
  void initState() {
    super.initState();
    itemsSelected = widget.items ?? [];
    for (var i = 0; i < itemsSelected.length; i++) {
      for (var j = 0; j < productList.length; j++) {
        if (itemsSelected[i].code == productList[j].code) {
          setState(() {
            productList[j].count = itemsSelected[i].count;
            productList[j].newPrice = itemsSelected[i].newPrice;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    productTotalController.dispose();
    productCountController.dispose();
    productPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop({"items": itemsSelected});
        return true;
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
          leading: item.count > 0
              ? Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  child: Text(
                    item.count.toString(),
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ))
              : const Icon(Icons.hourglass_empty),
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
          onTap: () {
            showProductDialog(item);
          },
        ));
  }

  void showProductDialog(ProductModel item) {
    productPriceController.text = item.newPrice > 0
        ? item.newPrice.toStringAsFixed(2)
        : item.price.toStringAsFixed(2);
    productCountController.text = item.count.toString();
    productTotalController.text = (double.parse(productPriceController.text) *
            int.parse(productCountController.text))
        .toStringAsFixed(2);
    productCountController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: productCountController.text.length,
    );

    showDialog<int>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return SingleChildScrollView(
          child: AlertDialog(
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    readOnly: true,
                    initialValue: item.code,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.code),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        labelText: translation(context).product_code,
                        border: const OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    readOnly: true,
                    initialValue: item.name,
                    minLines: 1,
                    maxLines: 5,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.notes),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        labelText: translation(context).product_name,
                        border: const OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    readOnly: true,
                    initialValue: item.remain.toStringAsFixed(0),
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.bookmark_border),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        labelText: translation(context).product_remain,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  item.remain > 0 ? Colors.blue : Colors.red),
                        )),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: productPriceController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 14),
                    validator: (value) {
                      if (double.parse(value!) < 0) {
                        return translation(context).field_less_zero;
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.monetization_on_outlined),
                      labelText: translation(context).product_price,
                      border: const OutlineInputBorder(),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                    ),
                    onChanged: (value) {
                      double price = double.parse(value);
                      int count = int.parse(productCountController.text);
                      productTotalController.text =
                          (price * count).toStringAsFixed(2);
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: productCountController,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    style: const TextStyle(fontSize: 14),
                    validator: (value) {
                      if (int.parse(value!) < 0) {
                        return translation(context).field_less_zero;
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.discount),
                        suffixIcon: IconButton(
                          onPressed: () {
                            productCountController.text = '0';
                            productCountController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: productCountController.text.length,
                            );
                            productTotalController.text = '0.00';
                          },
                          icon: const Icon(Icons.clear),
                        ),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        labelText: translation(context).product_count,
                        border: const OutlineInputBorder()),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        double price =
                            double.parse(productPriceController.text);
                        int count = int.parse(value);
                        productTotalController.text =
                            (price * count).toStringAsFixed(2);
                      }
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    controller: productTotalController,
                    readOnly: true,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        labelText: translation(context).product_total,
                        labelStyle:
                            const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).errorColor),
                child: Text(translation(context).cancel),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.green),
                child: Text(
                  translation(context).save,
                  style: const TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      item.count = int.parse(productCountController.text);
                      if (double.parse(productPriceController.text) !=
                          item.price) {
                        item.newPrice =
                            double.parse(productPriceController.text);
                      }
                    });
                    itemsSelected.clear();
                    for (ProductModel product in productList) {
                      if (product.count > 0) {
                        itemsSelected.add(product);
                      }
                    }
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomSearch extends SearchDelegate {
  List<ProductModel> products = [
    ProductModel(
        id: 1,
        code: '100.001',
        name: 'СОРОЧКИ трикотаж/шелк',
        remain: 5,
        price: 5),
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
    for (var result in products) {
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
    for (var result in products) {
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
