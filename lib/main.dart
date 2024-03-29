import 'package:flutter/material.dart';
import 'palette.dart';

void main() {
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        primarySwatch: Palette.kToDark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login(BuildContext context) {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username == 'bongo' && password == 'htl') {
      Navigator.pushReplacement(
        context,
       MaterialPageRoute(builder: (context) => TableSelectPage()),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Invalid username or password.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _login(context);
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class TableSelectPage extends StatelessWidget {
  final List<int> tables = List.generate(20, (index) => index + 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tables'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemCount: tables.length,
          itemBuilder: (context, index) {
            int tableNumber = tables[index];
            return ListTile(
              title: Text('Table $tableNumber'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MenuDisplayPage(selectedTable: tableNumber),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class MenuDisplayPage extends StatefulWidget {
  final int selectedTable;

  const MenuDisplayPage({required this.selectedTable});

  @override
  _MenuDisplayPageState createState() => _MenuDisplayPageState();
}

class _MenuDisplayPageState extends State<MenuDisplayPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> orders = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addOrder(String item) {
    setState(() {
      orders.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('bongo | Table ${widget.selectedTable.toString()}'),

        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigate to the order page while passing orders and selectedTable
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderPage(orders: orders, selectedTable: widget.selectedTable),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MenuCategory(
            items: const [
              'Burger', 'Pizza', 'Salad', 'Pasta', 'Sandwich', 'Steak', 'Sushi', 'Taco', 'Ramen', 'Chicken Wings',
              'Caesar Salad', 'Hot Dog', 'Fried Rice', 'Wrap', 'Nachos', 'Hamburger', 'Club Sandwich', 'Lasagna',
              'Calzone', 'Fish and Chips',
            ],
            onItemTap: _addOrder,
          ),
      MenuCategory(
        items: const [
          'Soda', 'Coffee', 'Tea', 'Mojito', 'Lemonade', 'Smoothie', 'Milkshake', 'Beer', 'Wine', 'Cocktail',
          'Iced Coffee', 'Orange Juice', 'Iced Tea', 'Cola', 'Water', 'Margarita', 'Mocktail', 'Juice',
          'Limeade', 'Hot Chocolate',
        ],
        onItemTap: _addOrder,
      ),
      MenuCategory(
        items: const [
          'Cake', 'Ice Cream', 'Brownie', 'Cheesecake', 'Cookie', 'Cupcake', 'Pudding', 'Gelato', 'Tiramisu',
          'Pie', 'Macaroon', 'Donut', 'Churros', 'Muffin', 'Waffle', 'Fruit Salad', 'Sorbet', 'Frozen Yogurt',
          'Trifle', 'Custard',
        ],
        onItemTap: _addOrder,
          ),
        ],
      ),
      bottomNavigationBar: Material(
        color: Theme.of(context).primaryColor,
        child: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(child: Text('Food',style: TextStyle(fontSize: 20),)),
            Tab(child: Text('Drinks',style: TextStyle(fontSize: 20),)),
            Tab(child: Text('Desserts',style: TextStyle(fontSize: 20),)),
          ],
        ),
      ),
    );
  }
}

class MenuCategory extends StatefulWidget {
  final List<String> items;
  final Function(String) onItemTap;

  const MenuCategory({required this.items, required this.onItemTap});

  @override
  _MenuCategoryState createState() => _MenuCategoryState();
}

class _MenuCategoryState extends State<MenuCategory> {
  Set<String> selectedItems = Set();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemBuilder: (context, index) {
        final itemName = widget.items[index];
        final isSelected = selectedItems.contains(itemName);

        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedItems.remove(itemName);
              } else {
                selectedItems.add(itemName);
              }
            });
            widget.onItemTap(itemName);
            Future.delayed(const Duration(milliseconds: 150), () {
              setState(() {
                selectedItems.remove(itemName);
              });
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: isSelected ? Colors.orange.withOpacity(0.5) : null,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.all(4.0),
            alignment: Alignment.center,
            child: Text(
              itemName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        );
      },
    );
  }
}


class OrderPage extends StatefulWidget {
  final List<String> orders;
  final int selectedTable;
  const OrderPage({required this.orders, required this.selectedTable});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  Map<String, List<String>> categorizedOrders = {};

  @override
  void initState() {
    super.initState();
    _categorizeOrders();
  }

  void _categorizeOrders() {
    categorizedOrders.clear();

    for (var order in widget.orders) {
      var category = getCategory(order);
      if (!categorizedOrders.containsKey(category)) {
        categorizedOrders[category] = [];
      }
      categorizedOrders[category]!.add(order);
    }
    setState(() {});
  }

  String getCategory(String order) {

    //
    //TODO
    // Hier noch unbedingt die Kategorie eines Produktes rausfiltern und ausgeben
    //
    //
    
    return order;
  }

  void _removeItem(String item) {
    setState(() {
      widget.orders.remove(item);
      _categorizeOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: categorizedOrders.keys.length,
              itemBuilder: (context, index) {
                var category = categorizedOrders.keys.elementAt(index);
                var items = categorizedOrders[category]!;

                return ExpansionTile(
                  title: Text(
                    category,
                    style: const TextStyle(fontSize: 20),
                  ),
                  children: items.map((item) {
                    return ListTile(
                      title: Text(
                        item,
                        style: const TextStyle(fontSize: 20),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _removeItem(item);
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => TableSelectPage()),
                      (Route<dynamic> route) => false,
                );
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Done'),
                      content: Text(
                        'The Order has been saved.\nTable Number: ${widget.selectedTable.toString()}',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
                var toRemove = <String>[];
                categorizedOrders.keys.forEach((element) {
                  toRemove.add(element);
                });
                widget.orders.removeWhere((element) => toRemove.contains(element));
              },
              child: const Text('Send Order'),
            ),
          ),
        ],
      ),
    );
  }
}



