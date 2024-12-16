import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firestore_lazy_loading_totalxsoftware/firestore_lazy_loading_totalxsoftware.dart';
import 'package:firestore_lazy_loading_totalxsoftware_example/firebase_options.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Lazy Loading',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LazyLoadingPage(),
    );
  }
}

class LazyLoadingPage extends StatefulWidget {
  const LazyLoadingPage({super.key});

  @override
  State<LazyLoadingPage> createState() => _LazyLoadingPageState();
}

class _LazyLoadingPageState extends State<LazyLoadingPage> {
  // FirestoreLazyLoadingTotalxsoftware instance
  FirestoreLazyLoadingTotalxsoftware lazyLoading =
      FirestoreLazyLoadingTotalxsoftware();
  // List to hold fetched data
  List<NotificationModel> notificationList = [];
  bool isNoMoreData = false;
  bool isLoading = false;

  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() {
    lazyLoading.fetchInitData(
      context,
      query: FirebaseFirestore.instance
          .collection('notification')
          .orderBy('createdAt'),
      limit: 10,
      noMoreData: (value) {
        isNoMoreData = value;
        setState(() {});
      },
      onLoading: (value) {
        isLoading = value;
        setState(() {});
      },
      onData: (data) {
        for (var element in data) {
          notificationList.add(NotificationModel.fromMap(element.data()));
        }
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    // Dispose the scroll controller when done
    lazyLoading.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lazy Loading Example'),
      ),
      body: CustomScrollView(
        controller: lazyLoading.scrollController,
        slivers: [
          if (isLoading)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else
            SliverList.builder(
              itemCount: notificationList.length,
              itemBuilder: (context, index) {
                final item = notificationList[index];
                return ListTile(
                  title: Text(item.title),
                  subtitle: Text(item.description),
                );
              },
            ),
          SliverToBoxAdapter(
            child: lazyLoading.bottomLoadingIndicator(
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
          //
          // OR
          //
          // if (!isNoMoreData && notificationList.isNotEmpty)
          //   const SliverToBoxAdapter(
          //     child: Center(
          //       child: CircularProgressIndicator(),
          //     ),
          //   ),
        ],
      ),
    );
  }
}

class NotificationModel {
  String? id;
  final String title;
  String? imageUrl;
  final String description;
  final Timestamp createdAt;
  final String subscription;
  final String? fcmToken;
  final String? userId;
  NotificationModel({
    this.id,
    required this.title,
    this.imageUrl,
    required this.description,
    required this.createdAt,
    required this.subscription,
    this.fcmToken,
    this.userId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'description': description,
      'createdAt': createdAt,
      'subscription': subscription,
      'fcmToken': fcmToken,
      'userId': userId,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] != null ? map['id'] as String : null,
      title: map['title'] as String,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      description: map['description'] as String,
      createdAt: map['createdAt'] as Timestamp,
      subscription: map['subscription'] as String,
      fcmToken: map['fcmToken'] != null ? map['fcmToken'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
    );
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? imageUrl,
    String? description,
    Timestamp? createdAt,
    String? subscription,
    String? fcmToken,
    String? userId,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      subscription: subscription ?? this.subscription,
      fcmToken: fcmToken ?? this.fcmToken,
      userId: userId ?? this.userId,
    );
  }
}
