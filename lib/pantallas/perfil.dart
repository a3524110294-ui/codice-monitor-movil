import 'package:flutter/material.dart';
import 'historial.dart';
import 'login.dart';
import 'reporte.dart';
import 'equipo.dart';
import 'inicio.dart';

// =========================================================================
// 1. PANTALLA PRINCIPAL: PERFIL (perfil.dart)
// =========================================================================
class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  // Controladores de Texto para Datos del Perfil
  final TextEditingController _nombreController = TextEditingController(
    text: 'Fernando Hernández Flores',
  );
  final TextEditingController _correoController = TextEditingController(
    text: 'fernando@gmail.com',
  );
  final TextEditingController _organizacionController = TextEditingController(
    text: 'Códice',
  );
  String _rolSeleccionado = 'Administrador';

  // Controladores para Preferencias de Alertas (Inician vacíos / apagados)
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _correoAdicionalController =
      TextEditingController();

  bool _alertaCaidasCriticas = false;
  bool _alertaLatenciaElevada = false;
  bool _alertaResumenSemanal = false;
  bool _alertaCertificadosVencer = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF4F4F5),
      body: SafeArea(
        child: Column(
          children: [
            // ÁREA SCROLLABLE DE CONFIGURACIONES
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 120.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CABECERA: AVATAR, NOMBRE Y ACCIONES SUPERIORES
                    _buildSeccionEncabezadoUser(context),
                    const SizedBox(height: 16),

                    // FORMULARIO: INFORMACIÓN PERSONAL DEL USUARIO
                    _buildCardContenedor(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabelFormulario('NOMBRE COMPLETO'),
                          const SizedBox(height: 6),
                          _buildTextField(_nombreController, null, 'Tu nombre'),
                          const SizedBox(height: 16),

                          _buildLabelFormulario('CORREO ELECTRÓNICO'),
                          const SizedBox(height: 6),
                          _buildTextField(
                            _correoController,
                            null,
                            'correo@ejemplo.com',
                          ),
                          const SizedBox(height: 16),

                          _buildLabelFormulario('ROL O PERMISOS'),
                          const SizedBox(height: 6),
                          _buildDropdownRoles(),
                          const SizedBox(height: 16),

                          _buildLabelFormulario('EMPRESA / ORGANIZACIÓN'),
                          const SizedBox(height: 6),
                          _buildTextField(
                            _organizacionController,
                            null,
                            'Nombre de empresa',
                          ),
                          const SizedBox(height: 24),

                          _buildBotondeAccion(
                            texto: 'Guardar cambios',
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Información de perfil actualizada',
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // FORMULARIO: PREFERENCIAS DE ALERTAS
                    _buildCardContenedor(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Preferencias de\nAlertas',
                                style: TextStyle(
                                  fontFamily: 'GeistMono',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF141414),
                                  height: 1.2,
                                ),
                              ),
                              Text(
                                'notificaciones'.toLowerCase(),
                                style: const TextStyle(
                                  fontFamily: 'GeistMono',
                                  fontSize: 11,
                                  color: Color(0xFFA3A3A3),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          _buildLabelFormulario('NÚMERO DE TELÉFONO (SMS)'),
                          const SizedBox(height: 6),
                          _buildTextField(
                            _telefonoController,
                            Icons.phone_outlined,
                            '+52  55  1234  5678',
                          ),
                          const SizedBox(height: 16),

                          _buildLabelFormulario(
                            'CORREOS ADICIONALES PARA NOTIFICACIONES',
                          ),
                          const SizedBox(height: 6),
                          _buildTextField(
                            _correoAdicionalController,
                            Icons.mail_outline_rounded,
                            'alertas@tuempresa.com',
                          ),
                          const SizedBox(height: 20),

                          // LISTA DE SWITCHES DE CONTROL DE ALERTAS
                          _buildSwitchRow(
                            titulo: 'Caídas críticas',
                            subtitulo: 'Aviso inmediato por SMS y correo',
                            valor: _alertaCaidasCriticas,
                            onChanged: (val) =>
                                setState(() => _alertaCaidasCriticas = val),
                          ),
                          const Divider(color: Color(0xFFE5E5E5), height: 24),
                          _buildSwitchRow(
                            titulo: 'Latencia elevada',
                            subtitulo: 'Cuando un sitio responde lento',
                            valor: _alertaLatenciaElevada,
                            onChanged: (val) =>
                                setState(() => _alertaLatenciaElevada = val),
                          ),
                          const Divider(color: Color(0xFFE5E5E5), height: 24),
                          _buildSwitchRow(
                            titulo: 'Resumen semanal',
                            subtitulo: 'Reporte de uptime cada lunes',
                            valor: _alertaResumenSemanal,
                            onChanged: (val) =>
                                setState(() => _alertaResumenSemanal = val),
                          ),
                          const Divider(color: Color(0xFFE5E5E5), height: 24),
                          _buildSwitchRow(
                            titulo: 'Certificados SSL por vencer',
                            subtitulo: 'Aviso 15 días antes',
                            valor: _alertaCertificadosVencer,
                            onChanged: (val) =>
                                setState(() => _alertaCertificadosVencer = val),
                          ),
                          const SizedBox(height: 24),

                          _buildBotondeAccion(
                            texto: 'Guardar preferencias',
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Preferencias de notificación guardadas',
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
                                    ),
                                    (route) => false,
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(
                                    color: Color(0xFFFF4B4B),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                                child: const Text(
                                  'Cerrar sesión',
                                  style: TextStyle(
                                    color: Color(0xFFFF4B4B),
                                    fontFamily: 'GeistMono',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: const MenuNavegacionGlobal(paginaActual: 4),
    );
  }

  // ENCABEZADO DEL PERFIL CON FOTO Y ACCIONES RÁPIDAS (CAMBIAR PASS / COMPRAS)
  Widget _buildSeccionEncabezadoUser(BuildContext context) {
    return _buildCardContenedor(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.person_outline,
                  size: 28,
                  color: Color(0xFF737373),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _nombreController.text,
                      style: const TextStyle(
                        fontFamily: 'GeistMono',
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Color(0xFF141414),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Text(
                          'Rol  ·  ',
                          style: TextStyle(
                            fontFamily: 'GeistMono',
                            fontSize: 12,
                            color: Color(0xFFA3A3A3),
                          ),
                        ),
                        Text(
                          _rolSeleccionado,
                          style: const TextStyle(
                            fontFamily: 'GeistMono',
                            fontSize: 12,
                            color: Color(0xFF737373),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CambiarContrasenaPage(),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE5E5E5)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Cambiar\ncontraseña',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'GeistMono',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF141414),
                      height: 1.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PlanesDePagoPage()),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE5E5E5)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    size: 16,
                    color: Color(0xFF141414),
                  ),
                  label: const Text(
                    'Compras',
                    style: TextStyle(
                      fontFamily: 'GeistMono',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF141414),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // CONSTRUCTORES DE ELEMENTOS DE DISEÑO COHESIVOS
  Widget _buildCardContenedor({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: child,
    );
  }

  Widget _buildLabelFormulario(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 10,
        fontFamily: 'GeistMono',
        color: Color(0xFF737373),
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    IconData? icono,
    String placeholder,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontFamily: 'GeistMono',
          fontSize: 14,
          color: Color(0xFF141414),
        ),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: const TextStyle(color: Color(0xFFA3A3A3), fontSize: 13),
          prefixIcon: icono != null
              ? Icon(icono, color: const Color(0xFFA3A3A3), size: 18)
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownRoles() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _rolSeleccionado,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF737373)),
          items: ['Administrador', 'Moderador', 'Cliente'].map((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(
                val,
                style: const TextStyle(
                  fontFamily: 'GeistMono',
                  fontSize: 14,
                  color: Color(0xFF141414),
                ),
              ),
            );
          }).toList(),
          onChanged: (val) => setState(() => _rolSeleccionado = val!),
        ),
      ),
    );
  }

  Widget _buildSwitchRow({
    required String titulo,
    required String subtitulo,
    required bool valor,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontFamily: 'GeistMono',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF141414),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitulo,
                style: const TextStyle(
                  fontFamily: 'GeistMono',
                  fontSize: 11,
                  color: Color(0xFF737373),
                ),
              ),
            ],
          ),
        ),
        Switch.adaptive(
          value: valor,
          activeColor: Colors.white,
          activeTrackColor: const Color(0xFF12AC6E),
          inactiveTrackColor: const Color(0xFFE5E5E5),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildBotondeAccion({
    required String texto,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3DF27D),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          texto,
          style: const TextStyle(
            fontFamily: 'GeistMono',
            color: Color(0xFF141414),
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// =========================================================================
// 2. PANTALLA: CAMBIAR CONTRASEÑA (cambiar_contrasena.dart)
// =========================================================================
class CambiarContrasenaPage extends StatefulWidget {
  const CambiarContrasenaPage({super.key});

  @override
  State<CambiarContrasenaPage> createState() => _CambiarContrasenaPageState();
}

class _CambiarContrasenaPageState extends State<CambiarContrasenaPage> {
  late FocusNode _actualFocusNode;
  late FocusNode _nuevaFocusNode;
  late FocusNode _confirmFocusNode;

  @override
  void initState() {
    super.initState();
    _actualFocusNode = FocusNode();
    _nuevaFocusNode = FocusNode();
    _confirmFocusNode = FocusNode();

    _actualFocusNode.addListener(() => setState(() {}));
    _nuevaFocusNode.addListener(() => setState(() {}));
    _confirmFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _actualFocusNode.dispose();
    _nuevaFocusNode.dispose();
    _confirmFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE5E5E5)),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 16,
                    color: Color(0xFF141414),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(18.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE5E5E5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Para proteger tu cuenta, ingresa tu contraseña actual antes de definir una nueva.',
                      style: TextStyle(
                        fontFamily: 'GeistMono',
                        fontSize: 12,
                        color: Color(0xFF737373),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildInputBloque('CONTRASEÑA ACTUAL', _actualFocusNode),
                    const SizedBox(height: 16),
                    _buildInputBloque('NUEVA CONTRASEÑA', _nuevaFocusNode),
                    const SizedBox(height: 16),
                    _buildInputBloque(
                      'CONFIRMAR NUEVA CONTRASEÑA',
                      _confirmFocusNode,
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      children: [
                        Text(
                          '– ',
                          style: TextStyle(
                            color: Color(0xFF12AC6E),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Mínimo 8 caracteres con letras y números.',
                          style: TextStyle(
                            fontFamily: 'GeistMono',
                            fontSize: 11,
                            color: Color(0xFF737373),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style:
                            ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3DF27D),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ).copyWith(
                              overlayColor: MaterialStateProperty.all(
                                Colors.transparent,
                              ),
                            ),
                        child: const Text(
                          'Actualizar contraseña',
                          style: TextStyle(
                            fontFamily: 'GeistMono',
                            color: Color(0xFF141414),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputBloque(String label, FocusNode focusNode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontFamily: 'GeistMono',
            color: Color(0xFF737373),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: focusNode.hasFocus
                  ? const Color(0xFF3DF27D)
                  : const Color(0xFFE5E5E5),
              width: focusNode.hasFocus ? 1.5 : 1,
            ),
          ),
          child: TextField(
            focusNode: focusNode,
            obscureText: true,
            style: const TextStyle(fontFamily: 'GeistMono', fontSize: 14),
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.lock_outline_rounded,
                color: Color(0xFFA3A3A3),
                size: 18,
              ),
              suffixIcon: Icon(
                Icons.visibility_outlined,
                color: Color(0xFFA3A3A3),
                size: 18,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}

// =========================================================================
// 3. PANTALLA: PLANES DE PAGO / COMPRAS (planes_de_pago.dart)
// =========================================================================
class PlanesDePagoPage extends StatelessWidget {
  const PlanesDePagoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E5E5)),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 16,
                        color: Color(0xFF141414),
                      ),
                    ),
                  ),
                  const Text(
                    'Planes de pago',
                    style: TextStyle(
                      fontFamily: 'GeistMono',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF141414),
                    ),
                  ),
                  const SizedBox(width: 38), // Balance visual
                ],
              ),
              const SizedBox(height: 14),
              // BANNER DE MODO PRUEBA
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 14,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFC7FFD1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.watch_later_outlined,
                      size: 16,
                      color: Color(0xFF025E45),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Modo prueba — 7 días restantes',
                      style: TextStyle(
                        fontFamily: 'GeistMono',
                        fontSize: 12,
                        color: Color(0xFF025E45),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // CONTENIDO SCROLLABLE DE LOS PAQUETES
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildCardPaquete(context, 'Paquete 1', 'INICIAL', '399', [
                      '1 sitio disponible',
                      'Monitorea cada 5 min',
                      'Alertas por correo',
                    ], false),
                    _buildCardPaquete(
                      context,
                      'Paquete 2',
                      'RECOMENDADO',
                      '799',
                      [
                        '5 sitios disponibles',
                        'Monitorea cada 1 min',
                        'Alertas SMS + correo',
                        'Reportes semanales',
                      ],
                      true,
                    ),
                    _buildCardPaquete(
                      context,
                      'Paquete 3',
                      'EMPRESARIAL',
                      '999',
                      [
                        'Sitios ilimitados',
                        'Monitoreo en tiempo real',
                        'Soporte prioritario 24/7',
                      ],
                      false,
                    ),

                    const SizedBox(height: 10),
                    // BOTÓN IR AL HISTORIAL
                    OutlinedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HistorialComprasPage(),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFFE5E5E5)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(
                        Icons.assignment_outlined,
                        size: 16,
                        color: Color(0xFF141414),
                      ),
                      label: const Text(
                        'Ver historial de compras',
                        style: TextStyle(
                          fontFamily: 'GeistMono',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF141414),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardPaquete(
    BuildContext context,
    String titulo,
    String tag,
    String precio,
    List<String> caracteristicas,
    bool isFeatured,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isFeatured ? const Color(0xFF12AC6E) : const Color(0xFFE5E5E5),
          width: isFeatured ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontFamily: 'GeistMono',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF141414),
                    ),
                  ),
                  Text(
                    tag,
                    style: const TextStyle(
                      fontFamily: 'GeistMono',
                      fontSize: 10,
                      color: Color(0xFFA3A3A3),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '\$$precio',
                    style: const TextStyle(
                      fontFamily: 'GeistMono',
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: Color(0xFF141414),
                    ),
                  ),
                  const Text(
                    '/mes',
                    style: const TextStyle(
                      fontFamily: 'GeistMono',
                      fontSize: 11,
                      color: Color(0xFF737373),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...caracteristicas.map(
            (feat) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  const Icon(Icons.check, size: 14, color: Color(0xFF12AC6E)),
                  const SizedBox(width: 8),
                  Text(
                    feat,
                    style: const TextStyle(
                      fontFamily: 'GeistMono',
                      fontSize: 12,
                      color: Color(0xFF141414),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FacturacionPage()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isFeatured
                    ? const Color(0xFF3DF27D)
                    : Colors.white,
                elevation: 0,
                side: isFeatured
                    ? null
                    : const BorderSide(color: Color(0xFFE5E5E5)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Comprar paquete',
                style: TextStyle(
                  fontFamily: 'GeistMono',
                  color: const Color(0xFF141414),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// 4. PANTALLA: FACTURACIÓN (facturacion.dart)
// =========================================================================
class FacturacionPage extends StatelessWidget {
  const FacturacionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE5E5E5)),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 16,
                    color: Color(0xFF141414),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFC7FFD1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Paquete 2 · Recomendado',
                          style: TextStyle(
                            fontFamily: 'GeistMono',
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF025E45),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '5 sitios · facturación mensual',
                          style: TextStyle(
                            fontFamily: 'GeistMono',
                            fontSize: 11,
                            color: Color(0xFF025E45),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '\$799',
                      style: TextStyle(
                        fontFamily: 'GeistMono',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF025E45),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE5E5E5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Datos de pago',
                      style: TextStyle(
                        fontFamily: 'GeistMono',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF141414),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildLabelField('NOMBRE DEL TITULAR'),
                    _buildFormInput('Como aparece en la tarjeta'),
                    _buildLabelField('NÚMERO DE TARJETA'),
                    _buildFormInput(
                      '4242 4242 4242 4242',
                      icon: Icons.credit_card_outlined,
                      isGreenBorder: true,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabelField('VENCIMIENTO'),
                              _buildFormInput('MM / AA'),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabelField('CVV'),
                              _buildFormInput('···'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    _buildLabelField('CALLE Y NÚMERO'),
                    _buildFormInput('Av. Reforma 123, Int. 4'),
                    _buildLabelField('CIUDAD'),
                    _buildFormInput('Ciudad de México'),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabelField('ESTADO / PROVINCIA'),
                              _buildFormInput('CDMX'),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabelField('CÓDIGO POSTAL'),
                              _buildFormInput('06600'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Procesando pago...')),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3DF27D),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(
                    Icons.lock_outline_rounded,
                    size: 16,
                    color: Color(0xFF141414),
                  ),
                  label: const Text(
                    'Procesar pago · \$799',
                    style: TextStyle(
                      fontFamily: 'GeistMono',
                      color: Color(0xFF141414),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      size: 12,
                      color: Color(0xFFA3A3A3),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Pago cifrado y seguro',
                      style: TextStyle(
                        fontFamily: 'GeistMono',
                        fontSize: 11,
                        color: Color(0xFFA3A3A3),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabelField(String text) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 6),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        fontFamily: 'GeistMono',
        color: Color(0xFF737373),
        fontWeight: FontWeight.bold,
      ),
    ),
  );
  Widget _buildFormInput(
    String hint, {
    IconData? icon,
    bool isGreenBorder = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: TextField(
        style: const TextStyle(fontFamily: 'GeistMono', fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFA3A3A3)),
          prefixIcon: icon != null
              ? Icon(icon, size: 16, color: const Color(0xFFA3A3A3))
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}

// =========================================================================
// 5. PANTALLA: HISTORIAL DE COMPRAS (historial_compras.dart)
// =========================================================================
class HistorialComprasPage extends StatelessWidget {
  const HistorialComprasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E5E5)),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 16,
                        color: Color(0xFF141414),
                      ),
                    ),
                  ),
                  const Text(
                    'Historial de compras',
                    style: TextStyle(
                      fontFamily: 'GeistMono',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF141414),
                    ),
                  ),
                  const SizedBox(width: 38),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 14,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFC7FFD1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.watch_later_outlined,
                      size: 16,
                      color: Color(0xFF025E45),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Modo prueba — 7 días restantes',
                      style: TextStyle(
                        fontFamily: 'GeistMono',
                        fontSize: 12,
                        color: Color(0xFF025E45),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFE5E5E5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recibos',
                            style: TextStyle(
                              fontFamily: 'GeistMono',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF141414),
                            ),
                          ),
                          Text(
                            '3 pagos',
                            style: TextStyle(
                              fontFamily: 'GeistMono',
                              fontSize: 12,
                              color: Color(0xFFA3A3A3),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            _buildItemRecibo(
                              'Paquete 3 · FCT-003',
                              '13/02/2026  ·  14:00',
                              '999.00',
                              'Pagado',
                              const Color(0xFFC7FFD1),
                              const Color(0xFF025E45),
                            ),
                            const Divider(color: Color(0xFFE5E5E5), height: 20),
                            _buildItemRecibo(
                              'Paquete 2 · FCT-002',
                              '12/03/2026  ·  14:00',
                              '799.00',
                              'Pagado',
                              const Color(0xFFC7FFD1),
                              const Color(0xFF025E45),
                            ),
                            const Divider(color: Color(0xFFE5E5E5), height: 20),
                            _buildItemRecibo(
                              'Paquete 1 · FCT-001',
                              '03/04/2026  ·  14:00',
                              '350.00',
                              'Pendiente',
                              const Color(0xFFFFF4D1),
                              const Color(0xFFB37402),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemRecibo(
    String desc,
    String fecha,
    String total,
    String estado,
    Color statusBg,
    Color statusText,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F4F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.assignment_outlined,
              size: 20,
              color: Color(0xFF737373),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  desc,
                  style: const TextStyle(
                    fontFamily: 'GeistMono',
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF141414),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  fecha,
                  style: const TextStyle(
                    fontFamily: 'GeistMono',
                    fontSize: 11,
                    color: Color(0xFFA3A3A3),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$$total',
                style: const TextStyle(
                  fontFamily: 'GeistMono',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF141414),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  estado,
                  style: TextStyle(
                    fontFamily: 'GeistMono',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: statusText,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// 1. COMPONENTE GLOBAL DE MENÚ DE NAVEGACIÓN (CORREGIDO)
// =========================================================================
class MenuNavegacionGlobal extends StatelessWidget {
  final int paginaActual;

  const MenuNavegacionGlobal({super.key, required this.paginaActual});

  void _navegar(BuildContext context, int indice) {
    if (indice == paginaActual) return;

    Widget siguientePantalla;
    switch (indice) {
      case 0:
        siguientePantalla = const InicioPage();
        break;
      case 1:
        siguientePantalla = const HistorialPage();
        break;
      case 2:
        siguientePantalla = const ReportesPage();
        break;
      case 3:
        siguientePantalla = const EquipoPage();
        break;
      case 4:
        siguientePantalla = const PerfilPage();
        break;
      case 5:
        // Corregido: Limpia el historial de rutas y fuerza el envío a Login
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
        return;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => siguientePantalla,
        transitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E5E5), width: 1)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBotonMenu(context, 0, Icons.home_outlined, "Inicio"),
              _buildBotonMenu(
                context,
                1,
                Icons.watch_later_outlined,
                "Historial",
              ),
              _buildBotonMenu(context, 2, Icons.bar_chart, "Reportes"),
              _buildBotonMenu(context, 3, Icons.groups_outlined, "Equipo"),
              _buildBotonMenu(context, 4, Icons.person_outline, "Perfil"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBotonMenu(
    BuildContext context,
    int indice,
    IconData icono,
    String etiqueta,
  ) {
    final bool esActivo = paginaActual == indice;

    return InkWell(
      onTap: () => _navegar(context, indice),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: esActivo ? const Color(0xFFC7FFD1) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icono,
              size: 24,
              color: esActivo
                  ? const Color(0xFF025E45)
                  : const Color(0xFF737373),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            etiqueta,
            style: TextStyle(
              fontSize: 11,
              fontFamily: 'GeistMono',
              fontWeight: esActivo ? FontWeight.bold : FontWeight.normal,
              color: esActivo
                  ? const Color(0xFF12AC6E)
                  : const Color(0xFF737373),
            ),
          ),
        ],
      ),
    );
  }
}
