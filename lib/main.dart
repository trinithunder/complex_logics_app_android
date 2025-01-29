import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_screen.dart';
import 'homepage.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}






// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


class HeaderTemplateItem {
  String? sectionTitle;
  bool isSearch;
  String? searchTitleText;
  String? searchSubTitleText;
  String? searchIcon;
  String? borderColor;
  int? borderWidth;

  HeaderTemplateItem({
    this.sectionTitle,
    required this.isSearch,
    this.searchTitleText,
    this.searchSubTitleText,
    this.searchIcon,
    this.borderColor,
    this.borderWidth,
  });
}

class BodyTemplateItem {
  String? contentCellTitle;
  String? contentCellSubTitle;
  String? contentBodyItem;

  BodyTemplateItem({
    this.contentCellTitle,
    this.contentCellSubTitle,
    this.contentBodyItem,
  });
}

class FooterTemplateItem {
  String footerLinkAction;

  FooterTemplateItem({required this.footerLinkAction});
}

class TemplateView extends StatefulWidget {
  @override
  _TemplateViewState createState() => _TemplateViewState();
}

class _TemplateViewState extends State<TemplateView> {
  List<HeaderTemplateItem> headerItems = [];
  List<BodyTemplateItem> contentBodyItems = [];
  List<FooterTemplateItem> footerContentItems = [];
  bool isOverlayControlsActive = false;
  bool isVideoPlayerView = false;
  bool isSubmissionScreen = false;
  bool isOnboardingScreen = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TemplateHeaderView(headerItems: headerItems),
          TemplateContentBodyView(contentBodyItems: contentBodyItems),
          TemplateFooterView(
            footerContentItems: isVideoPlayerView ? [] : footerContentItems,
          ),
        ],
      ),
    );
  }
}

Future<Map<String, dynamic>> fetchData(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}

Future<void> postData(String url, Map<String, dynamic> data) async {
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(data),
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to post data');
  }
}

class TemplateHeaderView extends StatelessWidget {
  final List<HeaderTemplateItem> headerItems;

  TemplateHeaderView({required this.headerItems});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Hello world"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: headerItems.map((item) {
            return item.isSearch
                ? Container(
              width: 300,
              height: 100,
              color: Colors.orange,
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Icon(Icons.search, color: Colors.white),
                  Spacer(),
                ],
              ),
            )
                : Text(item.sectionTitle ?? "");
          }).toList(),
        ),
      ],
    );
  }
}

class TemplateContentBodyView extends StatelessWidget {
  final List<BodyTemplateItem> contentBodyItems;

  TemplateContentBodyView({required this.contentBodyItems});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Hello world"),
        Column(
          children: contentBodyItems.map((item) => Text(item.contentCellTitle ?? "")).toList(),
        ),
      ],
    );
  }
}

class TemplateFooterView extends StatelessWidget {
  final List<FooterTemplateItem> footerContentItems;
  final bool displayControls = false;

  TemplateFooterView({required this.footerContentItems});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text("Hello world"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: footerContentItems.map((item) => Text(item.footerLinkAction)).toList(),
          ),
          Visibility(
            visible: displayControls,
            child: Text("Player controls will replace this view"),
          ),
        ],
      ),
    );
  }
}

// Securely Store the Token
//
// Use flutter_secure_storage to securely store the API token in your app.
//
// Token Storage Helper Class:
// Create a helper class to manage secure storage operations:



// Login and Get Token
//
// When a user logs in, make an HTTP request to your backend to get the authentication token. On successful login, save the token securely.
//
// Login Function:

// Future<void> login(String email, String password) async {
//   final url = Uri.parse("https://your-backend.com/users/sign_in");
//
//   final response = await http.post(url, body: {
//     'email': email,
//     'password': password,
//   });
//
//   if (response.statusCode == 200) {
//     final responseData = json.decode(response.body);
//     final token = responseData['token'];
//     await SecureStorage.saveToken(token);  // Save token securely
//   } else {
//     throw Exception('Failed to login');
//   }
// }
//
// // Make Authenticated Requests
// //
// // For any API request that requires authentication, add the token to the Authorization header.
// //
// // Fetch ACH Clients with Token:
//
// Future<void> fetchACHClients() async {
//   final token = await SecureStorage.loadToken();
//
//   if (token == null) {
//     throw Exception('No token found. Please log in first.');
//   }
//
//   final url = Uri.parse("https://your-backend.com/api/ach_clients");
//
//   final response = await http.get(
//     url,
//     headers: {
//       'Authorization': 'Bearer $token',  // Include token in header
//     },
//   );
//
//   if (response.statusCode == 200) {
//     final data = json.decode(response.body);
//     print(data);  // Handle the response data
//   } else {
//     throw Exception('Failed to load ACH clients');
//   }
// }
//
//
// // Logout and Invalidate the Token
// //
// // When a user logs out, delete the token from secure storage to invalidate the session.
// //
// // Logout Function:
//
// Future<void> logout() async {
//   await SecureStorage.deleteToken();  // Delete token on logout
//   print('Logged out successfully');
// }


