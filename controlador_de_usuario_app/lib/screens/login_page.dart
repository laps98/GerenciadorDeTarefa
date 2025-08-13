import 'package:controlador_de_usuario_app/dialogs/loading_dialog.dart';
import 'package:controlador_de_usuario_app/helpers/future_helper.dart';
import 'package:controlador_de_usuario_app/main.dart';
import 'package:controlador_de_usuario_app/models/login_request.dart';
import 'package:controlador_de_usuario_app/screens/task_page.dart';
import 'package:controlador_de_usuario_app/services/conta_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget{
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
  LoginRequest usuario = LoginRequest();
  var service = ContaService();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Seja bem-vindo',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Color(0xFF1C1C1C),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Faça o login para continuar',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: Color(0xFF1C1C1C),
                ),
              ),
              const SizedBox(height: 26),
              TextField(
                controller: usuario.login,
                decoration: const InputDecoration(
                  labelText: 'Login',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: usuario.senha,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 26),
              SizedBox(
                width: double.infinity,
                height: 49,
                child: ElevatedButton(
                  onPressed: () {
                    LoadingDialog.show(context: context, mensagem: 'Realizando login');

                    service.logar(usuario).whenComplete(() {
                      if (!context.mounted) return;

                      Navigator.of(context).pop();
                    }).then((value) {
                      if (!context.mounted) return;

                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Home()), (route) => false);

                    }).handleError(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B62FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              // Center(
              //   child: Text(
              //     'Forgot Password?',
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //       fontSize: 14,
              //       color: Color(0xFF87879D),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 10),
              // Center(
              //   child: Text(
              //     "Don't have an account? Sign Up",
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //       fontFamily: 'Poppins',
              //       fontSize: 14,
              //       color: Color(0xFF87879D),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}