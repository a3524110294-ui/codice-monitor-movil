import 'package:flutter/material.dart';
// Asegúrate de ajustar las rutas de importación si es diferente en tu proyecto
import 'facturacion.dart';
import 'inicio.dart'; 

class PackagePage extends StatelessWidget {
  const PackagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2), // Fondo F2F2F2 del Figma
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Mini Logo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Códice", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Geist')),
                  Text("/", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF60F16E), fontFamily: 'Geist')),
                ],
              ),
              const SizedBox(height: 8),
              Text("BIENVENIDO  •  PASO 2 DE 2", style: TextStyle(color: const Color(0xFF12AC6E), fontWeight: FontWeight.bold, fontSize: 10, fontFamily: 'Geist')),
              const SizedBox(height: 16),
              Text("Selecciona tu plan para comenzar", textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'Geist')),
              const SizedBox(height: 12),
              Text("Elige el paquete que se ajuste a la cantidad de sitios que necesitas monitorear.", 
                textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600, fontSize: 14, fontFamily: 'Geist')),
              const SizedBox(height: 32),

              _buildPlanCard(
                context,
                title: "Paquete 1",
                subtitle: "INICIAL",
                price: "399",
                features: ["1 sitio disponible", "Monitoreo cada 5 min", "Alertas por correo"],
              ),
              const SizedBox(height: 16),
              _buildPlanCard(
                context,
                title: "Paquete 2",
                subtitle: "RECOMENDADO",
                price: "799",
                isRecommended: true,
                features: ["5 sitios disponibles", "Monitoreo cada 1 min", "Alertas SMS + correo", "Reportes semanales"],
              ),
              const SizedBox(height: 16),
              _buildPlanCard(
                context,
                title: "Paquete 3",
                subtitle: "EMPRESARIAL",
                price: "999",
                features: ["Sitios ilimitados", "Monitoreo en tiempo real", "Soporte prioritario 24/7"],
              ),
              
              const SizedBox(height: 32),
              const Divider(color: Colors.grey),
              const SizedBox(height: 16),
              
              // Botón Prueba Gratuita -> Redirige directo a inicio.dart (Dashboard)
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const InicioPage()),
                  );
                },
                icon: const Icon(Icons.timer_outlined, color: Color(0xFF025E45)),
                label: const Text(
                  "Iniciar prueba gratuita de 7 días", 
                  style: TextStyle(color: Color(0xFF025E45), fontWeight: FontWeight.bold, fontFamily: 'Geist')
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  side: const BorderSide(color: Color(0xFF60F16E)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              Text("Sin tarjeta de crédito • puedes elegir un paquete más adelante", style: TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'Geist')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required String title, 
    required String subtitle, 
    required String price, 
    required List<String> features, 
    bool isRecommended = false
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isRecommended ? Border.all(color: const Color(0xFF60F16E), width: 2) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Geist')),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500, letterSpacing: 1, fontFamily: 'Geist')),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("\$$price", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Geist')),
                  const Text("/mes", style: TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Geist')),
                ],
              )
            ],
          ),
        const SizedBox(height: 20),
        ...features.map((f) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(children: [
            const Icon(Icons.check, color: Color(0xFF60F16E), size: 18),
            const SizedBox(width: 10),
            Text(f, style: const TextStyle(color: Color(0xFF737373), fontFamily: 'Geist')),
          ]),
        )).toList(),
        const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              // CORRECCIÓN: Al pulsar el paquete, abre FacturacionPage pasándole el título del plan
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FacturacionPage(selectedPlan: title),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isRecommended ? const Color(0xFF60F16E) : Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
                side: const BorderSide(color: Color(0xFFE5E5E5)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text("Elegir $title", style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Geist')),
            ),
          )
        ],
      ),
    );
  }
}