
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smile_tech/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _searchController = TextEditingController();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _numeroCelularController =
      TextEditingController();
  final TextEditingController _padecimientosController =
      TextEditingController();
  final TextEditingController _tratamientoARealizarController =
      TextEditingController();
  final TextEditingController _tratamientoRealizadoController =
      TextEditingController();
  final TextEditingController _correoElectronicoController =
      TextEditingController();
  final TextEditingController _comentarioController = TextEditingController();
  List<Map<String, String>> pacientes = [];
  List<Map<String, String>> busquedaPacientes = [];
  String nombrePaciente = '';
  String numeroCelular = '';
  String padecimientos = '';
  String tratamientoARealizar = '';
  String tratamientoRealizado = '';
  String correoElectronico = '';
  String comentario = '';
  String variable = "";
  bool isVisibleUpdate = false;
  bool isVisibleForm = false;
  bool isVisibleCuadro = false;
  bool terminarBusqueda =false;
  //SharedPreferences
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();


//guardaDatosBD y actualizarBD
  Future<void> persistPacientesList() async {
    final SharedPreferences prefs = await _prefs;
    String encodedData = json.encode(pacientes);
    await prefs.setString('pacientes', encodedData);
  }

// Método añadido para cargar la lista de pacientes
  Future<void> loadPacientesList() async {
    final SharedPreferences prefs = await _prefs;
    String? encodedData = prefs.getString('pacientes');
    if (encodedData != null) {
      List<dynamic> decodedData = json.decode(encodedData);
      setState(() {
        List<Map<String, String>> pacientesSaved = List<Map<String, String>>.from(decodedData.map((e) => Map<String, String>.from(e)));
        pacientes = pacientesSaved;
        isVisibleCuadro = true;
      });
    }
  }

  //eliminarPacienteDatosBD
  Future<void> removePaciente(String nombre) async {
    final SharedPreferences prefs = await _prefs;
    pacientes.removeWhere((paciente) => paciente['nombre'] == nombre);
    await persistPacientesList();
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadPacientesList();
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
                    Navigator.pushNamed(context, "cirugia_screen");
                  },
                  child: const Text(
                    'Cirugías',
                    style: kTextWhite,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "ortodoncia_screen");
                  },
                  child: const Text(
                    'Ortodoncia',
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

                            for (int i = 0; i < pacientes.length; i++) {
                              Map<String, String> pacienteActual = pacientes[i];
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
          child: Stack(
            children: [
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
                      height: 650,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Datos del paciente",
                              style: kTextBlack,
                            ),
                          ),
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _numeroCelularController,
                              textAlign: TextAlign.center,
                              style: kTextBlack,
                              //controller:
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 13.0, horizontal: 10.0),
                                hintText:
                                    "Ingrese el numero de celular del paciente",
                                labelText: "Número de celular",
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _padecimientosController,
                              textAlign: TextAlign.center,
                              style: kTextBlack,
                              //controller:
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 13.0, horizontal: 10.0),
                                hintText:
                                    "Ingrese los padecimientos del paciente",
                                labelText: "Padecimientos",
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _tratamientoARealizarController,
                              textAlign: TextAlign.center,
                              style: kTextBlack,
                              //controller:
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 13.0, horizontal: 10.0),
                                hintText: "Ingrese el tratamiento a realizar",
                                labelText: "Tratamiento a realizar",
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _tratamientoRealizadoController,
                              textAlign: TextAlign.center,
                              style: kTextBlack,
                              //controller:
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 13.0, horizontal: 10.0),
                                hintText: "Ingrese los tratamientos realizados",
                                labelText: "Tratamiento realizado",
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _correoElectronicoController,
                              textAlign: TextAlign.center,
                              style: kTextBlack,
                              //controller:
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 13.0, horizontal: 10.0),
                                hintText: "Ingrese el correo del paciente",
                                labelText: "Correo electrónico",
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
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
                                      setState(()  {
                                        int datosPersona = 0;
                                        Map<String, String> actualizarPaciente = {
                                          'nombre': _nombreController.text,
                                          'numeroCelular':
                                          _numeroCelularController.text,
                                          'padecimientos':
                                          _padecimientosController.text,
                                          'tratamientoARealizar':
                                          _tratamientoARealizarController
                                              .text,
                                          'tratamientoRealizado':
                                          _tratamientoRealizadoController
                                              .text,
                                          'correoElectronico':
                                          _correoElectronicoController.text,
                                          'comentario':
                                          _comentarioController.text,

                                        };
                                        for(Map pacientesData in pacientes){
                                          if(pacientesData["nombre"]==variable){
                                            break;
                                          }else{
                                            datosPersona++;
                                          }
                                        }
                                        pacientes[datosPersona]=actualizarPaciente;
                                        _nombreController.clear();
                                        _numeroCelularController.clear();
                                        _padecimientosController.clear();
                                        _tratamientoARealizarController.clear();
                                        _tratamientoRealizadoController.clear();
                                        _correoElectronicoController.clear();
                                        _comentarioController.clear();

                                        isVisibleCuadro =! isVisibleCuadro;


                                        isVisibleUpdate =! isVisibleUpdate;

                                      });
                                      await persistPacientesList();
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
                                        _numeroCelularController.clear();
                                        _padecimientosController.clear();
                                        _tratamientoARealizarController.clear();
                                        _tratamientoRealizadoController.clear();
                                        _correoElectronicoController.clear();
                                        _comentarioController.clear();
                                        isVisibleCuadro=!isVisibleCuadro;

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
                      height: 650,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Datos del paciente",
                              style: kTextBlack,
                            ),
                          ),
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _numeroCelularController,
                              textAlign: TextAlign.center,
                              style: kTextBlack,
                              //controller:
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 13.0, horizontal: 10.0),
                                hintText:
                                    "Ingrese el numero de celular del paciente",
                                labelText: "Número de celular",
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _padecimientosController,
                              textAlign: TextAlign.center,
                              style: kTextBlack,
                              //controller:
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 13.0, horizontal: 10.0),
                                hintText:
                                    "Ingrese los padecimientos del paciente",
                                labelText: "Padecimientos",
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _tratamientoARealizarController,
                              textAlign: TextAlign.center,
                              style: kTextBlack,
                              //controller:
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 13.0, horizontal: 10.0),
                                hintText: "Ingrese el tratamiento a realizar",
                                labelText: "Tratamiento a realizar",
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _tratamientoRealizadoController,
                              textAlign: TextAlign.center,
                              style: kTextBlack,
                              //controller:
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 13.0, horizontal: 10.0),
                                hintText: "Ingrese los tratamientos realizados",
                                labelText: "Tratamiento realizado",
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _correoElectronicoController,
                              textAlign: TextAlign.center,
                              style: kTextBlack,
                              //controller:
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 13.0, horizontal: 10.0),
                                hintText: "Ingrese el correo del paciente",
                                labelText: "Correo electrónico",
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
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
                                        Map<String, String> nuevoPaciente = {
                                          'nombre': _nombreController.text,
                                          'numeroCelular':
                                              _numeroCelularController.text,
                                          'padecimientos':
                                              _padecimientosController.text,
                                          'tratamientoARealizar':
                                              _tratamientoARealizarController
                                                  .text,
                                          'tratamientoRealizado':
                                              _tratamientoRealizadoController
                                                  .text,
                                          'correoElectronico':
                                              _correoElectronicoController.text,
                                          'comentario':
                                              _comentarioController.text,
                                        };
                                        pacientes.add(nuevoPaciente);
                                        _nombreController.clear();
                                        _numeroCelularController.clear();
                                        _padecimientosController.clear();
                                        _tratamientoARealizarController.clear();
                                        _tratamientoRealizadoController.clear();
                                        _correoElectronicoController.clear();
                                        _comentarioController.clear();

                                        isVisibleCuadro = true;
                                        isVisibleForm = !isVisibleForm;
                                      });
                                      await persistPacientesList();
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
                                        isVisibleCuadro =! isVisibleCuadro;
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

                    children: busquedaPacientes.isEmpty?pacientes.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, String> paciente = entry.value;
                      return Container(
                        margin: const EdgeInsets.all(10.0),
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: kBackground2,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    " \n Nombre: ${paciente['nombre']}",
                                    style: const TextStyle(
                                      color: kBlack,
                                      fontSize: 15,
                                      fontFamily: "Viga",
                                    ),
                                  ),
                                  Text(
                                    " Número de celular: ${paciente['numeroCelular']}",
                                    style: const TextStyle(
                                      color: kBlack,
                                      fontSize: 15,
                                      fontFamily: "Viga",
                                    ),
                                  ),
                                  Text(
                                    " Padecimientos: ${paciente['padecimientos']}",
                                    style: const TextStyle(
                                      color: kBlack,
                                      fontSize: 15,
                                      fontFamily: "Viga",
                                    ),
                                  ),
                                  Text(
                                    " Tratamiento a realizar: ${paciente['tratamientoARealizar']}",
                                    style: const TextStyle(
                                      color: kBlack,
                                      fontSize: 15,
                                      fontFamily: "Viga",
                                    ),
                                  ),
                                  Text(
                                    " Tratamiento realizado: ${paciente['tratamientoRealizado']}",
                                    style: const TextStyle(
                                      color: kBlack,
                                      fontSize: 15,
                                      fontFamily: "Viga",
                                    ),
                                  ),
                                  Text(
                                    " Correo electrónico: ${paciente['correoElectronico']}",
                                    style: const TextStyle(
                                      color: kBlack,
                                      fontSize: 15,
                                      fontFamily: "Viga",
                                    ),
                                  ),
                                  Text(
                                    " Comentario: ${paciente['comentario']}",
                                    style: const TextStyle(
                                      color: kBlack,
                                      fontSize: 15,
                                      fontFamily: "Viga",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 25),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      isVisibleCuadro = ! isVisibleCuadro;
                                      setState(() {
                                        isVisibleUpdate = true;

                                        _nombreController.text =
                                            paciente['nombre'] ?? '';
                                        variable =  paciente['nombre'] ?? '';
                                        _numeroCelularController.text =
                                            paciente['numeroCelular'] ?? '';
                                        _padecimientosController.text =
                                            paciente["padecimientos"] ?? '';
                                        _tratamientoARealizarController.text =
                                            paciente["tratamientoARealizar"] ??
                                                '';
                                        _tratamientoRealizadoController.text =
                                            paciente["tratamientoRealizado"] ??
                                                '';
                                        _correoElectronicoController.text =
                                            paciente["correoElectronico"] ?? '';
                                        _comentarioController.text =
                                            paciente['comentario'] ?? '';
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
                                                onPressed: () async {
                                                  removePaciente("nombre");

                                                  setState(()  {

                                                    pacientes.removeAt(index);

                                                  });
                                                  Navigator.of(context).pop();
                                                  await removePaciente("nombre");
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
                      Map<String, String> paciente = entry.value;
                      return Container(
                        margin: const EdgeInsets.all(10.0),
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: kBackground2,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    " \n Nombre: ${paciente['nombre']}",
                                    style: const TextStyle(
                                      color: kBlack,
                                      fontSize: 15,
                                      fontFamily: "Viga",
                                    ),
                                  ),
                                  Text(
                                    " Número de celular: ${paciente['numeroCelular']}",
                                    style: const TextStyle(
                                      color: kBlack,
                                      fontSize: 15,
                                      fontFamily: "Viga",
                                    ),
                                  ),
                                  Text(
                                    " Padecimientos: ${paciente['padecimientos']}",
                                    style: const TextStyle(
                                      color: kBlack,
                                      fontSize: 15,
                                      fontFamily: "Viga",
                                    ),
                                  ),
                                  Text(
                                    " Tratamiento a realizar: ${paciente['tratamientoARealizar']}",
                                    style: const TextStyle(
                                      color: kBlack,
                                      fontSize: 15,
                                      fontFamily: "Viga",
                                    ),
                                  ),
                                  Text(
                                    " Tratamiento realizado: ${paciente['tratamientoRealizado']}",
                                    style: const TextStyle(
                                      color: kBlack,
                                      fontSize: 15,
                                      fontFamily: "Viga",
                                    ),
                                  ),
                                  Text(
                                    " Correo electrónico: ${paciente['correoElectronico']}",
                                    style: const TextStyle(
                                      color: kBlack,
                                      fontSize: 15,
                                      fontFamily: "Viga",
                                    ),
                                  ),
                                  Text(
                                    " Comentario: ${paciente['comentario']}",
                                    style: const TextStyle(
                                      color: kBlack,
                                      fontSize: 15,
                                      fontFamily: "Viga",
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                                            paciente['nombre'] ?? '';
                                        variable =  paciente['nombre'] ?? '';
                                        _numeroCelularController.text =
                                            paciente['numeroCelular'] ?? '';
                                        _padecimientosController.text =
                                            paciente["padecimientos"] ?? '';
                                        _tratamientoARealizarController.text =
                                            paciente["tratamientoARealizar"] ??
                                                '';
                                        _tratamientoRealizadoController.text =
                                            paciente["tratamientoRealizado"] ??
                                                '';
                                        _correoElectronicoController.text =
                                            paciente["correoElectronico"] ?? '';
                                        _comentarioController.text =
                                            paciente['comentario'] ?? '';
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
                                                  isVisibleCuadro =! isVisibleCuadro;
                                                  setState(() {
                                                    pacientes.removeAt(index);
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
              isVisibleCuadro =! isVisibleCuadro;
              isVisibleForm = !isVisibleForm;
            });
          },
          child: const Icon(Icons.person_add)),
    );
  }
}
