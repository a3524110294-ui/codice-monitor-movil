import 'package:flutter/material.dart';
import 'dart:ui';
import 'inicio.dart'; //
import 'login.dart';

// =========================================================================
// MODELO DE DATOS: INCIDENCIA
// =========================================================================
class Incidencia {
  final String sitio;
  final String tipoEvento;
  final String estado; // 'Estable', 'Lento', 'Caído'
  final String detalles;
  final String fecha; // 'HOY', 'AYER' o formato 'dd/mm/yyyy'
  final DateTime fechaReal;
  final String hora;
  final String duracion;
  final String codigoHttp;
  final String descripcion;
  final String horaRestauracion;

  Incidencia({
    required this.sitio,
    required this.tipoEvento,
    required this.estado,
    required this.detalles,
    required this.fecha,
    required this.fechaReal,
    required this.hora,
    required this.duracion,
    required this.codigoHttp,
    required this.descripcion,
    required this.horaRestauracion,
  });
}

// =========================================================================
// PANTALLA PRINCIPAL: HISTORIAL PAGE
// =========================================================================
class HistorialPage extends StatefulWidget {
  const HistorialPage({super.key});

  @override
  State<HistorialPage> createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  bool isBlurred = false;

  // Datos base simulados
  final List<Incidencia> _todasLasIncidencias = [
    Incidencia(
      sitio: 'Witchie Watches',
      tipoEvento: 'Caída del servidor',
      estado: 'Caído',
      detalles: 'Caída del servidor - HTTP 503',
      fecha: 'HOY',
      fechaReal: DateTime(2026, 6, 25),
      hora: 'hace 12 min',
      duracion: '3h 15m',
      codigoHttp: 'HTTP 503',
      descripcion:
          'Interrupción total del servicio que impide el acceso al sistema. El monitoreo detectó tiempo de respuesta nulo de forma sostenida.',
      horaRestauracion: '17:15',
    ),
    Incidencia(
      sitio: 'EzSafe',
      tipoEvento: 'Latencia elevada',
      estado: 'Lento',
      detalles: 'Latencia elevada · 870 ms',
      fecha: 'HOY',
      fechaReal: DateTime(2026, 6, 25),
      hora: 'hace 38 min',
      duracion: '45m',
      codigoHttp: 'N/A',
      descripcion:
          'Los tiempos de respuesta superan el umbral óptimo configurado.',
      horaRestauracion: '16:40',
    ),
    Incidencia(
      sitio: 'TMA Logistics USA',
      tipoEvento: 'Pico de respuesta',
      estado: 'Lento',
      detalles: 'Pico de respuesta · 540 ms',
      fecha: 'HOY',
      fechaReal: DateTime(2026, 6, 25),
      hora: 'hace 1 h',
      duracion: '20m',
      codigoHttp: 'N/A',
      descripcion:
          'Degradación temporal del rendimiento de la base de datos externa.',
      horaRestauracion: '15:20',
    ),
    Incidencia(
      sitio: 'Grupo APE',
      tipoEvento: 'Servicio restablecido',
      estado: 'Estable',
      detalles: 'Servicio restablecido · 200 ms',
      fecha: 'HOY',
      fechaReal: DateTime(2026, 6, 25),
      hora: 'hace 2 h',
      duracion: '1h 05m',
      codigoHttp: 'HTTP 200',
      descripcion: 'Estabilización completa del balanceador de carga.',
      horaRestauracion: '14:30',
    ),
    Incidencia(
      sitio: 'Witchie Watches',
      tipoEvento: 'Error 500',
      estado: 'Caído',
      detalles: 'Error 500 · respuesta del backend',
      fecha: 'AYER',
      fechaReal: DateTime(2026, 6, 24),
      hora: '22:14',
      duracion: '2h 10m',
      codigoHttp: 'HTTP 500',
      descripcion:
          'Fallo crítico inesperado en el microservicio de pasarela de pagos.',
      horaRestauracion: '00:24',
    ),
    Incidencia(
      sitio: 'Naked Hotel Zipolite',
      tipoEvento: 'Certificado SSL',
      estado: 'Lento',
      detalles: 'Certificado SSL por vencer',
      fecha: 'AYER',
      fechaReal: DateTime(2026, 6, 24),
      hora: '18:30',
      duracion: 'N/A',
      codigoHttp: 'Advertencia',
      descripcion:
          'El certificado TLS/SSL expira en menos de 7 días. Requiere renovación inmediata.',
      horaRestauracion: 'N/A',
    ),
    Incidencia(
      sitio: 'Golden Alliance Legal',
      tipoEvento: 'Monitoreo normal',
      estado: 'Estable',
      detalles: 'Monitoreo normal · 180 ms',
      fecha: 'AYER',
      fechaReal: DateTime(2026, 6, 24),
      hora: '09:05',
      duracion: 'N/A',
      codigoHttp: 'HTTP 200',
      descripcion:
          'El sistema funciona de acuerdo con las métricas de rendimiento establecidas.',
      horaRestauracion: 'N/A',
    ),
  ];

