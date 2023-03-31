import 'user.dart';
import 'bubble.dart';

class Message {
  LocalUser author;
  Bubble bubble;
  String content;

  Message({required this.author, required this.bubble, required this.content});
}
