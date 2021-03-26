import 'dart:async';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_to_text.dart'as stt;
import 'package:todo_app/Note.dart';
import 'package:todo_app/Read.dart';
import 'package:todo_app/Game.dart';
import 'package:todo_app/Work.dart';
import 'package:todo_app/Music.dart';
import 'package:todo_app/Sports.dart';
import 'package:todo_app/Studys.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
main()=>runApp(MaterialApp(
  title:'To Do',
  debugShowCheckedModeBanner: false,
  home: SplashScreen(),
));
class pushNotificationsManager {
  pushNotificationsManager._();
  factory pushNotificationsManager() => _instance;
  static final pushNotificationsManager _instance =
  pushNotificationsManager._();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;
  Future<void> init() async {
    if (!_initialized) {
      //ios
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure();
      String token = await _firebaseMessaging.getToken();
      print("my new token - $token");
      _initialized=true;
    }
  }
}
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds:4),
            ()=> Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => Home())));
  }
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Lottie.asset('asset/lottie/46121-developing-section.json'),)
    );
  }
}




class Home extends StatefulWidget {
  Home ({Key key}):super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  ThemeData _lightThem=ThemeData(accentColor: Colors.lightBlueAccent,
      brightness: Brightness.light,primaryColor: Colors.blue);

  ThemeData _darkThem =ThemeData(accentColor: Colors.black,
      brightness: Brightness.dark,primaryColor: Colors.black);

  bool _light=true;

  Widget build(BuildContext context) {
    return MaterialApp(title: 'To Do',
      routes: ({
        'home1':(Context)=>home1(),
        'Tasks':(Context)=>Tasks(),
        'read':(Context)=>read(),
        'work':(Context)=>work(),
        'game':(Context)=>game(),
        'music':(Context)=>music(),
        'studys':(Context)=>studys(),
        'sports':(Context)=>sports(),
        'NewNote':(Context)=>NewNote(),
        'newTask':(Context)=>newTask(),
        'newTask1':(Context)=>newTask1(),
        'newTask2':(Context)=>newTask2(),
        'newTask3':(Context)=>newTask3(),
        'newTask4':(Context)=>newTask4(),


      }),
      theme: _light ?_lightThem :_darkThem,
      debugShowCheckedModeBanner: false,
      home:Scaffold(
        drawer: Drawer(child:Column(children: [MainDrawer(),Switch(value: _light, onChanged: (State){
          setState(() {
            _light=State;
          });
        })],)),
        body:onboarding(),)
    );
  }
}

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        child: Padding(
          padding: EdgeInsets.only(top: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50.0,
                backgroundImage: NetworkImage(
                  "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                "username",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),


            ],
          ),
        ),
      ),
      SizedBox(
        height: 20.0,
      ),

      ListTile(
        onTap: () {},
        leading: Icon(
          Icons.person,
          color: Colors.black,
        ),
        title: Text("Your Profile"),
      ),

      ListTile(
        onTap: () {},
        leading: Icon(
          Icons.inbox,
          color: Colors.black,
        ),
        title: Text("Your Inbox"),
      ),

      ListTile(
        onTap: () {},
        leading: Icon(
          Icons.assessment,
          color: Colors.black,
        ),
        title: Text("help"),
      ),
      ListTile(
        onTap: () {},
        leading: Icon(
          Icons.notifications,
          color: Colors.black,
        ),
        title: Text("notifications"),
      ),
      ListTile(
        onTap: () {},
        leading: Icon(
          Icons.settings,
          color: Colors.black,
        ),
        title: Text("tools"),
      ),
    ]);
  }
}








class onboarding extends StatefulWidget {
  @override
  _onboardingState createState() => _onboardingState();
}

