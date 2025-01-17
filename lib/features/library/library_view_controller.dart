import 'package:book_adapter/controller/firebase_controller.dart';
import 'package:book_adapter/features/library/data/book_collection.dart';
import 'package:book_adapter/features/library/data/book_item.dart';
import 'package:book_adapter/service/storage_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final libraryViewController = StateNotifierProvider<LibraryViewController, LibraryViewData>((ref) {
  final bookStreamProvider = ref.watch(firebaseControllerProvider).bookStreamProvider;
  final collectionsStreamProvider = ref.watch(firebaseControllerProvider).collectionsStreamProvider;

  final books = ref.watch(bookStreamProvider);
  final collections = ref.watch(collectionsStreamProvider);

  final data = LibraryViewData(books: books.asData?.value, collections: collections.asData?.value);
  return LibraryViewController(ref.read, data: data);
});

// State is if the view is loading
class LibraryViewController extends StateNotifier<LibraryViewData> {
  LibraryViewController(this._read, {required LibraryViewData data}) : super(data);

  final Reader _read;

  Future<void> addBooks(BuildContext context) async {
    // Make storage service call to pick books
    final sRes = await _read(storageServiceProvider).pickFile(
      type: FileType.custom,
      allowedExtensions: ['epub'],
      allowMultiple: true,
      withReadStream: true,
    );

    if (sRes.isLeft()) {
      return;
    }

    final platformFiles = sRes.getOrElse(() => []);

    final uploadedBooks = <Book>[];
    for (final file in platformFiles) {
      // Add book to firebase
      final fRes = await _read(firebaseControllerProvider).addBook(file);
      fRes.fold(
        (failure) {
          final snackBar = SnackBar(content: Text(failure.message), duration: const Duration(seconds: 2),);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        (book) => uploadedBooks.add(book)
      );
    }
  }

  Future<void> deleteBook(String bookId) {
    throw UnimplementedError();
  }

  Future<void> signOut() async {
    await _read(firebaseControllerProvider).signOut();
  }
}

class LibraryViewData {
  final List<Book>? books;
  final List<BookCollection>? collections;
  LibraryViewData({
    this.books,
    this.collections,
  });

  LibraryViewData copyWith({
    List<Book>? books,
    List<BookCollection>? collections,
  }) {
    return LibraryViewData(
      books: books ?? this.books,
      collections: collections ?? this.collections,
    );
  }
}
