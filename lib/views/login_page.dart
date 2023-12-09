import 'package:google_fonts/google_fonts.dart';
import 'package:system_app/controllers/authentication.dart';
import 'package:flutter/material.dart';
import '../widgets/input_widget.dart';
import 'register_page.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
    const LoginPage({super.key});
    
    @override
    State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final AuthenticationController _authenticationController = Get.put(AuthenticationController());

    @override
    Widget build(BuildContext context) {
      var sizeWidth = MediaQuery.of(context).size.width;
      return Scaffold(
          body: Center(
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          Text(
                              'Login Page',
                              style: GoogleFonts.poppins(
                                  fontSize: sizeWidth * 0.080,
                              )
                          ),
                          const SizedBox(height: 30),
                          InputWidget(
                              hintText: 'Username',
                              obscureText: false,
                              icon: const Icon(Icons.person),
                              controller: _usernameController
                          ),
                          const SizedBox(height: 30),
                          InputWidget(
                              hintText: 'Password',
                              obscureText: true,
                              icon: const Icon(Icons.lock),
                              controller: _passwordController
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
                                  await _authenticationController.login(
                                      username: _usernameController.text.trim(),
                                      password: _passwordController.text.trim()
                                  );
                              },
                              child: Obx((){
                                  return _authenticationController.isLoading.value ?
                                      const Center(
                                          child: CircularProgressIndicator(
                                              color: Colors.white
                                          ),
                                      )
                                      :Text('Login', style: GoogleFonts.poppins(
                                      fontSize: sizeWidth * 0.040,
                                      color: Colors.white
                                  ));
                              }),
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                              onPressed: () {
                                  Get.to(() => const RegisterPage());
                              },
                              child: Text(
                                  'Register', 
                                  style: GoogleFonts.poppins(
                                      fontSize: sizeWidth * 0.040,
                                      color: Colors.black
                                  ),
                              ),
                          ),
                      ],
                  )
              ),
          ),
      );
    }
}