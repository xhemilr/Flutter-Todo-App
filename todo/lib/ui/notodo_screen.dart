import 'package:flutter/material.dart';
import 'package:todo/model/nodo_item.dart';
import 'package:todo/util/database_helper.dart';

class NoToDoScreen extends StatefulWidget {
  @override
  _NoToDoScreenState createState() => _NoToDoScreenState();
}

class _NoToDoScreenState extends State<NoToDoScreen> {

  var db = new DatabaseHelper();
  var _textEditingController = new TextEditingController();

  final List<NoDoItem> itemList = <NoDoItem>[];

  @override
  void initState() {
    super.initState();
    _readNoDoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              itemCount: itemList.length,
              padding: EdgeInsets.all(10),
              reverse: false,
              itemBuilder: (_, position){
                return Card(
                  color: Colors.white10,
                  child: ListTile(
                    title: itemList[position],
//                    onLongPress: ()=> print('test'),
                    trailing: new GestureDetector(
                      key: new Key(itemList[position].itemName),
                      child: Icon(
                        Icons.remove_circle,
                        color: Colors.redAccent,
                        size: 50,
                        ),
                      onTap: () => (){
                        print('test');
                          _deleteNoDo(itemList[position].id, position);
                        },
                    ),
                  ),
                );
              }
            ),
          ),
          Divider(
            height: 1.0,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Item',
        backgroundColor: Colors.redAccent,
        child: ListTile(
          title: Icon(Icons.add),
        ),
        onPressed: _showFormDialog,
      ),
    );
  }
  void _showFormDialog(){

    var alert = new AlertDialog(
      content: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textEditingController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Item',
                hintText: 'eg. Dont buy stuff',
                icon: Icon(Icons.note_add)
              ),
            ),
          )
        ],
      ),
      actions: [
        FlatButton(
          onPressed: (){
            _handleSubmit(_textEditingController.text);
            _textEditingController.clear();
          },
          child: Text('Save'),
        ),
        FlatButton(
          onPressed: ()=> Navigator.pop(context),
          child: Text('Cancel'),
        )
      ],
    );
    showDialog(
      context: context,
      builder: (_){
        return alert;
      }
    );
  }
  void _handleSubmit(String text) async {
    _textEditingController.clear();
    NoDoItem noDoItem = new NoDoItem(text, DateTime.now().toIso8601String());
    int savedItemId = await db.saveUser(noDoItem);

    NoDoItem addedItem = await db.getUser(savedItemId);

    Navigator.pop(context);
    setState(() {
      itemList.insert(0, addedItem);
    });
  }

  void _readNoDoList() async {
    List items = await db.getAllUsers();
    items.forEach((element) {
//      NoDoItem noDoItem = NoDoItem.map(element);
      setState(() {
        itemList.add(NoDoItem.map(element));
      });
    });
  }

  void _deleteNoDo(int id, int index) async {
    await db.deleteUser(id);

    setState(() {
      itemList.removeAt(index);
    });
  }
}
