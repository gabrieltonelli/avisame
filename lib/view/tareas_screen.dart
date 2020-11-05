import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:avisame4/model/tarea.dart';
import 'package:avisame4/model/user.dart';
import 'package:avisame4/tarea_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:avisame4/globals.dart' as globals;

class Credenciales {
  String user;
  String password;
  Credenciales({this.user, this.password});
}

class TareasScreen extends StatefulWidget {

  //final User user;

  //TareasScreen({Key key, @required this.user}): super(key: key);
  _TareasScreenState createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {

  @override
  Widget build(BuildContext context) {

    final String uri = 'https://avisame.app/restapi/v1/tareas?id_empresa='+ globals.loggedUser.idEmpresa.toString()
        + '&id_cliente=' + globals.loggedUser.idCliente.toString()
        + '&id_colaborador=' + globals.loggedUser.idColaborador.toString();

    Future<List<Tarea>> _fetchTareas() async {
      debugPrint('API: $uri');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        final items = json.decode(response.body).cast<Map<String, dynamic>>();
        List<Tarea> listOfTareas = items.map<Tarea>((json) {
          return Tarea.fromJson(json);
        }).toList();
        return listOfTareas;
      } else {
        throw Exception('Error al obtener las tareas');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Tareas Pendientes'),
        backgroundColor: Colors.red,
        elevation: .9,

        actions: <Widget>[
          /*
            IconButton(
              icon: Icon(
                Icons.videocam,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.call,
                color: Colors.white,
              ),
              onPressed: () {},
            ),

            */

          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () {},
          )


        ],
      ),

      body: FutureBuilder<List<Tarea>>(
        future: _fetchTareas(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          return ListView(
            children: snapshot.data.map((Tarea) =>

              InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) {
                          return TareaDetalle(tarea: Tarea);
                        },
                      ),
                    );
                  },
                  child:

                  Card(
                      elevation: 10.0,
                    child:

                    Container(
                        padding: new EdgeInsets.all(10.0),
                        child:
                        ListTile(
                          title: Text(Tarea.descripcion),
                          subtitle: Text(Tarea.domicilio),

                          leading: new CircularPercentIndicator(
                            radius: 50.0,
                            lineWidth: 5.0,
                            animation: true,
                            animationDuration: 2000,
                            percent: Tarea.avance/100,
                            progressColor: Color(int.parse(Tarea.color.substring(1, 7), radix: 16) + 0xFF000000),
                            center: new Text(
                              Tarea.avance.toString()+'%',
                              style:
                              new TextStyle(fontSize: 12),
                            ),
                          ),
                        )

                    )

                  )
                     /*************************/
                  /*


                   */
              /*****************************/

              )

            )
                .toList(),
          );
        },
      ),
    );
  }
}