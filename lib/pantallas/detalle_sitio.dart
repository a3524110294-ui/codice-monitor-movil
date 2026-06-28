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
  Color colorEstado;
  Color fondoEstado;
  bool estaPausado;
  List<RegistroHistorial> historial;

  SitioModel({
    required this.nombre, 
    required this.url, 
    required this.categoria,
    this.estado = "Operativo",
    this.ping = "200ms",
    this.colorEstado = const Color(0xFF025E45),
    this.fondoEstado = const Color(0xFFC7FFD1),
    this.estaPausado = false,
    List<RegistroHistorial>? historial,
  }) : historial = historial ?? [
          RegistroHistorial(
            estado: "Caído", 
            descripcion: "El servidor no responde a la petición HTTP (Timeout 504). El origen de la falla se debe a una saturación en el puerto de enlace principal que impidió la respuesta del servidor en el tiempo establecido.", 
            tiempo: "Hace 10 min", 
            color: const Color(0xFFFF4B4B)
          ),
          RegistroHistorial(
            estado: "Lento", 
            descripcion: "Tiempo de respuesta superior a 800ms por alta concurrencia en la base de datos.", 
            tiempo: "Hace 2 hrs", 
            color: const Color(0xFFD97706)
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
    required this.color
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

// =========================================================================
// PANTALLA DE DETALLE DE SITIO
// =========================================================================
class DetalleSitioPage extends StatefulWidget {
  final SitioModel sitio;
  const DetalleSitioPage({super.key, required this.sitio});

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
                Navigator.pop(context); // Regresa a la pantalla de inicio
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
    // Si el sitio está pausado, aplicamos efecto visual "Liquid Glass" (Desenfoque + Opacidad)
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFFF2F2F2),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF141414), size: 18),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              widget.sitio.nombre,
              style: const TextStyle(fontFamily: 'Geist', color: Color(0xFF141414), fontWeight: FontWeight.bold, fontSize: 16),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Color(0xFF737373)),
                tooltip: "Editar información",
                onPressed: _abrirModalEdicion,
              ),
              IconButton(
                icon: Icon(
                  widget.sitio.estaPausado ? Icons.play_arrow : Icons.pause, 
                  color: const Color(0xFF737373)
                ),
                tooltip: widget.sitio.estaPausado ? "Reanudar monitoreo" : "Pausar monitoreo",
                onPressed: () {
                  setState(() {
                    widget.sitio.estaPausado = !widget.sitio.estaPausado;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Color(0xFFFF4B4B)),
                tooltip: "Eliminar sitio",
                onPressed: _abrirModalEliminacion,
              ),
            ],
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // 1. Contenedor del Estado Actual
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5E5E5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("ESTADO ACTUAL", style: TextStyle(color: Color(0xFF737373), fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Geist')),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(color: widget.sitio.fondoEstado, borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.circle, size: 8, color: widget.sitio.colorEstado),
                                const SizedBox(width: 6),
                                Text(widget.sitio.estado.toUpperCase(), style: TextStyle(color: widget.sitio.colorEstado, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Geist')),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(widget.sitio.url, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Geist', color: Color(0xFF141414))),
                      const SizedBox(height: 6),
                      const Text("Monitoreo activo verificado por Códice.", style: TextStyle(color: Color(0xFF737373), fontSize: 12, fontFamily: 'Geist')),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // 2. Contenedor de Métricas y Respuesta
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5E5E5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("MÉTRICAS Y RESPUESTA", style: TextStyle(color: Color(0xFF737373), fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Geist')),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Tiempo de respuesta", style: TextStyle(fontSize: 14, fontFamily: 'Geist', color: Color(0xFF141414))),
                          Text(widget.sitio.ping, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Geist', color: widget.sitio.colorEstado)),
                        ],
                      ),
                      const Divider(height: 24, color: Color(0xFFE5E5E5)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Categoría", style: TextStyle(fontSize: 14, fontFamily: 'Geist', color: Color(0xFF737373))),
                          Text(widget.sitio.categoria, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Geist', color: Color(0xFF141414))),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 3. SECCIÓN HISTORIAL DE SITIO
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5E5E5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("HISTORIAL DE ESTADOS", style: TextStyle(color: Color(0xFF737373), fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Geist')),
                      const SizedBox(height: 12),
                      ...widget.sitio.historial.map((registro) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => _abrirModalDetalleError(registro),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9F9F9),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFFE5E5E5))
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 8, height: 8, 
                                        decoration: BoxDecoration(color: registro.color, shape: BoxShape.circle),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(registro.estado, style: TextStyle(fontWeight: FontWeight.bold, color: registro.color, fontFamily: 'Geist')),
                                    ],
                                  ),
                                  Text(registro.tiempo, style: const TextStyle(fontSize: 11, color: Color(0xFF737373), fontFamily: 'Geist')),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )).toList(),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Botón genérico / Reverificar
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Verificando disponibilidad del sitio...', style: TextStyle(fontFamily: 'Geist')),
                          backgroundColor: Color(0xFF025E45),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF60F16E),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Reverificar ahora", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Geist')),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: const MenuNavegacionGlobal(paginaActual: 0), 
        ),
        
        // Efecto "Liquid Glass" superpuesto si está pausado
        if (widget.sitio.estaPausado)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
              child: Container(
                color: Colors.black.withOpacity(0.15),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ]
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.pause_circle_outline, color: Color(0xFF025E45), size: 28),
                        const SizedBox(width: 12),
                        const Text(
                          "Monitoreo Pausado", 
                          style: TextStyle(
                            fontFamily: 'Geist', 
                            fontSize: 16, 
                            fontWeight: FontWeight.bold, 
                            color: Color(0xFF141414)
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// =========================================================================
// VENTANA MODAL: EDITAR INFORMACIÓN DE SITIO
// =========================================================================
class ModalEditarSitio extends StatefulWidget {
  final SitioModel sitio;
  final Function(String, String, String) onGuardar;
  const ModalEditarSitio({super.key, required this.sitio, required this.onGuardar});

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
              BoxShadow(color: const Color(0xFF141414).withOpacity(0.34), offset: const Offset(0, 28), blurRadius: 70),
              BoxShadow(color: const Color(0xFF141414).withOpacity(0.16), offset: const Offset(0, 2), blurRadius: 10),
              const BoxShadow(color: Colors.white, offset: Offset(0, 1), blurRadius: 0),
              const BoxShadow(color: Colors.white, offset: Offset(0, -1), blurRadius: 0),
            ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Editar sitio", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Geist')),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18, color: Color(0xFF737373)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text("Actualiza la información del sitio web.", style: TextStyle(color: Color(0xFF737373), fontSize: 12, fontFamily: 'Geist')),
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
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E5E5))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF60F16E), width: 2)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                items: <String>['E-commerce', 'Blog', 'Corporativo', 'Otro'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(fontFamily: 'Geist', color: Color(0xFF141414))),
                  );
                }).toList(),
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
                        _categoriaSeleccionada!
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF60F16E),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Guardar cambios", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Geist')),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF737373), fontFamily: 'Geist'));
  }

  Widget _buildTextField(String hint, {required TextEditingController controller}) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontFamily: 'Geist', color: Color(0xFF141414)),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E5E5))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF60F16E), width: 2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
  const ModalEliminarSitio({super.key, required this.nombreSitio, required this.onEliminar});

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
              BoxShadow(color: const Color(0xFF141414).withOpacity(0.34), offset: const Offset(0, 28), blurRadius: 70),
              BoxShadow(color: const Color(0xFF141414).withOpacity(0.16), offset: const Offset(0, 2), blurRadius: 10),
              const BoxShadow(color: Colors.white, offset: Offset(0, 1), blurRadius: 0),
              const BoxShadow(color: Colors.white, offset: Offset(0, -1), blurRadius: 0),
            ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("¿Eliminar sitio?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Geist')),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18, color: Color(0xFF737373)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '¿Estás seguro que deseas eliminar el sitio "$nombreSitio"? Esta acción no se puede deshacer y perderás todas las métricas.', 
                style: const TextStyle(color: Color(0xFF737373), fontSize: 13, fontFamily: 'Geist', height: 1.4)
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          side: const BorderSide(color: Color(0xFFE5E5E5)),
                        ),
                        child: const Text("Cancelar", style: TextStyle(color: Color(0xFF141414), fontFamily: 'Geist', fontWeight: FontWeight.bold)),
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Eliminar", style: TextStyle(color: Colors.white, fontFamily: 'Geist', fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              )
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
              BoxShadow(color: const Color(0xFF141414).withOpacity(0.34), offset: const Offset(0, 28), blurRadius: 70),
              BoxShadow(color: const Color(0xFF141414).withOpacity(0.16), offset: const Offset(0, 2), blurRadius: 10),
              const BoxShadow(color: Colors.white, offset: Offset(0, 1), blurRadius: 0),
              const BoxShadow(color: Colors.white, offset: Offset(0, -1), blurRadius: 0),
            ]
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
                          width: 10, height: 10, 
                          decoration: BoxDecoration(color: registro.color, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Incidencia: ${registro.estado}", 
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Geist'),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18, color: Color(0xFF737373)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(registro.tiempo, style: const TextStyle(color: Color(0xFF737373), fontSize: 11, fontFamily: 'Geist')),
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
                        fontFamily: 'Geist'
                      )
                    ),
                    const SizedBox(height: 8),
                    Text(
                      registro.descripcion, 
                      style: const TextStyle(
                        fontSize: 12.5, 
                        color: Color(0xFF737373), 
                        fontFamily: 'Geist', 
                        height: 1.5
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Entendido", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Geist')),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}