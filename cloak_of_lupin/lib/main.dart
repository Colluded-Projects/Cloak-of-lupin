import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  List<List<String>> accounts = [
    ["google", "xebra@gmail.com", "Xebra23"],
    ["github", "git@cool.com", "code123"],
  ];

  
  bool checkHash(String inputKeyword) {
    const String correctPassword = 'yellow'; 
    return inputKeyword == correctPassword;
  }

  void _submitKeyword() {
    if (checkHash(keyword)) {
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
          content: Text(password),
          actions: [
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
        accounts.add([domain, username, password]);
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
        title: Text('PASSWORD MANAGER'),
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

  Widget _buildKeywordPage() {
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
                color: Colors.black,
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

  Widget _buildAccountsPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Domain: ${accounts[index][0]}'),
                  subtitle: Text('Username: ${accounts[index][1]}'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      _showPassword(context, accounts[index][2]);
                    },
                    child: Text('See Password'),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _goToAddAccountPage,
            child: Text('Add New Account'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddAccountPage() {
    final TextEditingController domainController = TextEditingController();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
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
              _addAccount(
                domainController.text,
                usernameController.text,
                passwordController.text,
              );
            },
            child: Text('Add Account'),
          ),
        ],
      ),
    );
  }
}
