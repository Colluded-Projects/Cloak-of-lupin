import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:path_provider/path_provider.dart';


//CREATING HASH
String sha256Hash(String input) {
  var bytes = utf8.encode(input);
  var digest = sha256.convert(bytes);
  return digest.toString();
}//UASAGE: String hash = sha256Hash(keywd);


//READING A FILE INTO A STR VAR
//IMPORT needed for the following function import 'package:flutter/services.dart' show rootBundle;
Future<String> readFromFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}\\${'keywd.txt'}');
    // Check if the file already exists
    if (!(await file.exists())) {
      await file.create();
      return '';
    }
    String fileContent = await file.readAsString();
    //String fileContent = await rootBundle.loadString('${directory.path}\\${'keywd.txt'}');
    return fileContent;
}
//READING FILE INTO LIST
//IMPORT for the following: import 'package:flutter/services.dart' show rootBundle;

Future<List<String>> readWordsFromFile() async {
  await Future.delayed(Duration(seconds: 1));
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}${Platform.pathSeparator}info.txt');
    final fileStat = await file.stat();
  if (fileStat.size == 0) {
    return [];
  }
    String fileContent = await file.readAsString();
    // Split the content by spaces
    List<String> words = fileContent.split(' ');
    return words;
}


//WRITING INTO FILE, ERASING CONTENT AND WRITTING
//IMPORT for the following function: import 'dart:io';
Future<void> writeWordsToFile(List<String> words) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}\\${'info.txt'}'; // Specify the file name

  // Create the file
  final file = File(filePath);

  // Write the words to the file, joining them with spaces
  await file.writeAsString(words.join(' '));
}


//ENCRYPT
//IMPORT for the following function: import 'dart:io';

  void encryptFile(String keywd) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}\\${'info.txt'}';
    final key = encrypt.Key.fromUtf8(keywd);
    final iv = encrypt.IV.fromUtf8('usjighrsthnjoird');
    final File file = File(filePath);
    String plaintext = await file.readAsString();
    if(plaintext.isEmpty){return;}
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt( plaintext, iv: iv);

    await file.writeAsString(encrypted.base16);
  }

//DECRYPT
//IMPORT for following function:
//import 'dart:io';
//import 'package:encrypt/encrypt.dart' as encrypt;

void decryptFile(String keywd) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('${directory.path}\\${'info.txt'}');

    // Check if the file already exists
    if (!(await file.exists())) {
      await file.create();
      return;
    }
  final key = encrypt.Key.fromUtf8(keywd);
  final iv = encrypt.IV.fromUtf8('usjighrsthnjoird');
  String encryptedData = await file.readAsString();
  if(encryptedData.isEmpty){return;}
  final encrypter = encrypt.Encrypter(encrypt.AES(key));
  final decrypted = encrypter.decrypt(encrypt.Encrypted.fromBase16(encryptedData), iv: iv);
  await file.writeAsString(decrypted);
}