class _onboardingState extends State<onboarding> {
  int currentPage = 0;
  PageController _pageController = new PageController(
      initialPage: 0,
      keepPage: true
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.7,
                child: PageView(
                  controller: _pageController,
                  children: [
                    onBoardPage("onboard1", "Welcome to_do"),
                    onBoardPage("onboard2", "Work Happens"),
                    onBoardPage("onboard3", "Task and Assignments"),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) => getIndicator(index)),
              )
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.only(top: 20),
              height: 300,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              decoration: BoxDecoration(

              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    child: Container(height: 300,
                      padding: EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft:Radius.elliptical(120,120),bottomLeft: Radius.elliptical(120,120)),
                          color: Colors.blue,
                          boxShadow: [BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: Offset(0, 9),
                              blurRadius: 20,
                              spreadRadius: 3
                          )
                          ]
                      ),
                      child:  Column(mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Padding( padding: const EdgeInsets.only(left:20,right:20,bottom: 20),
                          child: FlatButton(onPressed: (){Navigator.pushNamed(context,'home1');},
                            child: Container(height: 90,width: 600,
                              decoration: BoxDecoration(color: Colors.white,borderRadius:
                              BorderRadius.horizontal(left:Radius.circular(100),)
                              ),
                             child: Column(
                                mainAxisAlignment: MainAxisAlignment.center
                                ,children:[
                              Text('Get Started',style: TextStyle(fontSize: 40,backgroundColor: Colors.blue[100],letterSpacing: 8,
                              ),)]),),),),
 //////////////////////////////////////////                       ////////////////////////
                      ],),
            )
              ),
                ]),
          )
          ),
     ]),
    );
  }

  AnimatedContainer getIndicator(int pageNo) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      height: 10,
      width: (currentPage == pageNo) ? 20 : 10,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: (currentPage == pageNo) ? Colors.black : Colors.grey
      ),
    );
  }

  Column onBoardPage(String img, String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          height: 200,
          width: MediaQuery
              .of(context)
              .size
              .width,
          padding: EdgeInsets.all(50),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('asset/image/$img.png')
              )
          ),
        ),
        SizedBox(height: 50,),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(title, style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w500
          ),),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
          child: Text(
            "",
            style: TextStyle(
                fontSize: 16,
                color: Colors.grey
            ), textAlign: TextAlign.center,),
        )
      ],
    );
  }
}






enum AuthType { login, register }

class home1 extends StatelessWidget {
  final AuthType authType;

  const home1({Key key, this.authType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 45),
                      Text(
                        'Welcome',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 3),
                      ),
                      SizedBox(height: 40,),
                      Center(child:  Lottie.asset('asset/lottie/46116-digital-workspace.json'),)
                    ],
                  ),
                ),
              ],
            ),
            AuthForm(),
          ],
        ),
      ),
    );
  }
}
/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
/////////////////////////////////////////////////
class AuthForm extends StatefulWidget {
  final AuthType authType;

  const AuthForm({Key key, @required this.authType}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '', _password = '';
  home1 authBase = home1();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Enter your email',
                hintText: 'ex: abdo@gmail.com',
              ),
              onChanged: (value) {
                _email = value;
              },
              validator: (value) =>
              value.isEmpty ? 'You must enter a valid email' : null,
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Enter your password',
              ),
              obscureText: true,
              onChanged: (value) {
                _password = value;
              },
              validator: (value) => value.length <= 6
                  ? 'Your password must be larger than 6 characters'
                  : null,
            ),
            SizedBox(height: 20),
            OriginalButton(
              text: widget.authType == AuthType.login ? 'Register':'Login',
              color: Colors.lightBlue,
              textColor: Colors.white,
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  Navigator.pushNamed(context, 'Tasks');

                }},
            ),
            SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

class OriginalButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;

  const OriginalButton({Key key, this.text, this.onPressed, this.color, this.textColor}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: double.infinity,
      child: RaisedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: 18),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        color: color,
      ),
    );
  }
}



////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////
//////////////////////////////////////////////////////
////////////////////////////

