import 'package:flutter/material.dart';

class ReportesPage extends StatefulWidget {
  const ReportesPage({super.key});

  @override
  State<ReportesPage> createState() => _ReportesPageState();
}

class _ReportesPageState extends State<ReportesPage> {
  bool _filtroUltimos7Dias = true;
  bool _filtroEstable = false;
  bool _filtroLento = false;
  bool _filtroCaido = false;

  final List<RegistroEstadoSitio> _historialMaster = [
    RegistroEstadoSitio(
      nombre: 'Grupo APE',
      latencia: '200ms',
      uptime: '99.9%',
      estado: 'Estable',
      fechaRegistro: 'Hoy, 10:00 AM',
    ),
    RegistroEstadoSitio(
      nombre: 'EzSafe',
      latencia: '870ms',
      uptime: '97.4%',
      estado: 'Lento',
      fechaRegistro: 'Hoy, 09:45 AM',
    ),
    RegistroEstadoSitio(
      nombre: 'Witchie Watches',
      latencia: '—',
      uptime: '94.1%',
      estado: 'Caído',
      fechaRegistro: 'Hoy, 09:30 AM',
    ),
    RegistroEstadoSitio(
      nombre: 'Grupo APE',
      latencia: '180ms',
      uptime: '99.9%',
      estado: 'Estable',
      fechaRegistro: 'Ayer, 06:12 PM',
    ),
    RegistroEstadoSitio(
      nombre: 'EzSafe',
      latencia: '920ms',
      uptime: '96.2%',
      estado: 'Lento',
      fechaRegistro: 'Ayer, 04:20 PM',
    ),
    RegistroEstadoSitio(
      nombre: 'Witchie Watches',
      latencia: '1200ms',
      uptime: '94.1%',
      estado: 'Lento',
      fechaRegistro: 'Ayer, 02:15 PM',
    ),
    RegistroEstadoSitio(
      nombre: 'Grupo APE',
      latencia: '—',
      uptime: '98.5%',
      estado: 'Caído',
      fechaRegistro: '12 Jun, 11:00 AM',
    ),
  ];

  late List<RegistroEstadoSitio> _historialFiltrado;

  @override
  void initState() {
    super.initState();
    _historialFiltrado = List.from(_historialMaster);
  }

  void _aplicarFiltrado() {
    setState(() {
      _historialFiltrado = _historialMaster.where((registro) {
        final dentroDeLosUltimos7Dias =
            !_filtroUltimos7Dias ||
            registro.fechaRegistro.startsWith('Hoy') ||
            registro.fechaRegistro.startsWith('Ayer');

        if (!dentroDeLosUltimos7Dias) {
          return false;
        }

        if (!_filtroEstable && !_filtroLento && !_filtroCaido) {
          return true;
        }

        if (_filtroEstable && registro.estado == 'Estable') {
          return true;
        }
        if (_filtroLento && registro.estado == 'Lento') {
          return true;
        }
        if (_filtroCaido && registro.estado == 'Caído') {
          return true;
        }
        return false;
      }).toList();
    });
  }

