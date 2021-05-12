import 'package:blue_car/model/chats_list.dart';
import 'package:blue_car/model/user.dart';
import 'package:blue_car/page/chat_page.dart';
import 'package:flutter/material.dart';


class ChatBodyWidget extends StatelessWidget {
  final List<ChatsList> chatsList;
  final String myID;

  const ChatBodyWidget({
    @required this.chatsList,
    Key key, this.myID,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: buildChats(),


    ),
  );

  Widget buildChats() => ListView.separated(
    physics: BouncingScrollPhysics(),
    itemBuilder: (context, index) {
      final chat = chatsList[index];
      return Container(
        margin: const EdgeInsets.only(bottom: 10, top: 10),
        child: ListTile(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChatPage(idUser: myID, idAnuncio: chat.idAnuncio,),
            ));
          },
          leading: CircleAvatar(
            radius: 25,
            // backgroundImage: NetworkImage(chat.urlPhoto),
          ),
          title: Text(chat.name),
        ),

      );
    },
    itemCount: chatsList.length,
    separatorBuilder: (BuildContext context, int index) => Divider(height: 1),

  );
}