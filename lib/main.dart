// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/catalog.dart';
import 'src/item_tile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Catalog>(
      create: (context) => Catalog(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MPR - Delta',
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MPR - Delta',
            style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold
            ),
        ),
        backgroundColor: Colors.green,
        elevation: 2,
      ),
      body: Selector<Catalog, int?>(
        // Selector is a widget from package:provider. It allows us to listen
        // to only one aspect of a provided value. In this case, we are only
        // listening to the catalog's `itemCount`, because that's all we need
        // at this level.
        selector: (context, catalog) => catalog.itemCount,
        builder: (context, itemCount, child) => ListView.builder(
          // When `itemCount` is null, `ListView` assumes an infinite list.
          // Once we provide a value, it will stop the scrolling beyond
          // the last element.
          itemCount: itemCount,
          padding: const EdgeInsets.symmetric(vertical: 18),
          itemBuilder: (context, index) {
            // Every item of the `ListView` is individually listening
            // to the catalog.
            var catalog = Provider.of<Catalog>(context);

            // Catalog provides a single synchronous method for getting
            // the current data.
            var item = catalog.getByIndex(index);

            if (item.isLoading) {
              return const LoadingItemTile();
            }

            return ItemTile(item: item);
          },
        ),
      ),
    );
  }
}
