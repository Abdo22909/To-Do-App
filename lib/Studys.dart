import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:share/share.dart';
import 'package:image_picker/image_picker.dart';
class studys extends StatefulWidget {
  @override
  _studysState createState() => _studysState();
}
class _studysState extends State<studys> with TickerProviderStateMixin {
  AnimationController _controller;
  String filterType = "today";
  DateTime today = new DateTime.now();
  String taskPop  = "close";
  var monthNames = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEPT", "OCT", "NOV", "DEC"];
  CalendarController ctrlr = new CalendarController();
  @override
  void initState() {
    _controller=AnimationController(vsync: this,duration: Duration(milliseconds: 200));
    super.initState();
  }
  final Controller = ScrollController();
  TabController tabController;
  @override
  void intiStat(){
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(appBar: AppBar(elevation: 0,toolbarHeight: 10,),floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Column(mainAxisSize: MainAxisSize.min,children: [
          Container(alignment: Alignment.topCenter,height: 70,width: 56,child:
          ScaleTransition(scale: CurvedAnimation(
              parent: _controller,
              curve: Interval(0.0,1.0,curve: Curves.easeOut)
          ),
              child: FloatingActionButton(backgroundColor: Colors.blue,heroTag: 'add',mini: true,onPressed: (){
                Share.share("Flutter is cool!");
              }, child: Icon(Icons.share),)),),
          Container(height: 70,width: 56,child: FloatingActionButton(onPressed: (){
            if(_controller.isDismissed){
              _controller.forward();
            }else{
              _controller.reverse();
            }
          },
            child: Icon(Icons.more_vert),backgroundColor: Colors.blue,),),
        ],),
        body: Column(
            children: [
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
              Container(color: Colors.blue,
                child: TabBar(
                    controller: tabController,
                    labelPadding: EdgeInsets.all(1),
                    tabs: [
                      Tab(child:Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text('do',style: TextStyle(color: Colors.white),),Icon(Icons.home),],),),
                      Tab(child:Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text('doing',style: TextStyle(color:
                      Colors.white),),Icon(Icons.dangerous,)],),),
                      Tab(child:Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text('done',style: TextStyle(color: Colors.white),),Icon(Icons.done),],),),
                    ]),
              ),
              Expanded(
                child: Container(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      NewNote1(),
                      doing(),
                      done(),
                    ],
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}

class NewNote1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Screen();
  }

}
class Screen extends StatefulWidget {
  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  String filterType = "today";
  DateTime today = new DateTime.now();
  String taskPop = "close";
  var monthNames = [
    "JAN",
    "FEB",
    "MAR",
    "APR",
    "MAY",
    "JUN",
    "JUL",
    "AUG",
    "SEPT",
    "OCT",
    "NOV",
    "DEC"
  ];
  CalendarController ctrlr = new CalendarController();
  List _myList1 = [];

  @override
  void initState() {
    super.initState();
    PathProvider4.readData().then((data1) {
      setState(() {
        _myList1 = json.decode(data1);
      });
    }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
            child: Row(
              children: <Widget>[
                Expanded(child:
                FlatButton(onPressed: (){Navigator.pushNamed(context,'newTask3');}, child:Text('New Task') ))
              ],
            ),
          ),
          TaskList1(_myList1),
        ],
      ),
    );
  }
}

class TaskList1 extends StatefulWidget {
  List _myList1;
  TaskList1(this._myList1);
  @override
  _TaskList1State createState() => _TaskList1State();
}

