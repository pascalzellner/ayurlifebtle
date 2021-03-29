import 'package:ayurlifebtle/services/cardiobyteanalyse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';


class CharacteristicScreen extends StatefulWidget {
  CharacteristicScreen({Key key,this.characteristic}) : super(key: key);

  final BluetoothCharacteristic characteristic;

  @override
  _CharacteristicScreenState createState() => _CharacteristicScreenState();
}

class _CharacteristicScreenState extends State<CharacteristicScreen> {

  bool _setNotify = true;
  String _text = 'ABONNER';

  TextButton _button(){
    switch (_setNotify){
      case true:
      return TextButton(
        onPressed: (){
          setState(() {
            _setNotify=false;
            _text='OUBLIER';
          });
          widget.characteristic.setNotifyValue(true);
        },
        child: Text(_text,style: TextStyle(color: Colors.white),)
      );
      break;
      case false:
      return TextButton(
        onPressed: (){
          setState(() {
            _setNotify=true;
            _text='ABONNER';
          });
          widget.characteristic.setNotifyValue(false);
        },
        child: Text(_text,style:TextStyle(color: Colors.white,),)
      );
      break;
    }
  }

  ListTile _tileValue(){
    if(widget.characteristic.isNotifying==false){
      return ListTile(
        title: Text('Valeurs émises'),
        subtitle: StreamBuilder<List<int>>(
          stream:widget.characteristic.value,
          initialData: [],
          builder: (c,snapshot)=> Column(children:[
            Text(snapshot.data.toString()),
            Text(_uintType(snapshot.data)),
            Text('HR: '+ CardioByteAnalyseService().getlastHearRateValue(snapshot.data).toString()),
            Text(_skinContact(snapshot.data).toString()),
            Text(_energyManadged(snapshot.data).toString()),
            Text(_availableRR(snapshot.data).toString()),
            Text(CardioByteAnalyseService().rrData(snapshot.data).toString()),
          ])
        ),
      );
    }else{
      return ListTile(
        title:Text('Abonnement inactif')
      );
    }
  }

  String _skinContact(List<int>values){
    if(values.length>0){
      if(CardioByteAnalyseService().isSensorContactAvailable(values)){
      if(CardioByteAnalyseService().isSensorContactActiv(values)){
        return 'Contact sense available & activ';
      }else{
        return 'Conctact sense availble & unactiv';
      }
    }else{
      return ('Contact sense unavailable');
    }
    }else{
      return null;
    }
  }

  String _uintType(List<int> values){
    bool _type = CardioByteAnalyseService().isUint8Sensor(values);
    switch(_type){
      case true:
      return 'Unint8 data package';
      break;
      case false:
      return 'Uint16 data package';
      break;
      default:
      return 'Pas de data package';
    }
  }

  String _energyManadged(List<int>values){
    if(values.length>0){
      if(CardioByteAnalyseService().isEnergyManagedExpanditure(values)){
        return 'Energy Expanditure Managed';
      }else{
        return 'Energy Expanditure Unaivailable';
      }
    }else{
      return 'Energy Expanditure Unaivailable';
    }
  }

  String _availableRR(List<int>values){

    switch(CardioByteAnalyseService().isRRavailable(values)){
      case true:
      return 'RR available';
      break;
      case false:
      return 'RR unvailable';
      break;
      default:
      return 'Data null';
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Char/'+ widget.characteristic.uuid.toString(),style: TextStyle(fontSize: 12.0),),
        actions: [
          _button(),
        ],
      ),
      body: Column(children: [
        _tileValue(),
        StreamBuilder<List<BluetoothDescriptor>>(
          stream:Stream.periodic(Duration(seconds: 1)).asyncMap((_) => widget.characteristic.descriptors),
          initialData: [],
          builder: (c,snapshot)=>Column(
            children: snapshot.data.map(
              (d)=>ListTile(
                title: Text(d.uuid.toString(),style:TextStyle(fontSize: 12.0)),
                subtitle: StreamBuilder(
                  stream: d.value,
                  initialData: [],
                  builder: (c,snapshot)=>Text(snapshot.data.toString()),
                )
            ),
          ).toList(),
        ),
      ),
      ],
    ),
    );
  }
}