import 'package:flutter/material.dart';
import 'prop.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(251, 231, 227, 213),
      ),
      home: PasswordManager(),
      
    );
  }
}

class PasswordManager extends StatefulWidget {
  @override
  
  _PasswordManagerState createState() => _PasswordManagerState();
}

class _PasswordManagerState extends State<PasswordManager> {
  int _currentPage = 0;
  String keyword = '';
  String errorMessage = '';
  List<String> accounts =[];
  Future<bool> checkHash(String inputKeyword) async{//checks if the entered keyword is correct or not 
    String correctPassword = await readFromFile(); 
    while (inputKeyword.length < 32) {
    inputKeyword += 's'; // SALTING the keyword
    }
    keyword = inputKeyword;
    inputKeyword= sha256Hash(inputKeyword);
    if(correctPassword==''){
      final Directory directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}${Platform.pathSeparator}colkeywd.txt';
      final file = File(filePath);
      await file.writeAsString(inputKeyword);
      return true;
    }
    return inputKeyword == correctPassword;
  }

  Future<void> _submitKeyword() async{
    if (await checkHash(keyword)){
      accounts = await readWordsFromFile(keyword);
      setState(() {
        _currentPage = 1;
      });

    } else {
      setState(() {
        errorMessage = 'Incorrect password. Please try again.';
      });
    }
  }

  void _showPassword(BuildContext context, String password) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Password'),
          backgroundColor: Color.fromARGB(252, 227, 219, 196),
          content: Text(password),
          actions: [
           TextButton(
              onPressed:(){
                Clipboard.setData(ClipboardData(text: password)).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Copied to clipboard'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                });
              },
              child: Icon(Icons.copy)
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _addAccount(String domain, String username, String password) {
    if (domain.isNotEmpty && username.isNotEmpty && password.isNotEmpty) {
      setState(() {
        accounts.addAll([domain, username, password]);
        writeWordsToFile(accounts, keyword);
        _currentPage = 1;
      });
    } else {
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('please enter all the details!')),
      );
    }
  }

  void _goToAddAccountPage() {
    setState(() {
      _currentPage = 2; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CLOAK OF LUPIN- A Password Manager'),
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 24),
        backgroundColor: Color.fromARGB(252, 227, 219, 196),
      ),
    body: _getPage(_currentPage),
    );
  }

  Widget _getPage(int page) {
    switch (page) {
      case 0:
        return _buildKeywordPage();
      case 1: 
        return _buildAccountsPage();
      case 2:
        return _buildAddAccountPage();
      default:
        return _buildKeywordPage();
    }
  }

  Widget _buildKeywordPage() { //FIRST screen
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter the Keyword',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 125, 65, 136),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 300,
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Keyword',
                ),
                onChanged: (value) {
                  setState(() {
                    keyword = value;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitKeyword,
              style: ElevatedButton.styleFrom(
               backgroundColor: Color.fromARGB(255, 240, 228, 215),// Text color
              ),
              child: Text('Submit'),
            ),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountsPage() {//SECOND screen, once the keyword is approved
    return Drawer(
      width: double.infinity,
    child: Scaffold(
      appBar: AppBar(
        title: Text('Accounts'),
        backgroundColor: Color.fromARGB(255, 253, 241, 225),
      ),
      drawer: Drawer(
        child: Container(
        decoration: BoxDecoration(
    color: Color.fromARGB(255, 253, 241, 225), // Violet ARGB color
  ),
child: ListView(
children: [
UserAccountsDrawerHeader(
accountName: Text('san'),
accountEmail: Text('san@msrit.edu'),
currentAccountPicture: CircleAvatar(
child: Text('SN'),
),
),
ListTile(
leading: Icon(Icons.arrow_back),
title: Text('Return to Accounts'),
onTap: () {
// Navigate to the home page
  Navigator.of(context).pop();// Close the drawer
},
),
ListTile(
leading: Icon(Icons.plus_one),
title: Text('Add account'),
onTap: _goToAddAccountPage,
),
ListTile(
leading: Icon(Icons.question_mark_rounded),
title: Text('How it runs'),
onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => _howitruns()),
              );
            },

),
ListTile(
leading: Icon(Icons.logo_dev),
title: Text('Contribution'),
onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => _contribution()),
              );
            },

),

],
),
),),
      body: Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: (accounts.length/3).floor(),
              itemBuilder: (context, index) {
                  return Card(
                  color:  Color.fromARGB(250, 243, 238, 224),
                  child: Padding(
                  padding: EdgeInsets.all(25.0),
                  child: Row(
                  children: [
                  Expanded(
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Domain: ${accounts[index * 3]}'),
                    SizedBox(height: 8.0),
                    Text('Username: ${accounts[(index * 3) + 1]}'),
                    
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _showPassword(context, accounts[(index * 3) + 2]);
          },
          style: ElevatedButton.styleFrom(
               backgroundColor:  Color.fromARGB(249, 233, 228, 215),// Text color
              ),
          child: Text('See Password'),
        ),
        IconButton(
    icon: Icon(Icons.close_sharp),
    color: Color.fromARGB(255, 127, 16, 175),
    onPressed: () {
            // Show the dialog when the button is pressed
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Delete Account'),
                  backgroundColor: Color.fromARGB(255, 240, 228, 215),
                  content: Text('Do you want to delete the account details?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // Dismiss the dialog when the button is pressed
                        setState(() {
                        accounts.removeRange(index*3, (index*3)+3);
                        writeWordsToFile(accounts, keyword);
                        Navigator.of(context).pop(); 
                        });
                      },
                      style: ElevatedButton.styleFrom(
               backgroundColor: Color.fromARGB(255, 240, 228, 215),// Text color
              ),
                      child: Text('Delete'),
                    ),
                  ],
                );
              },);}
  ),
      ],
    ),
  ),
                  );
              },
            ),
          ),
          
        ],
      ),),)
    );
  }

  Widget _buildAddAccountPage() { //Add accounts screen, where you add new accounts
    final TextEditingController domainController = TextEditingController();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Scaffold(
      appBar: AppBar(
      leading: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () {
      // Navigate to the other screen
      setState(() {
      _currentPage = 1; 
    });
    },
  ),
    title: Text('Add new account'),
    backgroundColor: Color.fromARGB(255, 240, 228, 215),
    actions: [  IconButton(    
      icon: Icon(Icons.key),    
      onPressed: () {
        String randPass = randomPass();
        Clipboard.setData(ClipboardData(text: randPass)).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Random Password copied to clipboard: $randPass\nClick again to generate new one.'),
                      duration: Duration(seconds: 4),
                    ),
                  );
                });
          },  ),],
      ),      
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: domainController,
            decoration: InputDecoration(
              labelText: 'Domain',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              String domain = domainController.text;
              if (!isValidDomain(domain)){
                domainController.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Invalid domain. Please try again.')),
              );
              } else {
              _addAccount(
                domainController.text,
                usernameController.text,
                passwordController.text,
              );}
            },
            style: ElevatedButton.styleFrom(
               backgroundColor: Color.fromARGB(255, 240, 228, 215),// Text color
              ),
            child: Text('Add Account'),
          ),
        ],
      ),),
    );
  }
  Widget _howitruns() { //how it runs page
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Scaffold(
      appBar: AppBar(
      leading: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () {
      //Navigate to the other screen
      setState(() {
        Navigator.of(context).pop(); 
      //_currentPage = 1; 
    });
    },
  ),
        title: Text('How It Runs?'),
        backgroundColor: Color.fromARGB(255, 240, 228, 215),
      ),      
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        
        children: [
         
         Padding(
          padding: const EdgeInsets.all(100.0), 
          child: Text("There are few pre-requisites terms you need to know.\nPre-requisites terms: Encryption, Decryption, AES crypt, Salting<of password>\n\nWhen you open the app for the first time, the keyword you enter will be salted, hashed and stored. So, the next time you enter, it verifies the hash of the keyword you enter with the saved hash and gives you the access.\n\nWhen you add another account to the app, it will use AES crypt, encrypt the data and store it in a file in the apps document directory. AES crypt requires a keyword and an initialization vector(IV). The keyword is the one you entered(with salting) and the IV is pre-defined in the code which can be changed.\n\n\nThus your account details are safely encrypted and decrypted!", 
          style: TextStyle(fontSize:18 ),),
          ),
        ],
      ),),
    );
  }
  Widget _contribution() { //how it runs page
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Scaffold(
      appBar: AppBar(
      leading: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () {
      //Navigate to the other screen
      setState(() {
        Navigator.of(context).pop();
    });
    },
  ),
        title: Text('Contribution'),
        backgroundColor: Color.fromARGB(255, 240, 228, 215),
      ),      
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         Padding(
          padding: const EdgeInsets.all(100.0), 
          child: RichText(
          text: TextSpan(
          style: TextStyle(fontSize:18, color: Colors.black ),
          children: [
            TextSpan(text: "This project is Open Source.\nContribute to the project by giving new ideas, themes, reporting issues.....\nThe code is in Github. Give a "),
            TextSpan(text: "Pull Request.",
            style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async{
                        launchUrl(Uri.parse('https://github.com/Colluded-Projects/Cloak-of-lupin/pulls'));
                      },)
         ], ), ),),
        ],
      ),),
    );
  }
  
}
