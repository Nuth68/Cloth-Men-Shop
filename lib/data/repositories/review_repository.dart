import '../datasources/remote/graphql_service.dart';
import '../models/review_model.dart';

class ReviewRepository {
  final GraphqlService _gql;

  ReviewRepository(this._gql);

  Future<List<ReviewModel>> getReviews(String productId) async {
    final response = await _gql.query('''
      query GetReviews(\$productId: Int!) {
        reviews(productId: \$productId) {
          id
          rating
          title
          comment
          createdAt
          userId
        }
      }
    ''', variables: {'productId': int.tryParse(productId) ?? 0});
    if (response.errors?.isNotEmpty == true) return [];
    final list = response.data?['reviews'] as List<dynamic>? ?? [];
    return list.map((j) => ReviewModel.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<ReviewModel?> createReview({
    required String productId,
    required double rating,
    String? title,
    String? comment,
  }) async {
    final response = await _gql.mutate('''
      mutation CreateReview(\$productId: Int!, \$rating: Float!, \$title: String, \$comment: String) {
        createReview(createReviewInput: {
          productId: \$productId
          rating: \$rating
          title: \$title
          comment: \$comment
        }) {
          id
          rating
          title
          comment
          createdAt
        }
      }
    ''', variables: {
      'productId': int.tryParse(productId) ?? 0,
      'rating': rating,
      'title': title ?? '',
      'comment': comment ?? '',
    });
    if (response.errors?.isNotEmpty == true) return null;
    final data = response.data?['createReview'];
    if (data == null) return null;
    return ReviewModel.fromJson(data as Map<String, dynamic>);
  }
}
