import 'package:flutter/foundation.dart';
import 'package:stevenako_flutter/networks/api_acess.dart';

class PostCommentItem {
  final String id;
  final String userName;
  final String avatar;
  final String text;
  final String? replyTo;
  final bool edited;
  final dynamic userId;
  final DateTime createdAt;

  PostCommentItem({
    required this.id,
    required this.userName,
    required this.avatar,
    required this.text,
    this.replyTo,
    this.edited = false,
    this.userId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  PostCommentItem copyWith({
    String? id,
    String? userName,
    String? avatar,
    String? text,
    String? replyTo,
    bool? edited,
    dynamic userId,
    DateTime? createdAt,
  }) {
    return PostCommentItem(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      avatar: avatar ?? this.avatar,
      text: text ?? this.text,
      replyTo: replyTo ?? this.replyTo,
      edited: edited ?? this.edited,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, String> toMap() {
    return {
      'id': id,
      'userName': userName,
      'avatar': avatar,
      'text': text,
      'replyTo': replyTo ?? '',
      'edited': edited ? 'true' : 'false',
      'userId': userId?.toString() ?? '',
    };
  }

  factory PostCommentItem.fromMap(Map<String, dynamic> map) {
    return PostCommentItem(
      id: map['id']?.toString() ?? DateTime.now().microsecondsSinceEpoch.toString(),
      userName: map['userName']?.toString() ?? 'User',
      avatar: map['avatar']?.toString() ?? '',
      text: map['text']?.toString() ?? '',
      replyTo: (map['replyTo'] != null && map['replyTo'].toString().isNotEmpty)
          ? map['replyTo'].toString()
          : null,
      edited: map['edited'] == 'true' || map['edited'] == true,
      userId: map['userId'],
    );
  }
}

class PostCommentsProvider extends ChangeNotifier {
  final Map<String, List<PostCommentItem>> _commentsByPost = {};

  int? _replyingToIndex;
  int? _editingIndex;
  String? _activePostKey;

  int? get replyingToIndex => _replyingToIndex;
  int? get editingIndex => _editingIndex;
  String? get activePostKey => _activePostKey;

  void setActivePost(String postKey) {
    if (_activePostKey != postKey) {
      _activePostKey = postKey;
      _replyingToIndex = null;
      _editingIndex = null;
      notifyListeners();
    }
  }

  void initializeComments(String postKey, List<dynamic>? initialComments) {
    if (!_commentsByPost.containsKey(postKey)) {
      final List<PostCommentItem> list = [];
      if (initialComments != null) {
        for (final item in initialComments) {
          if (item is Map<String, dynamic>) {
            list.add(PostCommentItem.fromMap(item));
          } else if (item is Map) {
            list.add(PostCommentItem.fromMap(Map<String, dynamic>.from(item)));
          } else if (item is PostCommentItem) {
            list.add(item);
          }
        }
      }
      _commentsByPost[postKey] = list;
      notifyListeners();
    }
  }

  List<PostCommentItem> getComments(String postKey) {
    return _commentsByPost[postKey] ?? [];
  }

  int getCommentCount(String postKey) {
    return _commentsByPost[postKey]?.length ?? 0;
  }

  String getCurrentUserName() {
    final user = getUserProfileRxObj.dataFetcher.valueOrNull?.data?.user;
    if (user != null) {
      if (user.name != null && user.name!.trim().isNotEmpty) {
        return user.name!.trim();
      }
      if (user.username != null && user.username!.trim().isNotEmpty) {
        return user.username!.trim();
      }
    }
    return 'You';
  }

  String getCurrentUserAvatar() {
    final user = getUserProfileRxObj.dataFetcher.valueOrNull?.data?.user;
    return user?.avatar ?? '';
  }

  dynamic getCurrentUserId() {
    final user = getUserProfileRxObj.dataFetcher.valueOrNull?.data?.user;
    return user?.id;
  }

  void addComment({
    required String postKey,
    required String text,
    String? userName,
    String? avatar,
    dynamic userId,
  }) {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) return;

    final list = _commentsByPost.putIfAbsent(postKey, () => []);

    if (_editingIndex != null && _editingIndex! < list.length) {
      // Edit existing comment
      final current = list[_editingIndex!];
      list[_editingIndex!] = current.copyWith(
        text: trimmedText,
        edited: true,
      );
      _editingIndex = null;
    } else if (_replyingToIndex != null && _replyingToIndex! < list.length) {
      // Reply to comment
      final parentComment = list[_replyingToIndex!];
      list.add(
        PostCommentItem(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          userName: userName ?? getCurrentUserName(),
          avatar: avatar ?? getCurrentUserAvatar(),
          text: trimmedText,
          replyTo: parentComment.userName,
          userId: userId ?? getCurrentUserId(),
        ),
      );
      _replyingToIndex = null;
    } else {
      // New top-level comment
      list.add(
        PostCommentItem(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          userName: userName ?? getCurrentUserName(),
          avatar: avatar ?? getCurrentUserAvatar(),
          text: trimmedText,
          userId: userId ?? getCurrentUserId(),
        ),
      );
    }

    notifyListeners();
  }

  void editComment({
    required String postKey,
    required int index,
    required String newText,
  }) {
    final trimmed = newText.trim();
    if (trimmed.isEmpty) return;

    final list = _commentsByPost[postKey];
    if (list != null && index >= 0 && index < list.length) {
      list[index] = list[index].copyWith(text: trimmed, edited: true);
      notifyListeners();
    }
  }

  void deleteComment({
    required String postKey,
    required int index,
  }) {
    final list = _commentsByPost[postKey];
    if (list != null && index >= 0 && index < list.length) {
      list.removeAt(index);
      if (_editingIndex == index) _editingIndex = null;
      if (_replyingToIndex == index) _replyingToIndex = null;
      notifyListeners();
    }
  }

  void startReply(int index) {
    _replyingToIndex = index;
    _editingIndex = null;
    notifyListeners();
  }

  void startEdit(int index) {
    _editingIndex = index;
    _replyingToIndex = null;
    notifyListeners();
  }

  void cancelReplyOrEdit() {
    _replyingToIndex = null;
    _editingIndex = null;
    notifyListeners();
  }
}
