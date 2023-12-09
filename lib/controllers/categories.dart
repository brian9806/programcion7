import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:system_app/constants/constans.dart';
import 'package:get_storage/get_storage.dart';
import 'package:system_app/models/categories_model.dart';
import 'dart:convert';


class CategoriesController extends GetxController {
  Rx<List<CategoriesModel>> categories = Rx<List<CategoriesModel>>([]);
  final box = GetStorage();

  @override
  void onInit() async {
    super.onInit();
    try{
      categories.value.clear();
      var response = await http.get(
        Uri.parse('${url}categories'),
        headers: {
          'Accept': 'application/json',
        }
      );
      if(response.statusCode == 201){
        final content = json.decode(response.body)['categories'];
        for(var item in content){
          categories.value.add(CategoriesModel.fromJson(item));
        }
      }else{
        // ignore: avoid_print
        print(response.body);
      }
    }catch(e){
      //ignore: avoid_print
      print(e.toString());
    }
  }



}