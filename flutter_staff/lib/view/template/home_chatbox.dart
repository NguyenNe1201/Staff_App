import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeChatBoxPage extends StatefulWidget {
  const HomeChatBoxPage({super.key});

  @override
  State<HomeChatBoxPage> createState() => _HomeChatBoxPageState();
}

class _HomeChatBoxPageState extends State<HomeChatBoxPage> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: const Color(0xFF171717),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60, left: 5, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          _globalKey.currentState?.openDrawer();
                        },
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection:
                      Axis.horizontal, // điều chỉnh hiển thị hàng ngang
                  padding: const EdgeInsets.only(left: 5),
                  children: [
                    buildTitleHeder("Mesages", Colors.white),
                    const SizedBox(
                      width: 30,
                    ),
                    buildTitleHeder("Online", Colors.grey),
                    const SizedBox(
                      width: 30,
                    ),
                    buildTitleHeder("Group", Colors.grey),
                    const SizedBox(
                      width: 30,
                    ),
                    buildTitleHeder("Group", Colors.grey)
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 180,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
              height: 210,
              decoration: const BoxDecoration(
                  color: Color(0xff27c1a9),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  )),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Favorite contacts',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.more_vert_rounded,
                            color: Colors.white,
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 90,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        buildContactAvatar('Tit Nga', 'user-1.jpg'),
                        buildContactAvatar('Nguyen', 'user-2.jpg'),
                        buildContactAvatar('Van Du', 'user-3.jpg'),
                        buildContactAvatar('Hoai Ca', 'user-4.jpg'),
                        buildContactAvatar('Bao Trung', 'user-1.jpg'),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 355,
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: ListView(
                padding: const EdgeInsets.only(left: 25),
                children: [
                  buildConversationRow(
                      'user-1.jpg', 'Lora', 'Hello! nice to meet you.', 2),
                  buildConversationRow(
                      'user-1.jpg', 'Lora', 'Hello! nice to meet you.', 3),
                  buildConversationRow(
                      'user-1.jpg', 'Lora', 'Hello! nice to meet you.', 0),
                  buildConversationRow(
                      'user-1.jpg', 'Lora', 'Hello! nice to meet you.', 4),
                ],
              ),
            ),
          ),
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: SizedBox(
        height: 55,
        width: 55,
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Color(0xff27c1a9),
          child: Icon(
            Icons.edit_outlined,
            size: 30,
            color: Colors.white,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      drawer: const Drawer(
        width: 275,
        elevation: 30,
        backgroundColor: Colors.black87,
       
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(
                        width: 55,
                      ),
                      Text(
                        "Setting",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      UserAvatar(filename: 'user-1.jpg'),
                      SizedBox(width: 12),
                      Text(
                        'Nguyen Ne',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  SizedBox(height: 35),
                  DrawerItem(title: 'Account', icon: Icons.key),
                  DrawerItem(title: 'Chats', icon: Icons.chat),
                  DrawerItem(title: 'Notification', icon: Icons.notifications),
                  Divider(
                    height: 35,
                    color: Colors.green,
                  )
                ],
              ),
              DrawerItem(title: 'Logout', icon: Icons.logout),
            ],
          ),
        ),
      ),
    );
  }

  Column buildConversationRow(
      String _avatar, String _name, String _content, int msgCount) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                UserAvatar(filename: _avatar),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_name),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(_content)
                  ],
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: 25),
              child: Column(
                children: [
                  Text('11:20'),
                  SizedBox(
                    height: 15,
                  ),
                  if (msgCount > 0)
                    CircleAvatar(
                      radius: 7,
                      backgroundColor: Color(0xff27c1a8),
                      child: Text(
                        msgCount.toString(),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const Divider(
          indent: 70,
        )
      ],
    );
  }

  Padding buildContactAvatar(String _textUser, String _nameImg) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: Column(
        children: [
          UserAvatar(filename: _nameImg),
          const SizedBox(
            height: 5,
          ),
          Text(
            _textUser,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          )
        ],
      ),
    );
  }

  TextButton buildTitleHeder(String _title, Color? color_) {
    return TextButton(
        onPressed: () {},
        child: Text(
          _title,
          style: TextStyle(
            color: color_,
            fontSize: 18,
          ),
        ));
  }
}

class DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  const DrawerItem({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){},
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 30),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}

class UserAvatar extends StatelessWidget {
  final String filename;
  const UserAvatar({
    super.key,
    required this.filename,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 32,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 29,
        backgroundImage: Image.asset('assets/images/$filename').image,
      ),
    );
  }
}
