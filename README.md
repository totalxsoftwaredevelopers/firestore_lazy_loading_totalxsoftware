# Firestore Lazy Loading Totalxsoftware

<a href="https://totalx.in">
<img alt="Launch Totalx" src="https://totalx.in/assets/logo-k3HH3X3v.png">
</a>

<p><strong>Developed by <a rel="noopener" target="_new" style="--streaming-animation-state: var(--batch-play-state-1); --animation-rate: var(--batch-play-rate-1);" href="https://totalx.in"><span style="--animation-count: 18; --streaming-animation-state: var(--batch-play-state-2);">Totalx Software</span></a></strong></p>

---

A Flutter package to simplify lazy loading of Firestore data with pagination, utilizing a `ScrollController` to trigger data fetches as users scroll.

## Features

- Pagination support for Firestore queries.
- Automatic data loading when nearing the end of the list.
- Handles loading states and no-more-data conditions.
- Simple API for integration.

## Installation

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  firestore_lazy_loading_totalxsoftware: 1.0.0
```

Then, run:

```bash
flutter pub get
```

## Usage

### Example Code

Here is an example implementation of lazy loading Firestore data using the `firestore_lazy_loading_totalxsoftware` package:

```dart
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
  FirestoreLazyLoadingTotalxsoftware lazyLoading = FirestoreLazyLoadingTotalxsoftware();
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
        ],
      ),
    );
  }
}

```

### Key Points

1. Initialize `FirestoreLazyLoadingTotalxsoftware` and provide a Firestore query.
2. Use `fetchInitData` for initial data fetch and lazy loading setup.
3. Pass callbacks for loading state, data updates, and no-more-data conditions.
4. Use `bottomLoadingIndicator` to display a loading spinner at the bottom of the list.

## Explore more about TotalX at www.totalx.in - Your trusted software development company!

<div style="display: flex; gap: 20px; justify-content: center; align-items: center; margin-top: 15px;"> <a href="https://www.youtube.com/channel/UCWysKlrrg4_a3W4Usw5MYKw" target="_blank"> <img src="https://cdn-icons-png.flaticon.com/512/1384/1384060.png" alt="YouTube" width="60" height="60"> <p style="text-align: center;">YouTube</p> </a> <a href="https://x.com/i/flow/login?redirect_after_login=%2FTOTALXsoftware" target="_blank"> <img src="https://cdn-icons-png.flaticon.com/512/733/733579.png" alt="X (Twitter)" width="60" height="60"> <p style="text-align: center;">Twitter</p> </a> <a href="https://www.instagram.com/totalx.in/" target="_blank"> <img src="https://cdn-icons-png.flaticon.com/512/1384/1384063.png" alt="Instagram" width="60" height="60"> <p style="text-align: center;">Instagram</p> </a> <a href="https://www.linkedin.com/company/total-x-softwares/" target="_blank"> <img src="https://cdn-icons-png.flaticon.com/512/145/145807.png" alt="LinkedIn" width="60" height="60"> <p style="text-align: center;">LinkedIn</p> </a> </div>

## 🌐 Connect with Totalx Software

Join the vibrant Flutter Firebase Kerala community for updates, discussions, and support:

<a href="https://t.me/Flutter_Firebase_Kerala" target="_blank" style="text-decoration: none;"> <img src="https://cdn-icons-png.flaticon.com/512/2111/2111646.png" alt="Telegram" width="90" height="90"> <p><b>Flutter Firebase Kerala Totax</b></p> </a>
