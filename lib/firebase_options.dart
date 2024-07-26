import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return FirebaseOptions(
      apiKey: 'AIzaSyAYGjYktAsbQkX2i7imTGWibusJ3W3enP4',
      appId: '1:249843902855:android:a888f2927efdb314a28b22',
      messagingSenderId: '249843902855',
      projectId: 'task-3da99',
      authDomain: '',  // Set as empty string since it's not provided in the JSON
      storageBucket: 'task-3da99.appspot.com',
      measurementId: '',  // Set as empty string since it's not provided in the JSON
    );
  }
}