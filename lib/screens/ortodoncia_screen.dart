import "package:flutter/material.dart";
import "package:smile_tech/constants/constants.dart";
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class OrtodonciaScreen extends StatefulWidget {
  const OrtodonciaScreen({super.key});

  @override
  State<OrtodonciaScreen> createState() => _OrtodonciaScreenState();
}

class _OrtodonciaScreenState extends State<OrtodonciaScreen> {
  List<Map<String, String>> pacientesOrto = [];
  List<Map<String, String>> busquedaPacientes = [];
  String nombrePaciente = '';
  String hora = '';
  String comentario = '';
  final TextEditingController _horaController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _comentarioController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  String variable = "";
  bool isVisibleUpdate = false;
  bool isVisibleForm = false;
  bool isVisibleCuadro = false;
  bool terminarBusqueda =false;

  String insertLineBreaks(String comment, int wordLimit) {
    var words = comment.split(' ');
    String newComment = '';
    for (int i = 0; i < words.length; i++) {
      newComment += words[i];
      if ((i + 1) % wordLimit == 0 && i != words.length - 1) {
        newComment += '\n';
      } else if (i != words.length - 1) {
        newComment += ' ';
      }
    }
    return newComment;
  }

  //SharedPreferences
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//guardaDatosBD y actualizarBD
  Future<void> persistPacientesListCirugia() async {
    final SharedPreferences prefs = await _prefs;
    String encodedData = json.encode(pacientesOrto);
    await prefs.setString('pacientesOrtodoncia', encodedData);
  }

// Método añadido para cargar la lista de pacientes
  Future<void> loadPacientesListCirugia() async {
    final SharedPreferences prefs = await _prefs;
    String? encodedData = prefs.getString('pacientesOrtodoncia');
    if (encodedData != null) {
      List<dynamic> decodedData = json.decode(encodedData);
      setState(() {
        List<Map<String, String>> pacientesSaved = List<Map<String, String>>.from(decodedData.map((e) => Map<String, String>.from(e)));
        pacientesOrto = pacientesSaved;
        isVisibleCuadro = true;
      });
    }
  }

