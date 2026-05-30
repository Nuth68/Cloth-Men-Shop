import 'product_model.dart';

class MessageModel {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String? senderAvatarUrl;
  final String text;
  final DateTime timestamp;
  final bool isFromStylist;
  final ProductModel? product;
  final bool isRead;

  const MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    this.senderAvatarUrl,
    required this.text,
    required this.timestamp,
    required this.isFromStylist,
    this.product,
    this.isRead = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json['id'] as String,
        conversationId: json['conversation_id'] as String,
        senderId: json['sender_id'] as String,
        senderName: json['sender_name'] as String,
        senderAvatarUrl: json['sender_avatar_url'] as String?,
        text: json['text'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        isFromStylist: json['is_from_stylist'] as bool,
        product: json['product'] != null
            ? ProductModel.fromJson(json['product'] as Map<String, dynamic>)
            : null,
        isRead: json['is_read'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'conversation_id': conversationId,
        'sender_id': senderId,
        'sender_name': senderName,
        'sender_avatar_url': senderAvatarUrl,
        'text': text,
        'timestamp': timestamp.toIso8601String(),
        'is_from_stylist': isFromStylist,
        if (product != null) 'product': product!.toJson(),
        'is_read': isRead,
      };

  MessageModel copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? senderName,
    String? senderAvatarUrl,
    String? text,
    DateTime? timestamp,
    bool? isFromStylist,
    ProductModel? product,
    bool? isRead,
  }) =>
      MessageModel(
        id: id ?? this.id,
        conversationId: conversationId ?? this.conversationId,
        senderId: senderId ?? this.senderId,
        senderName: senderName ?? this.senderName,
        senderAvatarUrl: senderAvatarUrl ?? this.senderAvatarUrl,
        text: text ?? this.text,
        timestamp: timestamp ?? this.timestamp,
        isFromStylist: isFromStylist ?? this.isFromStylist,
        product: product ?? this.product,
        isRead: isRead ?? this.isRead,
      );
}
