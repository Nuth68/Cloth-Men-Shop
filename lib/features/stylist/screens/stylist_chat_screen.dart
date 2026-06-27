import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/repositories/chat_repository.dart';
import '../../../data/models/message_model.dart';
import '../../../data/models/product_model.dart';
import '../../../shared/widgets/shimmer_loading.dart';

class StylistChatScreen extends StatelessWidget {
  final String conversationId, stylistName, stylistAvatarUrl, stylistSpecialty;
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
      create: (_) =>
          ChatBloc(const ChatRepository())..add(LoadMessages(conversationId)),
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
  final String conversationId, stylistName, stylistAvatarUrl, stylistSpecialty;
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
  final TextEditingController _messageCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void dispose() {
    _messageCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut);
      }
    });
  }

  void _sendMessage() {
    final text = _messageCtrl.text.trim();
    if (text.isEmpty) return;
    context.read<ChatBloc>().add(SendMessage(
          conversationId: widget.conversationId,
          text: text,
        ));
    _messageCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatLoaded) _scrollToBottom();
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: AppColors.monoBlack),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      NetworkImage(widget.stylistAvatarUrl),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.stylistName,
                        style: AppTypography.heading2.copyWith(
                            color: AppColors.monoBlack)),
                    Row(
                      children: [
                        const Icon(Icons.circle,
                            size: 8, color: AppColors.success),
                        const SizedBox(width: 6),
                        Text("ONLINE",
                            style: AppTypography.bodySmall.copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(width: 8),
                        Text(widget.stylistSpecialty,
                            style: AppTypography.bodySmall.copyWith(
                                color: AppColors.brass,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: state is ChatLoading
              ? const Center(child: CircularProgressIndicator())
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
        if (state.messages.isNotEmpty)
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.monoLightGrey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                  _formatDateHeader(
                      state.messages.first.timestamp),
                  style: AppTypography.bodySmall.copyWith(
                      color: AppColors.monoGrey,
                      fontWeight: FontWeight.w500)),
            ),
          ),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollCtrl,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                ...state.messages.map(_buildMessageItem),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border(
                top: BorderSide(color: AppColors.monoDivider)),
          ),
          child: Row(
            children: [
              IconButton(
                  icon: const Icon(Icons.attach_file), onPressed: () {}),
              IconButton(
                  icon: const Icon(Icons.camera_alt_outlined),
                  onPressed: () {}),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.monoLightGrey,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _messageCtrl,
                    style: AppTypography.bodyMedium,
                    decoration: const InputDecoration(
                      hintText: "WRITE A MESSAGE...",
                      border: InputBorder.none,
                      hintStyle:
                          TextStyle(color: AppColors.monoGrey),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed:
                    state.isSending ? null : _sendMessage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.monoBlack,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                ),
                child: Text("SEND",
                    style: AppTypography.button.copyWith(
                        color: AppColors.white)),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          color: AppColors.monoOffWhite,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 16, color: AppColors.monoGrey),
              SizedBox(width: 8),
              Text("ENCRYPTED EDITORIAL CONSULTATION",
                  style: TextStyle(
                      fontSize: 12, color: AppColors.monoGrey)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageItem(MessageModel msg) {
    if (msg.isFromStylist) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.only(right: 60),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.monoLightGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (msg.product != null) ...[
                  _buildProductCard(msg.product!),
                  const SizedBox(height: 12),
                ],
                Text(msg.text,
                    style: AppTypography.bodyLarge.copyWith(
                        height: 1.4, color: AppColors.monoBlack)),
                const SizedBox(height: 8),
                Text(_formatTime(msg.timestamp),
                    style: AppTypography.bodySmall.copyWith(
                        color: AppColors.monoGrey)),
              ],
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(left: 60),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.monoBlack,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(msg.text,
                  style: AppTypography.bodyLarge.copyWith(
                      height: 1.4, color: AppColors.white)),
              const SizedBox(height: 8),
              Text(_formatTime(msg.timestamp),
                  style: AppTypography.bodySmall.copyWith(
                      color: Colors.white54)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.monoDivider),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12)),
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    ShimmerLoading.banner(height: 200),
                errorWidget: (_, __, ___) => Container(
                    color: AppColors.monoLightGrey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("NEW ARRIVAL",
                    style: AppTypography.labelSmall.copyWith(
                        color: AppColors.error)),
                const SizedBox(height: 8),
                Text(product.name,
                    style: AppTypography.heading2.copyWith(
                        color: AppColors.monoBlack)),
                const SizedBox(height: 8),
                Text(product.description,
                    style: AppTypography.bodySmall.copyWith(
                        color: AppColors.monoGrey)),
                const SizedBox(height: 12),
                Text(
                    "\$${product.price.toStringAsFixed(2)}",
                    style: AppTypography.price),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.monoBlack,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14),
                    ),
                    child: Text("ADD TO SELECTION",
                        style: AppTypography.button.copyWith(
                            color: AppColors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime t) {
    final hour = t.hour > 12 ? t.hour - 12 : t.hour;
    final min = t.minute.toString().padLeft(2, '0');
    final amPm = t.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$min $amPm';
  }

  String _formatDateHeader(DateTime t) {
    const days = [
      'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY',
      'FRIDAY', 'SATURDAY', 'SUNDAY'
    ];
    const months = [
      'JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE',
      'JULY', 'AUGUST', 'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER'
    ];
    return '${days[t.weekday - 1]}, ${months[t.month - 1]} ${t.day}';
  }
}
