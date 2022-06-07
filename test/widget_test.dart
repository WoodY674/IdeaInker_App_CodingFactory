import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thebestatoo/Classes/Posts.dart';

void main() {
  test("Test récupération des posts",() async {
    var postsToGet = fetchPosts();
    List<Posts> posts =  await postsToGet;
    expect(posts.isNotEmpty, true);
  });
}
