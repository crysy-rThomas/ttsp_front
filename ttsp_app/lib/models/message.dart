class Message {
  final int id;
  final int index;
  final String content;
  final int conversationId;
  final String role;

  Message({
    required this.id,
    required this.index,
    required this.content,
    required this.conversationId,
    required this.role,
  });
}