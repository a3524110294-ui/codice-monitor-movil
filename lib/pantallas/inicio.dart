import 'dart:ui';
import 'package:flutter/material.dart';
import 'detalle_sitio.dart'; // SitioModel viene de aquí
import 'historial.dart';
import 'reporte.dart';
import 'equipo.dart';
import 'perfil.dart';
import 'login.dart';

// =========================================================================
// MENÚ DE NAVEGACIÓN GLOBAL
// =========================================================================
class MenuNavegacionGlobal extends StatelessWidget {
  final int paginaActual;
  const MenuNavegacionGlobal({super.key, required this.paginaActual});

  void _navegar(BuildContext context, int indice) {
    // Salir (índice 5) hace logout, no es una página normal
    if (indice == 5) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) => const LoginScreen(),
          transitionDuration: Duration.zero,
        ),
      );
      return;
    }
    if (indice == paginaActual) return;
    Widget sig;
    switch (indice) {
      case 0:
        sig = const InicioPage();
        break;
      case 1:
        sig = const HistorialPage();
        break;
      case 2:
        sig = const ReportesPage();
        break;
      case 3:
        sig = const EquipoPage();
        break;
      case 4:
        sig = const PerfilPage();
        break;
      default:
        return;
    }
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (c, a1, a2) => sig,
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
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _btn(context, 0, Icons.home_outlined, Icons.home, "Inicio"),
              _btn(
                context,
                1,
                Icons.watch_later_outlined,
                Icons.watch_later,
                "Historial",
              ),
              _btn(
                context,
                2,
                Icons.bar_chart_outlined,
                Icons.bar_chart,
                "Reportes",
              ),
              _btn(context, 3, Icons.groups_outlined, Icons.groups, "Equipo"),
              _btn(context, 4, Icons.person_outline, Icons.person, "Perfil"),
              _btn(context, 5, Icons.logout, Icons.logout, "Salir"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _btn(
    BuildContext context,
    int indice,
    IconData inactivo,
    IconData activo,
    String label,
  ) {
    final bool sel = paginaActual == indice;
    return GestureDetector(
      onTap: () => _navegar(context, indice),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: sel ? const Color(0xFFC7FFD1) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              sel ? activo : inactivo,
              size: 24,
              color: sel ? const Color(0xFF025E45) : const Color(0xFF737373),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontFamily: 'Geist',
              fontWeight: sel ? FontWeight.bold : FontWeight.normal,
              color: sel ? const Color(0xFF12AC6E) : const Color(0xFF737373),
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// ENTRADA PRINCIPAL
// =========================================================================
class InicioPage extends StatefulWidget {
  const InicioPage({super.key});
  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  final List<SitioModel> _sitios = [
    SitioModel(
      nombre: "Grupo APE",
      url: "grupoape.mx",
      categoria: "Corporativo",
      estado: "Operativo",
      ping: "200ms",
      colorEstado: const Color(0xFF12AC6E),
      fondoEstado: const Color(0xFFC7FFD1),
    ),
    SitioModel(
      nombre: "Naked Hotel Zipolite",
      url: "nakedhotelzipolite.com",
      categoria: "Corporativo",
      estado: "Operativo",
      ping: "240ms",
      colorEstado: const Color(0xFF12AC6E),
      fondoEstado: const Color(0xFFC7FFD1),
    ),
    SitioModel(
      nombre: "EzSafe",
      url: "ezsafe.app",
      categoria: "Otro",
      estado: "Lento",
      ping: "870ms",
      colorEstado: const Color(0xFFD97706),
      fondoEstado: const Color(0xFFFEF3C7),
    ),
    SitioModel(
      nombre: "Witchie Watches",
      url: "witchiewatches.com",
      categoria: "E-commerce",
      estado: "Caído",
      ping: "Caído",
      colorEstado: const Color(0xFFFF4B4B),
      fondoEstado: const Color(0xFFFFEBEB),
    ),
    SitioModel(
      nombre: "Golden Alliance Legal",
      url: "goldenalliance.legal",
      categoria: "Corporativo",
      estado: "Operativo",
      ping: "180ms",
      colorEstado: const Color(0xFF12AC6E),
      fondoEstado: const Color(0xFFC7FFD1),
    ),
    SitioModel(
      nombre: "TMA Logistics USA",
      url: "tmalogistics.us",
      categoria: "Corporativo",
      estado: "Operativo",
      ping: "210ms",
      colorEstado: const Color(0xFF12AC6E),
      fondoEstado: const Color(0xFFC7FFD1),
    ),
  ];

  void _agregarSitio(String nombre, String url, String categoria) {
    setState(() {
      _sitios.add(SitioModel(nombre: nombre, url: url, categoria: categoria));
    });
  }

  void _mostrarModal(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Agregar Sitio",
      barrierColor: Colors.black.withValues(alpha: 0.2),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, _) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: FadeTransition(
            opacity: animation,
            child: ModalAgregarSitio(onSitioAgregado: _agregarSitio),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_sitios.isEmpty) {
      return DashboardVacioPage(onAgregarTap: () => _mostrarModal(context));
    }
    return DashboardLlenoPage(
      sitios: _sitios,
      onAgregarTap: () => _mostrarModal(context),
    );
  }
}

// =========================================================================
// HEADER COMPARTIDO
// =========================================================================
Widget _buildHeader(VoidCallback onAgregarTap) {
  return Container(
    color: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: const [
            Text(
              "Códice",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Geist',
                color: Color(0xFF141414),
              ),
            ),
            Text(
              "/",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF60F16E),
                fontFamily: 'Geist',
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: onAgregarTap,
          icon: const Icon(Icons.add, size: 16, color: Color(0xFF141414)),
          label: const Text(
            "Agregar sitio",
            style: TextStyle(
              color: Color(0xFF141414),
              fontWeight: FontWeight.bold,
              fontFamily: 'Geist',
              fontSize: 13,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF60F16E),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
        ),
      ],
    ),
  );
}

