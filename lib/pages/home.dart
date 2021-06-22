import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:band_name/models/band.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List <Band> bands = [
    Band(id: '1', name: 'Hear This Music', votes: 5),
    Band(id: '2', name: 'Carbom Fiber Music', votes: 3),
    Band(id: '3', name: 'Pina Records', votes: 1),
    Band(id: '4', name: 'La Alcaldia', votes: 2),
    Band(id: '5', name: 'Casa Blanca', votes: 5),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('DiscName', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (cotext, i) => _bandTile(bands[i])
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
   );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction){
        print('direccion: $direction');
      },
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
            onTap: (){
              print(band.name);
            },
          ),
    );
  }

  addNewBand(){

    final textController = new TextEditingController();

    if(Platform.isAndroid){

     return showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
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
        );
      },
    );
  }
  showCupertinoDialog(
    context: context,
    builder: ( _ ){
      return CupertinoAlertDialog(
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
      );
    }
    );
  }

  void addBandToList(String name){

    if(name.length>1){

      this.bands.add(new Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {
        
      });
    }
    
    Navigator.pop(context);
  }
}