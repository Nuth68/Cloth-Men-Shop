import '../../../data/models/product_model.dart';

abstract class ChatEvent {
  const ChatEvent();
}

class LoadMessages extends ChatEvent {
  final String conversationId;
  const LoadMessages(this.conversationId);
}

class SendMessage extends ChatEvent {
  final String conversationId;
  final String text;
  final ProductModel? product;

  const SendMessage({
    required this.conversationId,
    required this.text,
    this.product,
  });
}

class MarkMessagesRead extends ChatEvent {
  final String conversationId;
  const MarkMessagesRead(this.conversationId);
}
