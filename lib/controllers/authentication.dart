import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:system_app/constants/constans.dart';
import 'package:flutter/material.dart';
import '../views/home_page.dart';

class AuthenticationController extends GetxController {
    final isLoading = false.obs;
    final token = ''.obs;

    final box = GetStorage();

    Future register({
        required String name,
        required String lastName,
        required String username,
        required String email,
        required String password,
    }) async {
        try{
            isLoading.value = true;
            var data = {
                'name': name,
                'last_name': lastName,
                'username': username,
                'email': email,
                'password': password,
            };

            var response = await http.post(
                Uri.parse('${url}register'),
                headers: {
                    'accept': 'application/json',
                },
                body: data
            );

            if(response.statusCode == 201) {
                isLoading.value = false;
                var responseBody = json.decode(response.body);
                if (responseBody != null && responseBody['token'] != null) {
                    token.value = responseBody['token'];
                    box.write('token', token.value);
                    Get.offAll(() => const HomePage());
                }
            }else{
                isLoading.value = false;
                Get.snackbar(
                    'Error',
                    'Se ha producido un error al registrar el usuario, por favor verifique los datos ingresados',
                    backgroundColor: Colors.red[200],
                    colorText: Colors.white,
                    icon: const Icon(Icons.error, color: Colors.white),
                    duration: const Duration(seconds: 3),
                );
                // ignore: avoid_print
                print(json.decode(response.body));
            }
        } catch (e) {
            isLoading.value = false;
            // ignore: avoid_print
            print('Error during registration: $e');
            if (e is http.ClientException) {
                // ignore: avoid_print
                print('HTTP Client Exception: $e');
            }
        }
    }

    Future login({
        required String username,
        required String password,
    }) async {
        try {
            isLoading.value = true;
            var data = {
                'username': username,
                'password': password,
            };

            var response = await http.post(
                Uri.parse('${url}login'),
                headers: {
                'Accept': 'application/json',
                },
                body: data,
            );

            if (response.statusCode == 201) {
                isLoading.value = false;
                token.value = json.decode(response.body)['token'];
                box.write('token', token.value);
                Get.offAll(() => const HomePage());
            } else {
                isLoading.value = false;
                Get.snackbar(
                    'Error',
                    'Se ha producido un error al ingresar, por favor verifique los datos ingresados',
                    backgroundColor: Colors.red[200],
                    colorText: Colors.white,
                    icon: const Icon(Icons.error, color: Colors.white),
                    duration: const Duration(seconds: 3),
                );
                // ignore: avoid_print
                print(json.decode(response.body));
            }
        } catch (e) {
            isLoading.value = false;
            // ignore: avoid_print
            print('Error during Login: $e');
            if (e is http.ClientException) {
                // ignore: avoid_print
                print('HTTP Client Exception: $e');
            }
        }
    }




}