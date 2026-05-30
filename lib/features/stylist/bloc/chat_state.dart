import '../../../data/models/message_model.dart';

abstract class ChatState {
  const ChatState();
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatLoading extends ChatState {
  const ChatLoading();
}

class ChatLoaded extends ChatState {
  final List<MessageModel> messages;
  final bool isSending;

  const ChatLoaded({required this.messages, this.isSending = false});
}

class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);
}
