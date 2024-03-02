import 'package:blacklist/utils/callbacks.dart';
import 'package:blacklist/views/auth/passphrase.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'utils/helpers/errored.dart';
import 'utils/helpers/loading.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Animate.restartOnHotReload = true;
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: FutureBuilder<FirebaseApp>(
        future: load(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
          if (snapshot.hasData) {
            return const Passphrase();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }
          return Errored(error: snapshot.error.toString());
        },
      ),
    );
  }
}
