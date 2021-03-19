import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trab_giovany/helper/authenticate.dart';
import 'package:trab_giovany/helper/constants.dart';
import 'package:trab_giovany/helper/helperfunctions.dart';
import 'package:trab_giovany/services/auth.dart';
import 'package:trab_giovany/services/database.dart';
import 'package:trab_giovany/views/conversation_screen.dart';
import 'package:trab_giovany/views/search.dart';
import 'package:trab_giovany/widgets/widget.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream chatRoomStream;

  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index){
            return ChatRoomTile(snapshot.data.documents[index].data["chatroomid"]
            .toString().replaceAll("_", "")
            .replaceAll(Constants.myName, ""),
                snapshot.data.documents[index].data["chatroomid"]);
          },
        ) : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async{
    Constants.myName = await HelperFunctions.getUserNameSharedReference();
    databaseMethods.getChatRooms(Constants.myName).then((val){
      setState(() {
        chatRoomStream = val;
      });
    });
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo.png",
          height: 50,),
        actions: [
          GestureDetector(
            onTap: (){
              authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => Authenticate()
              ));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          ),
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()
          ));
        },
      ) ,
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String username;
  final String chatRoomId;
  ChatRoomTile(this.username, this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoomId)
        ));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30)
              ),
              child: Text("${username.substring(0,1).toUpperCase()}", style: mediumTextStyle(),),
            ),
            SizedBox(width: 8,),
            Text(username, style: mediumTextStyle(),),
          ],
        ),
      ),
    );
  }
}

