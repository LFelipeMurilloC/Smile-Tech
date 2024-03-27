import 'package:flutter/material.dart';
import 'package:smile_tech/constants/constants.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isVisible = false;
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
                  width: 120,
                  height: 30,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Buscar...",
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 10), // Reduce el padding interno
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 100,
                        ),
                        child: Material(
                          elevation: 15,
                          child: IconButton(
                            icon: const Icon(Icons.search, size: 20),
                            onPressed: () {},
                          ),
                        ),
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
              Visibility(
                visible: isVisible,
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
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              textAlign: TextAlign.center,
                              style: kTextBlack,
                              //controller:
                              decoration: InputDecoration(
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
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              textAlign: TextAlign.center,
                              style: kTextBlack,
                              //controller:
                              decoration: InputDecoration(
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
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              textAlign: TextAlign.center,
                              style: kTextBlack,
                              //controller:
                              decoration: InputDecoration(
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
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              textAlign: TextAlign.center,
                              style: kTextBlack,
                              //controller:
                              decoration: InputDecoration(
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
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              textAlign: TextAlign.center,
                              style: kTextBlack,
                              //controller:
                              decoration: InputDecoration(
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
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              textAlign: TextAlign.center,
                              style: kTextBlack,
                              //controller:
                              decoration: InputDecoration(
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
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              textAlign: TextAlign.center,
                              style: kTextBlack,
                              //controller:
                              decoration: InputDecoration(
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
                                    onPressed: () {},
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
                                        isVisible = !isVisible;
                                      });
                                    },
                                    child: const Text("Cerrar", style: kTextBlack)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
              isVisible = !isVisible;
            });
          },
          child: const Icon(Icons.person_add)),
    );
  }
}