class Tasks extends StatefulWidget {
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          AA(size: size),
          SizedBox(height: 20,),
          Padding( padding: const EdgeInsets.only(left:120,right:0,bottom: 30),
            child: FlatButton(onPressed: (){Navigator.pushNamed(context,'read');},
              child: Container(height: 90,width: 600,
                decoration: BoxDecoration(color: Colors.white,borderRadius:
                BorderRadius.horizontal(left:Radius.circular(100),)
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center
                    ,children:[
                  Text('1-Read',style: TextStyle(fontSize: 40,color: Colors.blue.withOpacity(0.7),fontWeight: FontWeight.w600),)]),),),),
          Padding( padding: const EdgeInsets.only(left:0,right:120,bottom: 30),
            child: FlatButton(onPressed: (){Navigator.pushNamed(context,'work');},
              child: Container(height: 90,width: 600,
                decoration: BoxDecoration(color: Colors.white,borderRadius:
                BorderRadius.horizontal(right:Radius.circular(100),)
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center
                    ,children:[
                  Text('2-Work',style: TextStyle(fontSize: 40,color: Colors.blue.withOpacity(0.7),fontWeight: FontWeight.w600),)]),),),),
          Padding( padding: const EdgeInsets.only(left:120,right:0,bottom: 30),
            child: FlatButton(onPressed: (){Navigator.pushNamed(context,'game');},
              child: Container(height: 90,width: 600,
                decoration: BoxDecoration(color: Colors.white,borderRadius:
                BorderRadius.horizontal(left:Radius.circular(100),)
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center
                    ,children:[
                  Text('3-Game',style: TextStyle(fontSize: 40,color: Colors.blue.withOpacity(0.7),fontWeight: FontWeight.w600),)]),),),),
          Padding( padding: const EdgeInsets.only(left:0,right:120,bottom: 30),
            child: FlatButton(onPressed: (){Navigator.pushNamed(context,'music');},
              child: Container(height: 90,width: 600,
                decoration: BoxDecoration(color: Colors.white,borderRadius:
                BorderRadius.horizontal(right:Radius.circular(100),)
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center
                    ,children:[
                  Text('4-Music',style: TextStyle(fontSize: 40,color: Colors.blue.withOpacity(0.7),fontWeight: FontWeight.w600),)]),),),),
          Padding( padding: const EdgeInsets.only(left:120,right:0,bottom: 30),
            child: FlatButton(onPressed: (){Navigator.pushNamed(context,'studys');},
              child: Container(height: 90,width: 600,
                decoration: BoxDecoration(color: Colors.white,borderRadius:
                BorderRadius.horizontal(left:Radius.circular(100),)
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center
                    ,children:[
                  Text('5-Studys',style: TextStyle(fontSize: 40,color: Colors.blue.withOpacity(0.7),fontWeight: FontWeight.w600),)]),),),),

          Padding( padding: const EdgeInsets.only(left:0,right:120,bottom: 30),
            child: FlatButton(onPressed: (){Navigator.pushNamed(context,'sports');},
              child: Container(height: 90,width: 600,
                decoration: BoxDecoration(color: Colors.white,borderRadius:
                BorderRadius.horizontal(right:Radius.circular(100),)
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center
                    ,children:[
                  Text('6-Sports',style: TextStyle(fontSize: 40,color: Colors.blue.withOpacity(0.7),fontWeight: FontWeight.w600),)]),),),),

          Padding( padding: const EdgeInsets.only(left:120,right:0,bottom: 30),
            child: FlatButton(onPressed: (){Navigator.pushNamed(context,'NewNote');},
              child: Container(height: 90,width: 600,
                decoration: BoxDecoration(color: Colors.white,borderRadius:
                BorderRadius.horizontal(left:Radius.circular(100),)
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center
                    ,children:[
                  Text('7-Note',style: TextStyle(fontSize: 40,color: Colors.blue.withOpacity(0.7),fontWeight: FontWeight.w600),)]),),),),
          ])
      )
    );
  }
  }
class AA extends StatefulWidget{
  const AA({
    Key key,
    @required this.size,
  }) : super(key:key);
  final Size size;

  @override
  _AAState createState() => _AAState();
}

class _AAState extends State<AA> {
  TextEditingController _gg =TextEditingController();
  String textval;
  void dd (val){
    setState((){
      textval =_gg.text;
      print(val);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(height: widget.size.height*0.5,
        color: Colors.white,
        child: Stack(
          children: [
            Container(
              height: widget.size.height * 0.5-27,
              decoration: BoxDecoration(color: Colors.blue,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(45),bottomRight: Radius.circular(45))),
              child: Column(mainAxisAlignment: MainAxisAlignment.end,children: [
                Lottie.asset('asset/lottie/37478-intelligence-ai.json'),
                Text('    Change your Task                    ',style: TextStyle(letterSpacing: 4,fontWeight:FontWeight.bold,color: Colors.white,fontSize: 30),)
                ,Text(''),Text(''),],),),
            Positioned(bottom: 0,left: 0,right: 0,
                child:Container(alignment: Alignment.center,margin: EdgeInsets.symmetric(horizontal: 20),padding: EdgeInsets.symmetric(horizontal: 20),height: 50,decoration: BoxDecoration(color: Colors.white,
                    borderRadius: BorderRadius.circular(20),boxShadow: [BoxShadow(
                        offset: Offset(0, 10),
                        blurRadius: 50,
                        color: Colors.blue.withOpacity(0.23))]),
                  child: Row(
                      children:[Expanded(
                        child: TextField(minLines: null,style: TextStyle(color: Colors.blue),onChanged: dd,
                          decoration: InputDecoration(hintText:"Search",hintStyle: TextStyle(color: Colors.blue.withOpacity(0.6))
                            ,enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,),),),
                        Icon(Icons.search_rounded),]),))],),),
    ],);
  }
}