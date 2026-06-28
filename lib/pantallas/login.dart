import 'package:flutter/material.dart';
import 'registro.dart';
import 'recuperar_password.dart';
import 'inicio.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Definición de la paleta de colores del diseño
  static const Color primaryGreen = Color(0xFF12AC6E);
  static const Color lightGreenButton = Color(0xFF60F16E); // Opcional para acentos
  static const Color textPrimary = Color(0xFF141414);
  static const Color textSecondary = Color(0xFF737373);
  static const Color inputBackground = Color(0xFFE5E5E5);

  // Controladores para los campos de texto
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Clave para validar el formulario
  final _formKey = GlobalKey<FormState>();

  // Estado para ocultar/mostrar la contraseña
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // LÓGICA DE INICIO DE SESIÓN AQUÍ
      // Por ejemplo, llamar a tu servicio de Firebase Auth o API
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Iniciando sesión...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // --- LOGO / TÍTULO ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Códice',
                        style: TextStyle(
                          fontFamily: 'Geist',
                          fontSize: 42,
                          fontWeight: FontWeight.w700, // Bold
                          color: textPrimary,
                        ),
                      ),
                      Text(
                        '/',
                        style: TextStyle(
                          fontFamily: 'Geist',
                          fontSize: 42,
                          fontWeight: FontWeight.w700,
                          color: primaryGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // --- SUBTÍTULO ---
                  const Text(
                    'Ingresa tus credenciales para acceder a tu panel de monitoreo.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Geist',
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: textSecondary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // --- CAMPO: CORREO ELECTRÓNICO ---
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'CORREO ELECTRÓNICO',
                      style: TextStyle(
                        fontFamily: 'GeistMono',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                      fontFamily: 'GeistMono',
                      fontSize: 14,
                      color: textPrimary,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.mail_outline, color: textSecondary),
                      hintText: 'fernando@gmail.com',
                      hintStyle: const TextStyle(color: textSecondary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: inputBackground, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: inputBackground, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: primaryGreen, width: 2.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu correo';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Ingresa un correo válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // --- CAMPO: CONTRASEÑA ---
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'CONTRASEÑA',
                      style: TextStyle(
                        fontFamily: 'GeistMono',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(
                      fontFamily: 'GeistMono',
                      fontSize: 14,
                      color: textPrimary,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.lock_outline, color: textSecondary),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: inputBackground, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: inputBackground, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: primaryGreen, width: 2.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu contraseña';
                      }
                      if (value.length < 6) {
                        return 'Debe tener al menos 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // --- ENLACE: OLVIDASTE TU CONTRASEÑA ---
                  GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RecuperarPasswordPage()),
    );
  },
  child: const Text(
    '¿Olvidaste tu contraseña?',
    style: TextStyle(
      fontFamily: 'Geist',
      color: Color(0xFF12AC6E), // O el color de tu variable
      fontWeight: FontWeight.w600,
    ),
  ),
),
                  const SizedBox(height: 32),

                  // --- BOTÓN: INICIAR SESIÓN ---
                  SizedBox(
  width: double.infinity,
  height: 52,
  child: ElevatedButton(
    onPressed: () {
      // Validaciones opcionales de tus campos de texto aquí...
      
      // Navegación a inicio.dart reemplazando la pantalla actual
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const InicioPage()), // Reemplaza 'InicioPage()' por el nombre de la clase de tu pantalla de inicio
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF60F16E),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    child: const Text(
      "Iniciar sesión", 
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Geist', fontSize: 16)
    ),
  ),
),
                  const SizedBox(height: 32),
// --- ENLACE: CREAR CUENTA ---
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const Text(
      '¿No tienes cuenta? ',
      style: TextStyle(
        fontFamily: 'Geist',
        fontSize: 14,
        color: textSecondary,
      ),
    ),
    GestureDetector(
      onTap: () {
        // AQUÍ ESTÁ LA CONEXIÓN: Abre la pantalla de Registro
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RegistroPage(), // Asegúrate de importar 'registro.dart' arriba
          ),
        );
      },
      child: const Text(
        'Crea una',
        style: TextStyle(
          fontFamily: 'Geist',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: primaryGreen,
        ),
      ),
    ),
  ],
),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}