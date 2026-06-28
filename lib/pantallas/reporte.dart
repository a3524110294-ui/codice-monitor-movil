import 'package:flutter/material.dart';
import 'dart:ui';
import 'inicio.dart';// 
import 'login.dart';
import 'historial.dart';

// =========================================================================
// MODELOS DE DATOS AUXILIARES
// =========================================================================
class ReporteSitio {
  final String nombre;
  final String latencia;
  final String uptime;
  final String estado; // 'Estable', 'Lento', 'Caído'

  ReporteSitio({
    required this.nombre,
    required this.latencia,
    required this.uptime,
    required this.estado,
  });
}

class HistorialError {
  final String titulo;
  final String duracion;
  final double porcentajeBarra; 
  final String tipo; 

  HistorialError({
    required this.titulo,
    required this.duracion,
    required this.porcentajeBarra,
    required this.tipo,
  });
}

// =========================================================================
// PANTALLA PRINCIPAL: REPORTES PAGE
// =========================================================================
class ReportesPage extends StatefulWidget {
  const ReportesPage({super.key});

  @override
  State<ReportesPage> createState() => _ReportesPageState();
}

class _ReportesPageState extends State<ReportesPage> {
  bool isBlurred = false;

  // REQUERIMIENTO: Estados de selección inicializados en FALSE (desmarcados por defecto)
  bool _filtroEstableSeleccionado = false;
  bool _filtroLentoSeleccionado = false;
  bool _filtroCaidoSeleccionado = false;

  // Fuente de datos maestra (Inalterable)
  final List<ReporteSitio> _sitiosMaster = [
    ReporteSitio(nombre: 'Grupo APE', latencia: '200ms', uptime: '99.9%', estado: 'Estable'),
    ReporteSitio(nombre: 'EzSafe', latencia: '870ms', uptime: '97.4%', estado: 'Lento'),
    ReporteSitio(nombre: 'Witchie Watches', latencia: '—', uptime: '94.1%', estado: 'Caído'),
  ];

  // Lista mutada que se renderiza en la tabla de abajo
  List<ReporteSitio> _sitiosFiltrados = [];

  @override
  void initState() {
    super.initState();
    // Al inicio se despliegan todos los elementos
    _sitiosFiltrados = List.from(_sitiosMaster);
  }

  // REQUERIMIENTO: Lógica para ejecutar el filtrado real al presionar el botón
  void _aplicarFiltradoPorEstatus() {
    setState(() {
      // Si no hay ninguna casilla seleccionada, interpretamos que muestra todo
      if (!_filtroEstableSeleccionado && !_filtroLentoSeleccionado && !_filtroCaidoSeleccionado) {
        _sitiosFiltrados = List.from(_sitiosMaster);
        return;
      }

      // En caso contrario, filtra los objetos que coincidan con las selecciones activas
      _sitiosFiltrados = _sitiosMaster.where((sitio) {
        if (_filtroEstableSeleccionado && sitio.estado == 'Estable') return true;
        if (_filtroLentoSeleccionado && sitio.estado == 'Lento') return true;
        if (_filtroCaidoSeleccionado && sitio.estado == 'Caído') return true;
        return false;
      }).toList();
    });
  }

