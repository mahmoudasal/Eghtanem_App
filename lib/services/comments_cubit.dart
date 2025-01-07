// import 'package:bloc/bloc.dart';
// import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// import 'package:http/http.dart' as http;
// import 'package:logger/logger.dart';

// abstract class CommentsState {}

// class CommentsInitial extends CommentsState {}

// class CommentsLoading extends CommentsState {}

// class CommentsLoaded extends CommentsState {
//   final List<Map<String, dynamic>> comments;
//   final bool hasMore;
//   final bool isLoadingMore;

//   CommentsLoaded({
//     required this.comments,
//     required this.hasMore,
//     this.isLoadingMore = false,
//   });
// }

// class CommentsError extends CommentsState {
//   final String errorMessage;

//   CommentsError(this.errorMessage);
// }

// class CommentsCubit extends Cubit<CommentsState> {
//   CommentsCubit() : super(CommentsInitial());

//   final _secureStorage = const FlutterSecureStorage();
//   var logger = Logger();

//   List<Map<String, dynamic>> _comments = [];
//   String? _pageToken;
//   bool _hasMoreData = true;
//   bool _isLoading = false;

//   bool get isLoading => _isLoading;

//   Future<void> fetchComments(String videoId, {bool loadMore = false}) async {
//     if (_isLoading) return;
//     _isLoading = true;

//     final currentState = state;

//     if (!loadMore) {
//       emit(CommentsLoading());
//     } else {
//       if (currentState is CommentsLoaded) {
//         // Emit a new CommentsLoaded state with isLoadingMore = true
//         emit(CommentsLoaded(
//           comments: currentState.comments,
//           hasMore: currentState.hasMore,
//           isLoadingMore: true,
//         ));
//       }
//     }

//     final accessToken = await _getAccessToken();
//     if (accessToken == null) {
//       emit(CommentsError('User not signed in'));
//       _isLoading = false;
//       return;
//     }

//     const maxResults = 10;

//     try {
//       final params = {
//         'part': 'snippet',
//         'videoId': videoId,
//         'maxResults': maxResults.toString(),
//         if (_pageToken != null) 'pageToken': _pageToken,
//       };

//       final uri =
//           Uri.https('www.googleapis.com', '/youtube/v3/commentThreads', params);

//       final response = await http.get(uri, headers: {
//         'Authorization': 'Bearer $accessToken',
//       });

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);

//         final items = data['items'] as List<dynamic>;

//         List<Map<String, dynamic>> newComments = [];

//         for (var item in items) {
//           final snippet = item['snippet']['topLevelComment']['snippet'];
//           final commentText = snippet['textDisplay'];
//           final authorDisplayName = snippet['authorDisplayName'];
//           final authorProfileImageUrl = snippet['authorProfileImageUrl'];
//           final likeCount = snippet['likeCount'];
//           final publishedAt = snippet['publishedAt'];

//           newComments.add({
//             'authorDisplayName': authorDisplayName,
//             'authorProfileImageUrl': authorProfileImageUrl,
//             'commentText': commentText,
//             'likeCount': likeCount,
//             'publishedAt': publishedAt,
//           });
//         }

//         if (!loadMore) {
//           _comments = newComments;
//         } else {
//           _comments.addAll(newComments);
//         }

//         _pageToken = data['nextPageToken'];

//         if (_pageToken == null) {
//           _hasMoreData = false;
//         }

//         emit(CommentsLoaded(
//           comments: List.from(_comments),
//           hasMore: _hasMoreData,
//           isLoadingMore: false,
//         ));
//       } else {
//         throw Exception(
//             'Failed to fetch comments. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       logger.e('Error fetching comments: $e');
//       emit(CommentsError('Failed to fetch comments: $e'));
//     } finally {
//       _isLoading = false;
//     }
//   }
// }
