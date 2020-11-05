import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'dart:async';
import 'package:avisame4/model/tarea.dart';
import 'package:avisame4/model/notificacion.dart';
import 'package:avisame4/view/send_text_notification.dart';
import 'package:avisame4/view/send_image_notification.dart';
import 'package:avisame4/view/send_status_notification.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bubble/bubble.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:avisame4/globals.dart' as globals;

void main() {
  runApp(new MaterialApp(
      title: 'Avisame!',
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      home: new TareaDetalle())
  );
}

class TareaDetalle extends StatefulWidget {

  final Tarea tarea;

  TareaDetalle({Key key, @required this.tarea}): super(key: key);
  TareaDetalleState createState() => new TareaDetalleState();
}

class TareaDetalleState extends State<TareaDetalle> with TickerProviderStateMixin {
  int _angle = 90;
  bool _isRotated = true;

  AnimationController _controller;
  Animation<double> _animation0;
  Animation<double> _animation1;
  Animation<double> _animation2;
  Animation<double> _animation3;
  Animation<double> _animation4;
  ScrollController _scroll = ScrollController();

  var refreshKey = GlobalKey<RefreshIndicatorState>();


  Future<Null> scrollToEndList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      Timer(Duration(milliseconds: 500), () => _scroll.jumpTo(_scroll.position.maxScrollExtent));
    });

    return null;
  }


  @override
  void initState() {

    scrollToEndList();



    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animation0 = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.00, 0.20, curve: Curves.linear),
    );
    _animation1 = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.10, 0.30, curve: Curves.linear),
    );

    _animation2 = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.20, 0.40, curve: Curves.linear),
    );

    _animation3 = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.30, 0.50, curve: Curves.linear),
    );
    _animation4 = new CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.40, 0.60, curve: Curves.linear),
    );

    _controller.reverse();
    super.initState();
  }




  void _rotate(){
    setState((){
      if(_isRotated) {
        _angle = 45;
        _isRotated = false;
        _controller.forward();
      } else {
        _angle = 90;
        _isRotated = true;
        _controller.reverse();
      }
    });
  }








  @override
  Widget build(BuildContext context) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;
    final String uri = 'https://avisame.app/restapi/v1/notificaciones?id_tarea='+widget.tarea.idTarea.toString();






    Future<List<Notificacion>> _fetchNotificaciones() async {
      debugPrint('API: $uri');
      var response = await http.get(uri);

      if (response.statusCode == 200) {
        final items = json.decode(response.body).cast<Map<String, dynamic>>();
        List<Notificacion> notificaciones = items.map<Notificacion>((json) {
          return Notificacion.fromJson(json);
        }).toList();
        return notificaciones;
      } else {
        throw Exception('Error al obtener las notificaciones');
      }
    }