// =========================================================================
// PANTALLA A: DASHBOARD VACÍO
// =========================================================================
class DashboardVacioPage extends StatelessWidget {
  final VoidCallback onAgregarTap;
  const DashboardVacioPage({super.key, required this.onAgregarTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(onAgregarTap),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: const BoxDecoration(
                          color: Color(0xFFC7FFD1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.wifi_protected_setup,
                          size: 64,
                          color: Color(0xFF025E45),
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        "Aún no tienes sitios bajo monitoreo",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Geist',
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Agrega tu primer dominio y Códice empezará a vigilar su disponibilidad y tiempo de respuesta 24/7.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF737373),
                          fontSize: 14,
                          fontFamily: 'Geist',
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: onAgregarTap,
                          icon: const Icon(Icons.add, color: Colors.black),
                          label: const Text(
                            "Agregar primer sitio",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: 'Geist',
                              fontSize: 15,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF60F16E),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _stepDot("Pega la URL", activo: true),
                          _stepLine(),
                          _stepDot("Define alertas", activo: false),
                          _stepLine(),
                          _stepDot("Listo", activo: false),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MenuNavegacionGlobal(paginaActual: 0),
    );
  }

  Widget _stepDot(String text, {required bool activo}) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: activo ? const Color(0xFF12AC6E) : const Color(0xFFB5B5B5),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: activo ? const Color(0xFF12AC6E) : const Color(0xFFB5B5B5),
            fontSize: 12,
            fontFamily: 'Geist',
            fontWeight: activo ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _stepLine() {
    return Container(
      width: 12,
      height: 1,
      color: const Color(0xFFE5E5E5),
      margin: const EdgeInsets.symmetric(horizontal: 6),
    );
  }
}

// =========================================================================
// PANTALLA B: DASHBOARD LLENO
// =========================================================================
class DashboardLlenoPage extends StatelessWidget {
  final List<SitioModel> sitios;
  final VoidCallback onAgregarTap;
  const DashboardLlenoPage({
    super.key,
    required this.sitios,
    required this.onAgregarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(onAgregarTap),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildUptimeCard(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Sitios web",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Geist',
                        ),
                      ),
                      Text(
                        "${sitios.length} registrados",
                        style: const TextStyle(
                          color: Color(0xFF737373),
                          fontSize: 12,
                          fontFamily: 'Geist',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...sitios.map(
                    (s) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: _buildSiteRow(context, s),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MenuNavegacionGlobal(paginaActual: 0),
    );
  }

  Widget _buildUptimeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "UPTIME PROMEDIO",
                  style: TextStyle(
                    color: Color(0xFF737373),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Geist',
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "98.2%",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF12AC6E),
                    fontFamily: 'Geist',
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Últimas 24 horas",
                  style: TextStyle(
                    color: Color(0xFF737373),
                    fontSize: 12,
                    fontFamily: 'Geist',
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFC7FFD1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.circle, size: 8, color: Color(0xFF025E45)),
                    SizedBox(width: 6),
                    Text(
                      "Operativo",
                      style: TextStyle(
                        color: Color(0xFF025E45),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Geist',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 90,
                height: 36,
                child: CustomPaint(painter: _MiniLineChartPainter()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSiteRow(BuildContext context, SitioModel sitio) {
    return GestureDetector(
      onTap: () {
        if (sitio.estado == "Caído" || sitio.estado == "Lento") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetalleSitioPage(sitio: sitio)),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E5E5)),
        ),
        child: Row(
          children: [
            Container(
              width: 9,
              height: 9,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: sitio.colorEstado,
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sitio.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      fontFamily: 'Geist',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sitio.url,
                    style: const TextStyle(
                      color: Color(0xFF737373),
                      fontSize: 12,
                      fontFamily: 'Geist',
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: sitio.fondoEstado,
                borderRadius: BorderRadius.circular(20),
              ),
              child: sitio.estado == "Caído"
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 7, color: sitio.colorEstado),
                        const SizedBox(width: 5),
                        Text(
                          sitio.estado,
                          style: TextStyle(
                            color: sitio.colorEstado,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Geist',
                          ),
                        ),
                      ],
                    )
                  : Text(
                      sitio.ping,
                      style: TextStyle(
                        color: sitio.colorEstado,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Geist',
                      ),
                    ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios,
              size: 13,
              color: Color(0xFFB5B5B5),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// MINI GRÁFICA
// =========================================================================
class _MiniLineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF12AC6E)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final points = [
      Offset(0, size.height * 0.6),
      Offset(size.width * 0.15, size.height * 0.4),
      Offset(size.width * 0.30, size.height * 0.55),
      Offset(size.width * 0.45, size.height * 0.25),
      Offset(size.width * 0.60, size.height * 0.45),
      Offset(size.width * 0.75, size.height * 0.20),
      Offset(size.width * 0.88, size.height * 0.35),
      Offset(size.width, size.height * 0.15),
    ];

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final curr = points[i];
      final cx = (prev.dx + curr.dx) / 2;
      path.cubicTo(cx, prev.dy, cx, curr.dy, curr.dx, curr.dy);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// =========================================================================
// MODAL: AGREGAR SITIO
// =========================================================================
class ModalAgregarSitio extends StatefulWidget {
  final Function(String, String, String) onSitioAgregado;
  const ModalAgregarSitio({super.key, required this.onSitioAgregado});

  @override
  State<ModalAgregarSitio> createState() => _ModalAgregarSitioState();
}

class _ModalAgregarSitioState extends State<ModalAgregarSitio> {
  final _nombreController = TextEditingController();
  final _urlController = TextEditingController();
  String? _categoria;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 318,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.7),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF141414).withValues(alpha: 0.34),
                offset: const Offset(0, 28),
                blurRadius: 70,
              ),
              BoxShadow(
                color: const Color(0xFF141414).withValues(alpha: 0.16),
                offset: const Offset(0, 2),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Detalles del sitio",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Geist',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 18,
                      color: Color(0xFF737373),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                "Ingresa la información del sitio que deseas monitorear.",
                style: TextStyle(
                  color: Color(0xFF737373),
                  fontSize: 12,
                  fontFamily: 'Geist',
                ),
              ),
              const SizedBox(height: 20),

              _label("NOMBRE DEL SITIO"),
              const SizedBox(height: 6),
              _field("Ej. Tienda Principal", _nombreController),
              const SizedBox(height: 16),

              _label("URL"),
              const SizedBox(height: 6),
              TextField(
                controller: _urlController,
                style: const TextStyle(
                  fontFamily: 'Geist',
                  color: Color(0xFF141414),
                ),
                decoration: InputDecoration(
                  hintText: "https://",
                  hintStyle: TextStyle(
                    fontFamily: 'Geist',
                    color: Colors.grey.shade400,
                  ),
                  prefixIcon: const Icon(
                    Icons.language,
                    color: Color(0xFF737373),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF60F16E),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _label("CATEGORÍA"),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                value: _categoria,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF60F16E),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                hint: const Text(
                  "Selecciona una categoría",
                  style: TextStyle(
                    color: Color(0xFFB5B5B5),
                    fontFamily: 'Geist',
                  ),
                ),
                items: ['E-commerce', 'Blog', 'Corporativo', 'Otro']
                    .map(
                      (v) => DropdownMenuItem(
                        value: v,
                        child: Text(
                          v,
                          style: const TextStyle(
                            fontFamily: 'Geist',
                            color: Color(0xFF141414),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _categoria = val),
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (_nombreController.text.isNotEmpty &&
                        _urlController.text.isNotEmpty &&
                        _categoria != null) {
                      widget.onSitioAgregado(
                        _nombreController.text,
                        _urlController.text,
                        _categoria!,
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF60F16E),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Añadir sitio",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Geist',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
      color: Color(0xFF737373),
      fontFamily: 'Geist',
    ),
  );

  Widget _field(String hint, TextEditingController ctrl) => TextField(
    controller: ctrl,
    style: const TextStyle(fontFamily: 'Geist', color: Color(0xFF141414)),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontFamily: 'Geist', color: Colors.grey.shade400),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF60F16E), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );
}

// =========================================================================
// PLACEHOLDER
// =========================================================================
class PlaceholderScreen extends StatelessWidget {
  final String titulo;
  const PlaceholderScreen({super.key, required this.titulo});

  int _idx() {
    switch (titulo) {
      case "Historial":
        return 1;
      case "Reportes":
        return 2;
      case "Equipo":
        return 3;
      case "Perfil":
        return 4;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          titulo,
          style: const TextStyle(
            fontFamily: 'Geist',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: Text(
          "Pantalla de $titulo",
          style: const TextStyle(
            fontFamily: 'Geist',
            fontSize: 20,
            color: Color(0xFF141414),
          ),
        ),
      ),
      bottomNavigationBar: MenuNavegacionGlobal(paginaActual: _idx()),
    );
  }
}
