import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
import '../../../shared/widgets/monograph_header.dart';
import '../../../core/l10n/app_localizations.dart';

class StylistChatScreen extends StatelessWidget {
  final String conversationId, stylistName, stylistAvatarUrl, stylistSpecialty;
  const StylistChatScreen({super.key, required this.conversationId, required this.stylistName,
    this.stylistAvatarUrl = 'https://i.pravatar.cc/150?u=elena', this.stylistSpecialty = 'EXPERT STYLIST'});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatBloc(const ChatRepository())..add(LoadMessages(conversationId)),
      child: _ChatScreenBody(conversationId: conversationId, stylistName: stylistName,
        stylistAvatarUrl: stylistAvatarUrl, stylistSpecialty: stylistSpecialty),
    );
  }
}

class _ChatScreenBody extends StatefulWidget {
  final String conversationId, stylistName, stylistAvatarUrl, stylistSpecialty;
  const _ChatScreenBody({required this.conversationId, required this.stylistName,
    required this.stylistAvatarUrl, required this.stylistSpecialty});
  @override
  State<_ChatScreenBody> createState() => _ChatScreenBodyState();
}

class _ChatScreenBodyState extends State<_ChatScreenBody> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  bool _isTyping = false;

  @override
  void dispose() { _msgCtrl.dispose(); _scrollCtrl.dispose(); super.dispose(); }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  void _send() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    context.read<ChatBloc>().add(SendMessage(conversationId: widget.conversationId, text: text));
    _msgCtrl.clear();
    setState(() => _isTyping = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (_, state) { if (state is ChatLoaded) _scrollDown(); },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.surface(context),
          body: SafeArea(top: false, 
            child: Column(
              children: [
                MonographHeader(
                  onBack: () => context.pop(),
                  onBag: () => context.push('/cart'),
                  onNotification: () => context.push('/notifications'),
                  elevated: true,
                ),
                // Stylist info row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(children: [
                    CircleAvatar(radius: 18, backgroundImage: NetworkImage(widget.stylistAvatarUrl)),
                    const SizedBox(width: 10),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(widget.stylistName, style: AppTypography.heading2, maxLines: 1),
                      Row(children: [
                        const Icon(Icons.circle, size: 7, color: AppColors.success),
                        const SizedBox(width: 4),
                        Text(l10n.translate('online'), style: AppTypography.bodySmall.copyWith(color: AppColors.success)),
                      ]),
                    ])),
                  ]),
                ),
                Expanded(
                  child: state is ChatLoading
                      ? Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.onSurface))
                      : state is ChatLoaded ? _buildChat(state) : const SizedBox(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChat(ChatLoaded state) {
    final l10n = AppLocalizations.of(context);
    return Column(children: [
      if (state.messages.isNotEmpty)
        Center(child: Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          decoration: BoxDecoration(color: AppColors.monoLightGrey.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(20)),
          child: Text(_formatDate(state.messages.first.timestamp),
              style: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey)),
        )),
      Expanded(
        child: ListView.builder(
          controller: _scrollCtrl, padding: const EdgeInsets.symmetric(horizontal: 14),
          itemCount: state.messages.length,
          itemBuilder: (_, i) => _buildBubble(state.messages[i]),
        ),
      ),
      // Input bar
      Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
        decoration: BoxDecoration(color: AppColors.surface(context), border: const Border(top: BorderSide(color: AppColors.monoDivider))),
        child: Row(children: [
          IconButton(icon: const Icon(Icons.image_outlined, size: 22, color: AppColors.monoGrey), onPressed: () {}),
          Expanded(child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(color: AppColors.monoLightGrey.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(24)),
            child: TextField(
              controller: _msgCtrl, onChanged: (_) => setState(() => _isTyping = _msgCtrl.text.isNotEmpty),
              style: AppTypography.bodyMedium,
              decoration: InputDecoration(hintText: l10n.translate('messageHint'), border: InputBorder.none, hintStyle: const TextStyle(color: AppColors.monoGrey)),
              onSubmitted: (_) => _send(),
            ),
          )),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: _isTyping ? _send : null,
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: _isTyping ? AppColors.monoBlack : AppColors.monoLightGrey, shape: BoxShape.circle),
              child: const Icon(Icons.send_rounded, size: 16, color: AppColors.white),
            ),
          ),
        ]),
      ),
    ]);
  }

  Widget _buildBubble(MessageModel msg) {
    final isMe = !msg.isFromStylist;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
        if (msg.product != null) _buildProductCard(msg.product!),
        Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isMe ? AppColors.monoBlack : AppColors.monoLightGrey.withValues(alpha: 0.5),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16), topRight: const Radius.circular(16),
              bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(4),
              bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(16),
            ),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(msg.text, style: AppTypography.bodyLarge.copyWith(height: 1.35, color: isMe ? AppColors.white : null)),
            const SizedBox(height: 4),
            Text(_formatTime(msg.timestamp), style: AppTypography.bodySmall.copyWith(color: isMe ? Colors.white54 : AppColors.monoGrey)),
          ]),
        ),
      ]),
    );
  }

  Widget _buildProductCard(ProductModel p) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      width: MediaQuery.of(context).size.width * 0.72,
      decoration: BoxDecoration(border: Border.all(color: AppColors.monoDivider), borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(11)), child: SizedBox(height: 160, width: double.infinity,
          child: CachedNetworkImage(imageUrl: p.imageUrl, fit: BoxFit.cover,
            placeholder: (_, _) => ShimmerLoading.banner(height: 160),
            errorWidget: (_, _, _) => Container(color: AppColors.monoLightGrey)))),
        Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l10n.translate('newArrivalTag'), style: AppTypography.labelSmall.copyWith(color: AppColors.error)),
          const SizedBox(height: 6),
          Text(p.name, style: AppTypography.heading2), const SizedBox(height: 4),
          Text(p.description, style: AppTypography.bodySmall.copyWith(color: AppColors.monoGrey), maxLines: 2),
          const SizedBox(height: 10),
          Row(children: [
            Text('\$${p.price.toStringAsFixed(0)}', style: AppTypography.price),
            const Spacer(),
            SizedBox(height: 34, child: ElevatedButton(
              onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: AppColors.monoBlack, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal: 12)),
              child: Text(l10n.translate('addToCart'), style: AppTypography.button.copyWith(color: AppColors.white, fontSize: 11)),
            )),
          ]),
        ])),
      ]),
    );
  }

  String _formatTime(DateTime t) {
    final h = t.hour > 12 ? t.hour - 12 : (t.hour == 0 ? 12 : t.hour);
      return '$h:${t.minute.toString().padLeft(2, '0')} ${t.hour >= 12 ? 'PM' : 'AM'}';
  }

  String _formatDate(DateTime t) {
    const d = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${d[t.weekday - 1]}, ${m[t.month - 1]} ${t.day}';
  }
}
