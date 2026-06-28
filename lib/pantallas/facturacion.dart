import 'package:flutter/material.dart';
// Asegúrate de importar la pantalla de inicio
import 'inicio.dart';

class FacturacionPage extends StatelessWidget {
  final String selectedPlan;
  const FacturacionPage({super.key, required this.selectedPlan});

  @override
  Widget build(BuildContext context) {
    // Definimos el precio según el plan recibido
    String precioPlan = "\$799";
    if (selectedPlan.contains("1")) {
      precioPlan = "\$399";
    } else if (selectedPlan.contains("3")) {
      precioPlan = "\$999";
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // CORRECCIÓN: La flechita te regresa a la pantalla anterior (planes)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black), 
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Facturación", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Geist')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumen del paquete
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFFC7FFD1), borderRadius: BorderRadius.circular(16)),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.check, color: Color(0xFF025E45)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(selectedPlan, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Geist')),
                        const Text("facturación mensual", style: TextStyle(fontSize: 12, color: Color(0xFF025E45), fontFamily: 'Geist')),
                      ],
                    ),
                  ),
                  Text(precioPlan, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Geist')),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Formulario de Pago
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Datos de pago", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Geist')),
                  const SizedBox(height: 20),
                  _buildLabel("NOMBRE DEL TITULAR"),
                  _buildField("Como aparece en la tarjeta"),
                  _buildLabel("NÚMERO DE TARJETA"),
                  _buildField("4242 4242 4242 4242", icon: Icons.credit_card),
                  Row(
                    children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabel("VENCIMIENTO"), _buildField("MM / AA")])),
                      const SizedBox(width: 16),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabel("CVV"), _buildField("***")])),
                    ],
                  ),
                  _buildLabel("CALLE Y NÚMERO"),
                  _buildField("Av. Reforma 123, Int. 4"),
                  _buildLabel("CIUDAD"),
                  _buildField("Ciudad de México"),
                  Row(
                    children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabel("ESTADO"), _buildField("CDMX")])),
                      const SizedBox(width: 16),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildLabel("C.P."), _buildField("06600")])),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Botón Procesar Pago
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  // 1. Mostrar mensaje en la parte inferior
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Pago realizado exitosamente", 
                        style: TextStyle(fontFamily: 'Geist', fontWeight: FontWeight.bold)
                      ),
                      backgroundColor: Color(0xFF12AC6E),
                      duration: Duration(seconds: 2),
                    ),
                  );

                  // 2. Redirigir al inicio/dashboard
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const InicioPage()),
                  );
                },
                icon: const Icon(Icons.lock_outline, size: 20),
                label: Text("Procesar pago • $precioPlan", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Geist')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF60F16E),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Center(child: Text("🔒 Pago cifrado y seguro", style: TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'Geist'))),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8),
    child: Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, fontFamily: 'Geist')),
  );

  Widget _buildField(String hint, {IconData? icon}) => TextField(
    style: const TextStyle(fontFamily: 'Geist'),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontFamily: 'Geist', color: Colors.grey.shade400),
      prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
      filled: true,
      fillColor: const Color(0xFFF2F2F2).withOpacity(0.5),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );
}