  // Funcionalidad para resetear los filtros por completo
  void _limpiarFiltros() {
    setState(() {
      _filtroEstableSeleccionado = false;
      _filtroLentoSeleccionado = false;
      _filtroCaidoSeleccionado = false;
      _sitiosFiltrados = List.from(_sitiosMaster);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F5),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // CABECERA SUPERIOR
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Text('Códice', style: TextStyle(fontFamily: 'GeistMono', fontWeight: FontWeight.bold, fontSize: 24, color: Color(0xFF141414))),
                          Text('/', style: TextStyle(fontFamily: 'GeistMono', fontWeight: FontWeight.bold, fontSize: 24, color: Color(0xFF12AC6E))),
                        ],
                      ),
                      GestureDetector(
                        onTap: _mostrarOpcionesExportar,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE5E5E5)),
                          ),
                          child: const Icon(Icons.download_outlined, color: Color(0xFF141414), size: 20),
                        ),
                      )
                    ],
                  ),
                ),

                // CONTENIDO EN SCROLL
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        // BOTONES DE FILTROS RÁPIDOS
                        Row(
                          children: [
                            _buildPillFiltro('Últimos 7 días', icon: Icons.access_time),
                            const SizedBox(width: 8),
                            _buildPillFiltro('Todos los sitios'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        
                        // REQUERIMIENTO: BOTÓN INTERACTIVO "FILTRAR" (Aplica los cambios al pulsarse)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: _aplicarFiltradoPorEstatus,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(color: const Color(0xFF141414), borderRadius: BorderRadius.circular(20)),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.tune, color: Colors.white, size: 16),
                                  SizedBox(width: 6),
                                  Text('Filtrar', style: TextStyle(fontFamily: 'GeistMono', color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                  SizedBox(width: 4),
                                  Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // CARD: FILTRAR POR ESTATUS
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('FILTRAR POR ESTATUS', style: TextStyle(fontFamily: 'GeistMono', fontSize: 11, color: const Color(0xFF737373).withOpacity(0.8), fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                                  GestureDetector(
                                    onTap: _limpiarFiltros,
                                    child: const Text('Limpiar', style: TextStyle(fontFamily: 'GeistMono', fontSize: 12, color: Color(0xFF12AC6E), fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _buildTagEstatus(
                                    'Estable', 
                                    const Color(0xFF12AC6E), 
                                    const Color(0xFFC7FFD1), 
                                    _filtroEstableSeleccionado,
                                    () => setState(() => _filtroEstableSeleccionado = !_filtroEstableSeleccionado)
                                  ),
                                  _buildTagEstatus(
                                    'Lento', 
                                    const Color(0xFFF5A524), 
                                    const Color(0xFFFEF3D6), 
                                    _filtroLentoSeleccionado,
                                    () => setState(() => _filtroLentoSeleccionado = !_filtroLentoSeleccionado)
                                  ),
                                  _buildTagEstatus(
                                    'Caído', 
                                    const Color(0xFFE53E3E), 
                                    const Color(0xFFFCE4E4), 
                                    _filtroCaidoSeleccionado,
                                    () => setState(() => _filtroCaidoSeleccionado = !_filtroCaidoSeleccionado)
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // CARD: ESTADO GENERAL
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Estado general', style: TextStyle(fontFamily: 'GeistMono', fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF141414))),
                                  Text('${_sitiosMaster.length} sitios', style: const TextStyle(fontFamily: 'GeistMono', fontSize: 13, color: Color(0xFF737373))),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CustomPaint(
                                          size: const Size(100, 100),
                                          painter: DonutChartPainter(),
                                        ),
                                        const Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('7', style: TextStyle(fontFamily: 'GeistMono', fontWeight: FontWeight.bold, fontSize: 22, color: Color(0xFF141414))),
                                            Text('ESTABLES', style: TextStyle(fontFamily: 'GeistMono', fontSize: 8, color: Color(0xFF737373), fontWeight: FontWeight.bold)),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildLeyendaDona('Estables', '7', const Color(0xFF12AC6E)),
                                      const SizedBox(height: 10),
                                      _buildLeyendaDona('En revisión', '1', const Color(0xFFF5A524)),
                                      const SizedBox(height: 10),
                                      _buildLeyendaDona('Con error', '1', const Color(0xFFE53E3E)),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // CARD: TIEMPO DE RESPUESTA (TABLA CON FILTRADO REAL APLICADO)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Tiempo de respuesta', style: TextStyle(fontFamily: 'GeistMono', fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF141414))),
                                  Text('prom. ms', style: const TextStyle(fontFamily: 'GeistMono', fontSize: 12, color: Color(0xFF737373))),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.0),
                                child: Row(
                                  children: [
                                    Expanded(flex: 3, child: Text('SITIO', style: TextStyle(fontFamily: 'GeistMono', fontSize: 11, color: Color(0xFFA3A3A3), fontWeight: FontWeight.bold))),
                                    Expanded(flex: 2, child: Text('LATENCIA', style: TextStyle(fontFamily: 'GeistMono', fontSize: 11, color: Color(0xFFA3A3A3), fontWeight: FontWeight.bold), textAlign: TextAlign.left)),
                                    Expanded(flex: 2, child: Text('UPTIME', style: TextStyle(fontFamily: 'GeistMono', fontSize: 11, color: Color(0xFFA3A3A3), fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Divider(color: Color(0xFFE5E5E5)),
                              
                              // Mensaje adaptativo si no se encuentran elementos bajo el criterio
                              if (_sitiosFiltrados.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 24.0),
                                  child: Center(child: Text('No hay sitios con este estatus', style: TextStyle(fontFamily: 'GeistMono', fontSize: 13, color: Color(0xFF737373)))),
                                )
                              else
                                ..._sitiosFiltrados.map((sitio) => _buildFilaTablaSitio(sitio)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                const MenuNavegacionGlobal(paginaActual: 2),
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

  Widget _buildPillFiltro(String texto, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF12AC6E)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 15, color: const Color(0xFF12AC6E)), const SizedBox(width: 6)],
          Text(texto, style: const TextStyle(fontFamily: 'GeistMono', fontSize: 13, color: Color(0xFF12AC6E), fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // REQUERIMIENTO: El Tag cambia su diseño reflejando de forma precisa si está seleccionado o no
  Widget _buildTagEstatus(String titulo, Color color, Color fondo, bool seleccionado, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: seleccionado ? fondo : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: seleccionado ? color : const Color(0xFFE5E5E5), width: 1.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(titulo, style: const TextStyle(fontFamily: 'GeistMono', fontSize: 13, color: Color(0xFF141414))),
            if (seleccionado) ...[
              const SizedBox(width: 6),
              Icon(Icons.check, size: 14, color: color),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildLeyendaDona(String etiqueta, String conteo, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 10),
        SizedBox(width: 90, child: Text(etiqueta, style: const TextStyle(fontFamily: 'GeistMono', fontSize: 13, color: Color(0xFF737373)))),
        Text(conteo, style: const TextStyle(fontFamily: 'GeistMono', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF141414))),
      ],
    );
  }

  Widget _buildFilaTablaSitio(ReporteSitio sitio) {
    Color tagFondo = sitio.estado == 'Caído' ? const Color(0xFFFCE4E4) : (sitio.estado == 'Lento' ? const Color(0xFFFEF3D6) : const Color(0xFFC7FFD1));
    Color tagTexto = sitio.estado == 'Caído' ? const Color(0xFFE53E3E) : (sitio.estado == 'Lento' ? const Color(0xFFF5A524) : const Color(0xFF025E45));

    return InkWell(
      onTap: () {
        if (sitio.estado == 'Caído') {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ReporteDetalleErroresPage(nombreSitio: sitio.nombre)));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 4.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(flex: 3, child: Text(sitio.nombre, style: const TextStyle(fontFamily: 'GeistMono', fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF141414)))),
                Expanded(flex: 2, child: Text(sitio.latencia, style: const TextStyle(fontFamily: 'GeistMono', fontSize: 13, color: Color(0xFF737373)))),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: tagFondo, borderRadius: BorderRadius.circular(12)),
                      child: Text(sitio.uptime, style: TextStyle(fontFamily: 'GeistMono', fontSize: 12, fontWeight: FontWeight.bold, color: tagTexto)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(color: Color(0xFFF4F4F5), height: 1),
          ],
        ),
      ),
    );
  }

  void _mostrarOpcionesExportar() {
    setState(() => isBlurred = true);

    String rangoSeleccionado = ''; 
    bool incluirEstables = false;
    bool incluirLentos = false;
    bool incluirCaidos = false;
    String formatoSeleccionado = ''; 

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
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Opciones de exportación', style: TextStyle(fontSize: 18, fontFamily: 'GeistMono', fontWeight: FontWeight.bold, color: Color(0xFF141414), decoration: TextDecoration.none)),
                                  SizedBox(height: 4),
                                  Text('Configura qué datos deseas\ndescargar de tus reportes.', style: TextStyle(fontSize: 12, fontFamily: 'GeistMono', color: Color(0xFF737373), decoration: TextDecoration.none, height: 1.3)),
                                ],
                              ),
                              GestureDetector(
                                onTap: () { Navigator.pop(context); setState(() => isBlurred = false); },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(color: const Color(0xFFF4F4F5), borderRadius: BorderRadius.circular(10)),
                                  child: const Icon(Icons.close, color: Color(0xFF737373), size: 16),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _tituloSeccionModal('RANGO DE DATOS'),
                          const SizedBox(height: 8),
                          _buildRadioButtonModal('Todo el historial', 'desde 2024', rangoSeleccionado == 'todo', () => setModalState(() => rangoSeleccionado = 'todo')),
                          const SizedBox(height: 8),
                          _buildRadioButtonModal('Últimos 7 días', '1-7 jun', rangoSeleccionado == '7dias', () => setModalState(() => rangoSeleccionado = '7dias')),
                          const SizedBox(height: 8),
                          _buildRadioButtonModal('Este mes', 'junio', rangoSeleccionado == 'mes', () => setModalState(() => rangoSeleccionado = 'mes')),
                          const SizedBox(height: 20),
                          _tituloSeccionModal('INCLUIR POR ESTATUS'),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildCheckboxModal('Estables', incluirEstables, const Color(0xFF12AC6E), const Color(0xFFC7FFD1), (val) => setModalState(() => incluirEstables = val!)),
                              _buildCheckboxModal('Lentos', incluirLentos, const Color(0xFFF5A524), const Color(0xFFFEF3D6), (val) => setModalState(() => incluirLentos = val!)),
                              _buildCheckboxModal('Caídos', incluirCaidos, const Color(0xFFE53E3E), const Color(0xFFFCE4E4), (val) => setModalState(() => incluirCaidos = val!)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _tituloSeccionModal('FORMATO DE ARCHIVO'),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _buildChipFormato('CSV', Icons.insert_drive_file_outlined, formatoSeleccionado == 'csv', () => setModalState(() => formatoSeleccionado = 'csv')),
                              const SizedBox(width: 8),
                              _buildChipFormato('PDF', Icons.picture_as_pdf_outlined, formatoSeleccionado == 'pdf', () => setModalState(() => formatoSeleccionado = 'pdf')),
                              const SizedBox(width: 8),
                              _buildChipFormato('Excel', Icons.table_chart_outlined, formatoSeleccionado == 'excel', () => setModalState(() => formatoSeleccionado = 'excel')),
                            ],
                          ),
                          const SizedBox(height: 26),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () { Navigator.pop(context); setState(() => isBlurred = false); },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFFE5E5E5)),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  ),
                                  child: const Text('Cancelar', style: TextStyle(fontFamily: 'GeistMono', color: Color(0xFF141414), fontWeight: FontWeight.bold, fontSize: 13)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    setState(() => isBlurred = false);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF5CE67E),
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.download, size: 16, color: Color(0xFF141414)),
                                      SizedBox(width: 6),
                                      Text('Exportar', style: TextStyle(fontFamily: 'GeistMono', color: Color(0xFF141414), fontWeight: FontWeight.bold, fontSize: 13)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
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

  Widget _tituloSeccionModal(String texto) {
    return Text(texto, style: const TextStyle(fontSize: 11, fontFamily: 'GeistMono', color: Color(0xFF737373), fontWeight: FontWeight.bold, letterSpacing: 0.5, decoration: TextDecoration.none));
  }

  Widget _buildRadioButtonModal(String titulo, String subtitulo, bool seleccionado, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: seleccionado ? const Color(0xFF12AC6E) : const Color(0xFFE5E5E5), width: seleccionado ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Icon(seleccionado ? Icons.radio_button_checked : Icons.radio_button_off, color: seleccionado ? const Color(0xFF12AC6E) : const Color(0xFFA3A3A3), size: 20),
            const SizedBox(width: 12),
            Text(titulo, style: const TextStyle(fontSize: 13, fontFamily: 'GeistMono', fontWeight: FontWeight.bold, color: Color(0xFF141414), decoration: TextDecoration.none)),
            const Spacer(),
            Text(subtitulo, style: const TextStyle(fontSize: 12, fontFamily: 'GeistMono', color: Color(0xFFA3A3A3), decoration: TextDecoration.none)),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxModal(String etiqueta, bool checked, Color colorRama, Color fondoActivo, ValueChanged<bool?> onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!checked),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: checked ? fondoActivo : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: checked ? colorRama : const Color(0xFFE5E5E5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 6, height: 6, decoration: BoxDecoration(color: colorRama, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(etiqueta, style: const TextStyle(fontFamily: 'GeistMono', fontSize: 13, color: Color(0xFF141414), decoration: TextDecoration.none)),
            if (checked) ...[
              const SizedBox(width: 6),
              Icon(Icons.check, size: 14, color: colorRama)
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildChipFormato(String extension, IconData icono, bool seleccionado, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: seleccionado ? Colors.white : const Color(0xFFF4F4F5).withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: seleccionado ? const Color(0xFF141414) : const Color(0xFFE5E5E5), width: seleccionado ? 1.5 : 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icono, size: 16, color: const Color(0xFF141414)),
              const SizedBox(width: 6),
              Text(extension, style: const TextStyle(fontFamily: 'GeistMono', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF141414), decoration: TextDecoration.none)),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================================
// PANTALLA SECUNDARIA: LISTADO DE ERRORES
// =========================================================================
class ReporteDetalleErroresPage extends StatefulWidget {
  final String nombreSitio;
  const ReporteDetalleErroresPage({super.key, required this.nombreSitio});

  @override
  State<ReporteDetalleErroresPage> createState() => _ReporteDetalleErroresPageState();
}

class _ReporteDetalleErroresPageState extends State<ReporteDetalleErroresPage> {
  bool isInnerBlurred = false;

  final List<HistorialError> _listaErrores = [
    HistorialError(titulo: 'Caída del servidor', duracion: '3h 15m', porcentajeBarra: 1.0, tipo: 'Caído'),
    HistorialError(titulo: 'Error 500', duracion: '48m', porcentajeBarra: 0.6, tipo: 'Caído'),
    HistorialError(titulo: 'SSL caducado', duracion: '1h 02m', porcentajeBarra: 0.75, tipo: 'Lento'),
    HistorialError(titulo: 'Error 500', duracion: '22m', porcentajeBarra: 0.3, tipo: 'Caído'),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E5E5))),
                          child: const Icon(Icons.arrow_back_ios_new, size: 16, color: Color(0xFF141414)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text('Reportes — ${widget.nombreSitio}', style: const TextStyle(fontFamily: 'GeistMono', fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF141414))),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCE4E4),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE53E3E)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.warning_amber_rounded, color: Color(0xFFE53E3E), size: 20),
                              SizedBox(width: 8),
                              Text('Error', style: TextStyle(fontFamily: 'GeistMono', color: Color(0xFFE53E3E), fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Incidencias recientes', style: TextStyle(fontFamily: 'GeistMono', fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF141414))),
                                  Text('${_listaErrores.length} eventos', style: const TextStyle(fontFamily: 'GeistMono', fontSize: 12, color: Color(0xFF737373))),
                                ],
                              ),
                              const SizedBox(height: 16),
                              ..._listaErrores.map((err) => _buildFilaHistorialErrores(err)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const MenuNavegacionGlobal(paginaActual: 2),
              ],
            ),
          ),
          if (isInnerBlurred)
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

  Widget _buildFilaHistorialErrores(HistorialError error) {
    Color colorBarra = error.tipo == 'Caído' ? const Color(0xFFE53E3E) : const Color(0xFFF5A524);
    Color colorFondoTag = error.tipo == 'Caído' ? const Color(0xFFFCE4E4) : const Color(0xFFFEF3D6);

    return InkWell(
      onTap: () => _mostrarVentanaEmergenteDescripcion(error),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E5E5)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(error.titulo, style: const TextStyle(fontFamily: 'GeistMono', fontSize: 13, color: Color(0xFF141414), fontWeight: FontWeight.w500)),
            ),
            Expanded(
              flex: 2,
              child: Container(
                height: 8,
                decoration: BoxDecoration(color: const Color(0xFFF4F4F5), borderRadius: BorderRadius.circular(4)),
                child: Row(
                  children: [
                    Expanded(flex: (error.porcentajeBarra * 100).toInt(), child: Container(decoration: BoxDecoration(color: colorBarra, borderRadius: BorderRadius.circular(4)))),
                    Expanded(flex: ((1.0 - error.porcentajeBarra) * 100).toInt(), child: const SizedBox()),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: colorFondoTag, borderRadius: BorderRadius.circular(12)),
              child: Text(error.duracion, style: TextStyle(fontFamily: 'GeistMono', fontSize: 11, fontWeight: FontWeight.bold, color: colorBarra)),
            )
          ],
        ),
      ),
    );
  }

  void _mostrarVentanaEmergenteDescripcion(HistorialError error) {
    setState(() => isInnerBlurred = true);

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
                              Container(width: 4, height: 16, color: const Color(0xFFE53E3E)),
                              const SizedBox(width: 8),
                              const Text('Descripción del error', style: TextStyle(fontSize: 16, fontFamily: 'GeistMono', fontWeight: FontWeight.bold, color: Color(0xFFE53E3E), decoration: TextDecoration.none)),
                            ],
                          ),
                          GestureDetector(
                            onTap: () { Navigator.pop(context); setState(() => isInnerBlurred = false); },
                            child: Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: const Color(0xFFF4F4F5), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.close, color: Color(0xFF737373), size: 18)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _filaDetalleLiteral('Incidencia', error.titulo),
                      const Divider(color: Color(0xFFE5E5E5), height: 1),
                      _filaDetalleLiteral('Fecha / Hora', '15/04/2026 - 14:00'),
                      const Divider(color: Color(0xFFE5E5E5), height: 1),
                      _filaDetalleLiteral('Duración', error.duracion),
                      const Divider(color: Color(0xFFE5E5E5), height: 1),
                      _filaDetalleLiteral('Código', error.tipo == 'Caído' ? 'HTTP 503' : 'N/A'),
                      const SizedBox(height: 16),
                      const Text('Interrupción total del servicio que impide el acceso al sistema. El monitoreo detectó tiempo de respuesta nulo de forma sostenida.', style: TextStyle(fontSize: 12, fontFamily: 'GeistMono', color: Color(0xFF737373), height: 1.5, decoration: TextDecoration.none)),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: const Color(0xFFC7FFD1), borderRadius: BorderRadius.circular(12)),
                        child: const Row(
                          children: [
                            Icon(Icons.check_circle_outline, color: Color(0xFF025E45), size: 16),
                            SizedBox(width: 8),
                            Expanded(child: Text('Resuelto · servicio restablecido a las 17:15', style: TextStyle(fontSize: 11, fontFamily: 'GeistMono', color: Color(0xFF025E45), fontWeight: FontWeight.bold, decoration: TextDecoration.none))),
                          ],
                        ),
                      )
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

  Widget _filaDetalleLiteral(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titulo, style: const TextStyle(fontSize: 13, fontFamily: 'GeistMono', color: Color(0xFF737373), decoration: TextDecoration.none)),
          Text(valor, style: const TextStyle(fontSize: 13, fontFamily: 'GeistMono', color: Color(0xFF141414), fontWeight: FontWeight.bold, decoration: TextDecoration.none)),
        ],
      ),
    );
  }
}