  // Variables de filtrado actuales activos en la UI
  List<Incidencia> _incidenciasFiltradas = [];
  String _rangoSeleccionado = '';
  DateTime? _fechaInicioFiltro;
  DateTime? _fechaFinFiltro;
  bool _filtroCaidas = false;
  bool _filtroAdvertencias = false;
  bool _filtroRestauraciones = false;
  String _busquedaSitio = '';

  @override
  void initState() {
    super.initState();
    _aplicarFiltrosInternos();
  }

  // Obtiene la lista ordenada de nombres únicos de los sitios de tus incidencias disponibles
  List<String> get _listaNombresSitios {
    return _todasLasIncidencias.map((e) => e.sitio).toSet().toList()..sort();
  }

  void _aplicarFiltrosInternos() {
    setState(() {
      _incidenciasFiltradas = _todasLasIncidencias.where((item) {
        // Filtrado por Tipo de Evento / Estado
        bool tieneFiltroTipo =
            _filtroCaidas || _filtroAdvertencias || _filtroRestauraciones;
        if (tieneFiltroTipo) {
          if (item.estado == 'Caído' && !_filtroCaidas) return false;
          if (item.estado == 'Lento' && !_filtroAdvertencias) return false;
          if (item.estado == 'Estable' && !_filtroRestauraciones) return false;
        }

        // Filtrado por Selección Exacta del Desplegable de Sitio
        if (_busquedaSitio.isNotEmpty && item.sitio != _busquedaSitio) {
          return false;
        }

        // Filtrado por Rango de Tiempo
        final hoy = DateTime(2026, 6, 25);
        if (_rangoSeleccionado == 'Hoy') {
          return item.fechaReal.year == hoy.year &&
              item.fechaReal.month == hoy.month &&
              item.fechaReal.day == hoy.day;
        } else if (_rangoSeleccionado == 'Últimos 7 días') {
          final limiteSieteDias = hoy.subtract(const Duration(days: 7));
          return item.fechaReal.isAfter(limiteSieteDias) ||
              item.fechaReal.isAtSameMomentAs(limiteSieteDias);
        } else if (_rangoSeleccionado == 'Personalizado') {
          if (_fechaInicioFiltro != null &&
              item.fechaReal.isBefore(_fechaInicioFiltro!)) {
            return false;
          }
          if (_fechaFinFiltro != null &&
              item.fechaReal.isAfter(_fechaFinFiltro!)) {
            return false;
          }
        }
        return true;
      }).toList();
    });
  }

  int get _countEstables =>
      _todasLasIncidencias.where((e) => e.estado == 'Estable').length;
  int get _countLentos =>
      _todasLasIncidencias.where((e) => e.estado == 'Lento').length;
  int get _countCaidas =>
      _todasLasIncidencias.where((e) => e.estado == 'Caído').length;

