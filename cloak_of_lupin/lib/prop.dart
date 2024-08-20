import 'dart:convert';//for hashing
import 'dart:io'; // reading and writing functions(check below)
import 'package:crypto/crypto.dart';//for hashing
import 'package:encrypt/encrypt.dart' as encrypt; //for AES encryption
import 'package:path_provider/path_provider.dart'; // for reading and writing functions(check below)


//CREATING HASH
String sha256Hash(String input) {
  var bytes = utf8.encode(input);
  var digest = sha256.convert(bytes);
  return digest.toString();
}//UASAGE: String hash = sha256Hash(keywd);


//READING A FILE INTO A STR VAR
Future<String> readFromFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}${Platform.pathSeparator}colkeywd.txt');
    // Check if the file already exists
    if (!(await file.exists())) {
      await file.create();
      return '';
    }
    String fileContent = await file.readAsString();
    return fileContent;
}
//READING FILE INTO LIST
Future<List<String>> readWordsFromFile(String keywd) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}${Platform.pathSeparator}colinfo.txt');
    if (!(await file.exists())) {
      await file.create();
      return [];
    }
    final fileStat = await file.stat();
  if (fileStat.size == 0) {
    return [];
  }
  String encryptedData = await file.readAsString();
  //Decrypting data
  final key = encrypt.Key.fromUtf8(keywd);
  final iv = encrypt.IV.fromUtf8('usjighrsthnjoird');
  final encrypter = encrypt.Encrypter(encrypt.AES(key));
  final decrypted = encrypter.decrypt(encrypt.Encrypted.fromBase16(encryptedData), iv: iv);
  // Split the content by spaces
  List<String> words = decrypted.split(' ');
  return words;
}


//WRITING INTO FILE, ERASING CONTENT AND WRITTING
Future<void> writeWordsToFile(List<String> words, String keywd) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}${Platform.pathSeparator}colinfo.txt'; // Specify the file name

  // Create the file
  final file = File(filePath);
  //encrypt
  String nonEncrypted = words.join(" ");
  final key = encrypt.Key.fromUtf8(keywd);
  final iv = encrypt.IV.fromUtf8('usjighrsthnjoird');
  final encrypter = encrypt.Encrypter(encrypt.AES(key));
  final encrypted = encrypter.encrypt( nonEncrypted, iv: iv);

  await file.writeAsString(encrypted.base16);
}