// =========================================================================
// CUSTOM PAINTER: ANILLO DE DONA SEGMENTADO
// =========================================================================
class DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double center = size.width / 2;
    double radius = (size.width - paint.strokeWidth) / 2;

    paint.color = const Color(0xFF12AC6E);
    canvas.drawArc(Rect.fromCircle(center: Offset(center, center), radius: radius), -1.2, 3.8, false, paint);

    paint.color = const Color(0xFFF5A524);
    canvas.drawArc(Rect.fromCircle(center: Offset(center, center), radius: radius), 2.8, 0.8, false, paint);

    paint.color = const Color(0xFFE53E3E);
    canvas.drawArc(Rect.fromCircle(center: Offset(center, center), radius: radius), 3.8, 1.2, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


// =========================================================================
// 1. COMPONENTE GLOBAL DE MENÚ DE NAVEGACIÓN
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

    Widget siguientePantalla;
    switch (indice) {
      case 0:
        siguientePantalla = const InicioPage();
        break;
      case 1:
        siguientePantalla = const HistorialPage(); // <- AQUÍ ESTABA EL PLACEHOLDER
        break;
      case 2:
        siguientePantalla = const ReportesPage();
        break;
      case 3:
        siguientePantalla = const PlaceholderScreen(titulo: "Equipo");
        break;
      case 4:
        siguientePantalla = const PlaceholderScreen(titulo: "Perfil");
        break;
        case 5: 
        siguientePantalla = const LoginScreen ();
        break;
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
              _buildBotonMenu(context, 0, Icons.home_outlined, Icons.home, "Inicio"),
              _buildBotonMenu(context, 1, Icons.watch_later_outlined, Icons.watch_later, "Historial"),
              _buildBotonMenu(context, 2, Icons.bar_chart, Icons.bar_chart, "Reportes"),
              _buildBotonMenu(context, 3, Icons.groups_outlined, Icons.groups, "Equipo"),
              _buildBotonMenu(context, 4, Icons.person_outline, Icons.person, "Perfil"),
              _buildBotonMenu(context, 5, Icons.logout, Icons.logout, "Salir"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBotonMenu(BuildContext context, int indice, IconData iconoInactivo, IconData iconoActivo, String etiqueta) {
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
                color: esActivo ? const Color(0xFF025E45) : const Color(0xFF737373),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              etiqueta,
              style: TextStyle(
                fontSize: 11,
                fontFamily: 'Geist',
                fontWeight: esActivo ? FontWeight.bold : FontWeight.normal,
                color: esActivo ? const Color(0xFF12AC6E) : const Color(0xFF737373),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
