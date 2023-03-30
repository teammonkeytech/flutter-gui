import 'User.dart';
import 'Bubble.dart';

class Message {
  User author;
  Bubble bubble;
  String content;

  Message({required this.author, required this.bubble, required this.content});
}
