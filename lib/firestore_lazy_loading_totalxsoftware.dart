library firestore_lazy_loading_totalxsoftware;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

export 'firestore_lazy_loading_totalxsoftware.dart';

/// A class to handle lazy loading of Firestore data with pagination
/// using a `ScrollController` to trigger the loading of more data as the user scrolls.
class FirestoreLazyLoadingTotalxsoftware {
  /// Controller to monitor the scroll position for lazy loading
  ScrollController scrollController = ScrollController();

  /// The last document snapshot fetched from Firestore, used for pagination
  QueryDocumentSnapshot<Map<String, dynamic>>? lastDoc;

  /// Flag to indicate whether data is being loaded
  bool _isLoadingProgress = false;

  /// Flag to indicate if there is no more data to load
  bool _noMoreData = false;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _docs = [];

  /// Fetches the initial data from Firestore and sets up the scroll listener
  /// to fetch more data as the user scrolls near the bottom.
  ///
  /// [context] is the BuildContext to access the media query.
  /// [query] is the Firestore query to fetch data from.
  /// [limit] is the number of documents to fetch per request.
  /// [noMoreData] callback that is called when there is no more data to fetch.
  /// [onLoading] callback that indicates the loading state.
  /// [onData] callback that provides the fetched data.
  Future<void> fetchInitData(
    BuildContext context, {
    required Query<Map<String, dynamic>> query,
    required int limit,
    required Function(bool value) noMoreData,
    required Function(bool value) onLoading,
    required Function(List<QueryDocumentSnapshot<Map<String, dynamic>>> data)
        onData,
  }) async {
    await fetchData(
      query: query,
      limit: limit,
      noMoreData: noMoreData,
      onLoading: onLoading,
      onData: onData,
    );
    // Adding scroll listener to trigger lazy loading as user scrolls
    scrollController.addListener(
      () {
        final maxScroll = scrollController.position.maxScrollExtent;
        final currentScroll = scrollController.position.pixels;
        final delta = MediaQuery.of(context).size.height * 0.11;

        // Triggering data fetch when the user scrolls close to the bottom
        if ((maxScroll - currentScroll) <= delta &&
            !_isLoadingProgress &&
            !_noMoreData) {
          fetchData(
            query: query,
            limit: limit,
            noMoreData: noMoreData,
            onLoading: onLoading,
            onData: onData,
          );
        }
      },
    );
  }

  /// Fetches data from Firestore with pagination.
  /// It fetches data either from the beginning or starting from the last fetched document.
  ///
  /// [query] is the Firestore query to fetch data from.
  /// [limit] is the number of documents to fetch per request.
  /// [noMoreData] callback that is called when there is no more data to fetch.
  /// [onLoading] callback that indicates the loading state.
  /// [onData] callback that provides the fetched data.
  Future<void> fetchData({
    required Query<Map<String, dynamic>> query,
    required int limit,
    required Function(bool value) noMoreData,
    required Function(bool value) onLoading,
    required Function(List<QueryDocumentSnapshot<Map<String, dynamic>>> data)
        onData,
  }) async {
    if (_isLoadingProgress) return;

    _isLoadingProgress = true;
    if (_docs.isEmpty) {
      onLoading(true);
    }

    QuerySnapshot<Map<String, dynamic>> ref;
    if (lastDoc == null) {
      // Fetching the first batch of data if no previous document exists
      ref = await query.limit(limit).get();
    } else {
      // Fetching the next batch starting after the last document
      ref = await query.startAfterDocument(lastDoc!).limit(limit).get();
    }

    if (ref.docs.isEmpty || ref.docs.length < limit) {
      _noMoreData = true;
      noMoreData(true);
    } else {
      lastDoc = ref.docs.last;
    }
    // Passing the document data to the onData callback
    final newDocs = ref.docs
        .where((doc) => !_docs.any((existingDoc) => existingDoc.id == doc.id))
        .toList();
    _docs.addAll(newDocs);
    onData(newDocs.map((d) => d).toList());

    _isLoadingProgress = false;
    onLoading(false);
  }

  /// Clears the state by resetting the last document, loading flags, and disposing the scroll controller.
  void clear() {
    _docs = [];
    lastDoc = null;
    _isLoadingProgress = false;
    _noMoreData = false;
    scrollController.dispose();
    scrollController = ScrollController();
  }

  Widget bottomLoadingIndicator({
    required Widget child,
  }) {
    if (!_noMoreData && _docs.isNotEmpty) {
      return child;
    } else {
      return const SizedBox();
    }
  }
}