  @override
  Widget build(BuildContext context) {
    final incidenciasHoy = _incidenciasFiltradas
        .where((e) => e.fecha == 'HOY')
        .toList();
    final incidenciasAyer = _incidenciasFiltradas
        .where((e) => e.fecha == 'AYER')
        .toList();
    final otrasIncidencias = _incidenciasFiltradas
        .where((e) => e.fecha != 'HOY' && e.fecha != 'AYER')
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F5),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // CABECERA
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Text(
                            'Códice',
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
                      GestureDetector(
                        onTap: _mostrarFiltroHistorial,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE5E5E5)),
                          ),
                          child: const Icon(
                            Icons.filter_list,
                            color: Color(0xFF141414),
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // CUERPO EN SCROLL
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // RESUMEN CARD
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Resumen — últimos 7 días',
                                    style: TextStyle(
                                      fontFamily: 'GeistMono',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Color(0xFF141414),
                                    ),
                                  ),
                                  Text(
                                    '${_todasLasIncidencias.length} sitios',
                                    style: const TextStyle(
                                      fontFamily: 'GeistMono',
                                      fontSize: 13,
                                      color: Color(0xFF737373),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildMetricaItem(
                                    _countEstables.toString(),
                                    'Estables',
                                    const Color(0xFF12AC6E),
                                  ),
                                  _buildMetricaItem(
                                    _countLentos.toString(),
                                    'Lentos',
                                    const Color(0xFFF5A524),
                                  ),
                                  _buildMetricaItem(
                                    _countCaidas.toString(),
                                    'Caídas',
                                    const Color(0xFFE53E3E),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ACTIVIDAD RECIENTE CONTAINER
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Actividad reciente',
                                    style: TextStyle(
                                      fontFamily: 'GeistMono',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF141414),
                                    ),
                                  ),
                                  Text(
                                    'todos los sitios'.toUpperCase(),
                                    style: const TextStyle(
                                      fontFamily: 'GeistMono',
                                      fontSize: 11,
                                      color: Color(0xFF737373),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              if (incidenciasHoy.isNotEmpty) ...[
                                _buildHeaderSeccion('HOY'),
                                ...incidenciasHoy.map(
                                  (item) => _buildItemIncidencia(item),
                                ),
                              ],

                              if (incidenciasAyer.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                _buildHeaderSeccion('AYER'),
                                ...incidenciasAyer.map(
                                  (item) => _buildItemIncidencia(item),
                                ),
                              ],

                              if (otrasIncidencias.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                _buildHeaderSeccion('ANTERIORES'),
                                ...otrasIncidencias.map(
                                  (item) => _buildItemIncidencia(item),
                                ),
                              ],

                              if (_incidenciasFiltradas.isEmpty)
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 40.0,
                                    ),
                                    child: Text(
                                      'No hay eventos con los filtros actuales.',
                                      style: TextStyle(
                                        fontFamily: 'GeistMono',
                                        color: Color(0xFF737373),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                MenuNavegacionGlobal(paginaActual: 1),
              ],
            ),
          ),

          if (isBlurred)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(color: Colors.black.withOpacity(0.08)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMetricaItem(String valor, String etiqueta, Color color) {
    return Column(
      children: [
        Text(
          valor,
          style: TextStyle(
            fontFamily: 'GeistMono',
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          etiqueta,
          style: const TextStyle(
            fontFamily: 'GeistMono',
            fontSize: 12,
            color: Color(0xFF737373),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderSeccion(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
      child: Text(
        titulo,
        style: const TextStyle(
          fontFamily: 'GeistMono',
          fontSize: 11,
          color: Color(0xFF737373),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildItemIncidencia(Incidencia item) {
    Color colorIndicador;
    Color colorFondoTag;
    Color colorTextoTag;
    if (item.estado == 'Caído') {
      colorIndicador = const Color(0xFFE53E3E);
      colorFondoTag = const Color(0xFFFCE4E4);
      colorTextoTag = const Color(0xFFE53E3E);
    } else if (item.estado == 'Lento') {
      colorIndicador = const Color(0xFFF5A524);
      colorFondoTag = const Color(0xFFFEF3D6);
      colorTextoTag = const Color(0xFFF5A524);
    } else {
      colorIndicador = const Color(0xFF12AC6E);
      colorFondoTag = const Color(0xFFC7FFD1);
      colorTextoTag = const Color(0xFF025E45);
    }

    return InkWell(
      onTap: () => _mostrarDetalleIncidencia(item),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, right: 12.0),
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: colorIndicador,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.sitio,
                              style: const TextStyle(
                                fontFamily: 'GeistMono',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xFF141414),
                              ),
                            ),
                          ),
                          Text(
                            item.hora,
                            style: const TextStyle(
                              fontFamily: 'GeistMono',
                              fontSize: 12,
                              color: Color(0xFFA3A3A3),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.detalles,
                              style: const TextStyle(
                                fontFamily: 'GeistMono',
                                fontSize: 12,
                                color: Color(0xFF737373),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colorFondoTag,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: colorTextoTag,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  item.estado,
                                  style: TextStyle(
                                    fontFamily: 'GeistMono',
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: colorTextoTag,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 22.0, top: 10.0),
              child: Divider(color: Color(0xFFF4F4F5), height: 1),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDetalleIncidencia(Incidencia item) {
    Color colorBarra = item.estado == 'Caído'
        ? const Color(0xFFE53E3E)
        : (item.estado == 'Lento'
              ? const Color(0xFFF5A524)
              : const Color(0xFF12AC6E));
    setState(() => isBlurred = true);

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black26.withOpacity(0.15),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE5E5E5), width: 1.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 4,
                                height: 16,
                                color: colorBarra,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Descripción del error',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'GeistMono',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE53E3E),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              setState(() => isBlurred = false);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F4F5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Color(0xFF737373),
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _filaDetalle('Incidencia', item.tipoEvento),
                      const Divider(color: Color(0xFFE5E5E5), height: 1),
                      _filaDetalle('Fecha / Hora', '15/04/2026 - 14:00'),
                      const Divider(color: Color(0xFFE5E5E5), height: 1),
                      _filaDetalle('Duración', item.duracion),
                      const Divider(color: Color(0xFFE5E5E5), height: 1),
                      _filaDetalle('Código', item.codigoHttp),
                      const SizedBox(height: 16),
                      Text(
                        item.descripcion,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'GeistMono',
                          color: Color(0xFF737373),
                          height: 1.5,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC7FFD1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              color: Color(0xFF025E45),
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Resuelto - servicio restablecido a las ${item.horaRestauracion}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'GeistMono',
                                  color: Color(0xFF025E45),
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
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
            ),
          ),
        );
      },
    );
  }

  Widget _filaDetalle(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 13,
              fontFamily: 'GeistMono',
              color: Color(0xFF737373),
              decoration: TextDecoration.none,
            ),
          ),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 13,
              fontFamily: 'GeistMono',
              color: Color(0xFF141414),
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // FILTRAR HISTORIAL DIALOG (MENÚ DESPLEGABLE DE SITIOS ACTUALIZADO)
  // =========================================================================
  void _mostrarFiltroHistorial() {
    setState(() => isBlurred = true);

    // Estado local limpio al iniciar el modal
    String localRango = '';
    DateTime? localInicio;
    DateTime? localFin;
    bool localCaidas = false;
    bool localAdvertencias = false;
    bool localRestauraciones = false;

    // Almacenará el nombre del sitio seleccionado desde el desplegable (vacío significa todos)
    String localSitioSeleccionado = '';

    String formatoFecha(DateTime? f) {
      if (f == null) return '  /   /      ';
      return '${f.day.toString().padLeft(2, '0')} / ${f.month.toString().padLeft(2, '0')} / ${f.year}';
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black26.withOpacity(0.15),
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
                  border: Border.all(color: const Color(0xFFE5E5E5), width: 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // CABECERA DEL FILTRO
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Filtrar historial',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'GeistMono',
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF141414),
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Acota el feed por fecha, tipo\nde evento y sitio.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'GeistMono',
                                      color: Color(0xFF737373),
                                      decoration: TextDecoration.none,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
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

                          // SECCIÓN: RANGO DE TIEMPO
                          _seccionTituloFiltro('RANGO DE TIEMPO'),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildChipRango(
                                'Hoy',
                                localRango,
                                () => setModalState(() => localRango = 'Hoy'),
                              ),
                              _buildChipRango(
                                'Últimos 7 días',
                                localRango,
                                () => setModalState(
                                  () => localRango = 'Últimos 7 días',
                                ),
                              ),
                              _buildChipRango(
                                'Personalizado',
                                localRango,
                                () => setModalState(
                                  () => localRango = 'Personalizado',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // CAMPOS FECHA INICIO / FIN
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _seccionTituloFiltro('FECHA DE INICIO'),
                                    const SizedBox(height: 6),
                                    GestureDetector(
                                      onTap: localRango != 'Personalizado'
                                          ? null
                                          : () async {
                                              DateTime? picked =
                                                  await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime(
                                                      2026,
                                                      6,
                                                      25,
                                                    ),
                                                    firstDate: DateTime(2020),
                                                    lastDate: DateTime(2030),
                                                  );
                                              if (picked != null)
                                                setModalState(
                                                  () => localInicio = picked,
                                                );
                                            },
                                      child: Opacity(
                                        opacity: localRango == 'Personalizado'
                                            ? 1.0
                                            : 0.4,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: const Color(0xFFE5E5E5),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.calendar_today_outlined,
                                                size: 16,
                                                color: Color(0xFF737373),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                formatoFecha(localInicio),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'GeistMono',
                                                  color: Color(0xFF141414),
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _seccionTituloFiltro('FECHA DE FIN'),
                                    const SizedBox(height: 6),
                                    GestureDetector(
                                      onTap: localRango != 'Personalizado'
                                          ? null
                                          : () async {
                                              DateTime? picked =
                                                  await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime(
                                                      2026,
                                                      6,
                                                      25,
                                                    ),
                                                    firstDate: DateTime(2020),
                                                    lastDate: DateTime(2030),
                                                  );
                                              if (picked != null)
                                                setModalState(
                                                  () => localFin = picked,
                                                );
                                            },
                                      child: Opacity(
                                        opacity: localRango == 'Personalizado'
                                            ? 1.0
                                            : 0.4,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: const Color(0xFFE5E5E5),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.calendar_today_outlined,
                                                size: 16,
                                                color: Color(0xFF737373),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                formatoFecha(localFin),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'GeistMono',
                                                  color: Color(0xFF141414),
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // TIPO DE EVENTO
                          _seccionTituloFiltro('TIPO DE EVENTO'),
                          const SizedBox(height: 8),
                          Wrap(
                            direction: Axis.vertical,
                            spacing: 8,
                            children: [
                              _buildCheckboxRow(
                                'Caídas',
                                localCaidas,
                                const Color(0xFFE53E3E),
                                const Color(0xFFFCE4E4),
                                (val) {
                                  setModalState(() => localCaidas = val!);
                                },
                              ),
                              _buildCheckboxRow(
                                'Advertencias',
                                localAdvertencias,
                                const Color(0xFFF5A524),
                                const Color(0xFFFEF3D6),
                                (val) {
                                  setModalState(() => localAdvertencias = val!);
                                },
                              ),
                              _buildCheckboxRow(
                                'Restauraciones',
                                localRestauraciones,
                                const Color(0xFF12AC6E),
                                const Color(0xFFC7FFD1),
                                (val) {
                                  setModalState(
                                    () => localRestauraciones = val!,
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // NUEVA BARRA DESPLEGABLE CORREGIDA: FILTRAR POR SITIO
                          _seccionTituloFiltro('FILTRAR POR SITIO'),
                          const SizedBox(height: 8),
                          Material(
                            color: Colors.transparent,
                            child: DropdownButtonFormField<String>(
                              value: localSitioSeleccionado.isEmpty
                                  ? ''
                                  : localSitioSeleccionado,
                              style: const TextStyle(
                                fontFamily: 'GeistMono',
                                fontSize: 13,
                                color: Color(0xFF141414),
                              ),
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Color(0xFF737373),
                              ),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Color(0xFF737373),
                                  size: 18,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 12,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE5E5E5),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE5E5E5),
                                  ),
                                ),
                              ),
                              items: [
                                const DropdownMenuItem<String>(
                                  value: '',
                                  child: Text(
                                    'Buscar sitio – todos',
                                    style: TextStyle(color: Color(0xFFA3A3A3)),
                                  ),
                                ),
                                ..._listaNombresSitios.map((String sitio) {
                                  return DropdownMenuItem<String>(
                                    value: sitio,
                                    child: Text(sitio),
                                  );
                                }),
                              ],
                              onChanged: (String? nuevoSitio) {
                                setModalState(() {
                                  localSitioSeleccionado = nuevoSitio ?? '';
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 24),

                          // ACCIONES DE FILTRO
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    setModalState(() {
                                      localRango = '';
                                      localInicio = null;
                                      localFin = null;
                                      localCaidas = false;
                                      localAdvertencias = false;
                                      localRestauraciones = false;
                                      localSitioSeleccionado = '';
                                    });
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
                                    'Limpiar',
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
                                      _rangoSeleccionado = localRango;
                                      _fechaInicioFiltro = localInicio;
                                      _fechaFinFiltro = localFin;
                                      _filtroCaidas = localCaidas;
                                      _filtroAdvertencias = localAdvertencias;
                                      _filtroRestauraciones =
                                          localRestauraciones;
                                      _busquedaSitio = localSitioSeleccionado;
                                      isBlurred = false;
                                    });
                                    _aplicarFiltrosInternos();
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF5CE67E),
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: const Text(
                                    'Aplicar filtros',
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
            );
          },
        );
      },
    );
  }

  Widget _seccionTituloFiltro(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontFamily: 'GeistMono',
        color: Color(0xFF737373),
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        decoration: TextDecoration.none,
      ),
    );
  }

  Widget _buildChipRango(String titulo, String activo, VoidCallback onTap) {
    bool esSeleccionado = titulo == activo;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: esSeleccionado ? const Color(0xFFC7FFD1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: esSeleccionado
                ? const Color(0xFF12AC6E)
                : const Color(0xFFE5E5E5),
          ),
        ),
        child: Text(
          titulo,
          style: TextStyle(
            fontFamily: 'GeistMono',
            fontSize: 13,
            fontWeight: esSeleccionado ? FontWeight.bold : FontWeight.normal,
            color: esSeleccionado
                ? const Color(0xFF025E45)
                : const Color(0xFF141414),
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCheckboxRow(
    String etiqueta,
    bool checked,
    Color colorRama,
    Color fondoActivo,
    ValueChanged<bool?> onChanged,
  ) {
    return GestureDetector(
      onTap: () => onChanged(!checked),
      child: IntrinsicWidth(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: checked ? fondoActivo : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: checked ? colorRama : const Color(0xFFE5E5E5),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: colorRama,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                etiqueta,
                style: const TextStyle(
                  fontFamily: 'GeistMono',
                  fontSize: 13,
                  color: Color(0xFF141414),
                  decoration: TextDecoration.none,
                ),
              ),
              if (checked) ...[
                const SizedBox(width: 8),
                Icon(Icons.check, size: 14, color: colorRama),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
