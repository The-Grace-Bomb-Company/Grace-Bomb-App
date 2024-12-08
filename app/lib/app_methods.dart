class AppMethods {
  static String createHashtag(String sentence) {
    final words = sentence.split(' ').where((word) => word.isNotEmpty);
    String hashtag =
        words.map((word) => word[0].toUpperCase() + word.substring(1)).join();
    if (hashtag[0] != '#') hashtag = '#$hashtag';
    return hashtag;
  }
}
