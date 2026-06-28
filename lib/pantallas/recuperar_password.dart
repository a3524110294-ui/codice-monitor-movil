import 'package:flutter/material.dart';
import 'verificacion.dart';

class RecuperarPasswordPage extends StatefulWidget {
  const RecuperarPasswordPage({super.key});

  @override
  State<RecuperarPasswordPage> createState() => _RecuperarPasswordPageState();
}

class _RecuperarPasswordPageState extends State<RecuperarPasswordPage> {
  // Paleta de colores de tu diseño
  final Color kPrimaryGreen = const Color(0xFF60F16E);
  final Color kDarkText = const Color(0xFF141414);
  final Color kSecondaryText = const Color(0xFF737373);
  final Color kBorderColor = const Color(0xFFE5E5E5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // Flechita que lo manda de nuevo a la pantalla de login
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Recuperar acceso", 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Geist')
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Logo Códice
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Códice", 
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: kDarkText, fontFamily: 'Geist')
                  ),
                  Text(
                    "/", 
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: kPrimaryGreen, fontFamily: 'Geist')
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                "Recuperar Contraseña", 
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Geist')
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Ingresa tu correo y te enviaremos un código de 6 dígitos para verificar tu identidad.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kSecondaryText, fontSize: 16, fontFamily: 'Geist'),
                ),
              ),
              const SizedBox(height: 40),

              // Campo de correo
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 8, top: 16),
                child: const Text(
                  "CORREO ELECTRÓNICO", 
                  style: TextStyle(color: Color(0xFF737373), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Geist')
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: "fernando@gmail.com",
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontFamily: 'Geist'),
                  prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF737373)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), 
                    borderSide: const BorderSide(color: Color(0xFFE5E5E5))
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), 
                    borderSide: BorderSide(color: kPrimaryGreen, width: 2)
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              // Botón Enviar Código -> Lo manda a la pantalla de verificación
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const VerificacionCodigoPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryGreen,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    "Enviar código", 
                    style: TextStyle(color: Color(0xFF141414), fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Geist')
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              // Textos informativos de pie de página
              Row(
                children: [
                  Container(width: 4, height: 4, decoration: const BoxDecoration(color: Color(0xFF12AC6E), shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "El código de 6 dígitos expira en 10 minutos.",
                      style: TextStyle(color: Color(0xFF737373), fontFamily: 'Geist'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(width: 4, height: 4, decoration: const BoxDecoration(color: Color(0xFF12AC6E), shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "Revisa tu carpeta de spam si no lo recibes.",
                      style: TextStyle(color: Color(0xFF737373), fontFamily: 'Geist'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}