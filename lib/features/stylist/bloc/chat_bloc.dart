import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_event.dart';
import 'chat_state.dart';
import '../../../data/repositories/chat_repository.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _repository;

  ChatBloc(this._repository) : super(const ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<MarkMessagesRead>(_onMarkRead);
  }

  Future<void> _onLoadMessages(LoadMessages event, Emitter<ChatState> emit) async {
    emit(const ChatLoading());
    try {
      final messages = await _repository.getMessages(event.conversationId);
      emit(ChatLoaded(messages: messages));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    if (state is ChatLoaded) {
      final current = state as ChatLoaded;
      emit(ChatLoaded(messages: current.messages, isSending: true));

      try {
        final message = await _repository.sendMessage(
          conversationId: event.conversationId,
          senderId: 'user_1',
          senderName: 'You',
          text: event.text,
          product: event.product,
        );
        emit(ChatLoaded(messages: [...current.messages, message]));
      } catch (e) {
        emit(ChatLoaded(messages: current.messages));
      }
    }
  }

  Future<void> _onMarkRead(MarkMessagesRead event, Emitter<ChatState> emit) async {
    try {
      await _repository.markAsRead(event.conversationId);
    } catch (_) {}
  }
}
