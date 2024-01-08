import 'package:brewery/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String appVersion = "";
  String authorEmail = "zdalny-browar@kazmierski.com.pl";

  @override
  void initState() {
    super.initState();
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
            decoration: BoxDecoration(
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.white.withOpacity(0.2), BlendMode.dstATop),
                    fit: BoxFit.cover,
                    image: const AssetImage("assets/images/bg3.jpg"))),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Center(
                      child: Text(
                        "Zdalny Browar",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 32),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text("Wersja aplikacji: $appVersion"),
                    const SizedBox(height: 16),
                    const Card(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        trailing: Icon(Icons.check, color: Colors.green),
                        title: Padding(
                          padding: EdgeInsets.only(bottom: 15.0),
                          child: Text("Początek"),
                        ),
                        subtitle: Text(
                            "Historia piwowarstwa domowego w Kamionkach sięga 2020 roku."),
                      ),
                    ),
                    const Card(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        trailing: Icon(Icons.check, color: Colors.green),
                        title: Padding(
                          padding: EdgeInsets.only(bottom: 15.0),
                          child: Text("Proces"),
                        ),
                        subtitle: Text(
                            "To tutaj warzone jest piwo z procesem zacierania!"),
                      ),
                    ),
                    const Card(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        trailing: Icon(Icons.check, color: Colors.green),
                        title: Padding(
                          padding: EdgeInsets.only(bottom: 15.0),
                          child: Text("Receptura"),
                        ),
                        subtitle: Text("Tylko sprawdzone przepisy :)"),
                      ),
                    ),
                    const Card(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        trailing: Icon(Icons.check, color: Colors.green),
                        title: Padding(
                          padding: EdgeInsets.only(bottom: 15.0),
                          child: Text("Kody QR"),
                        ),
                        subtitle: Text(
                            "Odkrywaj piwa skanując kody QR na etykietach. Dzięki temu możesz oceniać i komentować piwka!"),
                      ),
                    ),
                    GestureDetector(
                      onLongPress: () {
                        Clipboard.setData(ClipboardData(text: authorEmail));
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Skopiowano email do schowka!'),
                          backgroundColor: Colors.green,
                          duration: Duration(milliseconds: 1500),
                        ));
                      },
                      child: Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          trailing: const Icon(Icons.mail_outline,
                              color: Colors.redAccent),
                          title: const Padding(
                            padding: EdgeInsets.only(bottom: 15.0),
                            child: Text("Kontakt z twórcą aplikacji"),
                          ),
                          subtitle: Text(authorEmail),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
              child: Container(
            margin: const EdgeInsets.only(
                left: kDefaultPadding, top: kDefaultPadding),
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
