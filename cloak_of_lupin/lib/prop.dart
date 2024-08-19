import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/services.dart' show rootBundle;
class Passls{
  String? domain;
  String? usernm;
  String? passwd;
}
//CREATING HASH
String sha256Hash(String input) {
  var bytes = utf8.encode(input);
  var digest = sha256.convert(bytes);
  return digest.toString();
}
//String hash = sha256Hash(keywd);

//READING FILE INTO LIST
//import 'package:flutter/services.dart' show rootBundle;

Future<List<String>> readWordsFromFile() async {
  try {
    // Load the file from assets
    String fileContent = await rootBundle.loadString('example/file.txt');
    // Split the content by spaces
    List<String> words = fileContent.split(' ');
    return words; // Return the list of words
  } catch (e) {
    print("Error reading file: $e");
    return []; // Return an empty list in case of error
  }
}

//WRITING INTO FILE, ERASING CONTENT AND WRITTING
Future<void> writeWordsToFile(List<String> words) async {
  final filePath = 'example/file.txt'; // Specify the file name

  // Create the file
  final file = File(filePath);

  // Write the words to the file, joining them with spaces
  await file.writeAsString(words.join(' '));

  print('Words written to $filePath');
}
void someFunction() async {
  List<String> words = ['Hello', 'world', 'this', 'is', 'Flutter'];
  await writeWordsToFile(words);
}
    //someFunction();


//ENCRYPT
//import 'dart:io';
 // Use the same alias

void okbro() async {
   final filePath = 'example/file.txt';
  final key = encrypt.Key.fromUtf8('asdkinghtyuhfgdtagnuh123!@#ratsj');
  final iv = encrypt.IV.fromLength(16);
  final plaintext = File(filePath).readAsStringSync();
  final encrypter = encrypt.Encrypter(encrypt.AES(key));
  final encrypted = encrypter.encrypt(plaintext, iv: iv);

  File(filePath).writeAsStringSync(encrypted.base16);
  print('File encrypted and saved.');
}

//DECRYPT
//import 'dart:io';
//import 'package:encrypt/encrypt.dart' as encrypt; // Use the same alias

//void okbro() async {
  //final filePath = 'example/file.txt';
  //final key = encrypt.Key.fromUtf8('asdkinghtyuhfgdtagnuh123!@#ratsj');
//  final iv = encrypt.IV.fromUtf8('usjighrsthnjoird');
  //final encryptedData = File(filePath).readAsStringSync();
  //final encrypter = encrypt.Encrypter(encrypt.AES(key));
  //final decrypted = encrypter.decrypt(encrypt.Encrypted.fromBase16(encryptedData), iv: iv);

//  File(filePath).writeAsStringSync(decrypted);
  //print('File decrypted and saved.');
//}