import 'package:flutter/material.dart';
import 'package:user_app/models/meal.dart';
import 'package:user_app/views/home/drink_view/bevarge_item_view.dart';

class BeverageStoreDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> beverageStore;

  const BeverageStoreDetailsScreen({super.key, required this.beverageStore});

  @override
  _BeverageStoreDetailsScreenState createState() =>
      _BeverageStoreDetailsScreenState();
}

class _BeverageStoreDetailsScreenState
    extends State<BeverageStoreDetailsScreen> {
  List<Meal> items = [];
  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    items = List<Map<String, dynamic>>.from(widget.beverageStore['meals'] ?? [])
        .map((itemData) => Meal(
            id: itemData['id'],
            name: itemData['itemName'],
            description: itemData['description'],
            price: itemData['price'],
            imageUrl: itemData['imageUrl'] ?? '',
            ingredients: itemData['ingredients'],
            addOns: itemData['addOns'],
            category: itemData['category']))
        .toList();
    selectedCategory = '';
  }

  void filterMeals(String category) {
    setState(() {
      selectedCategory = category;
      if (category == '') {
        items =
            List<Map<String, dynamic>>.from(widget.beverageStore['meals'] ?? [])
                .map((mealData) => Meal(
                    id: mealData['id'],
                    name: mealData['itemName'],
                    description: mealData['description'],
                    price: mealData['price'],
                    imageUrl: mealData['imageUrl'] ?? '',
                    ingredients: mealData['ingredients'],
                    addOns: mealData['addOns'],
                    category: mealData['category']))
                .toList();
      } else {
        items =
            List<Map<String, dynamic>>.from(widget.beverageStore['meals'] ?? [])
                .map((mealData) => Meal(
                    id: mealData['id'],
                    name: mealData['itemName'],
                    description: mealData['description'],
                    price: mealData['price'],
                    imageUrl: mealData['imageUrl'] ?? '',
                    ingredients: mealData['ingredients'],
                    addOns: mealData['addOns'],
                    category: mealData['category']))
                .where((meal) => meal.category == category)
                .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.beverageStore['name'] ?? 'تفاصيل محل المشروبات'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Beverage Store Image
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.beverageStore['imageUrl'] ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Beverage Store Name
            Text(
              widget.beverageStore['name'] ?? 'اسم غير متوفر',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 24),
                    SizedBox(width: 4),
                    Text(
                      '0',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(width: 16),
                Row(
                  children: [
                    Icon(Icons.delivery_dining, color: Colors.green, size: 24),
                    SizedBox(width: 4),
                    Text(
                      'توصيل ',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(width: 16),
                Row(
                  children: [
                    Icon(Icons.timer, color: Colors.redAccent, size: 24),
                    SizedBox(width: 4),
                    Text(
                      '20 دقيقة',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Beverage Store Address
            Text(
              widget.beverageStore['address'] ?? 'عنوان غير متوفر',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            const Text(
              'التصنيفات:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
      SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('كل الوجبات'),
            selected: selectedCategory == '',
            onSelected: (selected) {
              filterMeals('');
            },
            selectedColor: Colors.redAccent,
          ),
          SizedBox(width: 8), // المسافة بين العناصر
          ...List<String>.from(widget.beverageStore['categories'] ?? [])
              .map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text(category),
                selected: selectedCategory == category,
                onSelected: (selected) {
                  filterMeals(category);
                },
                selectedColor: Colors.redAccent,
              ),
            );
          }).toList(),
        ],
      ),
    ),

            // Items Header
            const Text(
              'الأصناف المتاحة:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Items List
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BeverageDetailsScreen(
                          beverageStore: widget.beverageStore,
                          beverage: item,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Item Image
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                          child: Image.network(
                            item.imageUrl,
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Item Name
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),

                              // Item Description
                              Text(
                                item.description,
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 4),

                              // Item Price
                              Text(
                                'السعر: ${item.price}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