  //eliminarPacienteDatosBD
  Future<void> removePacienteCirugia(String nombre) async {
    final SharedPreferences prefs = await _prefs;
    pacientesOrto.removeWhere((paciente) => paciente['nombre'] == nombre);
    await persistPacientesListCirugia();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadPacientesListCirugia();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground2,
        flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SafeArea(
              child: Row(
                children: <Widget>[
                  // Espacio para el logo
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: Image.asset(
                      "images/logo2.png",
                      height: 30,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        leading: Container(),
        //Botones para ir a otras screens
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 26),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "main_screen");
                  },
                  child: const Text(
                    'Inicio',
                    style: kTextWhite,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "cirugia_screen");
                  },
                  child: const Text(
                    'Cirugía',
                    style: kTextWhite,
                  ),
                ),
                //Buscador de personas
                Container(
                  width: 130,
                  height: 30,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Buscar...",
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon:  Icon(!terminarBusqueda?Icons.search:Icons.delete_forever, size: 15),
                        onPressed: () {
                          if(!terminarBusqueda){
                            terminarBusqueda= true;
                            print("Botón de búsqueda presionado");
                            String nombreABuscar = _searchController.text;
                            int indiceDelPaciente = -1;

                            for (int i = 0; i < pacientesOrto.length; i++) {
                              Map<String, String> pacienteActual = pacientesOrto[i];
                              if (pacienteActual["nombre"]!.toLowerCase().contains(nombreABuscar.toLowerCase())) {
                                setState(() {
                                  busquedaPacientes.add(pacienteActual);
                                });
                                indiceDelPaciente = i;
                              }
                            }

                            if (indiceDelPaciente != -1) {
                              print("Paciente encontrado en el índ  ice: $indiceDelPaciente");
                            } else {
                              print("Paciente no encontrado");
                            }
                          }else{

                            setState(() {
                              terminarBusqueda = false;
                              busquedaPacientes.clear();
                              _searchController.clear();
                            });
                          }

                        },
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
               Text("Pantalla de Ortodoncia", style:kTextWhite.copyWith(fontSize: 30),
               ),
              //FormUpdate
              Visibility(
                visible: isVisibleUpdate,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 200),
                  child: Material(
                    borderRadius: BorderRadius.circular(15),
                    color: kWhite,
                    elevation: 15,
                    child: SizedBox(
                      width: 390,
                      height: 600,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Datos del paciente",
                              style: kTextBlack,
                            ),
                          ),
                          //nombre paciente
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _nombreController,
                              textAlign: TextAlign.center,
                              style: kTextBlack,
                              //controller:
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 13.0, horizontal: 10.0),
                                hintText: "Ingrese el nombre del paciente",
                                labelText: "Nombre",
                                labelStyle: kTextBlue2,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  borderSide: BorderSide(
                                      color: kBackground2, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: kBackground2, width: 2.0),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: kBackground2, width: 2.0),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //hora
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _horaController,
                              textAlign: TextAlign.center,
                              style: kTextBlack,
                              //controller:
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 13.0, horizontal: 10.0),
                                hintText:
                                "Ingrese la hora de la cita",
                                labelText: "Hora",
                                labelStyle: kTextBlue2,
                                //hintStyle: kSubTextBlack,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  borderSide: BorderSide(
                                      color: kBackground2, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: kBackground2, width: 2.0),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: kBackground2, width: 2.0),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //comentario
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              maxLines: 10,
                              controller: _comentarioController,
                              textAlign: TextAlign.center,
                              style: kTextBlack,
                              //controller:
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 13.0, horizontal: 10.0),
                                hintText: "Ingrese el comentario",
                                labelText: "Comentario",
                                labelStyle: kTextBlue2,
                                //hintStyle: kSubTextBlack,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  borderSide: BorderSide(
                                      color: kBackground2, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: kBackground2, width: 2.0),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: kBackground2, width: 2.0),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 30, top: 15),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all(kButton),
                                      elevation: MaterialStateProperty.all(15),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                30), // Radio del borde
                                            side: const BorderSide(
                                                color: kBackground2),
                                          )),
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        int datosPersona = 0;
                                        Map<String, String> actualizarPaciente = {
                                          'nombre': _nombreController.text,

                                          'horaCita':
                                          _horaController.text,
                                          'comentario':
                                          _comentarioController.text,

                                        };
                                        for(Map pacientesData in pacientesOrto){
                                          if(pacientesData["nombre"]==variable){
                                            break;
                                          }else{
                                            datosPersona++;
                                          }
                                        }
                                        pacientesOrto[datosPersona]=actualizarPaciente;
                                        _nombreController.clear();
                                        _horaController.clear();
                                        _comentarioController.clear();

                                        isVisibleUpdate =! isVisibleUpdate;

                                      });
                                      await persistPacientesListCirugia();
                                    },
                                    child: const Text(
                                      "Actualizar paciente",
                                      style: kTextBlack,
                                    )),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 30, top: 15),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all(kButton),
                                      elevation: MaterialStateProperty.all(15),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                30), // Radio del borde
                                            side: const BorderSide(
                                                color: kBackground2),
                                          )),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _nombreController.clear();
                                        _horaController.clear();
                                        _comentarioController.clear();

                                        isVisibleUpdate = !isVisibleUpdate;
                                      });
                                    },
                                    child: const Text("Cerrar",
                                        style: kTextBlack)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              //MainForm
              Visibility(
                visible: isVisibleForm,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50, bottom: 200),
                  child: Material(
                    borderRadius: BorderRadius.circular(15),
                    color: kWhite,
                    elevation: 15,
                    child: SizedBox(
                      width: 390,
                      height: 600,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Datos de la cita",
                              style: kTextBlack,
                            ),
                          ),
                          //nombre
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _nombreController,
                              textAlign: TextAlign.center,
                              style: kTextBlack,
                              //controller:
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 13.0, horizontal: 10.0),
                                hintText: "Ingrese el nombre del paciente",
                                labelText: "Nombre",
                                labelStyle: kTextBlue2,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  borderSide: BorderSide(
                                      color: kBackground2, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: kBackground2, width: 2.0),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: kBackground2, width: 2.0),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //hora
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _horaController,
                              textAlign: TextAlign.center,
                              style: kTextBlack,
                              //controller:
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 13.0, horizontal: 10.0),
                                hintText:
                                "Ingrese la hora de la cita",
                                labelText: "Hora",
                                labelStyle: kTextBlue2,
                                //hintStyle: kSubTextBlack,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  borderSide: BorderSide(
                                      color: kBackground2, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: kBackground2, width: 2.0),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: kBackground2, width: 2.0),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //Comentario
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              maxLines: 10,
                              controller: _comentarioController,
                              textAlign: TextAlign.center,
                              style: kTextBlack,
                              //controller:
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 13.0, horizontal: 10.0),
                                hintText: "Ingrese un comentario",
                                labelText: "Comentario",
                                labelStyle: kTextBlue2,
                                //hintStyle: kSubTextBlack,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  borderSide: BorderSide(
                                      color: kBackground2, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: kBackground2, width: 2.0),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: kBackground2, width: 2.0),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 30, top: 15),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all(kButton),
                                      elevation: MaterialStateProperty.all(15),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                30), // Radio del borde
                                            side: const BorderSide(
                                                color: kBackground2),
                                          )),
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        Map<String, String> nuevaCita = {
                                          'nombre': _nombreController.text,
                                          'horaCita':
                                          _horaController.text,
                                          'comentario':
                                          _comentarioController.text,
                                        };
                                        pacientesOrto.add(nuevaCita);
                                        _nombreController.clear();
                                        _horaController.clear();
                                        _comentarioController.clear();

                                        isVisibleCuadro = true;
                                        isVisibleForm = !isVisibleForm;
                                      });
                                      await persistPacientesListCirugia();
                                    },
                                    child: const Text(
                                      "Agregar paciente",
                                      style: kTextBlack,
                                    )),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 30, top: 15),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all(kButton),
                                      elevation: MaterialStateProperty.all(15),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                30), // Radio del borde
                                            side: const BorderSide(
                                                color: kBackground2),
                                          )),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isVisibleForm = !isVisibleForm;
                                      });
                                    },
                                    child: const Text("Cerrar",
                                        style: kTextBlack)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              //Cuadros
              Visibility(

                visible: isVisibleCuadro,
                child: SingleChildScrollView(
                  child: Column(
                    children: busquedaPacientes.isEmpty?pacientesOrto.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, String> citas = entry.value;
                      return Container(
                        constraints: const BoxConstraints(
                          minHeight: 150.0,
                        ),
                        margin: const EdgeInsets.all(10.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: kBackground2,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    " Nombre: ${citas['nombre']}",
                                    style: const TextStyle(
                                      color: kBlack,
                                      fontSize: 15,
                                      fontFamily: "Viga",
                                    ),

                                  ),
                                  Text(
                                    " La hora: ${citas['horaCita']}",
                                    style: const TextStyle(
                                      color: kBlack,
                                      fontSize: 15,
                                      fontFamily: "Viga",
                                    ),
                                  ),
                                  Text(
                                    " Comentario: ${insertLineBreaks(citas['comentario'] ?? '', 10)}",
                                    style: const TextStyle(
                                      color: kBlack,
                                      fontSize: 15,
                                      fontFamily: "Viga",
                                    ),
                                    maxLines: 10,
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        isVisibleUpdate = true;
                                        _nombreController.text = citas['nombre'] ?? '';
                                        variable =  citas['nombre'] ?? '';
                                        _horaController.text = citas['hora'] ??'';
                                        _comentarioController.text = citas['comentario'] ?? '';
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kButton,
                                    ),
                                    child: const Text('Actualizar',
                                        style: TextStyle(
                                          color: kBlack,
                                          fontSize: 15,
                                          fontFamily: "Viga",
                                        )),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Confirmar'),
                                            content: const Text(
                                                '¿Estás seguro de que quieres eliminar este paciente?'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('Cancelar'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Eliminar'),
                                                onPressed: () async {
                                                  setState(() {
                                                    pacientesOrto.removeAt(index);
                                                  });
                                                  await removePacienteCirugia("nombre");
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kButton,
                                    ),
                                    child: const Text('Eliminar',
                                        style: TextStyle(
                                          color: kBlack,
                                          fontSize: 15,
                                          fontFamily: "Viga",
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList():busquedaPacientes.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, String> citas = entry.value;
                      return Container(
                        constraints: const BoxConstraints(
                          minHeight: 150.0,
                        ),
                        margin: const EdgeInsets.all(10.0),

                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: kBackground2,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  " Nombre: ${citas['nombre']}",
                                  style: const TextStyle(
                                    color: kBlack,
                                    fontSize: 15,
                                    fontFamily: "Viga",
                                  ),
                                ),
                                Text(
                                  " La hora: ${citas['horaCita']}",
                                  style: const TextStyle(
                                    color: kBlack,
                                    fontSize: 15,
                                    fontFamily: "Viga",
                                  ),
                                ),
                                Text(
                                  " Comentario: ${insertLineBreaks(citas['comentario'] ?? '', 10)}",
                                  style: const TextStyle(
                                    color: kBlack,
                                    fontSize: 15,
                                    fontFamily: "Viga",
                                  ),
                                  maxLines: 10,
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 25),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        isVisibleUpdate = true;
                                        _nombreController.text =
                                            citas['nombre'] ?? '';
                                        variable =  citas['nombre'] ?? '';
                                        _horaController.text =
                                            citas["horaCita"] ?? '';
                                        _comentarioController.text =
                                            citas['comentario'] ?? '';
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kButton,
                                    ),
                                    child: const Text('Actualizar',
                                        style: TextStyle(
                                          color: kBlack,
                                          fontSize: 15,
                                          fontFamily: "Viga",
                                        )),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(right: 25),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Confirmar'),
                                            content: const Text(
                                                '¿Estás seguro de que quieres eliminar este paciente?'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('Cancelar'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Eliminar'),
                                                onPressed: () {
                                                  setState(() {
                                                    pacientesOrto.removeAt(index);
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kButton,
                                    ),
                                    child: const Text('Eliminar',
                                        style: TextStyle(
                                          color: kBlack,
                                          fontSize: 15,
                                          fontFamily: "Viga",
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: kButton,
          onPressed: () {
            setState(() {
              isVisibleForm = !isVisibleForm;
            });
          },
          child: const Icon(Icons.person_add)),
    );
  }
}

