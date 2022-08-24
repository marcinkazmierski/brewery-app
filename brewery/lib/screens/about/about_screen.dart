import 'package:brewery/constants.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatefulWidget {
  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String appVersion = "";

  @override
  void initState() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        appVersion = packageInfo.version;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    colorFilter: new ColorFilter.mode(
                        Colors.white.withOpacity(0.2), BlendMode.dstATop),
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/bg3.jpg"))),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Text(
                        "Zdalny Browar",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 32),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text("Wersja aplikacji: $appVersion"),
                    SizedBox(height: 16),
                    Card(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        trailing: Icon(Icons.check, color: Colors.green),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Text("Początek"),
                        ),
                        subtitle: Text(
                            "Historia piwowarstwa domowego w Kamionkach sięga 2020 roku."),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        trailing: Icon(Icons.check, color: Colors.green),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Text("Proces"),
                        ),
                        subtitle: Text(
                            "To tutaj warzone jest piwo z procesem zacierania!"),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        trailing: Icon(Icons.check, color: Colors.green),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Text("Receptura"),
                        ),
                        subtitle: Text("Tylko sprawdzone przepisy :)"),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        trailing: Icon(Icons.check, color: Colors.green),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Text("Kody QR"),
                        ),
                        subtitle: Text(
                            "Odkrywaj piwa skanując kody QR na etykietach. Dzięki temu możesz oceniać i komentować piwka!"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
              child: Container(
            margin:
                EdgeInsets.only(left: kDefaultPadding, top: kDefaultPadding),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(30),
            ),
            child: BackButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                color: Colors.white),
          )),
        ],
      ),
    );
  }
}
