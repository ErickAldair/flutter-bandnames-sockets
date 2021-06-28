import 'dart:io';

import 'package:band_name/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:band_name/models/band.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List <Band> bands = [
    /*Band(id: '1', name: 'Hear This Music', votes: 5),
    Band(id: '2', name: 'Carbom Fiber Music', votes: 3),
    Band(id: '3', name: 'Pina Records', votes: 1),
    Band(id: '4', name: 'La Alcaldia', votes: 2),
    Band(id: '5', name: 'Casa Blanca', votes: 5),*/
  ];

  @override
  void initState() {

   final  socketService = Provider.of<SocketService>(context, listen: false);
   
   socketService.socket.on('active-bands', _handleActiveBands);
   super.initState();
  }

  _handleActiveBands(dynamic payload){

    this.bands = (payload as List)
     .map((band) => Band.fromMap(band))
     .toList();

     setState(() {});

  }


  @override
  void dispose() {
    final  socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final  socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('DiscName', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.Online)
            ? Icon(Icons.check_circle, color: Colors.blue[300])
            : Icon(Icons.offline_bolt, color: Colors.red),



          )
        ],
      ),
      body: Column(
        children: [
          _showGraph(),
          Expanded(
            child: ListView.builder(
                  itemCount: bands.length,
                  itemBuilder: (cotext, i) => _bandTile(bands[i])
                ),
          )
      ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
   );
  }

  Widget _bandTile(Band band) {

    final  socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) => socketService.socket.emit('delete-band', {'id': band.id }),
      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete Band',style: TextStyle(color: Colors.white)),
        ),
      ),
      child: ListTile(
            leading: CircleAvatar(
              child: Text(band.name.substring(0,2)),
              backgroundColor: Colors.blue[100],
            ),
            title: Text(band.name),
            trailing: Text('${band.votes}', style: TextStyle(fontSize: 20)),
            onTap: () => socketService.socket.emit('vote-band', {'id': band.id }),
          ),
    );
  }

  addNewBand(){

    final textController = new TextEditingController();

    if(Platform.isAndroid){

     return showDialog(
      context: context, 
      builder: (_) =>  AlertDialog(
          title: Text('New Disc NAME:'),
          content: TextField(
            controller: textController,
          ),
          actions: [
            MaterialButton(
              child: Text('ADD'),
              elevation: 5,
              textColor: Colors.blue,
              onPressed: ()=>addBandToList(textController.text)
            ),
            MaterialButton(
              child: Text('Dismess'),
              elevation: 5,
              textColor: Colors.red,
              onPressed: ()=>Navigator.pop(context)
            )
          ],
        )      
    );
  }
  showCupertinoDialog(
    context: context,
    builder: ( _ ) => CupertinoAlertDialog(
        title: Text('New Disc Name'),
        content: CupertinoTextField(
          controller: textController,
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('ADD'),
            onPressed: ()=>addBandToList(textController.text)
            ),
            CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Dismiss'),
            onPressed: ()=>Navigator.pop(context)
            )
        ],
      )   
    );
  }

  void addBandToList(String name){

    final  socketService = Provider.of<SocketService>(context, listen: false);

    if(name.length>1){
     socketService.socket.emit('add-band',{'name': name });

    }
    
    Navigator.pop(context);
  }

  //mostrar grafica

  Widget _showGraph(){
    Map <String, double> dataMap = new Map();
    bands.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
     });

     final List<Color> colorList = [

       Colors.blue[50],
       Colors.blue[200],
       Colors.pink[50],
       Colors.pink[200],
       Colors.yellow[50],
       Colors.yellow[200],


     ];
  return  Container(
    padding: EdgeInsets.only(top: 10),
    width: double.infinity,
    height: 200,
    child:PieChart(
        dataMap: dataMap,
        animationDuration: Duration(milliseconds: 800),
        chartLegendSpacing: 32.0,
        chartRadius: MediaQuery.of(context).size.width / 2.7,
        showChartValuesInPercentage: true,
        showChartValues: true,
        showChartValuesOutside: false,
        chartValueBackgroundColor: Colors.grey[200],
        colorList: colorList,
        showLegends: true,
        legendPosition: LegendPosition.right,
        decimalPlaces: 1,
        showChartValueLabel: true,
        initialAngle: 0,
        chartValueStyle: defaultChartValueStyle.copyWith(
          color: Colors.blueGrey[900].withOpacity(0.9),
        ),
        chartType: ChartType.ring,
    )
    );
  }
}