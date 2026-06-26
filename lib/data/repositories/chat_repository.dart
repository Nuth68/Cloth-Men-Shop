import '../models/message_model.dart';
import '../models/product_model.dart';

class ChatRepository {
  // TODO: inject ApiService when backend is available
  // final ApiService _api;
  // ChatRepository(this._api);

  const ChatRepository();

  Future<List<MessageModel>> getMessages(String conversationId) async {
    // TODO: replace with actual API call
    // final data = await _api.get('/conversations/$conversationId/messages');
    // return (data as List).map((e) => MessageModel.fromJson(e)).toList();

    return _mockMessages(conversationId);
  }

  Future<MessageModel> sendMessage({
    required String conversationId,
    required String senderId,
    required String senderName,
    required String text,
    ProductModel? product,
  }) async {
    // TODO: replace with actual API call
    // final data = await _api.post('/conversations/$conversationId/messages', body: {
    //   'sender_id': senderId,
    //   'sender_name': senderName,
    //   'text': text,
    //   if (product != null) 'product': product.toJson(),
    // });
    // return MessageModel.fromJson(data);

    await Future.delayed(const Duration(milliseconds: 300));
    return MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      conversationId: conversationId,
      senderId: senderId,
      senderName: senderName,
      text: text,
      timestamp: DateTime.now(),
      isFromStylist: false,
      product: product,
      isRead: true,
    );
  }

  Future<void> markAsRead(String conversationId) async {
    // TODO: replace with actual API call
    // await _api.put('/conversations/$conversationId/read');
  }

  List<MessageModel> _mockMessages(String conversationId) {
    return [
      MessageModel(
        id: 'msg_1',
        conversationId: conversationId,
        senderId: 'stylist_1',
        senderName: 'Elena Vance',
        senderAvatarUrl: 'https://i.pravatar.cc/150?u=elena',
        text:
            "Hello! I've curated a few pieces that perfectly capture the 'Steav Fashion' aesthetic you're looking for. These emphasize clean lines and superior drape.",
        timestamp: DateTime.now().subtract(const Duration(minutes: 46)),
        isFromStylist: true,
        isRead: true,
      ),
      MessageModel(
        id: 'msg_2',
        conversationId: conversationId,
        senderId: 'user_1',
        senderName: 'You',
        text:
            "Thank you, Elena. I'm specifically interested in items that work well for transition weather but maintain a sharp silhouette.",
        timestamp: DateTime.now().subtract(const Duration(minutes: 44)),
        isFromStylist: false,
        isRead: true,
      ),
      MessageModel(
        id: 'msg_3',
        conversationId: conversationId,
        senderId: 'stylist_1',
        senderName: 'Elena Vance',
        senderAvatarUrl: 'https://i.pravatar.cc/150?u=elena',
        text: 'This cardigan would be an excellent foundation piece for your wardrobe.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 42)),
        isFromStylist: true,
        product: ProductModel(
          id: 'prod_1',
          name: 'Architectural Merino Cardigan',
          description: '100% Responsibly Sourced Merino Wool.',
          price: 490.00,
          imageUrl: 'https://picsum.photos/id/1015/600/800',
          categoryId: 'cat_1',
        ),
        isRead: true,
      ),
      MessageModel(
        id: 'msg_4',
        conversationId: conversationId,
        senderId: 'user_1',
        senderName: 'You',
        text: 'What do you think about these boots as a pairing?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 35)),
        isFromStylist: false,
        isRead: true,
      ),
    ];
  }
}
