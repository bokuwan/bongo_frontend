import 'package:flutter/material.dart';

void main() {
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
    // Add your authentication logic here, for simplicity using hardcoded values
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Example authentication with hardcoded credentials
    if (username == 'username' && password == 'password') {
      // Navigate to MenuDisplayPage if login is successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MenuDisplayPage()),
      );
    } else {
      // Show an error dialog or message for unsuccessful login
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Invalid username or password.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
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
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _login(context);
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuDisplayPage extends StatefulWidget {
  @override
  _MenuDisplayPageState createState() => _MenuDisplayPageState();
}

class _MenuDisplayPageState extends State<MenuDisplayPage> with SingleTickerProviderStateMixin {
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
        title: Text('Menu Display'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Food'),
            Tab(text: 'Drinks'),
            Tab(text: 'Desserts'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MenuCategory(
            items: [
              'Burger', 'Pizza', 'Salad', 'Pasta', 'Sandwich', 'Steak', 'Sushi', 'Taco', 'Ramen', 'Chicken Wings',
              'Caesar Salad', 'Hot Dog', 'Fried Rice', 'Wrap', 'Nachos', 'Hamburger', 'Club Sandwich', 'Lasagna',
              'Calzone', 'Fish and Chips',
            ],
            onItemTap: _addOrder,
          ),
          MenuCategory(
            items: [
              'Soda', 'Coffee', 'Tea', 'Mojito', 'Lemonade', 'Smoothie', 'Milkshake', 'Beer', 'Wine', 'Cocktail',
              'Iced Coffee', 'Orange Juice', 'Iced Tea', 'Cola', 'Water', 'Margarita', 'Mocktail', 'Juice',
              'Limeade', 'Hot Chocolate',
            ],
            onItemTap: _addOrder,
          ),
          MenuCategory(
            items: [
              'Cake', 'Ice Cream', 'Brownie', 'Cheesecake', 'Cookie', 'Cupcake', 'Pudding', 'Gelato', 'Tiramisu',
              'Pie', 'Macaron', 'Donut', 'Churros', 'Muffin', 'Waffle', 'Fruit Salad', 'Sorbet', 'Frozen Yogurt',
              'Trifle', 'Custard',
            ],
            onItemTap: _addOrder,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the order page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OrderPage(orders: orders)),
          );
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}

class MenuCategory extends StatefulWidget {
  final List<String> items;
  final Function(String) onItemTap;

  MenuCategory({required this.items, required this.onItemTap});

  @override
  _MenuCategoryState createState() => _MenuCategoryState();
}

class _MenuCategoryState extends State<MenuCategory> {
  Set<String> selectedItems = Set();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
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
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.green.withOpacity(0.5) : null,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text(
              itemName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }
}

class OrderPage extends StatelessWidget {
  final List<String> orders;

  OrderPage({required this.orders});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(orders[index]),
          );
        },
      ),
    );
  }
}
