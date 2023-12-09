import 'package:flutter/material.dart';
import '../widgets/option_menu.dart';
import 'package:system_app/controllers/products.dart';
import 'package:get/get.dart';
import 'package:system_app/constants/constans.dart';
import 'package:system_app/views/edit_product_page.dart';
import 'package:system_app/views/new_product_page.dart';
//import 'package:google_fonts/google_fonts.dart';
//import '../widgets/input_widget.dart';
//import 'package:image_picker/image_picker.dart';
//import 'package:system_app/controllers/products.dart';
//import 'package:get/get.dart';
//import 'dart:io';


class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {

  final ProductsController _productsController = Get.put(ProductsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: const Color.fromARGB(255, 255, 255, 255),
          child: Column(
            children: [
                Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(top: 40, bottom: 10),
                    child: Image.network('https://upload.wikimedia.org/wikipedia/commons/7/70/User_icon_BLACK-01.png'),
                ),
                const Text('Usuario', style: TextStyle(fontSize: 20)),
                const OptionMenu(
                  text: 'Home',
                  alignment: Alignment.centerLeft,
                  color: Colors.white,
                  textColor: Colors.black,
                  width: 10,
              ),
              const OptionMenu(
                  text: 'My products',
                  alignment: Alignment.centerLeft,
                  color: Color.fromARGB(100, 213, 213, 213), 
                  textColor: Colors.black,
                  width: 10,
              ),
              
              Expanded(
                  child: Container(),
              ),
              const OptionMenu(
                  text: 'Sign out',
                  alignment: Alignment.center,
                  color: Colors.black,
                  textColor: Colors.white,
                  width: 0,
              ),
            ],
          ),
        ),
      ),

      appBar: AppBar(
        title: const Text('My products', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),

      body: FutureBuilder(
        future: _productsController.getMyProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<dynamic> products = _productsController.productsList;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                //Agregar un minimo de 280
                maxCrossAxisExtent: 290,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                var product = products[index];
                return Card(
                  elevation: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Imagen del producto
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(url + product['image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Información del producto
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(product['description']),
                            Text('Precio: ${product['price']}'),
                            Text('Stock: ${product['stock']}'),
                          ],
                        ),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Get.to(EditProductsPage(productId: product['id']));
                            },
                            child: const Text('Editar'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _showDeleteConfirmationDialog(context, product['id']);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text('Eliminar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(const NewProductsPage());
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context, int productId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Está seguro de que desea eliminar este producto?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await _productsController.deleteProduct(productId);
                setState(() {});
                if(!mounted) return;
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}