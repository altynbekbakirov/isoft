import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isoft/components/navigation_drawer.dart';
import 'package:isoft/data/company_provider.dart';
import 'package:isoft/data/db_helper.dart';
import 'package:isoft/data/shared_prefs.dart';
import 'package:isoft/models/cart_model.dart';
import 'package:isoft/models/product_model.dart';
import 'package:provider/provider.dart';

late List<Product> productList;

Future<List<Product>> getProducts(BuildContext context) async {
  return await DatabaseHelper.instance
      .getAllProducts(context.watch<CompanyProvider>().activeCompany.id);
}

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key, required this.items}) : super(key: key);
  final List<Cart> items;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final formKey = GlobalKey<FormState>();
  final productTotalController = TextEditingController();
  final productCountController = TextEditingController();
  final productPriceController = TextEditingController();

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
        Navigator.of(context).pop({"items": widget.items});
        return true;
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
          height: 1,
          thickness: 1,
        );
      },
    );
  }

  Widget buildCard({required Product item, Color color = Colors.white}) {
    int productCount = 0;
    if (widget.items.length > 0) {
      for (var cartItem in widget.items) {
        if (item.id == cartItem.id) {
          productCount = cartItem.count;
          break;
        }
      }
    }

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
      leading: productCount > 0
          ? CircleAvatar(
              child: Text(
                '${productCount}',
                style: TextStyle(fontSize: 12),
              ),
              radius: 20,
            )
          : Text(''),
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
      onTap: () => showProductDialog(item),
    );
  }

  void showProductDialog(Product item) {
    bool isFound = false;

    if (widget.items.length > 0) {
      for (var cart in widget.items) {
        if (cart.id == item.id) {
          isFound = true;
          productCountController.text = cart.count.toString();
          break;
        }
      }
    }

    if (!isFound) {
      productCountController.text = '0';
    }

    productPriceController.text = item.salePrice.toString();
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
                    style: const TextStyle(fontSize: 14),
                    initialValue: item.onHand.toString(),
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.bookmark_border),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        labelText: translation(context).product_remain,
                        border: const OutlineInputBorder()),
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
                child: Text(translation(context).cancel),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                },
              ),
              ElevatedButton(
                child: Text(
                  translation(context).save,
                  style: const TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    int count = int.parse(productCountController.text);
                    if (isFound) {
                      for (int i = 0; i < widget.items.length; i++) {
                        if (widget.items[i].id == item.id) {
                          if (count == 0) {
                            setState(() {
                              widget.items.removeAt(i);
                            });
                          } else {
                            setState(() {
                              widget.items[i].count = count;
                            });
                          }
                          break;
                        }
                      }
                    } else {
                      final cart = Cart(
                          id: item.id,
                          code: item.code,
                          name: item.name,
                          price: item.salePrice ?? 0,
                          count: count);
                      setState(() {
                        widget.items.add(cart);
                      });
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
