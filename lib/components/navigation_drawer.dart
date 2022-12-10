import 'package:flutter/material.dart';
import 'package:isoft/data/company_provider.dart';
import 'package:isoft/data/db_helper.dart';
import 'package:isoft/data/shared_prefs.dart';
import 'package:isoft/models/company_model.dart';
import 'package:isoft/models/navigation_item.dart';
import 'package:isoft/data/navigation_provider.dart';
import 'package:isoft/routes/router_generator.dart';
import 'package:provider/provider.dart';

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  bool isSelectCompany = false;
  late Future<List<Company>> companies;

  Future<List<Company>> getCompanies() async {
    return await DatabaseHelper.instance.getCompanies();
  }

  @override
  void initState() {
    super.initState();
    companies = getCompanies();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          buildMenuHeader(context,
              title: 'Altynbek Bakirov', email: 'altynbek.bakirov@gmail.com'),
          Expanded(
            child: isSelectCompany
                ? FutureBuilder<List<Company>>(
                    initialData: [],
                    future: companies,
                    builder: (context, snapshot) {
                      final data = snapshot.data;
                      return ListView.separated(
                        physics: BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(0),
                        itemCount: data!.length,
                        itemBuilder: (context, index) {
                          return buildCompanyMenuItem(company: data[index]);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            height: 1,
                          );
                        },
                      );
                    },
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    children: [
                      buildMenuItem(context,
                          title: translation(context).home,
                          icon: Icons.home_outlined,
                          item: NavigationItem.home,
                          route: Routers.home),
                      buildMenuItem(context,
                          title: translation(context).products,
                          icon: Icons.point_of_sale_sharp,
                          item: NavigationItem.products,
                          route: Routers.products),
                      buildMenuItem(context,
                          title: translation(context).accounts,
                          icon: Icons.manage_accounts,
                          item: NavigationItem.accounts,
                          route: Routers.accounts),
                      const Divider(
                        color: Colors.black54,
                      ),
                      buildMenuItem(context,
                          title: translation(context).sales,
                          icon: null,
                          item: null),
                      buildMenuItem(context,
                          title: translation(context).sales_orders,
                          icon: Icons.bookmark_border,
                          item: NavigationItem.sales_orders,
                          route: Routers.salesOrders),
                      buildMenuItem(context,
                          title: translation(context).sales_invoices,
                          icon: Icons.shopping_cart_outlined,
                          item: NavigationItem.sales_invoices,
                          route: Routers.salesInvoices),
                      buildMenuItem(context,
                          title: translation(context).sales_returns,
                          icon: Icons.assignment_return_outlined,
                          item: NavigationItem.sales_returns,
                          route: Routers.salesReturns),
                      const Divider(
                        color: Colors.black54,
                      ),
                      buildMenuItem(context,
                          title: translation(context).purchases,
                          icon: null,
                          item: null),
                      buildMenuItem(context,
                          title: translation(context).purchases_orders,
                          icon: Icons.bookmark_border,
                          item: NavigationItem.purchases_orders,
                          route: Routers.purchasesOrders),
                      buildMenuItem(context,
                          title: translation(context).purchases_invoices,
                          icon: Icons.save_alt,
                          item: NavigationItem.purchases_invoices,
                          route: Routers.purchasesInvoices),
                      const Divider(color: Colors.black54),
                      buildMenuItem(context,
                          title: translation(context).warehouse,
                          icon: null,
                          item: null),
                      buildMenuItem(context,
                          title: translation(context).product_transactions,
                          icon: Icons.transfer_within_a_station,
                          item: NavigationItem.product_transactions,
                          route: Routers.productTransactions),
                      buildMenuItem(context,
                          title: translation(context).open_slips,
                          icon: Icons.plus_one,
                          item: NavigationItem.open_slips,
                          route: Routers.openSlips),
                      buildMenuItem(context,
                          title: translation(context).scrap_slips,
                          icon: Icons.delete_outlined,
                          item: NavigationItem.scrap_slips,
                          route: Routers.scrapSlips),
                      const Divider(color: Colors.black54),
                      buildMenuItem(context,
                          title: translation(context).safe_transactions,
                          icon: Icons.monetization_on_outlined,
                          item: NavigationItem.safe_transactions,
                          route: Routers.safeTransactions),
                      const Divider(color: Colors.black54),
                      buildMenuItem(context,
                          title: translation(context).settings,
                          icon: Icons.settings_outlined,
                          item: null,
                          route: Routers.settings,
                          replaceRoute: true),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget buildCompanyMenuItem({required Company company}) {
    final isSelected =
        context.watch<CompanyProvider>().activeCompany.id == company.id;

    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(vertical: -1),
      title: Text('(${company.nr}) - ${company.name}'),
      trailing: isSelected ? Icon(Icons.task_alt_sharp) : null,
      selected: isSelected,
      onTap: isSelected
          ? null
          : () async {
              context.read<CompanyProvider>().setActiveCompany(company);
              await setActiveCompany(company.id);
            },
    );
  }

  Widget buildMenuItem(BuildContext context,
      {required String title,
      IconData? icon,
      NavigationItem? item,
      String? route,
      bool replaceRoute = false}) {
    final isSelected =
        context.read<NavigationProvider>().navigationItem == item;

    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(vertical: -1),
      title: icon == null
          ? const Text("")
          : Text(
              title,
            ),
      leading: icon == null
          ? Text(title, style: const TextStyle(fontWeight: FontWeight.w500))
          : Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).unselectedWidgetColor,
            ),
      selected: isSelected,
      selectedTileColor: Colors.grey[200],
      onTap: item == null && replaceRoute == false
          ? null
          : () {
              if (item != null) {
                context.read<NavigationProvider>().setNavigationItem(item);
              }
              Navigator.of(context).pop();
              if (route != null) {
                replaceRoute
                    ? Navigator.of(context).pushNamed(route)
                    : Navigator.of(context).pushReplacementNamed(route);
              }
            },
    );
  }

  Widget buildMenuHeader(context,
      {required String title, required String email}) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.9),
      width: double.infinity,
      height: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.start,
          ),
          Text(
            email,
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.start,
          ),
          const SizedBox(
            height: 12,
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              setState(() {
                isSelectCompany = !isSelectCompany;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              color: Theme.of(context).primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '(${Provider.of<CompanyProvider>(context, listen: false).activeCompany.nr}) - ${Provider.of<CompanyProvider>(context, listen: false).activeCompany.name}',
                    style: TextStyle(color: Colors.white),
                  ),
                  const Expanded(child: Text('')),
                  Icon(
                    isSelectCompany
                        ? Icons.keyboard_arrow_up_outlined
                        : Icons.keyboard_arrow_down_outlined,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
