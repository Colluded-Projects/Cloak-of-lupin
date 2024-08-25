# Cloak of Lupin-
A password manager application in Flutter. It stores data with AES crypt and encrypts keyword with salting and hashing so no one can figure out the keyword.

## Installation-
Download the latest release and unzip it. 
To add your own initialization vector, edit _readWordsFromFile()_ and _writeWordsToFile()_ functions in _prop.dart_. 
Run using 
``` Dart 
flutter run
```
The GUI will open.

## Dependencies-
- Flutter version 3 or above.
- Visual Studio with "Desktop Development with c++" workload for running in windows.
- The following dependencies in pubspec.yaml
```
dependencies:
  crypto: ^3.0.2
  encrypt: ^5.0.0
  path_provider: ^2.0.11
  cupertino_icons: ^1.0.6
  url_launcher: ^6.3.0
#Keep the indentation in mind 
```

## Features-
- Keyword is salted.
- Decrypted data is not saved anywhere during runtime.
- AES encryption standard.
- has a GUI.

## Credits- 
- @ChrompyCoder and @chandinivasana  
- Mukti, an open source community from RIT, Bengaluru.

## Contributions-
Want to contribute? Create a [Pull request](https://github.com/Colluded-Projects/Cloak-of-lupin/pulls).
Want to request a feature or report a issue personally? Feel free to contact [Mukti on telegram.](https://t.me/+JYx6akEWSik2Yjc1)
