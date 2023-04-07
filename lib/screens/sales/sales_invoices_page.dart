import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isoft/components/navigation_drawer.dart';
import 'package:isoft/data/account_provider.dart';
import 'package:isoft/data/currency_provider.dart';
import 'package:isoft/data/shared_prefs.dart';
import 'package:isoft/data/ware_provider.dart';
import 'package:isoft/models/account_model.dart';
import 'package:isoft/models/cart_model.dart';
import 'package:isoft/screens/accounts/accounts_screen.dart';
import 'package:isoft/screens/currency_screen.dart';
import 'package:isoft/screens/products/product_screen.dart';
import 'package:isoft/screens/warehouse_screen.dart';
import 'package:provider/provider.dart';

class SalesInvoicesPage extends StatefulWidget {
  const SalesInvoicesPage({Key? key}) : super(key: key);

  @override
  State<SalesInvoicesPage> createState() => _SalesInvoicesPageState();
}

class _SalesInvoicesPageState extends State<SalesInvoicesPage> {
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
          title: Text(translation(context).sales_invoices),
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
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => InvoiceScreen()));
          },
          child: const Icon(Icons.add_outlined),
        ),
      ),
    );
  }
}

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({Key? key}) : super(key: key);

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final accountController = TextEditingController();
  final discountController = TextEditingController();
  final expensesController = TextEditingController();
  final sumController = TextEditingController();
  final currencyController = TextEditingController();
  final wareController = TextEditingController();

  final productTotalController = TextEditingController();
  final productCountController = TextEditingController();
  final productPriceController = TextEditingController();

  final formAccountKey = GlobalKey<FormState>();
  final formPaymentKey = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();

  List<Cart> items = [];
  double invoiceTotal = 0.00, discount = 0.00, expenses = 0.00;

  @override
  void dispose() {
    accountController.dispose();
    discountController.dispose();
    expensesController.dispose();
    sumController.dispose();
    currencyController.dispose();
    wareController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    discountController.selection = TextSelection(
        baseOffset: 0, extentOffset: discountController.text.length);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setInitialData();
  }

  Future setInitialData() async {
    currencyController.text =
        '${context.watch<CurrencyProvider>().activeCurrency.curCode} - ${context.watch<CurrencyProvider>().activeCurrency.curName}';
    wareController.text =
        '${context.watch<WareProvider>().getActiveWare.id} - ${context.watch<WareProvider>().getActiveWare.name}';
    accountController.text =
        '${context.watch<AccountProvider>().activeAccount.code} - ${context.watch<AccountProvider>().activeAccount.name}';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.close),
          ),
          actions: [
            IconButton(
                visualDensity: VisualDensity.comfortable,
                onPressed: () {
                  if (formAccountKey.currentState!.validate() &
                      formPaymentKey.currentState!.validate()) {
                    Navigator.of(context).pop();
                  }
                },
                icon: const Icon(Icons.save_outlined))
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            buildAccount(
                icon: Icons.person_outline,
                title: translation(context).account),
            buildProducts(
                icon: Icons.shopping_cart_outlined,
                title: translation(context).products),
            buildPayment(
                icon: Icons.payment_outlined,
                title: translation(context).invoice_payment)
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    final shouldPop = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(translation(context).discard_changes),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(translation(context).no)),
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(translation(context).yes)),
          ],
        );
      },
    );
    return shouldPop ?? false;
  }

  Widget buildAccount({required IconData icon, required String title}) {
    return Form(
      key: formAccountKey,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5),
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    alignment: Alignment.topLeft,
                    child: Icon(
                      icon,
                      size: 24,
                    ),
                  ),
                  Expanded(
                      child: Text(
                    title,
                    style: const TextStyle(fontSize: 18, color: Colors.black87),
                  )),
                ],
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 50,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: accountController,
                      textInputAction: TextInputAction.next,
                      minLines: 1,
                      maxLines: 3,
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => AccountsScreen()))
                            .then((value) {
                          if (value != null) {
                            Account account = value["account"];
                            accountController.text =
                                "${account.code} - ${account.name}";
                            formAccountKey.currentState!.validate();
                          }
                        });
                      },
                      readOnly: true,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(fontSize: 14),
                        errorStyle: const TextStyle(fontSize: 12),
                        hintText: "${translation(context).account_name} *",
                        isDense: true,
                        contentPadding: const EdgeInsets.all(4),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return translation(context).field_empty;
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        accountController.clear();
                      },
                      icon: const Icon(Icons.clear))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProducts({required IconData icon, required String title}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  alignment: Alignment.topLeft,
                  child: Icon(
                    icon,
                    size: 24,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, color: Colors.black87),
                ),
              ],
            ),
            buildProductsItem(items: items),
            buildProductsItemAddButton(),
            buildProductsItemDiscount(),
            buildProductsItemExpenses(),
            const SizedBox(
              height: 12,
            ),
            buildProductsItemTotal(),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProductsItem({required List<Cart> items}) {
    return ListView.builder(
      itemCount: items.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return Row(
          children: [
            const Expanded(
              flex: 1,
              child: SizedBox(
                width: 50,
              ),
            ),
            Expanded(
              flex: 6,
              child: TextFormField(
                key: Key(
                    "${items[index].code} ${items[index].count} ${items[index].price}"),
                initialValue:
                    "${items[index].name} \n${items[index].count} * ${items[index].price} = ${items[index].count * items[index].price}",
                readOnly: true,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                style: const TextStyle(fontSize: 14),
                onTap: () {
                  showProductDialog(items[index]);
                },
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(4),
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        items.removeAt(index);
                      });
                      calculateTotal(items: items);
                    },
                    icon: const Icon(
                      Icons.delete_outlined,
                      color: Colors.red,
                    )))
          ],
        );
      },
    );
  }

  Widget buildProductsItemAddButton() {
    return Row(
      children: [
        const Expanded(
          flex: 1,
          child: SizedBox(
            width: 50,
          ),
        ),
        Expanded(
          flex: 6,
          child: ElevatedButton(
            onPressed: () async {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => ProductScreen(
                            items: items,
                          )))
                  .then((value) {
                if (value != null) {
                  setState(() {
                    items = value['items'];
                    calculateTotal(items: items);
                  });
                  calculateTotal(items: items);
                }
              });
            },
            child: Text(translation(context).add_products),
          ),
        ),
      ],
    );
  }

  Widget buildProductsItemDiscount() {
    return Row(
      children: [
        const Expanded(
          flex: 1,
          child: SizedBox(
            width: 50,
          ),
        ),
        Expanded(
          flex: 6,
          child: TextFormField(
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            controller: discountController,
            style: const TextStyle(fontSize: 14),
            onChanged: (value) {
              setState(() {
                discount = (value.isEmpty ? 0 : double.parse(value));
              });
            },
            decoration: InputDecoration(
              labelText: translation(context).invoice_discounts,
              errorStyle: const TextStyle(fontSize: 12),
              isDense: true,
              contentPadding: const EdgeInsets.all(4),
            ),
          ),
        ),
        Expanded(
            flex: 1,
            child: IconButton(
                onPressed: () {
                  setState(() {
                    discount = 0;
                  });
                  discountController.text = '0';
                  discountController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: discountController.text.length,
                  );
                },
                icon: const Icon(Icons.clear)))
      ],
    );
  }

  Widget buildProductsItemExpenses() {
    return Row(
      children: [
        const Expanded(
          flex: 1,
          child: SizedBox(
            width: 50,
          ),
        ),
        Expanded(
          flex: 6,
          child: TextFormField(
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            controller: expensesController,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              errorStyle: const TextStyle(fontSize: 12),
              labelText: translation(context).invoice_expenses,
              isDense: true,
              contentPadding: const EdgeInsets.all(4),
            ),
            onChanged: (value) {
              setState(() {
                expenses = (value.isEmpty ? 0 : double.parse(value));
              });
            },
          ),
        ),
        Expanded(
            flex: 1,
            child: IconButton(
                onPressed: () {
                  setState(() {
                    expenses = 0;
                  });
                  expensesController.text = '0';
                  expensesController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: expensesController.text.length,
                  );
                },
                icon: const Icon(Icons.clear)))
      ],
    );
  }

  Widget buildProductsItemTotal() {
    return Row(
      children: [
        const Expanded(
          flex: 1,
          child: SizedBox(
            width: 50,
          ),
        ),
        Expanded(
          flex: 7,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${translation(context).invoice_total} :",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Container(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  (invoiceTotal - discount + expenses).toStringAsFixed(2),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildPayment({required IconData icon, required String title}) {
    return Form(
      key: formPaymentKey,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5),
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: 50,
                      alignment: Alignment.topLeft,
                      child: Icon(
                        icon,
                        size: 24,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 6,
                      child: Text(
                        title,
                        style: const TextStyle(
                            fontSize: 18, color: Colors.black87),
                      )),
                ],
              ),
              Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: SizedBox(
                      width: 50,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: TextFormField(
                      controller: sumController,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(fontSize: 14),
                        labelText: translation(context).invoice_sum,
                        errorStyle: const TextStyle(fontSize: 12),
                        isDense: true,
                        contentPadding: const EdgeInsets.all(4),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        sumController.clear();
                      },
                      icon: const Icon(Icons.clear))
                ],
              ),
              Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: SizedBox(
                      width: 50,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: TextFormField(
                      controller: currencyController,
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => CurrencyScreen(
                                    currency:
                                        currencyController.text.toString())))
                            .then((value) {
                          if (value != null) {
                            currencyController.text = value;
                            formPaymentKey.currentState!.validate();
                          }
                        });
                      },
                      readOnly: true,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(fontSize: 14),
                        labelText: "${translation(context).currency} *",
                        errorStyle: const TextStyle(fontSize: 12),
                        isDense: true,
                        contentPadding: const EdgeInsets.all(4),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return translation(context).field_empty;
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        currencyController.clear();
                      },
                      icon: const Icon(Icons.clear))
                ],
              ),
              Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: SizedBox(
                      width: 50,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: TextFormField(
                      controller: wareController,
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => WarehouseScreen(
                                    warehouse: wareController.text.toString())))
                            .then((value) {
                          if (value != null) {
                            wareController.text = value;
                            formPaymentKey.currentState!.validate();
                          }
                        });
                      },
                      readOnly: true,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(fontSize: 14),
                        labelText: "${translation(context).warehouse} *",
                        errorStyle: const TextStyle(fontSize: 12),
                        isDense: true,
                        contentPadding: const EdgeInsets.all(4),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return translation(context).field_empty;
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        wareController.clear();
                      },
                      icon: const Icon(Icons.clear))
                ],
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void calculateTotal({required List<Cart> items}) {
    invoiceTotal = 0;
    for (Cart product in items) {
      setState(() {
        invoiceTotal += product.count * product.price;
      });
    }
  }

  void showProductDialog(Cart item) {
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
                    minLines: 1,
                    maxLines: 5,
                    initialValue: item.name,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
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
                    initialValue: '0',
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
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
                      double price = double.parse(productPriceController.text);
                      int count = int.parse(value);
                      productTotalController.text =
                          (price * count).toStringAsFixed(2);
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
              OutlinedButton(
                style: ElevatedButton.styleFrom(primary: Colors.green),
                child: Text(
                  translation(context).save,
                  style: const TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      item.count = int.parse(productCountController.text);
                      if (item.count == 0) {
                        items.remove(item);
                      } else {
                        item.price = double.parse(productPriceController.text);
                      }
                      calculateTotal(items: items);
                    });
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
