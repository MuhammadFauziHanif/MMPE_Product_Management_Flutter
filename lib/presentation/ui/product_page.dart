import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mitsubishi_motors_parts_e_commerce/presentation/provider/product_provider.dart';
import 'package:mitsubishi_motors_parts_e_commerce/presentation/ui/add_product_page.dart';
import 'package:mitsubishi_motors_parts_e_commerce/presentation/ui/edit_product_page.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<ProductProvider>(context, listen: false).getProducts();

    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 0.7,
            ),
            itemCount: provider.listProduct.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(provider.listProduct[index].productName)));
                },
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                          child: Image.network(
                            provider.listProduct[index].imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          provider.listProduct[index].productName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Rp ${NumberFormat("#,##0", "id_ID").format(provider.listProduct[index].price)}',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Stock: ${provider.listProduct[index].stockQuantity}',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Column(
                              children: [
                                Icon(Icons.edit),
                                Text('Edit'),
                              ],
                            ),
                            onPressed: () {
                              // Navigate to the edit product page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProductPage(
                                    product: provider.listProduct[index],
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Column(
                              children: [
                                Icon(Icons.delete),
                                Text('Delete'),
                              ],
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Confirm Delete'),
                                    content: Text(
                                        'Are you sure you want to delete ${provider.listProduct[index].productName}?'),
                                    actions: [
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Delete'),
                                        onPressed: () async {
                                          // Handle delete action
                                          await Provider.of<ProductProvider>(
                                                  context,
                                                  listen: false)
                                              .deleteProduct(provider
                                                  .listProduct[index]
                                                  .productId);

                                          // After deletion, refresh the product list
                                          await Provider.of<ProductProvider>(
                                                  context,
                                                  listen: false)
                                              .getProducts();

                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddProductPage()));
        },
        icon: Icon(Icons.add),
        label: Text('Add New Product'),
      ),
    );
  }
}
