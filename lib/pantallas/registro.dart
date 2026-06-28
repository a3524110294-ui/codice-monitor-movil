import 'package:flutter/material.dart';
// Asegúrate de ajustar la ruta de importación si es diferente en tu proyecto
import 'package.dart'; 


class RegistroPage extends StatefulWidget {
  const RegistroPage({super.key});

  @override
  State<RegistroPage> createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  // Variables para controlar la visibilidad de las contraseñas
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  // Paleta de colores consistente
  final Color kPrimaryGreen = const Color(0xFF60F16E);
  final Color kDarkText = const Color(0xFF141414);
  final Color kSecondaryText = const Color(0xFF737373);
  final Color kBorderColor = const Color(0xFFE5E5E5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
              const SizedBox(height: 10),
              Text(
                "PASO 1 DE 2", 
                style: TextStyle(color: const Color(0xFF12AC6E), letterSpacing: 2, fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Geist')
              ),
              const SizedBox(height: 16),
              Text(
                "Crea tu cuenta para empezar a monitorear tus sitios.", 
                textAlign: TextAlign.center,
                style: TextStyle(color: kSecondaryText, fontSize: 16, fontFamily: 'Geist'),
              ),
              const SizedBox(height: 32),
              Text(
                "Crear Cuenta", 
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kDarkText, fontFamily: 'Geist')
              ),
              const SizedBox(height: 32),

              // Inputs del formulario
              _buildInputLabel("NOMBRE COMPLETO"),
              _buildTextField(hint: "Nombre y apellidos", icon: Icons.person_outline),
              
              _buildInputLabel("CORREO ELECTRÓNICO"),
              _buildTextField(hint: "tucorreo@empresa.com", icon: Icons.email_outlined),

              _buildInputLabel("CONTRASEÑA"),
              _buildTextField(
                hint: "Mínimo 8 caracteres", 
                icon: Icons.lock_outline, 
                isPassword: true,
                obscure: _obscurePassword,
                onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
              ),

              _buildInputLabel("CONFIRMAR CONTRASEÑA"),
              _buildTextField(
                hint: "Repite tu contraseña", 
                icon: Icons.lock_outline, 
                isPassword: true,
                obscure: _obscureConfirm,
                onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
              ),

              const SizedBox(height: 40),
              
              // Botón "Crear cuenta" -> Redirige a PackagePage (Planes)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PackagePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryGreen,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    "Crear cuenta", 
                    style: TextStyle(color: kDarkText, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Geist')
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Enlace para regresar al Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("¿Ya tienes cuenta? ", style: TextStyle(color: kSecondaryText, fontFamily: 'Geist')),
                  GestureDetector(
                    onTap: () {
                      // Regresa a la pantalla anterior (Login)
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Inicia sesión", 
                      style: TextStyle(
                        color: const Color(0xFF12AC6E), 
                        fontWeight: FontWeight.bold, 
                        fontFamily: 'Geist'
                      )
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(
        label, 
        style: TextStyle(color: kSecondaryText, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Geist')
      ),
    );
  }

  Widget _buildTextField({
    required String hint, 
    required IconData icon, 
    bool isPassword = false, 
    bool obscure = false, 
    VoidCallback? onToggle
  }) {
    return TextField(
      obscureText: obscure,
      style: const TextStyle(fontFamily: 'Geist'),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontFamily: 'Geist'),
        prefixIcon: Icon(icon, color: kSecondaryText),
        suffixIcon: isPassword 
            ? IconButton(
                icon: Icon(
                  // Si es true (oculto), muestra la rayita. Si es false (visible), quita la rayita.
                  obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: kSecondaryText,
                ),
                onPressed: onToggle,
              ) 
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), 
          borderSide: BorderSide(color: kBorderColor)
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), 
          borderSide: BorderSide(color: kPrimaryGreen, width: 2)
        ),
      ),
    );
  }
}