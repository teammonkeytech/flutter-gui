import 'user.dart';
import 'bubble.dart';

class Message {
  User author;
  Bubble bubble;
  String content;

  Message({required this.author, required this.bubble, required this.content});
}
