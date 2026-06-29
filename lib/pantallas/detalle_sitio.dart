import 'dart:ui';
import 'package:flutter/material.dart';

// =========================================================================
// MODELO DE SITIO
// =========================================================================
class SitioModel {
  String nombre;
  String url;
  String categoria;
  String estado;
  String ping;
  String servidor;
  String ssl;
  String ultimaRevision;
  Color colorEstado;
  Color fondoEstado;
  bool estaPausado;
  String? estadoAnterior;
  String? pingAnterior;
  Color? colorEstadoAnterior;
  Color? fondoEstadoAnterior;
  List<RegistroHistorial> historial;

  SitioModel({
    required this.nombre,
    required this.url,
    required this.categoria,
    this.estado = "Operativo",
    this.ping = "200ms",
    this.servidor = 'AWS • us-east-1',
    this.ssl = 'Válido • vence 12 dic',
    this.ultimaRevision = 'hace 2 min',
    this.colorEstado = const Color(0xFF025E45),
    this.fondoEstado = const Color(0xFFC7FFD1),
    this.estaPausado = false,
    this.estadoAnterior,
    this.pingAnterior,
    this.colorEstadoAnterior,
    this.fondoEstadoAnterior,
    List<RegistroHistorial>? historial,
  }) : historial =
           historial ??
           [
             RegistroHistorial(
               estado: "Caída del servidor",
               descripcion:
                   "El servidor no responde a la petición HTTP (Timeout 504). El origen de la falla se debe a una saturación en el puerto de enlace principal.",
               tiempo: "3h 15m",
               color: const Color(0xFFFF4B4B),
             ),
             RegistroHistorial(
               estado: "Error 500",
               descripcion:
                   "Se detectó un error interno del servidor durante la última revisión.",
               tiempo: "48m",
               color: const Color(0xFFFF4B4B),
             ),
             RegistroHistorial(
               estado: "SSL caducado",
               descripcion:
                   "El certificado SSL ha expirado y requiere renovación para restablecer la seguridad.",
               tiempo: "1h 02m",
               color: const Color(0xFFF59E0B),
             ),
             RegistroHistorial(
               estado: "Error 500",
               descripcion:
                   "Nuevo error 500 detectado en el endpoint de verificación.",
               tiempo: "22m",
               color: const Color(0xFFFF4B4B),
             ),
           ];
}

class RegistroHistorial {
  final String estado;
  final String descripcion;
  final String tiempo;
  final Color color;

  RegistroHistorial({
    required this.estado,
    required this.descripcion,
    required this.tiempo,
    required this.color,
  });
}

// =========================================================================
// COMPONENTE GLOBAL DE MENÚ DE NAVEGACIÓN
// =========================================================================
class MenuNavegacionGlobal extends StatelessWidget {
  final int paginaActual;

  const MenuNavegacionGlobal({super.key, required this.paginaActual});

  void _navegar(BuildContext context, int indice) {
    if (indice == 5) {
      Navigator.popUntil(context, (route) => route.isFirst);
      return;
    }
    if (indice == paginaActual) return;

    Navigator.pop(context);
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
                Icons.bar_chart,
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
}

// =========================================================================
// PANTALLA DE DETALLE DE SITIO
// =========================================================================
class DetalleSitioPage extends StatefulWidget {
  final SitioModel sitio;
  final VoidCallback onEliminar;
  final VoidCallback onSiteChanged;

  const DetalleSitioPage({
    super.key,
    required this.sitio,
    required this.onEliminar,
    required this.onSiteChanged,
  });

