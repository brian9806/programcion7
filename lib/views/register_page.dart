import 'package:google_fonts/google_fonts.dart';
import 'package:system_app/controllers/authentication.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../widgets/input_widget.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
    const RegisterPage({super.key});
    
    @override
    State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _lastnameController = TextEditingController();
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
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
                                'Register Page',
                                style: GoogleFonts.poppins(
                                    fontSize: sizeWidth * 0.080,
                                )
                            ),
                            const SizedBox(height: 30),
                            InputWidget(
                                hintText: 'name',
                                obscureText: false,
                                icon: const Icon(Icons.person),
                                controller: _nameController
                            ),
                            const SizedBox(height: 30),
                            InputWidget(
                                hintText: 'lastname',
                                obscureText: false,
                                icon: const Icon(Icons.person),
                                controller: _lastnameController
                            ),
                            const SizedBox(height: 30),
                            InputWidget(
                                hintText: 'username',
                                obscureText: false,
                                icon: const Icon(Icons.person),
                                controller: _usernameController
                            ),
                            const SizedBox(height: 30),
                            InputWidget(
                                hintText: 'email',
                                obscureText: false,
                                icon: const Icon(Icons.email),
                                controller: _emailController
                            ),
                            const SizedBox(height: 30),
                            InputWidget(
                                hintText: 'password',
                                obscureText: true,
                                icon: const Icon(Icons.lock),
                                controller: _passwordController
                            ),
                            const SizedBox(height: 30),ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50,
                                        vertical: 15
                                    ),
                                ),
                                onPressed: () async {
                                    await _authenticationController.register(
                                        name: _nameController.text.trim(),
                                        lastName: _lastnameController.text.trim(),
                                        username: _usernameController.text.trim(),
                                        email: _emailController.text.trim(),
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
                                    : Text('Register', style: GoogleFonts.poppins(
                                        fontSize: sizeWidth * 0.040,
                                        color: Colors.white
                                    ));
                                }),
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                                onPressed: () {
                                    Get.to(() => const LoginPage());
                                },
                                child: Text(
                                    'Login', 
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