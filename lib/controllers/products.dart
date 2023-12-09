import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:system_app/views/product_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:system_app/constants/constans.dart';

class ProductsController extends GetxController {
  final isLoading = false.obs;
  final box = GetStorage();
  final productsList = <dynamic>[].obs;
  final productsAll = <dynamic>[].obs;
  var currentProduct = {}.obs;

  Future newProduct({
    required String name,
    required String description,
    required double price,
    required int stock,
    required String category,
    required XFile image,
    required String status,
  }) async {
    isLoading.value = true;
    var getIdCategory = 0;

    var response = await http.get(
      Uri.parse('${url}categories'),
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      final content = json.decode(response.body)['categories'];
      content.forEach((item) {
        if (item['name'] == category) {
          getIdCategory = item['id'];
        }
      });
    }

    if (getIdCategory == 0) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'La categoria no se encuentra registrada',
        backgroundColor: Colors.red[200],
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
    } else {
      var imageBytes = await image.readAsBytes(); // Convierte XFile a bytes

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${url}products'),
      );

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer ${box.read('token')}',
      });

      request.fields.addAll({
        'name': name,
        'description': description,
        'price': double.parse(price.toString()).toString(),
        'stock': int.parse(stock.toString()).toString(),
        'category_id': getIdCategory.toString(),
        'status': status,
      });

      request.files.add(http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'product_image.jpg',
      ));

      try {
        var response = await request.send();
        if (response.statusCode == 201) {
          isLoading.value = false;
          Get.offAll(() => const ProductsPage());
        } else {
          isLoading.value = false;
          Get.snackbar(
            'Error',
            'Se ha producido un error al registrar el producto, por favor verifique los datos ingresados',
            backgroundColor: Colors.red[200],
            colorText: Colors.white,
            icon: const Icon(Icons.error, color: Colors.white),
            duration: const Duration(seconds: 3),
          );
          // ignore: avoid_print
          print(await response.stream.bytesToString());
        }
      } catch (e) {
        // ignore: avoid_print
        print('Error: $e');
      }
    }
  }

  Future<List<dynamic>> getAllProducts() async {
    try {
      var response = await http.get(
        Uri.parse('${url}products'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        var products = json.decode(response.body)['data'];
        productsAll.assignAll(products ?? []);
      }else{
        isLoading.value = false;
        Get.snackbar(
          'Error',
          'Error al obtener los productos',
          backgroundColor: Colors.red[200],
          colorText: Colors.white,
          icon: const Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 3),
        );
        return [];
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
    }
    return productsAll;
  }

  Future<List<dynamic>> getMyProducts() async {
    try {
      var response = await http.get(
        Uri.parse('${url}my-products'), 
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
      );

      if (response.statusCode == 201) {
        var products = json.decode(response.body)['data'];
        isLoading.value = false;
        productsList.assignAll(products ?? []);
      } else {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          'Error al obtener los productos',
          backgroundColor: Colors.red[200],
          colorText: Colors.white,
          icon: const Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 3),
        );
        return [];
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
      isLoading.value = false;
      return [];
    }

    return productsList;
  }

  Future<void> deleteProduct(int productId) async {
    try {
      isLoading.value = true;

      var response = await http.delete(
        Uri.parse('${url}my-product/$productId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
      );

      if (response.statusCode == 201) {
        isLoading.value = false;
        productsList.removeWhere((product) => product['id'] == productId);
        productsList.refresh();
        Get.snackbar(
          'Éxito',
          'Producto eliminado exitosamente',
          backgroundColor: Colors.green[200],
          colorText: Colors.white,
          icon: const Icon(Icons.check, color: Colors.white),
          duration: const Duration(seconds: 3),
        );
      } else {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          'Error al eliminar el producto',
          backgroundColor: Colors.red[200],
          colorText: Colors.white,
          icon: const Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 3),
        );
        // ignore: avoid_print
        //print(await response.stream.bytesToString()); 
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
      isLoading.value = false;
    }
  }

  Future<void> editProduct({
    required int productId,
    required String name,
    required String description,
    required double price,
    required int stock,
    required String category,
    required XFile? newImage, // Opcional: Imagen nueva para actualizar
    required String status,
  }) async {
    try {
      isLoading.value = true;
      var getIdCategory = 0;

      var response = await http.get(
        Uri.parse('${url}categories'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        final content = json.decode(response.body)['categories'];
        content.forEach((item) {
          if (item['name'] == category) {
            getIdCategory = item['id'];
          }
        });
      }

      if (getIdCategory == 0) {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          'La categoría no se encuentra registrada',
          backgroundColor: Colors.red[200],
          colorText: Colors.white,
          icon: const Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 3),
        );
      } else {
        var request = http.MultipartRequest(
          'PUT',
          Uri.parse('${url}my-product/$productId'),
        );

        request.headers.addAll({
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        });

        request.fields.addAll({
          'name': name,
          'description': description,
          'price': double.parse(price.toString()).toString(),
          'stock': int.parse(stock.toString()).toString(),
          'category_id': getIdCategory.toString(),
          'status': status,
        });

        if (newImage != null) {
          var imageBytes = await newImage.readAsBytes();
          request.files.add(http.MultipartFile.fromBytes(
            'image',
            imageBytes,
            filename: 'product_image.jpg',
          ));
        }

        var response = await request.send();
        if (response.statusCode == 200) {
          isLoading.value = false;
          Get.snackbar(
            'Éxito',
            'Producto actualizado exitosamente',
            backgroundColor: Colors.green[200],
            colorText: Colors.white,
            icon: const Icon(Icons.check, color: Colors.white),
            duration: const Duration(seconds: 3),
          );
          await getMyProducts();
          Get.offAll(() => const ProductsPage());
        } else {
          isLoading.value = false;
          Get.snackbar(
            'Error',
            'Se ha producido un error al actualizar el producto, por favor verifique los datos ingresados',
            backgroundColor: Colors.red[200],
            colorText: Colors.white,
            icon: const Icon(Icons.error, color: Colors.white),
            duration: const Duration(seconds: 3),
          );
          // ignore: avoid_print
          print(await response.stream.bytesToString());
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
      isLoading.value = false;
    }
  }

  Future<void> fetchProductDetailsById(int productId) async {
    try {
      isLoading.value = true;

      var response = await http.get(
        Uri.parse('${url}my-product/$productId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${box.read('token')}',
        },
      );

      if (response.statusCode == 201) {
        currentProduct.assignAll(json.decode(response.body));
        isLoading.value = false;
      } else {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          'Error al obtener los detalles del producto',
          backgroundColor: Colors.red[200],
          colorText: Colors.white,
          icon: const Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
      isLoading.value = false;
    }
  }




}