  @override
  State<DetalleSitioPage> createState() => _DetalleSitioPageState();
}

class _DetalleSitioPageState extends State<DetalleSitioPage> {
  void _abrirModalEdicion() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Editar Sitio",
      barrierColor: Colors.black.withOpacity(0.2),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: FadeTransition(
            opacity: animation,
            child: ModalEditarSitio(
              sitio: widget.sitio,
              onGuardar: (nombre, url, categoria) {
                setState(() {
                  widget.sitio.nombre = nombre;
                  widget.sitio.url = url;
                  widget.sitio.categoria = categoria;
                });
                widget.onSiteChanged();
              },
            ),
          ),
        );
      },
    );
  }

  void _abrirModalEliminacion() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Eliminar Sitio",
      barrierColor: Colors.black.withOpacity(0.2),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: FadeTransition(
            opacity: animation,
            child: ModalEliminarSitio(
              nombreSitio: widget.sitio.nombre,
              onEliminar: () {
                Navigator.pop(context); // Cierra el modal
                widget.onEliminar();
                widget.onSiteChanged();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'El sitio "${widget.sitio.nombre}" ha sido eliminado.',
                      style: const TextStyle(fontFamily: 'Geist'),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _abrirModalDetalleError(RegistroHistorial registro) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Detalle de Estado",
      barrierColor: Colors.black.withOpacity(0.2),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: FadeTransition(
            opacity: animation,
            child: ModalDetalleError(registro: registro),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFF4F4F6),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xFF141414),
                size: 18,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Detalle del sitio',
              style: TextStyle(
                fontFamily: 'Geist',
                color: Color(0xFF141414),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              children: [
                _buildHeaderCard(),
                const SizedBox(height: 16),
                _buildActionButtons(),
                const SizedBox(height: 16),
                _buildMetricsCard(),
                const SizedBox(height: 16),
                _buildAvailabilityCard(),
                if (widget.sitio.estaPausado) ...[
                  const SizedBox(height: 16),
                  _buildPausedNote(),
                ],
                if (!widget.sitio.estaPausado) ...[
                  const SizedBox(height: 16),
                  _buildInfoCard(),
                  const SizedBox(height: 16),
                  _buildHistorialCard(),
                ],
                const SizedBox(height: 24),
                _buildReverifyButton(),
              ],
            ),
          ),
          bottomNavigationBar: const MenuNavegacionGlobal(paginaActual: 0),
        ),
      ],
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF9F0),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.language,
                  color: Color(0xFF12AC6E),
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.sitio.nombre,
                      style: const TextStyle(
                        fontFamily: 'Geist',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF141414),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.sitio.url,
                      style: const TextStyle(
                        fontFamily: 'Geist',
                        color: Color(0xFF737373),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: widget.sitio.estaPausado
                      ? const Color(0xFFF0F4F8)
                      : widget.sitio.fondoEstado,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  widget.sitio.estaPausado ? 'Pausado' : widget.sitio.estado,
                  style: TextStyle(
                    fontFamily: 'Geist',
                    color: widget.sitio.estaPausado
                        ? const Color(0xFF6B7280)
                        : widget.sitio.colorEstado,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Monitoreo activo verificado por Códice.',
            style: TextStyle(
              fontFamily: 'Geist',
              color: Color(0xFF737373),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final isPaused = widget.sitio.estaPausado;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _abrirModalEdicion,
            icon: const Icon(
              Icons.edit_outlined,
              color: Color(0xFF141414),
              size: 18,
            ),
            label: const Text(
              'Editar',
              style: TextStyle(
                color: Color(0xFF141414),
                fontFamily: 'Geist',
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              side: const BorderSide(color: Color(0xFFE5E5E5)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              setState(() {
                if (widget.sitio.estaPausado) {
                  widget.sitio.estaPausado = false;
                  widget.sitio.estado =
                      widget.sitio.estadoAnterior ?? 'Operativo';
                  widget.sitio.ping = widget.sitio.pingAnterior ?? '200ms';
                  widget.sitio.colorEstado =
                      widget.sitio.colorEstadoAnterior ??
                      const Color(0xFF025E45);
                  widget.sitio.fondoEstado =
                      widget.sitio.fondoEstadoAnterior ??
                      const Color(0xFFC7FFD1);
                } else {
                  widget.sitio.estadoAnterior = widget.sitio.estado;
                  widget.sitio.pingAnterior = widget.sitio.ping;
                  widget.sitio.colorEstadoAnterior = widget.sitio.colorEstado;
                  widget.sitio.fondoEstadoAnterior = widget.sitio.fondoEstado;
                  widget.sitio.estaPausado = true;
                  widget.sitio.estado = 'Pausado';
                  widget.sitio.colorEstado = const Color(0xFF6B7280);
                  widget.sitio.fondoEstado = const Color(0xFFF0F4F8);
                  widget.sitio.ping = '—';
                }
              });
              widget.onSiteChanged();
            },
            icon: Icon(
              isPaused ? Icons.play_arrow : Icons.pause,
              color: isPaused ? Colors.white : const Color(0xFF141414),
              size: 18,
            ),
            label: Text(
              isPaused ? 'Reanudar monitoreo' : 'Pausar monitoreo',
              style: TextStyle(
                color: isPaused ? Colors.white : const Color(0xFF141414),
                fontFamily: 'Geist',
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isPaused
                  ? const Color(0xFF12AC6E)
                  : Colors.white,
              elevation: 0,
              side: isPaused
                  ? null
                  : const BorderSide(color: Color(0xFFE5E5E5)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _abrirModalEliminacion,
            icon: const Icon(
              Icons.delete_outline,
              color: Color(0xFFFF4B4B),
              size: 18,
            ),
            label: const Text(
              'Eliminar sitio',
              style: TextStyle(
                color: Color(0xFFFF4B4B),
                fontFamily: 'Geist',
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFF0F0),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsCard() {
    final isPaused = widget.sitio.estaPausado;
    final latency = isPaused ? '—' : widget.sitio.ping;
    final sublabel = isPaused
        ? 'En pausa'
        : (widget.sitio.ping == '—' ? 'Sin respuesta' : 'Respuesta válida');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ESTADO DEL MONITOREO',
                style: TextStyle(
                  color: Color(0xFF737373),
                  fontSize: 10,
                  letterSpacing: 0.8,
                  fontFamily: 'Geist',
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isPaused
                      ? const Color(0xFFF0F4F8)
                      : const Color(0xFFF4F9F4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isPaused ? 'Pausado' : 'Activo',
                  style: TextStyle(
                    color: isPaused
                        ? const Color(0xFF6B7280)
                        : const Color(0xFF025E45),
                    fontSize: 11,
                    fontFamily: 'Geist',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'LATENCIA',
                      style: TextStyle(
                        color: Color(0xFF737373),
                        fontSize: 10,
                        letterSpacing: 0.8,
                        fontFamily: 'Geist',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      latency,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Geist',
                        color: Color(0xFF141414),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      sublabel,
                      style: const TextStyle(
                        color: Color(0xFF737373),
                        fontSize: 12,
                        fontFamily: 'Geist',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'UPTIME 30D',
                      style: TextStyle(
                        color: Color(0xFF737373),
                        fontSize: 10,
                        letterSpacing: 0.8,
                        fontFamily: 'Geist',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.sitio.estaPausado ? '99.4%' : '94.1%',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Geist',
                        color: Color(0xFF141414),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.sitio.estaPausado
                          ? 'antes de pausar'
                          : '3 incidencias',
                      style: const TextStyle(
                        color: Color(0xFF737373),
                        fontSize: 12,
                        fontFamily: 'Geist',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(18),
            ),
            child: CustomPaint(
              painter: LineChartPainter(),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityCard() {
    final isPaused = widget.sitio.estaPausado;
    final bars = isPaused
        ? List<Color>.generate(
            12,
            (index) =>
                index < 5 ? const Color(0xFF12AC6E) : const Color(0xFFE5E5E5),
          )
        : <Color>[
            const Color(0xFF12AC6E),
            const Color(0xFF12AC6E),
            const Color(0xFF12AC6E),
            const Color(0xFF12AC6E),
            const Color(0xFF12AC6E),
            const Color(0xFFF5A524),
            const Color(0xFF12AC6E),
            const Color(0xFF12AC6E),
            const Color(0xFFE53E3E),
            const Color(0xFFE53E3E),
            const Color(0xFF12AC6E),
            const Color(0xFF12AC6E),
          ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Disponibilidad — 24h',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF141414),
                  fontFamily: 'Geist',
                ),
              ),
              Text(
                isPaused ? 'en pausa' : 'cada 30 min',
                style: const TextStyle(
                  color: Color(0xFF737373),
                  fontSize: 11,
                  fontFamily: 'Geist',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: bars.map((color) {
              return Expanded(
                child: Container(
                  height: 24,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        children: [
          _buildInfoRow('Servidor', widget.sitio.servidor),
          const SizedBox(height: 16),
          _buildInfoRow('SSL', widget.sitio.ssl),
          const SizedBox(height: 16),
          _buildInfoRow('Última revisión', widget.sitio.ultimaRevision),
          const SizedBox(height: 16),
          _buildInfoRow('Categoría', widget.sitio.categoria),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF737373),
            fontFamily: 'Geist',
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF141414),
              fontFamily: 'Geist',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPausedNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.info_outline, color: Color(0xFF6B7280), size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Sin verificaciones ni alertas mientras esté en pausa.',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 12,
                fontFamily: 'Geist',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorialCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Historial del sitio',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF141414),
              fontFamily: 'Geist',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.sitio.historial.length} incidencias',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF737373),
              fontFamily: 'Geist',
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: widget.sitio.historial.map((registro) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => _abrirModalDetalleError(registro),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E5E5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              registro.estado,
                              style: TextStyle(
                                fontFamily: 'Geist',
                                fontWeight: FontWeight.bold,
                                color: registro.color,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: registro.color.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              child: Text(
                                registro.tiempo,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: registro.color,
                                  fontFamily: 'Geist',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            minHeight: 8,
                            value:
                                registro.estado.contains('Caída') ||
                                    registro.estado.contains('Error')
                                ? 0.85
                                : 0.6,
                            color: registro.color,
                            backgroundColor: registro.color.withOpacity(0.18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildReverifyButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Verificando disponibilidad del sitio...',
                style: TextStyle(fontFamily: 'Geist'),
              ),
              backgroundColor: Color(0xFF025E45),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF60F16E),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Reverificar ahora',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Geist',
          ),
        ),
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = const Color(0xFF12AC6E)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final paintDot = Paint()
      ..color = const Color(0xFF12AC6E)
      ..style = PaintingStyle.fill;

    final paintGrid = Paint()
      ..color = const Color(0xFFE5E5E5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final points = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.17, size.height * 0.62),
      Offset(size.width * 0.34, size.height * 0.55),
      Offset(size.width * 0.51, size.height * 0.58),
      Offset(size.width * 0.68, size.height * 0.45),
      Offset(size.width * 0.85, size.height * 0.50),
      Offset(size.width, size.height * 0.42),
    ];

    for (var i = 0; i <= 4; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paintGrid);
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(path, paintLine);

    for (var point in points) {
      canvas.drawCircle(point, 4, paintDot);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// =========================================================================
// VENTANA MODAL: EDITAR INFORMACIÓN DE SITIO
// =========================================================================
class ModalEditarSitio extends StatefulWidget {
  final SitioModel sitio;
  final Function(String, String, String) onGuardar;
  const ModalEditarSitio({
    super.key,
    required this.sitio,
    required this.onGuardar,
  });

  @override
  State<ModalEditarSitio> createState() => _ModalEditarSitioState();
}

class _ModalEditarSitioState extends State<ModalEditarSitio> {
  late TextEditingController _nombreController;
  late TextEditingController _urlController;
  String? _categoriaSeleccionada;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.sitio.nombre);
    _urlController = TextEditingController(text: widget.sitio.url);
    _categoriaSeleccionada = widget.sitio.categoria;
  }

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
            border: Border.all(color: Colors.white.withOpacity(0.7), width: 1),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF141414).withOpacity(0.34),
                offset: const Offset(0, 28),
                blurRadius: 70,
              ),
              BoxShadow(
                color: const Color(0xFF141414).withOpacity(0.16),
                offset: const Offset(0, 2),
                blurRadius: 10,
              ),
              const BoxShadow(
                color: Colors.white,
                offset: Offset(0, 1),
                blurRadius: 0,
              ),
              const BoxShadow(
                color: Colors.white,
                offset: Offset(0, -1),
                blurRadius: 0,
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
                    "Editar sitio",
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
              const SizedBox(height: 6),
              const Text(
                "Actualiza la información del sitio web.",
                style: TextStyle(
                  color: Color(0xFF737373),
                  fontSize: 12,
                  fontFamily: 'Geist',
                ),
              ),
              const SizedBox(height: 20),

              _buildLabel("NOMBRE DEL SITIO"),
              const SizedBox(height: 6),
              _buildTextField("", controller: _nombreController),
              const SizedBox(height: 16),

              _buildLabel("URL"),
              const SizedBox(height: 6),
              _buildTextField("", controller: _urlController),
              const SizedBox(height: 16),

              _buildLabel("CATEGORÍA"),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                dropdownColor: Colors.white,
                value: _categoriaSeleccionada,
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
                items: <String>['E-commerce', 'Blog', 'Corporativo', 'Otro']
                    .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontFamily: 'Geist',
                            color: Color(0xFF141414),
                          ),
                        ),
                      );
                    })
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _categoriaSeleccionada = val;
                  });
                },
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (_nombreController.text.isNotEmpty &&
                        _urlController.text.isNotEmpty &&
                        _categoriaSeleccionada != null) {
                      widget.onGuardar(
                        _nombreController.text,
                        _urlController.text,
                        _categoriaSeleccionada!,
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
                    "Guardar cambios",
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: Color(0xFF737373),
        fontFamily: 'Geist',
      ),
    );
  }

  Widget _buildTextField(
    String hint, {
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontFamily: 'Geist', color: Color(0xFF141414)),
      decoration: InputDecoration(
        hintText: hint,
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}

// =========================================================================
// VENTANA MODAL: CONFIRMACIÓN ELIMINACIÓN DE SITIO
// =========================================================================
class ModalEliminarSitio extends StatelessWidget {
  final String nombreSitio;
  final VoidCallback onEliminar;
  const ModalEliminarSitio({
    super.key,
    required this.nombreSitio,
    required this.onEliminar,
  });

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
            border: Border.all(color: Colors.white.withOpacity(0.7), width: 1),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF141414).withOpacity(0.34),
                offset: const Offset(0, 28),
                blurRadius: 70,
              ),
              BoxShadow(
                color: const Color(0xFF141414).withOpacity(0.16),
                offset: const Offset(0, 2),
                blurRadius: 10,
              ),
              const BoxShadow(
                color: Colors.white,
                offset: Offset(0, 1),
                blurRadius: 0,
              ),
              const BoxShadow(
                color: Colors.white,
                offset: Offset(0, -1),
                blurRadius: 0,
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
                    "¿Eliminar sitio?",
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
              const SizedBox(height: 12),
              Text(
                '¿Estás seguro que deseas eliminar el sitio "$nombreSitio"? Esta acción no se puede deshacer y perderás todas las métricas.',
                style: const TextStyle(
                  color: Color(0xFF737373),
                  fontSize: 13,
                  fontFamily: 'Geist',
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: const BorderSide(color: Color(0xFFE5E5E5)),
                        ),
                        child: const Text(
                          "Cancelar",
                          style: TextStyle(
                            color: Color(0xFF141414),
                            fontFamily: 'Geist',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: onEliminar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF4B4B),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Eliminar",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Geist',
                            fontWeight: FontWeight.bold,
                          ),
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
    );
  }
}

// =========================================================================
// VENTANA MODAL: DETALLE DE DESCRIPCIÓN DE ERROR (HISTORIAL)
// =========================================================================
class ModalDetalleError extends StatelessWidget {
  final RegistroHistorial registro;
  const ModalDetalleError({super.key, required this.registro});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 325,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withOpacity(0.7), width: 1),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF141414).withOpacity(0.34),
                offset: const Offset(0, 28),
                blurRadius: 70,
              ),
              BoxShadow(
                color: const Color(0xFF141414).withOpacity(0.16),
                offset: const Offset(0, 2),
                blurRadius: 10,
              ),
              const BoxShadow(
                color: Colors.white,
                offset: Offset(0, 1),
                blurRadius: 0,
              ),
              const BoxShadow(
                color: Colors.white,
                offset: Offset(0, -1),
                blurRadius: 0,
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
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: registro.color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Incidencia: ${registro.estado}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Geist',
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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
              const SizedBox(height: 6),
              Text(
                registro.tiempo,
                style: const TextStyle(
                  color: Color(0xFF737373),
                  fontSize: 11,
                  fontFamily: 'Geist',
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E5E5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Detalles del suceso:",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF141414),
                        fontFamily: 'Geist',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      registro.descripcion,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF737373),
                        fontFamily: 'Geist',
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF60F16E),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Entendido",
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
}