/*
    Completer<GoogleMapController> _controller = Completer();

    const LatLng _center = const LatLng(-34.584092, -58.437427);

    void _onMapCreated(GoogleMapController controller) {
      _controller.complete(controller);
    }
    final Set<Marker> _markers = {};
    LatLng _lastMapPosition = _center;

    void _onAddMarkerButtonPressed(String tarea, String domicilio) {
      setState(() {
        _markers.add(Marker(
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow: InfoWindow(
            title: tarea,// widget.tarea.descripcion,
            snippet: domicilio,
          ),
          icon: BitmapDescriptor.defaultMarker,
        ));
      });
    }
    _onAddMarkerButtonPressed("algo","algo2");

*/


    return new Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.red,
          elevation: .9,
          title: Text(
            'Detalle de la Tarea',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              onPressed: () {},
            )
          ],
        ),

        body: new Stack(
            children: <Widget>[

              Container(
                color: Color(0xFFf8f9fa),
              ),

            /*GoogleMap(
              markers: _markers,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(

              target: _center,
              zoom: 11.0,
            ),
            ),*/


            /*****************************************************************/
              /*
            CustomScrollView(
            slivers: <Widget>[
            SliverAppBar(
            expandedHeight: 210.0,
            floating: false,
            pinned: true,
            title: Text("hola"),
            flexibleSpace: new FlexibleSpaceBar(
            background: TareaHeader(),

            ),
            ),
            SliverList(
            delegate: SliverChildListDelegate(
            <Widget>[
*/


            /*******************************************************************/





              FutureBuilder<List<Notificacion>>(
                future: _fetchNotificaciones(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                  return

                    Column(
                      children: <Widget>[

                        Stack(children:<Widget>[
                          Container(
                            /* margin: EdgeInsets.only(top: 5.0),*/

                              height: 130.0,
                              child: TareaHeader(tarea: widget.tarea)
                          ),
                  Container(
                  margin: EdgeInsets.only(top: 120.0),
                          child:
                          Card(
                              elevation: 10.0,
                              child:

                              Container(

                                  padding: new EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10.0, left: 10.0),
                                  constraints: BoxConstraints(
                                      /*maxHeight: 300.0,
                                      maxWidth: 200.0,
                                      minWidth: 150.0,
                                      minHeight: 150.0*/
                                  ),
                                  child:
                                  ListTile(
                                    title: Text(

                                        widget.tarea.denominacion,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    subtitle: Text(widget.tarea.domicilio,style: TextStyle(
                                      fontSize: 16.0,
                                    )),

                                    leading: new CircularPercentIndicator(
                                      radius: 50.0,
                                      lineWidth: 5.0,
                                      animation: true,
                                      animationDuration: 2000,
                                      percent: widget.tarea.avance/100,
                                      progressColor: Color(int.parse(widget.tarea.color.substring(1, 7), radix: 16) + 0xFF000000),
                                      center: new Text(
                                        widget.tarea.avance.toString()+'%',
                                        style:
                                        new TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  )

                              )

                          )
                  ),

                        ]
                        ),
                    Container(
                      child:
                      Bubble(
                        margin: BubbleEdges.fromLTRB(0,10,0,10),
                        alignment: Alignment.center,
                        stick: true,
                        color: Color(0xFFE0E3E3),
                        padding: BubbleEdges.all(10),
                        radius: Radius.circular(5.0),
                        child: Text(widget.tarea.descripcion,textAlign: TextAlign.center,style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xff000000))),
                      ),
                    ),


                    Expanded(
                    child:

                  ListView(

                    children: snapshot.data.map((Notificacion) =>

                        InkWell(
                          onTap:(){
                            print(Notificacion.tipo.toString());


                          },
                            /*onTap: () {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                  builder: (context) {
                                    return TareaDetalle(tarea: Tarea);
                                  },
                                ),
                              );
                            },*/
                            child:
                            Bubble(
                              alignment: Alignment.center,
                              color: Notificacion.idAutor.toString() == globals.loggedUser.idUsuario.toString() ? Color(0xFFE0E3E3) : Color(0xFFffdcdc) ,
                              elevation: 0 * px,
                              radius: Radius.circular(10.0),
                              margin: BubbleEdges.only(top: 4.0, right: 5.0, left: 5.0, bottom: 4.0),
                              nip: Notificacion.idAutor.toString() == globals.loggedUser.idUsuario.toString() ? BubbleNip.rightTop : BubbleNip.leftTop,
                              child: ListTile(

                                title: Notificacion.tipo == 'Imagen' ?
                                Container(
                                  margin: const EdgeInsets.only(bottom: 5.0),
                                  //width: MediaQuery.of(context).size.width - 10.0,

                                  height: 150.0,
                                  child: Align(
                  alignment: Alignment.centerLeft,
                  child: Image.network(
                    Notificacion.estado,
                    fit: BoxFit.fitHeight,
                  ),
                  )
                                )
                                    : Text(Notificacion.estado),
                                subtitle: Text(Notificacion.fechaHora + ' - ' + (Notificacion.idAutor.toString() == globals.loggedUser.idUsuario.toString() ? "Tu": Notificacion.autor)),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage('https://avisame.app/avatar.php?idusuario='+Notificacion.idAutor.toString()),
                                  backgroundColor: Colors.white,
                                  /*child: Text(Notificacion.tipo[0],
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.grey,
                                      )),*/
                                ),
                              ),
                            ),
                        )

                    )
                        .toList(),
                    //reverse: true,
                    //shrinkWrap: true,
                    controller: _scroll,
                  ),

                    ),

                ]
                  );



                },
              ),

            /***********************************************************************/




/*
            ]
            ),
            )
            ]
            ),
*/
             /*************************************************************************/

              new Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  child:
                ScaleTransition(
                scale: _animation0,
                alignment: FractionalOffset.bottomRight,
                child:


                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        color: new Color.fromRGBO(0, 0, 0, 0.8)
                    ),
              ),
              ),
              ),


              new Positioned(
                  bottom: 200.0,
                  right: 24.0,
                  child: new Container(
                    child: new Row(
                      children: <Widget>[
                        new ScaleTransition(
                          scale: _animation3,
                          alignment: FractionalOffset.center,
                          child: new Container(
                            margin: new EdgeInsets.only(right: 16.0),
                            child: new Text(
                              'Comentar algo',
                              style: new TextStyle(
                                fontSize: 13.0,
                                fontFamily: 'Roboto',
                                color: new Color(0xFF9E9E9E),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        new ScaleTransition(
                          scale: _animation3,
                          alignment: FractionalOffset.center,
                          child: new Material(
                              color: new Color(0xFF9E9E9E),
                              type: MaterialType.circle,
                              elevation: 6.0,
                              child: new GestureDetector(
                                child: new Container(
                                    width: 40.0,
                                    height: 40.0,
                                    child: new InkWell(
                                      onTap: (){

                                        _rotate();

                                        Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                            builder: (context) {
                                              return new TextNotificationScreen(
                                                tarea: widget.tarea
                                              );

                                            },
                                          ),
                                        );
                                      },
                                      child: new Center(
                                        child: new Icon(
                                          Icons.comment,
                                          color: new Color(0xFFFFFFFF),
                                        ),
                                      ),
                                    )
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                  )
              ),

              new Positioned(
                  bottom: 144.0,
                  right: 24.0,
                  child: new Container(
                    child: new Row(
                      children: <Widget>[
                        new ScaleTransition(
                          scale: _animation2,
                          alignment: FractionalOffset.center,
                          child: new Container(
                            margin: new EdgeInsets.only(right: 16.0),
                            child: new Text(
                              'Enviar una Foto',
                              style: new TextStyle(
                                fontSize: 13.0,
                                fontFamily: 'Roboto',
                                color: new Color(0xFF9E9E9E),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        new ScaleTransition(
                          scale: _animation2,
                          alignment: FractionalOffset.center,
                          child: new Material(
                              color: new Color(0xFF00BFA5),
                              type: MaterialType.circle,
                              elevation: 6.0,


                              child: new GestureDetector(
                          child: new Container(
                          width: 40.0,
                              height: 40.0,
                              child: new InkWell(
                                onTap: (){
                                  _rotate();
                                 // ImageNotificationScreen()



                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) {
                                        return UploadImageDemo(tarea: widget.tarea);
                                      },
                                    ),
                                  );






                                  /*
                                  if(_angle == 45.0){
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (context) {
                                        return new ImageNotificationScreen(
                                           // tarea: widget.tarea
                                        );
                                      },
                                    ),
                                  );
                                  }*/
                                },
                                child: new Center(
                                  child: new Icon(
                                    Icons.camera_alt,
                                    color: new Color(0xFFFFFFFF),
                                  ),
                                ),
                              )
                          ),
                        )


                          ),
                        ),
                      ],
                    ),
                  )
              ),
              new Positioned(
                  bottom: 88.0,
                  right: 24.0,
                  child: new Container(
                    child: new Row(
                      children: <Widget>[
                        new ScaleTransition(
                          scale: _animation1,
                          alignment: FractionalOffset.center,
                          child: new Container(
                            margin: new EdgeInsets.only(right: 16.0),
                            child: new Text(
                              'Adjuntar Archivo',
                              style: new TextStyle(
                                fontSize: 13.0,
                                fontFamily: 'Roboto',
                                color: new Color(0xFF9E9E9E),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        new ScaleTransition(
                          scale: _animation1,
                          alignment: FractionalOffset.center,
                          child: new Material(
                              color: new Color(0xFFFFBC5A),
                              type: MaterialType.circle,
                              elevation: 6.0,
                              child: new GestureDetector(
                                child: new Container(
                                    width: 40.0,
                                    height: 40.0,
                                    child: new InkWell(
                                      onTap: (){
                                        _rotate();
                                        if(_angle == 45.0){
                                          print("foo3");
                                        }
                                      },
                                      child: new Center(
                                        child: new Icon(
                                          Icons.link,
                                          color: new Color(0xFFFFFFFF),
                                        ),
                                      ),
                                    )
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                  )
              ),
//////////////////////////////////////////////////////////////////////////////

              new Positioned(
                  bottom: 260.0,
                  right: 24.0,
                  child: new Container(
                    child: new Row(
                      children: <Widget>[
                        new ScaleTransition(
                          scale: _animation4,
                          alignment: FractionalOffset.center,
                          child: new Container(
                            margin: new EdgeInsets.only(right: 16.0),
                            child: new Text(
                              'Informar Avance',
                              style: new TextStyle(
                                fontSize: 13.0,
                                fontFamily: 'Roboto',
                                color: new Color(0xFF9E9E9E),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        new ScaleTransition(
                          scale: _animation4,
                          alignment: FractionalOffset.center,
                          child: new Material(
                              color: new Color(0xFFE57373),
                              type: MaterialType.circle,
                              elevation: 6.0,
                              child: new GestureDetector(
                                child: new Container(
                                    width: 40.0,
                                    height: 40.0,
                                    child: new InkWell(
                                      onTap: (){
                                        _rotate();
                                        Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                            builder: (context) {
                                              return new StatusNotificationScreen(
                                                  tarea: widget.tarea
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: new Center(
                                        child: new Icon(
                                          Icons.new_releases,
                                          color: new Color(0xFFFFFFFF),
                                        ),
                                      ),
                                    )
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                  )
              ),
            //////////////////////////////////////////////////////////////////////////////////
              new Positioned(
                bottom: 16.0,
                right: 16.0,
                child: new Material(
                    color: new Color(0xFFff0000),
                    type: MaterialType.circle,
                    elevation: 6.0,
                    child: new GestureDetector(
                      child: new Container(
                          width: 56.0,
                          height: 56.00,
                          child: new InkWell(
                            onTap: _rotate,
                            child: new Center(
                                child: new RotationTransition(
                                  turns: new AlwaysStoppedAnimation(_angle / 360),
                                  child: new Icon(
                                    Icons.add,
                                    color: new Color(0xFFFFFFFF),
                                  ),
                                )
                            ),
                          )
                      ),
                    )
                ),
              ),
            ]
        )
    );
  }
}

/******************** begin header tarea (googlemap) ********************/

class TareaHeader extends StatefulWidget{
  final Tarea tarea;
  TareaHeader({Key key, @required this.tarea}): super(key: key);

  @override
  TareaHeaderState createState() => new TareaHeaderState();
}
class TareaHeaderState extends State<TareaHeader> {
  final double appBarHeight = 66.0;

  @override
  Widget build(BuildContext context) {
    Completer<GoogleMapController> _controller = Completer();
    LatLng _center;
    LatLng _center2;
    final double desp = 0.0005;
    //const LatLng _center = const LatLng(-34.584092, -58.437427);

    print('LATITUD: ' + widget.tarea.latitud.toString() + '   LONGITUD: '+widget.tarea.longitud.toString());
    if(widget.tarea.latitud != 0) {
      _center = LatLng(widget.tarea.latitud, widget.tarea.longitud);
      _center2 = LatLng((widget.tarea.latitud + desp), widget.tarea.longitud);
    }else{
      _center = LatLng(-34.584092, -58.437427);
      _center2 = LatLng((-34.584092+ desp),-58.437427);
    }
    void _onMapCreated(GoogleMapController controller) {
      _controller.complete(controller);
    }
    final Set<Marker> _markers = {};
    LatLng _lastMapPosition = _center;

    void _onAddMarkerButtonPressed(String tarea, String domicilio) {
      setState(() {
        _markers.add(Marker(
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow: InfoWindow(
            title: tarea,
            snippet: domicilio,
          ),
          icon: BitmapDescriptor.defaultMarker,
        ));
      });
    }
    _onAddMarkerButtonPressed(widget.tarea.descripcion,widget.tarea.domicilio);


    final double statusBarHeight = MediaQuery
        .of(context)
        .padding
        .top;
    return Container(
      padding: EdgeInsets.only(top: statusBarHeight),
      height: statusBarHeight + appBarHeight,
      child: Center(
        child:

        GoogleMap(
          markers: _markers,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(

            target: _center2,
            zoom: 15.0,
          ),
        ),


      ),
    );
  }
}
/******************** end header tarea ********************/


/*
class TareaScreen1 extends StatefulWidget {
  @override
  _TareaScreen1State createState() => new _TareaScreen1State();
}

class _TareaScreen1State extends State<TareaScreen1>
    with TickerProviderStateMixin {


  @override
  void initState() {
    super.initState();
  }

  Widget Tarea() {
    return new Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.red,
        image: DecorationImage(
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.1), BlendMode.dstATop),
          image: AssetImage('assets/images/mountains.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: new Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 130.0),
            child: Center(
              child: Icon(
                Icons.notifications_active,
                color: Colors.white,
                size: 50.0,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 0.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Avisame",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                  ),
                ),
                Text(
                  "!",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 0.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Avisame",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 150.0),
            alignment: Alignment.center,
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new OutlineButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.red,
                    highlightedBorderColor: Colors.white,
                    onPressed: () => gotoSignup(),
                    child: new Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 20.0,
                      ),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Expanded(
                            child: Text(
                              "REGISTRARSE",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
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
          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
            alignment: Alignment.center,
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new FlatButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.white,
                    onPressed: () => gotoLogin(),
                    child: new Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 20.0,
                      ),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Expanded(
                            child: Text(
                              "ACCEDER",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
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
    );
  }

  Widget LoginPage() {

    return new Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.05), BlendMode.dstATop),
          image: AssetImage('assets/images/mountains.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: new Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 120.0, bottom: 50.0),
            child: Center(
              child: Icon(
                Icons.notifications_active,
                color: Colors.redAccent,
                size: 50.0,
              ),
            ),
          ),
          new Row(
            children: <Widget>[
              new Expanded(
                child: new Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: new Text(
                    "USUARIO",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: Colors.redAccent,
                    width: 0.5,
                    style: BorderStyle.solid),
              ),
            ),
            padding: const EdgeInsets.only(left: 0.0, right: 10.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Expanded(
                  child: TextField(
                    obscureText: true,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'usuario',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 24.0,
          ),
          new Row(
            children: <Widget>[
              new Expanded(
                child: new Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: new Text(
                    "CONTRASEÑA",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: Colors.redAccent,
                    width: 0.5,
                    style: BorderStyle.solid),
              ),
            ),
            padding: const EdgeInsets.only(left: 0.0, right: 10.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Expanded(
                  child: TextField(
                    obscureText: true,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '*********',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 24.0,
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: new FlatButton(
                  child: new Text(
                    "Olvidate tu contraseña?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      fontSize: 15.0,
                    ),
                    textAlign: TextAlign.end,
                  ),
                  onPressed: () => {},
                ),
              ),
            ],
          ),
          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
            alignment: Alignment.center,
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new FlatButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    color: Colors.redAccent,
                    onPressed: () => {},
                    child: new Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 20.0,
                      ),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Expanded(
                            child: Text(
                              "INGRESAR",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
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

          /*
          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                new Expanded(
                  child: new Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(border: Border.all(width: 0.25)),
                  ),
                ),
                Text(
                  "OR CONNECT WITH",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                new Expanded(
                  child: new Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(border: Border.all(width: 0.25)),
                  ),
                ),
              ],
            ),
          ),



          */


/*

          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new Container(
                    margin: EdgeInsets.only(right: 8.0),
                    alignment: Alignment.center,
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new FlatButton(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                            color: Color(0Xff3B5998),
                            onPressed: () => {},
                            child: new Container(
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Expanded(
                                    child: new FlatButton(
                                      onPressed: ()=>{},
                                      padding: EdgeInsets.only(
                                        top: 20.0,
                                        bottom: 20.0,
                                      ),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Icon(
                                            const IconData(0xea90,
                                                fontFamily: 'icomoon'),
                                            color: Colors.white,
                                            size: 15.0,
                                          ),
                                          Text(
                                            "FACEBOOK",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
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






                ),
                new Expanded(
                  child: new Container(
                    margin: EdgeInsets.only(left: 8.0),
                    alignment: Alignment.center,
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new FlatButton(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                            color: Color(0Xffdb3236),
                            onPressed: () => {},
                            child: new Container(
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Expanded(
                                    child: new FlatButton(
                                      onPressed: ()=>{},
                                      padding: EdgeInsets.only(
                                        top: 20.0,
                                        bottom: 20.0,
                                      ),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Icon(
                                            const IconData(0xea88,
                                                fontFamily: 'icomoon'),
                                            color: Colors.white,
                                            size: 15.0,
                                          ),
                                          Text(
                                            "GOOGLE",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
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
                ),
              ],
            ),
          )


          */


        ],
      ),
    );
  }

  Widget SignupPage() {
    return new Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.05), BlendMode.dstATop),
          image: AssetImage('assets/images/mountains.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: new Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(100.0),
            child: Center(
              child: Icon(
                Icons.notifications_active,
                color: Colors.redAccent,
                size: 50.0,
              ),
            ),
          ),
          new Row(
            children: <Widget>[
              new Expanded(
                child: new Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: new Text(
                    "EMAIL",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: Colors.redAccent,
                    width: 0.5,
                    style: BorderStyle.solid),
              ),
            ),
            padding: const EdgeInsets.only(left: 0.0, right: 10.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Expanded(
                  child: TextField(
                    obscureText: true,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'samarthagarwal@live.com',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 24.0,
          ),
          new Row(
            children: <Widget>[
              new Expanded(
                child: new Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: new Text(
                    "CONTRASEÑA",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: Colors.redAccent,
                    width: 0.5,
                    style: BorderStyle.solid),
              ),
            ),
            padding: const EdgeInsets.only(left: 0.0, right: 10.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Expanded(
                  child: TextField(
                    obscureText: true,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '*********',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 24.0,
          ),
          new Row(
            children: <Widget>[
              new Expanded(
                child: new Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: new Text(
                    "REPETIR CONTRASEÑA",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: Colors.redAccent,
                    width: 0.5,
                    style: BorderStyle.solid),
              ),
            ),
            padding: const EdgeInsets.only(left: 0.0, right: 10.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Expanded(
                  child: TextField(
                    obscureText: true,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '*********',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 24.0,
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: new FlatButton(
                  child: new Text(
                    "Ya tienes una cuanta?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      fontSize: 15.0,
                    ),
                    textAlign: TextAlign.end,
                  ),
                  onPressed: () => {},
                ),
              ),
            ],
          ),
          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 50.0),
            alignment: Alignment.center,
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new FlatButton(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    color: Colors.redAccent,
                    onPressed: () => {},
                    child: new Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 20.0,
                      ),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Expanded(
                            child: Text(
                              "ENVIAR",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
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
    );
  }

  gotoLogin() {
    //controller_0To1.forward(from: 0.0);
    _controller.animateToPage(
      0,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  gotoSignup() {
    //controller_minus1To0.reverse(from: 0.0);
    _controller.animateToPage(
      2,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  PageController _controller = new PageController(initialPage: 1, viewportFraction: 1.0);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
//      child: new GestureDetector(
//        onHorizontalDragStart: _onHorizontalDragStart,
//        onHorizontalDragUpdate: _onHorizontalDragUpdate,
//        onHorizontalDragEnd: _onHorizontalDragEnd,
//        behavior: HitTestBehavior.translucent,
//        child: Stack(
//          children: <Widget>[
//            new FractionalTranslation(
//              translation: Offset(-1 - (scrollPercent / (1 / numCards)), 0.0),
//              child: SignupPage(),
//            ),
//            new FractionalTranslation(
//              translation: Offset(0 - (scrollPercent / (1 / numCards)), 0.0),
//              child: HomePage(),
//            ),
//            new FractionalTranslation(
//              translation: Offset(1 - (scrollPercent / (1 / numCards)), 0.0),
//              child: LoginPage(),
//            ),
//          ],
//        ),
//      ),
        child: PageView(
          controller: _controller,
          physics: new AlwaysScrollableScrollPhysics(),
          children: <Widget>[LoginPage(), HomePage(), SignupPage()],
          scrollDirection: Axis.horizontal,
        ));
  }
}
*/