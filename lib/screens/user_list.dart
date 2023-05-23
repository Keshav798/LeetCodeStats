import 'package:flutter/material.dart';
import 'package:leetcodestats/screens/user_data.dart';
import 'package:leetcodestats/screens/username_enter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<String> name = [];
  List<String> username = [];
  TextEditingController searchcontrol = TextEditingController();
  TextEditingController namecontrol = TextEditingController();
  TextEditingController usernamecontrol = TextEditingController();

  Future<void> getList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    name = [];
    username = [];

    for (String i in pref.getStringList("name")!) {
      name.add(i);
    }
    for (String i in pref.getStringList("username")!) {
      username.add(i);
    }

    print("data added");
  }

  void display(String username) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => UserData(username: username)));
  }

  void delete(String name, String username) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String>? n = pref.getStringList("name");
    List<String>? u = pref.getStringList("username");
    n!.remove(name);
    u!.remove(username);
    pref.setStringList("name", n);
    pref.setStringList("username", u);
    Fluttertoast.showToast(msg: "user deleted");
    setState(() {});
  }

  void sendtoUsernameEnter() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Username()));
  }

  void add(TextEditingController namecontrol,
      TextEditingController usernamecontrol) async {
    if (!namecontrol.text.isEmpty && !usernamecontrol.text.isEmpty) {
      SharedPreferences pref = await SharedPreferences.getInstance();

      List<String>? n = pref.getStringList("name");
      List<String>? u = pref.getStringList("username");
      if (n == null) {
        pref.setStringList("name", []);
        pref.setStringList("username", []);
      }
      if (n!.contains(namecontrol.text)) {
        Fluttertoast.showToast(msg: "Name already exists");
      } else {
        n.add(namecontrol.text);
      }
      if (u!.contains(usernamecontrol.text)) {
        Fluttertoast.showToast(msg: "username already exists");
      } else {
        u.add(usernamecontrol.text);
      }
      pref.setStringList("name", n);
      pref.setStringList("username", u);
      setState(() {
        usernamecontrol.clear();
        namecontrol.clear();
      });
    } else {
      Fluttertoast.showToast(msg: "Enter all fields");
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context).pop(true); // app will close
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //used for overiding back button
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        appBar: AppBar(title: Text("Friend List")),
        body: Column(children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: searchcontrol,
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                  hintText: "search",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0))),
            ),
          ),
          FutureBuilder(
            future: getList(),
            builder: (context, snapshot) {
              if (name.length == 0) {
                return Text("No User Found");
              } else {
                return Container(
                  height: 210,
                  width: 400,
                  child: ListView.builder(
                      itemCount: name.length,
                      itemBuilder: (context, index) {
                        if (name[index].contains(searchcontrol.text)) {
                          return ListTile(
                            onTap: () => display(username[index]),
                            onLongPress: () =>
                                delete(name[index], username[index]),
                            title: Text(name[index]),
                            subtitle: Text(username[index]),
                          );
                        } else {
                          return Text("");
                        }
                      }),
                );
              }
            },
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            child: Card(
              child: Column(children: [
                TextFormField(
                  controller: namecontrol,
                  decoration: InputDecoration(
                    hintText: "Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: usernamecontrol,
                  decoration: InputDecoration(
                    hintText: "Leetcode Username",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () => add(namecontrol, usernamecontrol),
                  child: Container(
                    width: 90,
                    height: 30,
                    color: Colors.blue,
                    child: Center(child: Text("Add friend")),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(child: Text("{Long press to delete user}")),
                SizedBox(
                  height: 10,
                ),
                Center(
                    child: InkWell(
                        onTap: () => sendtoUsernameEnter(),
                        child: Text(
                          "Find by leetcode username",
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        )))
              ]),
            ),
          )
        ]),
      ),
    );
  }
}
