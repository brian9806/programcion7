import 'package:flutter/material.dart';
import 'package:system_app/widgets/option_menu.dart';
import 'package:system_app/controllers/products.dart';
import 'package:system_app/constants/constans.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
    const HomePage({super.key});

    @override
    State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
                                color: Color.fromARGB(100, 213, 213, 213),
                                textColor: Colors.black,
                                width: 10,
                            ),
                            const OptionMenu(
                                text: 'My products',
                                alignment: Alignment.centerLeft,
                                color: Colors.white, 
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
                title: const Text('System A&M', style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.black,
                elevation: 0,
                centerTitle: true,
            ),

        body: FutureBuilder(
          future: _productsController.getAllProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<dynamic> products = _productsController.productsAll;
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
                              Text('Disponibles: ${product['stock']}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      );
    }
}