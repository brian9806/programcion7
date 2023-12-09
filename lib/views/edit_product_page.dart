import 'package:flutter/material.dart';
import '../widgets/option_menu.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/input_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:system_app/controllers/products.dart';
import 'package:get/get.dart';
import 'dart:io';
//import 'package:system_app/controllers/categories.dart';


class EditProductsPage extends StatefulWidget {
  final int productId;

  const EditProductsPage({
    super.key,
    required this.productId
  });

  @override
  State<EditProductsPage> createState() => _EditProductsPageState();
}

class _EditProductsPageState extends State<EditProductsPage> {
  final ProductsController _productsController = Get.find();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  //final CategoriesController _categoriesController = Get.put(CategoriesController());
  
  dynamic selectedImage;
  String _selectedCategory = '';
  String _selectedStatus = 'Activo';

  List<String> listStatus = ['Activo', 'Inactivo'];
  //List<String> listCategories = [];
  //debo recibir la lista de categorias de la base de datos
  List<String> listCategories = ["Hogar y muebles", "Electrodomesticos",
      "Herramientas", "Moda", "Vehiculos", "Celulares y accesorios", "Camaras y accesorios",
      "Consolas y videojuegos", "Televisores", "Computación", "Belleza", "Construccion"];

    @override
    void initState() {
      super.initState();
      if(listCategories.isNotEmpty){
        _selectedCategory = listCategories[0];
      }
      _loadProductDetails();
    }

    Future<void> _loadProductDetails() async {
      try {
        await _productsController.fetchProductDetailsById(widget.productId);
        // ignore: avoid_print
        print('Product details: ${_productsController.currentProduct['data']}');

        _nameController.text = _productsController.currentProduct['data']['name'] ?? '';
        _descriptionController.text = _productsController.currentProduct['data']['description'] ?? '';
        _priceController.text = _productsController.currentProduct['data']['price'].toString();
        _stockController.text = _productsController.currentProduct['data']['stock'].toString();
        _selectedCategory =  listCategories[(_productsController.currentProduct['data']['category'] - 1) ?? 0];
        _selectedStatus = _productsController.currentProduct['data']['status'] ?? 'Activo';
        setState(() {});

      } catch (e) {
        // ignore: avoid_print
        print('Error: $e');
      }
    }


    @override
    Widget build(BuildContext context) {
        var sizeWidth = MediaQuery.of(context).size.width;
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
                title: const Text('Edit products', style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.black,
                elevation: 0,
                centerTitle: true,
            ),
            body:  SingleChildScrollView(
              child: RefreshIndicator(
                onRefresh: () async {
                  // ignore: avoid_print
                  print("page refreshed");
                },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Edit product', 
                          style: GoogleFonts.poppins(
                            fontSize: sizeWidth * 0.080,
                          )
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: (){
                            _showSelectionDialog(context);
                          },
                          child: const Text('Pick Image'),
                        ),
                        const SizedBox(height: 10),
                        selectedImage == null ?
                          const Text('No Image Selected') :
                          Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(top: 40, bottom: 10),
                            child: _buildImagePreview(selectedImage!)
                          ),
                        const SizedBox(height: 30),
                        InputWidget(
                          hintText: 'name product',
                          obscureText: false,
                          icon: const Icon(Icons.article),
                          controller: _nameController
                        ),
                        const SizedBox(height: 30),
                        InputWidget(
                          hintText: 'description',
                          obscureText: false,
                          icon: const Icon(Icons.description),
                          controller: _descriptionController
                        ),
                        const SizedBox(height: 30),
                        InputNumberWidget(
                          hintText: 'Price',
                          controller: _priceController,
                          obscureText: false,
                          icon: const Icon(Icons.attach_money),
                          isDecimal: true
                        ),
                        const SizedBox(height: 30),
                        InputNumberWidget(
                          hintText: 'Stock',
                          controller: _stockController,
                          obscureText: false,
                          icon: const Icon(Icons.attach_money),
                          isDecimal: false
                        ),
                        const SizedBox(height: 30),
                        SelectedWidget(
                          select: _selectedStatus,
                          listOptions: listStatus,
                          onChanged: (value) {
                            _selectedStatus = value;
                          }
                        ),
                        const SizedBox(height: 30),
                        SelectedWidget(
                          select: _selectedCategory,
                          listOptions: listCategories,
                          onChanged: (value) {
                            _selectedCategory = value;
                          }
                        ),
                        const SizedBox(height: 30),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15
                            ),
                          ),
                          onPressed: () async {
                            await _productsController.editProduct(
                              productId: widget.productId,
                              name: _nameController.text.trim(),
                              description: _descriptionController.text.trim(),
                              newImage: null, //selectedImage == null ? null : XFile(selectedImage),
                              price: double.parse(_priceController.text.trim()),
                              stock: int.parse(_stockController.text.trim()),
                              status: _selectedStatus,
                              category: _selectedCategory,
                            );
                            _nameController.clear();
                            _descriptionController.clear();
                            _priceController.clear();
                            _stockController.clear();
                            selectedImage = null;
                            setState(() {
                              selectedImage = null;
                            });
                            _selectedCategory = listCategories[0];
                            _selectedStatus = 'Activo';
                          },
                          child: Obx(() {
                            return _productsController.isLoading.value ?
                              const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white
                                )
                              ):
                              Text('Save', style: GoogleFonts.poppins(
                                      fontSize: sizeWidth * 0.040,
                                      color: Colors.white
                                  ));
                          }),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  )
              )
            )
        );
    }

    Widget _buildImagePreview(dynamic image) {
      if (image is String) {
        return Image.network(image, width: 500, height: 500);
      } else if (image is File) {
        return Image.file(image, width: 500, height: 500);
      } else {
        return Container();
      }
    }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("From where do you want to take the photo?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: const Text("Gallery"),
                      onTap: () {
                        _openGallery(context);
                      },
                    ),
                    const Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: const Text("Camera"),
                      onTap: () {
                        _openCamera(context);
                      },
                    )
                  ],
                ),
              ));
        });
  }

  void _openGallery(BuildContext context) async {
    var picture = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(!context.mounted) return;
    setState(() {
      selectedImage = picture?.path;
    });
    Navigator.of(context).pop();
  }

  void _openCamera(BuildContext context) async {
    var picture = await ImagePicker().pickImage(source: ImageSource.camera);
    if(!context.mounted) return;
    setState(() {
      selectedImage = picture?.path;
    });
    Navigator.of(context).pop();
  }
    
}