  void _limpiarFiltros() {
    setState(() {
      _filtroUltimos7Dias = true;
      _filtroEstable = false;
      _filtroLento = false;
      _filtroCaido = false;
      _historialFiltrado = List.from(_historialMaster);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F5),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Text(
                        'Códice',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF141414),
                        ),
                      ),
                      Text(
                        '/',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF12AC6E),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: _mostrarExportar,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E5E5)),
                      ),
                      child: const Icon(
                        Icons.download_outlined,
                        color: Color(0xFF141414),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildPillFiltro(
                          'Últimos 7 días',
                          icon: Icons.access_time,
                          seleccionado: _filtroUltimos7Dias,
                          onTap: () {
                            setState(() {
                              _filtroUltimos7Dias = true;
                            });
                            _aplicarFiltrado();
                          },
                        ),
                        _buildPillFiltro(
                          'Todos los sitios',
                          seleccionado: !_filtroUltimos7Dias,
                          onTap: () {
                            setState(() {
                              _filtroUltimos7Dias = false;
                            });
                            _aplicarFiltrado();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        InkWell(
                          onTap: _aplicarFiltrado,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF141414),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.tune, color: Colors.white, size: 16),
                                SizedBox(width: 8),
                                Text(
                                  'Filtrar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: _limpiarFiltros,
                          child: const Text(
                            'Limpiar filtros',
                            style: TextStyle(
                              color: Color(0xFF12AC6E),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'FILTRAR POR ESTATUS',
                                style: TextStyle(
                                  color: Color(0xFF737373),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Selecciona',
                                style: TextStyle(
                                  color: Color(0xFF737373),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildTagEstatus(
                                'Estable',
                                const Color(0xFF12AC6E),
                                const Color(0xFFC7FFD1),
                                _filtroEstable,
                                () => setState(
                                  () => _filtroEstable = !_filtroEstable,
                                ),
                              ),
                              _buildTagEstatus(
                                'Lento',
                                const Color(0xFFF5A524),
                                const Color(0xFFFEF3D6),
                                _filtroLento,
                                () => setState(
                                  () => _filtroLento = !_filtroLento,
                                ),
                              ),
                              _buildTagEstatus(
                                'Caído',
                                const Color(0xFFE53E3E),
                                const Color(0xFFFCE4E4),
                                _filtroCaido,
                                () => setState(
                                  () => _filtroCaido = !_filtroCaido,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Estado general',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF141414),
                                ),
                              ),
                              Text(
                                'Últimos reportes',
                                style: TextStyle(
                                  color: Color(0xFF737373),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: CustomPaint(
                                  painter: DonutChartPainter(),
                                  child: const Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '7',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF141414),
                                          ),
                                        ),
                                        Text(
                                          'ESTABLES',
                                          style: TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF737373),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLeyendaDona(
                                      'Estables',
                                      '7',
                                      const Color(0xFF12AC6E),
                                    ),
                                    const SizedBox(height: 10),
                                    _buildLeyendaDona(
                                      'En revisión',
                                      '1',
                                      const Color(0xFFF5A524),
                                    ),
                                    const SizedBox(height: 10),
                                    _buildLeyendaDona(
                                      'Con error',
                                      '1',
                                      const Color(0xFFE53E3E),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Tiempo de respuesta',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF141414),
                                ),
                              ),
                              Text(
                                'prom. ms',
                                style: TextStyle(
                                  color: Color(0xFF737373),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Row(
                              children: const [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    'SITIO',
                                    style: TextStyle(
                                      color: Color(0xFF737373),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'LATENCIA',
                                    style: TextStyle(
                                      color: Color(0xFF737373),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'UPTIME',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Color(0xFF737373),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Divider(color: Color(0xFFE5E5E5)),
                          if (_historialFiltrado.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: Text(
                                  'No hay registros con este filtro',
                                  style: TextStyle(
                                    color: Color(0xFF737373),
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            )
                          else
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _historialFiltrado.length,
                              itemBuilder: (context, index) {
                                return _buildFilaTablaSitio(
                                  _historialFiltrado[index],
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPillFiltro(
    String texto, {
    IconData? icon,
    required bool seleccionado,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: seleccionado ? const Color(0xFFE8FFF0) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: seleccionado
                ? const Color(0xFF12AC6E)
                : const Color(0xFFE5E5E5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: const Color(0xFF12AC6E)),
              const SizedBox(width: 6),
            ],
            Text(
              texto,
              style: TextStyle(
                color: seleccionado
                    ? const Color(0xFF12AC6E)
                    : const Color(0xFF141414),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagEstatus(
    String titulo,
    Color color,
    Color background,
    bool seleccionado,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: seleccionado ? background : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: seleccionado ? color : const Color(0xFFE5E5E5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              titulo,
              style: const TextStyle(
                color: Color(0xFF141414),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (seleccionado) ...[
              const SizedBox(width: 6),
              Icon(Icons.check, size: 14, color: color),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLeyendaDona(String etiqueta, String conteo, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            etiqueta,
            style: const TextStyle(color: Color(0xFF737373), fontSize: 13),
          ),
        ),
        Text(
          conteo,
          style: const TextStyle(
            color: Color(0xFF141414),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFilaTablaSitio(RegistroEstadoSitio registro) {
    final Color tagFondo = registro.estado == 'Caído'
        ? const Color(0xFFFCE4E4)
        : registro.estado == 'Lento'
        ? const Color(0xFFFEF3D6)
        : const Color(0xFFC7FFD1);
    final Color tagTexto = registro.estado == 'Caído'
        ? const Color(0xFFE53E3E)
        : registro.estado == 'Lento'
        ? const Color(0xFFF5A524)
        : const Color(0xFF025E45);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  registro.nombre,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF141414),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  registro.fechaRegistro,
                  style: const TextStyle(
                    color: Color(0xFF737373),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              registro.latencia,
              style: const TextStyle(color: Color(0xFF404040), fontSize: 13),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: tagFondo,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  registro.uptime,
                  style: TextStyle(
                    color: tagTexto,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  void _mostrarExportar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Función de exportar aún no disponible.')),
    );
  }
}

class RegistroEstadoSitio {
  final String nombre;
  final String latencia;
  final String uptime;
  final String estado;
  final String fechaRegistro;

  RegistroEstadoSitio({
    required this.nombre,
    required this.latencia,
    required this.uptime,
    required this.estado,
    required this.fechaRegistro,
  });
}

class DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paintBackground = Paint()
      ..color = const Color(0xFFE5E5E5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;
    final paintForeground = Paint()
      ..color = const Color(0xFF12AC6E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - 6, paintBackground);
    final sweepAngle = 2 * 3.141592653589793 * 0.75;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 6),
      -3.141592653589793 / 2,
      sweepAngle,
      false,
      paintForeground,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
