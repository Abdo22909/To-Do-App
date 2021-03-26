import 'dart:convert';
import 'dart:io';
import 'package:speech_to_text/speech_to_text.dart'as stt;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:path_provider/path_provider.dart';
import 'package:table_calendar/table_calendar.dart';
class NewNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Screen(),
    );
  }

}
class Screen extends StatefulWidget {
  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  final Map <String,HighlightedWord> _highlights={
    'flutter':HighlightedWord(
      onTap: () =>print('flutter'),
      textStyle: const TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),
    ),
    'voise':HighlightedWord(
      onTap: () =>print('voice'),
      textStyle: const TextStyle(color: Colors.green,fontWeight: FontWeight.bold),
    ),
    'subscribe':HighlightedWord(
      onTap: () =>print('subscribe'),
      textStyle: const TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
    ),
    'like':HighlightedWord(
      onTap: () =>print('like'),
      textStyle: const TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold),
    ),
    'comment':HighlightedWord(
      onTap: () =>print('comment'),
      textStyle: const TextStyle(color: Colors.green,fontWeight: FontWeight.bold),
    ),
  };
  stt.SpeechToText _speech;
  bool _isListening =false;
  String _text='';
  double _confidence =1.0;

  String filterType = "today";
  DateTime today = new DateTime.now();
  String taskPop  = "close";
  var monthNames = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEPT", "OCT", "NOV", "DEC"];
  CalendarController ctrlr = new CalendarController();
  List _myList = [];
  final _textfieldcontroller = TextEditingController();
  @override
  void initState(){
    super.initState();
    PathProvider.readData().then((data){
      setState(() {
        _myList = json.decode(data);
      });
    }
    );
    _speech =stt.SpeechToText();
  }
  void _addNote(){
    if(_textfieldcontroller.text !=""||_text !=""){
      setState(() {
        Map<String,dynamic> newList=Map();
        newList["title"]=_textfieldcontroller.text;
        newList["title1"]=_text;
        newList["done"] = false;
        _myList.add(newList);
        _textfieldcontroller.text = "";
        PathProvider.saveData(_myList);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).backgroundColor,
        endRadius: 85,
        duration: const Duration(milliseconds: 1000),
        repeat: true,
        child: FloatingActionButton(
          onPressed:_listen,
          child: Icon(_isListening?Icons.mic:Icons.mic_none),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        toolbarHeight: 10,
      ),
      body: Column(
        children:<Widget> [
          Container(color: Colors.blue,width: 700,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Today ${monthNames[today.month-1]}, ${today.day}/${today.year}", style: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                ), )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
            child: Row(
              children: <Widget>[
                Expanded(child: TextField(
                  controller: _textfieldcontroller,
                  decoration: InputDecoration(hintText: _text,
                    labelText: "New Note", labelStyle: TextStyle(color: Colors.blue),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                )),
                RaisedButton(
                  onPressed: _addNote,
                  child: Text("Add"),color: Colors.blue,textColor: Colors.white,
                ),
              ],
            ),
          ),
          TaskList(_myList),
        ],
      ),
    );
  }
  void _listen() async{
    if(!_isListening){
      bool available =await _speech.initialize(
        onStatus: (val) => print('onStatus:$val'),
        onError: (val) => print('onError:$val'),
      );
      if (available){
        setState(() => _isListening = true);
        _speech.listen(
            onResult: (val) =>setState((){
              _text =val.recognizedWords;
              if (val.hasConfidenceRating && val.confidence > 0){
                _confidence =val.confidence;
              }
            })
        );
      }
    }else{
      setState(()=>_isListening =false);
      _speech.stop();
    }
  }
}

class TaskList extends StatefulWidget {
  List _myList;
  TaskList(this._myList);
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  Map<String,dynamic> _lastRemoved;
  int _lastPosRemoved ;
  @override
  Widget build(BuildContext context) {
    var _myList = widget._myList;
    return Expanded(
      child:RefreshIndicator(
        onRefresh: () async{
          await Future.delayed(Duration(seconds: 1));
          setState(() {
            _myList.sort((a,b){
              if(a["done"] && !b["done"]) return 1;
              else if(!a["done"]&& b["done"]) return -1 ;
              else return 0 ;
            });
          });
        },
        child:ListView.builder(
            itemCount: _myList.length,
            itemBuilder: (context,index){

              return Dismissible(key:UniqueKey(),background: Container(color: Colors.blue,
                child: Align(
                  alignment: Alignment(-0.9,0.0),
                  child: Icon(Icons.delete , color: Colors.white,),
                ),),
                direction: DismissDirection.startToEnd,
                child: Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.3,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            offset: Offset(0,9),
                            blurRadius: 20,
                            spreadRadius: 1
                        )]
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.blue,
                                  width: 4)
                          ),
                        ),
                        Container(height: 130,width: 200,
                          child: Column(mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children:[Padding(
                                padding: const EdgeInsets.only(top: 8,bottom: 8),
                                child:Column(children: [Text(_myList[index]["title"]),Text(_myList[index]["title1"]),],)
                              ),
                              ]),
                        ),

                        Expanded(child: Container(),),
                        Container(
                          height: 50,
                          width: 5,
                        ),
                      ],
                    ),
                  ),
                  secondaryActions: [
                    IconSlideAction(
                      caption: "Delete",color: Colors.blue,
                      icon: Icons.edit,closeOnTap: true,
                      onTap: (){
                        setState(() {
                          _lastRemoved= Map.from(widget._myList[index]);
                          _lastPosRemoved = index;
                          widget._myList.removeAt(index);
                          PathProvider.saveData(_myList);
                          final snack = SnackBar(backgroundColor: Colors.blue,content: Text("Task${_lastRemoved["title"]} removed!"),
                            action: SnackBarAction(
                              label: "تراجع",disabledTextColor: Colors.black,textColor: Colors.white,
                              onPressed: (){
                                setState(() {
                                  widget._myList.insert(_lastPosRemoved,_lastRemoved);
                                  PathProvider.saveData(_myList);
                                });
                              },
                            ),
                            duration: Duration(seconds: 4),
                          );
                          Scaffold.of(context).removeCurrentSnackBar();
                          Scaffold.of(context).showSnackBar(snack);
                        });
                      },
                    )
                  ],
                ),
              );
            }

        ),
      ), );
  }
}

class PathProvider{
  static Future<File> getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }
  static Future<File> saveData(list) async {
    String data = json.encode(list);
    final file = await getFile();
    return file.writeAsString(data);
  }
  static Future<String> readData() async {
    try{
      final file = await getFile();
      return file.readAsString();
    }catch(e){
      return null ;
    }
  }
}

