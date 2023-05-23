import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:leetcodestats/screens/user_data.dart';

class Username extends StatefulWidget {
  const Username({super.key});
  _UsernameState createState() => _UsernameState();
}

class _UsernameState extends State<Username> {
  TextEditingController controller = TextEditingController();

  void getData(String username) {
    if (username.isEmpty) {
      Fluttertoast.showToast(msg: "Enter a username");
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserData(username: username)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Stats by Username")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Enter correct leetcode username of User"),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Leetcode Username",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () => getData(controller.text),
              child: Container(
                width: 90,
                height: 30,
                color: Colors.blue,
                child: Center(child: Text("Get stats")),
              ),
            )
          ],
        ));
  }
}
