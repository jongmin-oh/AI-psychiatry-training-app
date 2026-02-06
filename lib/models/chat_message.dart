import 'package:json_annotation/json_annotation.dart';

part 'chat_message.g.dart';

@JsonSerializable()
class ChatMessage {
  final String id;
  final String sessionId;
  final String sender; // 'user' or 'ai'
  final String content;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.sessionId,
    required this.sender,
    required this.content,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);

  bool get isUser => sender == 'user';
  bool get isAI => sender == 'ai';
}
