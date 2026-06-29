import 'package:flutter/material.dart';
import 'dart:ui';
import 'historial.dart';
import 'login.dart';
import 'reporte.dart';
import 'inicio.dart';
import 'perfil.dart';

// =========================================================================
// MODELO DE DATOS: MIEMBRO DE EQUIPO
// =========================================================================
class MiembroEquipo {
  final String id;
  String nombre;
  String correo;
  final String
  rol; // 'Moderador' o 'Cliente' (Administrador fijo para el dueño)

  MiembroEquipo({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.rol,
  });
}

// =========================================================================
// PANTALLA PRINCIPAL: EQUIPO PAGE
// =========================================================================
class EquipoPage extends StatefulWidget {
  const EquipoPage({super.key});

  @override
  State<EquipoPage> createState() => _EquipoPageState();
}

class _EquipoPageState extends State<EquipoPage> {
  bool isBlurred = false; // Controla el desenfoque del fondo de la pantalla

  // LISTA BASE DE MIEMBROS (Simulando la persistencia de datos de tu app)
  final List<MiembroEquipo> _miembros = [
    MiembroEquipo(
      id: '1',
      nombre: 'Fernando Hernández',
      correo: 'fernando@gmail.com',
      rol: 'Administrador',
    ),
    MiembroEquipo(
      id: '2',
      nombre: 'Sergio Macías',
      correo: 'sergio@gmail.com',
      rol: 'Moderador',
    ),
    MiembroEquipo(
      id: '3',
      nombre: 'Laura Rios',
      correo: 'laura@gmail.com',
      rol: 'Moderador',
    ),
    MiembroEquipo(
      id: '4',
      nombre: 'Diego Torres',
      correo: 'diego@gmail.com',
      rol: 'Cliente',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F5),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // CABECERA SUPERIOR: TÍTULO Y BOTÓN INVITAR
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 14.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Text(
                            'Codice',
                            style: TextStyle(
                              fontFamily: 'GeistMono',
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Color(0xFF141414),
                            ),
                          ),
                          Text(
                            '/',
                            style: TextStyle(
                              fontFamily: 'GeistMono',
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Color(0xFF12AC6E),
                            ),
                          ),
                        ],
                      ),
                      // BOTÓN "+" INVITAR (Abre modal flotante de creación)
                      ElevatedButton.icon(
                        onPressed: _mostrarModalInvitar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3DF27D),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(
                          Icons.add,
                          size: 16,
                          color: Color(0xFF141414),
                        ),
                        label: const Text(
                          'Invitar',
                          style: TextStyle(
                            fontFamily: 'GeistMono',
                            color: Color(0xFF141414),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // FEED SCROLLABLE DE MIEMBROS (Ocupa toda la pantalla eficientemente)
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 6.0,
                    ),
                    itemCount: _miembros.length,
                    itemBuilder: (context, index) {
                      return _buildTarjetaMiembro(_miembros[index]);
                    },
                  ),
                ),

                // BARRA DE NAVEGACIÓN GLOBAL (Página Actual: 3 — Equipo)
                const MenuNavegacionGlobal(paginaActual: 3),
              ],
            ),
          ),

          // EFECTO BLUR EN CAPA SUPERIOR CUANDO HAY MODALES ACTIVAS
          if (isBlurred)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(color: Colors.black.withOpacity(0.06)),
              ),
            ),
        ],
      ),
    );
  }

  // WIDGET CARD: CONTENEDOR INDIVIDUAL DE MIEMBRO
  Widget _buildTarjetaMiembro(MiembroEquipo miembro) {
    // Iniciales para el Avatar Circular
    String iniciales = miembro.nombre
        .trim()
        .split(' ')
        .map((l) => l[0])
        .take(2)
        .join()
        .toUpperCase();

    // Configuración visual según el rol
    Color badgeFondo = miembro.rol == 'Administrador'
        ? const Color(0xFFC7FFD1)
        : (miembro.rol == 'Moderador'
              ? const Color(0xFFF4F4F5)
              : const Color(0xFFE5E5E5).withOpacity(0.5));
    Color badgeTexto = miembro.rol == 'Administrador'
        ? const Color(0xFF025E45)
        : const Color(0xFF141414);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Row(
        children: [
          // AVATAR CON INICIALES
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFC7FFD1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                iniciales,
                style: const TextStyle(
                  fontFamily: 'GeistMono',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF025E45),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // INFORMACIÓN ESENCIAL (RESPONSIVA)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  miembro.nombre,
                  style: const TextStyle(
                    fontFamily: 'GeistMono',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF141414),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  miembro.correo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'GeistMono',
                    fontSize: 11,
                    color: Color(0xFFA3A3A3),
                  ),
                ),
                const SizedBox(height: 6),
                // BADGE DE ROL
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: badgeFondo,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    miembro.rol,
                    style: TextStyle(
                      fontFamily: 'GeistMono',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: badgeTexto,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ACCIONES DEL MIEMBRO (EDITAR / ELIMINAR)
          // No se le permite editar ni remover al dueño/administrador principal de la cuenta
          if (miembro.rol != 'Administrador') ...[
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => _mostrarModalEditar(miembro),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E5E5)),
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      size: 16,
                      color: Color(0xFF141414),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _mostrarModalEliminar(miembro),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFCE4E4)),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      size: 16,
                      color: Color(0xFFE53E3E),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // =========================================================================
  // INTERMITENCIAS Y MODALES (CON EFECTO VIDRIO LÍQUIDO)
  // =========================================================================

  // 1. MODAL: AGREGAR NUEVO MIEMBRO (INVITAR)
  void _mostrarModalInvitar() {
    setState(() => isBlurred = true);

    final TextEditingController nameCtrl = TextEditingController();
    final TextEditingController emailCtrl = TextEditingController();
    String rolAsignado = 'Moderador'; // Valor por defecto inicial

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black12,
      pageBuilder: (context, animation, secondaryAnimation) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Center(
              child: Container(
                margin: const EdgeInsets.all(20),
                constraints: const BoxConstraints(maxWidth: 380),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.96),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFFE5E5E5)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Material(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // HEADER MODAL
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Agregar nuevo miembro',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'GeistMono',
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF141414),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    setState(() => isBlurred = false);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF4F4F5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Color(0xFF737373),
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // INPUT NOMBRE
                            _buildLabelFormulario('NOMBRE COMPLETO'),
                            const SizedBox(height: 6),
                            _buildTextField(
                              nameCtrl,
                              Icons.person_outline,
                              'Nombre y apellidos',
                            ),
                            const SizedBox(height: 16),

                            // INPUT EMAIL
                            _buildLabelFormulario('CORREO ELECTRÓNICO'),
                            const SizedBox(height: 6),
                            _buildTextField(
                              emailCtrl,
                              Icons.mail_outline_rounded,
                              'Correo electrónico',
                            ),
                            const SizedBox(height: 16),

                            // SELECCIÓN DE ROL (Únicamente Moderador y Cliente)
                            _buildLabelFormulario('ROL ASIGNADO'),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFFE5E5E5),
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: rolAsignado,
                                  isExpanded: true,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Color(0xFF737373),
                                  ),
                                  items: ['Moderador', 'Cliente'].map((
                                    String val,
                                  ) {
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
                                  onChanged: (val) =>
                                      setModalState(() => rolAsignado = val!),
                                ),
                              ),
                            ),
                            const SizedBox(height: 26),

                            // ACCIÓN DE ENVÍO
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (nameCtrl.text.isNotEmpty &&
                                      emailCtrl.text.isNotEmpty) {
                                    setState(() {
                                      _miembros.add(
                                        MiembroEquipo(
                                          id: DateTime.now()
                                              .millisecondsSinceEpoch
                                              .toString(),
                                          nombre: nameCtrl.text,
                                          correo: emailCtrl.text,
                                          rol: rolAsignado,
                                        ),
                                      );
                                      isBlurred = false;
                                    });
                                    Navigator.pop(context);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3DF27D),
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person_add_alt,
                                      size: 16,
                                      color: Color(0xFF141414),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Enviar invitación',
                                      style: TextStyle(
                                        fontFamily: 'GeistMono',
                                        color: Color(0xFF141414),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
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
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 2. MODAL: EDITAR MIEMBRO (ROL FIJO POR REQUERIMIENTO)
  void _mostrarModalEditar(MiembroEquipo miembro) {
    setState(() => isBlurred = true);

    final TextEditingController nameCtrl = TextEditingController(
      text: miembro.nombre,
    );
    final TextEditingController emailCtrl = TextEditingController(
      text: miembro.correo,
    );

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black12,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxWidth: 380),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.96),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFE5E5E5)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Editar miembro',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'GeistMono',
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF141414),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                setState(() => isBlurred = false);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4F4F5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Color(0xFF737373),
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Actualiza los datos y el rol de acceso del usuario.',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'GeistMono',
                            color: Color(0xFF737373),
                          ),
                        ),
                        const SizedBox(height: 20),

                        _buildLabelFormulario('NOMBRE COMPLETO'),
                        const SizedBox(height: 6),
                        _buildTextField(nameCtrl, Icons.person_outline, ''),
                        const SizedBox(height: 16),

                        _buildLabelFormulario('CORREO ELECTRÓNICO'),
                        const SizedBox(height: 6),
                        _buildTextField(
                          emailCtrl,
                          Icons.mail_outline_rounded,
                          '',
                        ),
                        const SizedBox(height: 16),

                        // CAMPO DE ROL BLOQUEADO / DESHABILITADO POR CONFIGURACIÓN DE NEGOCIO
                        _buildLabelFormulario('ROL ASIGNADO (NO EDITABLE)'),
                        const SizedBox(height: 6),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFF4F4F5,
                            ), // Color grisáceo que denota bloqueo
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE5E5E5)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                miembro.rol,
                                style: const TextStyle(
                                  fontFamily: 'GeistMono',
                                  fontSize: 14,
                                  color: Color(0xFFA3A3A3),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Icon(
                                Icons.lock_outline,
                                size: 16,
                                color: Color(0xFFA3A3A3),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 26),

                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() => isBlurred = false);
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Color(0xFFE5E5E5),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text(
                                  'Cancelar',
                                  style: TextStyle(
                                    fontFamily: 'GeistMono',
                                    color: Color(0xFF141414),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    miembro.nombre = nameCtrl.text;
                                    miembro.correo = emailCtrl.text;
                                    isBlurred = false;
                                  });
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3DF27D),
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text(
                                  'Guardar cambios',
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // 3. MODAL: ELIMINAR MIEMBRO CON CONFIRMACIÓN EXPLÍCITA
  void _mostrarModalEliminar(MiembroEquipo miembro) {
    setState(() => isBlurred = true);

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black12,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Container(
            margin: const EdgeInsets.all(24),
            constraints: const BoxConstraints(maxWidth: 360),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.96),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFE5E5E5)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ICONO DE ALERTA DE REMOCIÓN
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFCE4E4),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications_off_outlined,
                            color: Color(0xFFE53E3E),
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '¿Estás seguro de revocar el acceso a este usuario?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'GeistMono',
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF141414),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'El usuario perderá el acceso a este espacio de trabajo de inmediato. Podrás volver a invitarlo más adelante.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'GeistMono',
                            color: Color(0xFF737373),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // CAJA DE IDENTIFICACIÓN DEL USUARIO AFECTADO
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F4F5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFC7FFD1),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    miembro.nombre[0],
                                    style: const TextStyle(
                                      fontFamily: 'GeistMono',
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF025E45),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      miembro.nombre,
                                      style: const TextStyle(
                                        fontFamily: 'GeistMono',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Color(0xFF141414),
                                      ),
                                    ),
                                    Text(
                                      miembro.correo,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontFamily: 'GeistMono',
                                        fontSize: 11,
                                        color: Color(0xFF737373),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                miembro.rol,
                                style: const TextStyle(
                                  fontFamily: 'GeistMono',
                                  fontSize: 11,
                                  color: Color(0xFF737373),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // BOTONERA CON ACCIÓN DESTRUCITVA
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() => isBlurred = false);
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Color(0xFFE5E5E5),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text(
                                  'Cancelar',
                                  style: TextStyle(
                                    fontFamily: 'GeistMono',
                                    color: Color(0xFF141414),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _miembros.removeWhere(
                                      (m) => m.id == miembro.id,
                                    );
                                    isBlurred = false;
                                  });
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE53E3E),
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text(
                                  'Eliminar cuenta',
                                  style: TextStyle(
                                    fontFamily: 'GeistMono',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
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
          ),
        );
      },
    );
  }

  // AUXILIARES DE COHESIÓN ESTÍTICA
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
    IconData icono,
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
          hintStyle: const TextStyle(color: Color(0xFFA3A3A3), fontSize: 14),
          prefixIcon: Icon(icono, color: const Color(0xFFA3A3A3), size: 18),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
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
        siguientePantalla = ReportesPage();
        break;
      case 3:
        siguientePantalla = EquipoPage();
        break;
      case 4:
        siguientePantalla = PerfilPage();
        break;
      case 5:
        // Corrección: Envía al login de forma limpia borrando el historial de navegación previo
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
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

  Widget _buildBotonMenu(
    BuildContext context,
    int indice,
    IconData iconoInactivo,
    IconData iconoActivo,
    String etiqueta,
  ) {
    bool esActivo = (paginaActual == indice);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _navegar(context, indice),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: esActivo ? const Color(0xFFC7FFD1) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                esActivo ? iconoActivo : iconoInactivo,
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
                fontFamily: 'Geist',
                fontWeight: esActivo ? FontWeight.bold : FontWeight.normal,
                color: esActivo
                    ? const Color(0xFF12AC6E)
                    : const Color(0xFF737373),
              ),
            ),
          ],
        ),
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
              _buildBotonMenu(
                context,
                0,
                Icons.home_outlined,
                Icons.home,
                "Inicio",
              ),
              _buildBotonMenu(
                context,
                1,
                Icons.watch_later_outlined,
                Icons.watch_later,
                "Historial",
              ),
              _buildBotonMenu(
                context,
                2,
                Icons.bar_chart_outlined,
                Icons.bar_chart,
                "Reportes",
              ),
              _buildBotonMenu(
                context,
                3,
                Icons.groups_outlined,
                Icons.groups,
                "Equipo",
              ),
              _buildBotonMenu(
                context,
                4,
                Icons.person_outline,
                Icons.person,
                "Perfil",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
