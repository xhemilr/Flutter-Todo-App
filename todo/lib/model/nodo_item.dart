import 'package:flutter/material.dart';

class NoDoItem extends StatelessWidget {

  String _itemName;
  String _dateCreated;
  int _id;



  NoDoItem(this._itemName, this._dateCreated);

  NoDoItem.map(dynamic obj){
    this._itemName = obj['itemName'];
    this._dateCreated = obj['dateCreated'];
    this._id = obj['id'];
  }

  String get itemName => _itemName;

  String get dateCreated => _dateCreated;

  int get id => _id;

  Map<String, dynamic> toMap(){
    var map = new Map<String, dynamic>();
    map['itemName'] = _itemName;
    map['dateCreated'] = _dateCreated;
    if(_id != null){
      map['id'] = _id;
    }
    return map;
  }

  NoDoItem.fromMap(Map<String, dynamic> map){
    this._itemName = map['itemName'];
    this._dateCreated = map['dateCreated'];
    this._id = map['id'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _itemName,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: Text(
                  'Created on: $_dateCreated',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontStyle: FontStyle.italic
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
