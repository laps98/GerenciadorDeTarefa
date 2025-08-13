/*
// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Image Picker Demo',
      home: MyHomePage(title: 'Image Picker Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.title});

  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<XFile>? _mediaFileList;

  void _setImageFileListFromFile(XFile? value) {
    _mediaFileList = value == null ? null : <XFile>[value];
  }

  dynamic _pickImageError;
  bool isVideo = false;

  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  final TextEditingController limitController = TextEditingController();

  Future<void> _onImageButtonPressed(
      ImageSource source, {
        required BuildContext context,
        bool isMultiImage = false,
        bool isMedia = false,
      }) async {
    if (context.mounted) {
      if (isVideo) {
        final XFile? file = await _picker.pickVideo(
            source: source, maxDuration: const Duration(seconds: 10));
      } else if (isMultiImage) {
        await _displayPickImageDialog(context, true, (double? maxWidth,
            double? maxHeight, int? quality, int? limit) async {
          try {
            final List<XFile> pickedFileList = isMedia
                ? await _picker.pickMultipleMedia(
              maxWidth: maxWidth,
              maxHeight: maxHeight,
              imageQuality: quality,
              limit: limit,
            )
                : await _picker.pickMultiImage(
              maxWidth: maxWidth,
              maxHeight: maxHeight,
              imageQuality: quality,
              limit: limit,
            );
            setState(() {
              _mediaFileList = pickedFileList;
            });
          } catch (e) {
            setState(() {
              _pickImageError = e;
            });
          }
        });
      } else if (isMedia) {
        await _displayPickImageDialog(context, false, (double? maxWidth,
            double? maxHeight, int? quality, int? limit) async {
          try {
            final List<XFile> pickedFileList = <XFile>[];
            final XFile? media = await _picker.pickMedia(
              maxWidth: maxWidth,
              maxHeight: maxHeight,
              imageQuality: quality,
            );
            if (media != null) {
              pickedFileList.add(media);
              setState(() {
                _mediaFileList = pickedFileList;
              });
            }
          } catch (e) {
            setState(() {
              _pickImageError = e;
            });
          }
        });
      } else {
        await _displayPickImageDialog(context, false, (double? maxWidth,
            double? maxHeight, int? quality, int? limit) async {
          try {
            final XFile? pickedFile = await _picker.pickImage(
              source: source,
              maxWidth: maxWidth,
              maxHeight: maxHeight,
              imageQuality: quality,
            );
            setState(() {
              _setImageFileListFromFile(pickedFile);
            });
          } catch (e) {
            setState(() {
              _pickImageError = e;
            });
          }
        });
      }
    }
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {

    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_mediaFileList != null) {
      return Semantics(
        label: 'image_picker_example_picked_images',
        child: ListView.builder(
          key: UniqueKey(),
          itemBuilder: (BuildContext context, int index) {
            final String? mime = lookupMimeType(_mediaFileList![index].path);

            // Why network for web?
            // See https://pub.dev/packages/image_picker_for_web#limitations-on-the-web-platform
            return Semantics(
              label: 'image_picker_example_picked_image',
              child: kIsWeb
                  ? Image.network(_mediaFileList![index].path)
                  : (mime == null || mime.startsWith('image/')
                  ? Image.file(
                File(_mediaFileList![index].path),
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  return const Center(
                      child:
                      Text('This image type is not supported'));
                },
              )
                  : SizedBox.shrink()),
            );
          },
          itemCount: _mediaFileList!.length,
        ),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }


  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      if (response.type == RetrieveType.video) {
        isVideo = true;
      } else {
        isVideo = false;
        setState(() {
          if (response.files == null) {
            _setImageFileListFromFile(response.file);
          } else {
            _mediaFileList = response.files;
          }
        });
      }
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
        child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
            ? FutureBuilder<void>(
          future: retrieveLostData(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Text(
                  'You have not yet picked an image.',
                  textAlign: TextAlign.center,
                );
              case ConnectionState.done:
                return SizedBox.shrink();
              case ConnectionState.active:
                if (snapshot.hasError) {
                  return Text(
                    'Pick image/video error: ${snapshot.error}}',
                    textAlign: TextAlign.center,
                  );
                } else {
                  return const Text(
                    'You have not yet picked an image.',
                    textAlign: TextAlign.center,
                  );
                }
            }
          },
        )
            : SizedBox.shrink(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Semantics(
            label: 'image_picker_example_from_gallery',
            child: FloatingActionButton(
              onPressed: () {
                isVideo = false;
                _onImageButtonPressed(ImageSource.gallery, context: context);
              },
              heroTag: 'image0',
              tooltip: 'Pick Image from gallery',
              child: const Icon(Icons.photo),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              onPressed: () {
                isVideo = false;
                _onImageButtonPressed(
                  ImageSource.gallery,
                  context: context,
                  isMultiImage: true,
                  isMedia: true,
                );
              },
              heroTag: 'multipleMedia',
              tooltip: 'Pick Multiple Media from gallery',
              child: const Icon(Icons.photo_library),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              onPressed: () {
                isVideo = false;
                _onImageButtonPressed(
                  ImageSource.gallery,
                  context: context,
                  isMedia: true,
                );
              },
              heroTag: 'media',
              tooltip: 'Pick Single Media from gallery',
              child: const Icon(Icons.photo_library),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              onPressed: () {
                isVideo = false;
                _onImageButtonPressed(
                  ImageSource.gallery,
                  context: context,
                  isMultiImage: true,
                );
              },
              heroTag: 'image1',
              tooltip: 'Pick Multiple Image from gallery',
              child: const Icon(Icons.photo_library),
            ),
          ),
          if (_picker.supportsImageSource(ImageSource.camera))
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: FloatingActionButton(
                onPressed: () {
                  isVideo = false;
                  _onImageButtonPressed(ImageSource.camera, context: context);
                },
                heroTag: 'image2',
                tooltip: 'Take a Photo',
                child: const Icon(Icons.camera_alt),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () {
                isVideo = true;
                _onImageButtonPressed(ImageSource.gallery, context: context);
              },
              heroTag: 'video0',
              tooltip: 'Pick Video from gallery',
              child: const Icon(Icons.video_library),
            ),
          ),
          if (_picker.supportsImageSource(ImageSource.camera))
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () {
                  isVideo = true;
                  _onImageButtonPressed(ImageSource.camera, context: context);
                },
                heroTag: 'video1',
                tooltip: 'Take a Video',
                child: const Icon(Icons.videocam),
              ),
            ),
        ],
      ),
    );
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, bool isMulti, OnPickImageCallback onPick) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add optional parameters'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: maxWidthController,
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                      hintText: 'Enter maxWidth if desired'),
                ),
                TextField(
                  controller: maxHeightController,
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                      hintText: 'Enter maxHeight if desired'),
                ),
                TextField(
                  controller: qualityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'Enter quality if desired'),
                ),
                if (isMulti)
                  TextField(
                    controller: limitController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        hintText: 'Enter limit if desired'),
                  ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: const Text('PICK'),
                  onPressed: () {
                    final double? width = maxWidthController.text.isNotEmpty
                        ? double.parse(maxWidthController.text)
                        : null;
                    final double? height = maxHeightController.text.isNotEmpty
                        ? double.parse(maxHeightController.text)
                        : null;
                    final int? quality = qualityController.text.isNotEmpty
                        ? int.parse(qualityController.text)
                        : null;
                    final int? limit = limitController.text.isNotEmpty
                        ? int.parse(limitController.text)
                        : null;
                    onPick(width, height, quality, limit);
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality, int? limit);



*/

import 'package:controlador_de_usuario_app/screens/login_page.dart';
import 'package:controlador_de_usuario_app/screens/task_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';


late SharedPreferences prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  prefs = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('pt', 'BR'), // opcional, para português
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'Gerenciador de Usuário',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: _nextPage(),
    );
  }

  _nextPage() {
    Widget nextScreen = const LoginPage();
    String? dataDeExpiracao = prefs.getString('DataDeExpiracao');
    if (dataDeExpiracao != null) {
      var dataDeExpirado = DateTime.parse(dataDeExpiracao);

      if (dataDeExpirado.isAfter(DateTime.now())) {
        nextScreen = const Home();
      }
    }
    return nextScreen;
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const TaskPage(),
    const Center(child: Text('Perfil')),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<BottomNavigationBarItem> _items = const [
    BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tarefas'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _items,
        currentIndex: _currentIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}
