import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../../../data/repositories/chat_repository.dart';
import '../../../data/models/message_model.dart';
import '../../../data/models/product_model.dart';

class StylistChatScreen extends StatelessWidget {
  final String conversationId;
  final String stylistName;
  final String stylistAvatarUrl;
  final String stylistSpecialty;

  const StylistChatScreen({
    super.key,
    required this.conversationId,
    required this.stylistName,
    this.stylistAvatarUrl = 'https://i.pravatar.cc/150?u=elena',
    this.stylistSpecialty = 'EXPERT STYLIST',
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatBloc(const ChatRepository())..add(LoadMessages(conversationId)),
      child: _ChatScreenBody(
        conversationId: conversationId,
        stylistName: stylistName,
        stylistAvatarUrl: stylistAvatarUrl,
        stylistSpecialty: stylistSpecialty,
      ),
    );
  }
}

class _ChatScreenBody extends StatefulWidget {
  final String conversationId;
  final String stylistName;
  final String stylistAvatarUrl;
  final String stylistSpecialty;

  const _ChatScreenBody({
    required this.conversationId,
    required this.stylistName,
    required this.stylistAvatarUrl,
    required this.stylistSpecialty,
  });

  @override
  State<_ChatScreenBody> createState() => _ChatScreenBodyState();
}

class _ChatScreenBodyState extends State<_ChatScreenBody> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    context.read<ChatBloc>().add(SendMessage(
          conversationId: widget.conversationId,
          text: text,
        ));

    _messageController.clear();
  }

  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour > 12 ? timestamp.hour - 12 : timestamp.hour;
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final amPm = timestamp.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $amPm';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatLoaded) {
          _scrollToBottom();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.stylistAvatarUrl),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.stylistName,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.circle, size: 10, color: Colors.green),
                        const SizedBox(width: 6),
                        const Text(
                          "ONLINE",
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.green,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.stylistSpecialty,
                          style: const TextStyle(
                              fontSize: 13,
                              color: Colors.brown,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            actions: const [
              Icon(Icons.search, color: Colors.black),
              SizedBox(width: 16),
              Icon(Icons.shopping_bag_outlined, color: Colors.black),
              SizedBox(width: 16),
            ],
          ),
          body: state is ChatLoading
              ? const Center(child: CircularProgressIndicator())
              : state is ChatError
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Failed to load messages',
                              style: TextStyle(color: Colors.grey.shade600)),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () => context
                                .read<ChatBloc>()
                                .add(LoadMessages(widget.conversationId)),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : state is ChatLoaded
                      ? _buildChatBody(state)
                      : const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildChatBody(ChatLoaded state) {
    return Column(
      children: [
        // Date
        if (state.messages.isNotEmpty)
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _formatDateHeader(state.messages.first.timestamp),
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
              ),
            ),
          ),

        // Messages
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                ...state.messages.map((msg) => _buildMessageItem(msg)),
                if (state.isSending)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),

        // Bottom Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.attach_file),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.camera_alt_outlined),
                onPressed: () {},
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "WRITE A MESSAGE...",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: state.isSending ? null : _sendMessage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text("SEND",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),

        // Encrypted Footer
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.grey.shade50,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 16, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                "ENCRYPTED EDITORIAL CONSULTATION",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageItem(MessageModel msg) {
    if (msg.product != null && msg.isFromStylist) {
      return Column(
        children: [
          _buildStylistMessage(msg.text, _formatTime(msg.timestamp)),
          const SizedBox(height: 12),
          _buildProductCard(msg.product!),
          const SizedBox(height: 12),
        ],
      );
    }

    if (msg.isFromStylist) {
      return Column(
        children: [
          _buildStylistMessage(msg.text, _formatTime(msg.timestamp)),
          const SizedBox(height: 12),
        ],
      );
    }

    return Column(
      children: [
        _buildUserMessage(msg.text, _formatTime(msg.timestamp)),
        const SizedBox(height: 12),
      ],
    );
  }

  String _formatDateHeader(DateTime timestamp) {
    final days = [
      'MONDAY',
      'TUESDAY',
      'WEDNESDAY',
      'THURSDAY',
      'FRIDAY',
      'SATURDAY',
      'SUNDAY'
    ];
    final months = [
      'JANUARY',
      'FEBRUARY',
      'MARCH',
      'APRIL',
      'MAY',
      'JUNE',
      'JULY',
      'AUGUST',
      'SEPTEMBER',
      'OCTOBER',
      'NOVEMBER',
      'DECEMBER'
    ];
    return '${days[timestamp.weekday - 1]}, ${months[timestamp.month - 1]} ${timestamp.day}';
  }

  Widget _buildStylistMessage(String text, String time) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(right: 60),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text, style: const TextStyle(fontSize: 16, height: 1.4)),
            const SizedBox(height: 8),
            Text(time,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildUserMessage(String text, String time) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(left: 60),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              text,
              style: const TextStyle(
                  fontSize: 16, height: 1.4, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(time,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 280,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const Center(
                child: Icon(Icons.image, size: 64, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "NEW ARRIVAL",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  product.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600, height: 1.2),
                ),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: const TextStyle(fontSize: 15, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Text(
                  "\$${product.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      "ADD TO SELECTION",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