class _TaskList1State extends State<TaskList1> {
  File _image;
  Map<String,dynamic> _lastRemoved;
  int _lastPosRemoved ;
  @override
  Widget build(BuildContext context) {
    var _myList1 = widget._myList1;

    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
        print('Image Path $_image');
      });
    }
    return Expanded(
      child:RefreshIndicator(
        onRefresh: () async{
          await Future.delayed(Duration(seconds: 1));
          setState(() {
            _myList1.sort((c,d){
              if(c["done"] && !d["done"]) return 1;
              else if(!c["done"]&& d["done"]) return -1 ;
              else return 0 ;
            });
          });
        },
        child:ListView.builder(
            itemCount: _myList1.length,
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
                    child: Column(
                        children: [
                          Container(decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.horizontal(left: Radius.circular(10),right: Radius.circular(10))),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8,right: 20,bottom: 8),
                              child: Row(mainAxisAlignment: MainAxisAlignment.end,
                                children: [ Text(_myList1[index]["title"]),],),
                            ),
                          ),
                          Row(
                            children: [

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(height: 100,width: 200,
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children:[Padding(
                                          padding: const EdgeInsets.only(top: 8),
                                          child: Text(_myList1[index]["Description"]),
                                        ),
                                        ]),
                                  ),
                                  Row(
                                      children:[
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
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 10,top: 10),
                                          child: CircleAvatar(radius:100,backgroundColor: Colors.white,child: (_image!=null)?Image.file(
                                            _image,
                                            fit: BoxFit.fill,
                                          ):Image.network(
                                            "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                                            fit: BoxFit.fill,
                                          ),),
                                        ),
                                        IconButton(
                                          onPressed:(){
                                            getImage();
                                          },
                                          icon: Icon(Icons.attach_file, color:  Colors.grey,),
                                        ),
                                      ]),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10,bottom: 0),
                            child: Row(children: [Text(_myList1[index]["Due Data"]),],),
                          )
                        ] ),
                  ),
                  secondaryActions: [
                    IconSlideAction(
                      caption: 'Done',color: Colors.white,icon: Icons.done,closeOnTap: true,
                      onTap: (){
                        setState(() {
                          _lastRemoved= Map.from(widget._myList1[index]);
                          _lastPosRemoved = index;
                          widget._myList1.removeAt(index);
                          PathProvider4.saveData(done());
                          final snack = SnackBar(backgroundColor: Colors.blue,
                            content: Text("Task${_lastRemoved["title"]} removed!"),
                            action: SnackBarAction(
                              label: "تراجع",disabledTextColor: Colors.black,textColor: Colors.white,
                              onPressed: (){
                                setState(() {
                                  widget._myList1.insert(_lastPosRemoved,_lastRemoved);
                                  PathProvider4.saveData(_myList1);
                                });
                              },
                            ),
                            duration: Duration(seconds: 4),
                          );
                          Scaffold.of(context).removeCurrentSnackBar();
                          Scaffold.of(context).showSnackBar(snack);
                        });
                      },
                    ),
                    IconSlideAction(
                      caption: "Delete",color: Colors.blue,
                      icon: Icons.edit,closeOnTap: true,
                      onTap: (){
                        setState(() {
                          _lastRemoved= Map.from(widget._myList1[index]);
                          _lastPosRemoved = index;
                          widget._myList1.removeAt(index);
                          PathProvider4.saveData(_myList1);
                          final snack = SnackBar(backgroundColor: Colors.blue,content: Text("Task${_lastRemoved["title"]} removed!"),
                            action: SnackBarAction(
                              label: "تراجع",disabledTextColor: Colors.black,textColor: Colors.white,
                              onPressed: (){
                                setState(() {
                                  widget._myList1.insert(_lastPosRemoved,_lastRemoved);
                                  PathProvider4.saveData(_myList1);
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

class PathProvider4{
  static Future<File> getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data4.json");
  }
  static Future<File> saveData(list1) async {
    String data4 = json.encode(list1);
    final file1 = await getFile();
    return file1.writeAsString(data4);
  }
  static Future<String> readData() async {
    try{
      final file1 = await getFile();
      return file1.readAsString();
    }catch(a){
      return null ;
    }
  }
}









































class newTask3 extends StatefulWidget {
  @override
  _newTask3State createState() => _newTask3State();
}

class _newTask3State extends State<newTask3> {
  List _myList = [];
  final _textfieldcontroller = TextEditingController();
  final _textfield = TextEditingController();
  final _textfieldcontroller1 = TextEditingController();
  @override
  void initState() {
    super.initState();
    PathProvider4.readData().then((data1) {
      setState(() {
        _myList = json.decode(data1);
      });
    }
    );
  }

  void _addTask() {
    if (_textfieldcontroller.text != "" && _textfield.text != "" && _textfieldcontroller1.text != ""&&_image!=null) {
      setState(() {
        Map<String, dynamic> newList1 = Map();
        newList1["title"] = _textfieldcontroller.text;
        newList1["Description"] = _textfield.text;
        newList1["Due Data"] = _textfieldcontroller1.text;
        _myList.add(newList1);
        _textfieldcontroller.text = "";
        _textfield.text = "";
        _textfieldcontroller1.text = "";
        PathProvider4.saveData(_myList);
      });
    }
  }
  File _image;

  @override
  Widget build(BuildContext context) {

    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
        print('Image Path $_image');
      });
    }


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Text("New Task", style: TextStyle(
            fontSize: 25
        ),),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              height: 30,
              color: Colors.blue,
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 70,
                width: MediaQuery.of(context).size.width,
                color: Colors.blue.withOpacity(0.8),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: Colors.white
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.85,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 25,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("For", style: TextStyle(
                            fontSize: 18
                        ),),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              color: Colors.grey.withOpacity(0.2)
                          ),
                          child: Text("Asignee", style: TextStyle(
                              fontSize: 18
                          ),),
                        ),
                        SizedBox(width: 10,),
                        Text("In", style: TextStyle(
                            fontSize: 18
                        ),),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              color: Colors.grey.withOpacity(0.2)
                          ),
                          child: Text("Project", style: TextStyle(
                              fontSize: 18
                          ),),
                        ),
                      ],
                    ),
                    SizedBox(height: 15,),
                    Container(
                        padding: EdgeInsets.all(10),
                        color: Colors.white.withOpacity(0.2),
                        child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                            children:[Text('title',style: TextStyle(fontSize: 25,color: Colors.black87),),TextField(
                              controller: _textfieldcontroller
                              ,decoration: InputDecoration(
                              hintText: "title", labelStyle: TextStyle(fontSize: 30,color: Colors.black),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                            ),
                            ])),
                    SizedBox(height: 15,),
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Description", style: TextStyle(
                              fontSize: 18
                          ),),
                          SizedBox(height: 10,),
                          Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.5)
                                )
                            ),
                            child: TextField(
                              controller: _textfield,
                              maxLines: 6,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Add description here",
                              ),
                              style: TextStyle(
                                  fontSize: 18
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.5)
                                )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: IconButton(
                                    onPressed:(){
                                      getImage();
                                    },
                                    icon: Icon(Icons.attach_file, color:  Colors.grey,),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            padding: EdgeInsets.all(10),
                            color: Colors.grey.withOpacity(0.2),
                            child: TextField(
                              controller: _textfieldcontroller1,
                              decoration: InputDecoration(
                                hintText: "Due Date",
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                  fontSize: 18
                              ),
                            ),
                          ),

                          SizedBox(height: 20,),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                color: Colors.blue
                            ),
                            child: RaisedButton(elevation: 0,
                              onPressed: _addTask,
                              child: Text("Add Task"),color: Colors.blue,textColor: Colors.white,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}





















class doing extends StatefulWidget {
  @override
  _doingState createState() => _doingState();
}

class _doingState extends State<doing> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}




class done extends StatefulWidget {
  @override
  _doneState createState() => _doneState();
}

class _doneState extends State<done> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(children: [
          Container(child:Lottie.asset('asset/lottie/36184-awake-person-and-ui.json')),
          Container(child: Column(children: [
            SingleChildScrollView()
          ],),)
        ],),
      ),
    );
  }
}
