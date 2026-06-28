import 'package:flutter/material.dart';

class VerificacionCodigoPage extends StatelessWidget {
  const VerificacionCodigoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // La flechita de esta pantalla lo redirige a la pantalla de recuperación
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Verificación", 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Geist')
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Icono de sobre en contenedor verde claro
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color(0xFFC7FFD1), 
                  shape: BoxShape.circle
                ),
                child: const Icon(Icons.mail_outline, size: 48, color: Color(0xFF025E45)),
              ),
              const SizedBox(height: 32),
              const Text(
                "Ingresa el código", 
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Geist')
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Enviamos un código de 6 dígitos a fernando@gmail.com",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF737373), fontSize: 16, fontFamily: 'Geist'),
                ),
              ),
              const SizedBox(height: 40),

              // Campos numéricos con el mismo borde para todos los cuadros
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) => SizedBox(
                  width: 48,
                  height: 64,
                  child: TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Geist'),
                    decoration: InputDecoration(
                      counterText: "",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFE5E5E5), // Borde uniforme en todos los cuadros
                          width: 1.0
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF60F16E), width: 2),
                      ),
                    ),
                  ),
                )),
              ),

              const SizedBox(height: 40),
              // Botón de restablecer contraseña (lo manda al login)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Al darle al botón, regresa hasta la pantalla de login inicial
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF60F16E),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    "Verificar código", 
                    style: TextStyle(color: Color(0xFF141414), fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Geist')
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("¿No recibiste el código? ", style: TextStyle(color: Color(0xFF737373), fontFamily: 'Geist')),
                  GestureDetector(
                    onTap: () {
                      // Acción de reenvío
                    },
                    child: const Text(
                      "Reenviar", 
                      style: TextStyle(color: Color(0xFF12AC6E), fontWeight: FontWeight.bold, fontFamily: 'Geist')
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