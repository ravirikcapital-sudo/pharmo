import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:school/model/dashboard/teacherDashboardModel/messageModelTeacher.dart'; // Import for debugPrint

/// A service to manage message data (simulated in-memory).
///
/// This service provides methods to fetch and send messages,
/// acting as a mock backend for the application.
class MessageService {
  // Singleton instance of the service.
  static final MessageService _instance = MessageService._internal();

  // Factory constructor to return the singleton instance.
  factory MessageService() => _instance;

  // Private constructor for the singleton pattern.
  MessageService._internal();

  // In-memory storage for messages.
  final List<Message> _messages = [];

  // Define some constants for current user and admin/officer IDs.
  // In a real application, these would come from an authentication system.
  static const String _currentUser = 'user123';
  static const String _adminOfficer = 'adminOfficer456';

  /// Initializes sample message data for demonstration purposes.
  void initializeSampleData() {
    if (_messages.isNotEmpty) return; // Prevent re-initialization

    _messages.add(
      Message(
        id: 'msg1',
        senderId: _adminOfficer,
        receiverId: _currentUser,
        content: 'Welcome to the school portal! How can I assist you today?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: true,
      ),
    );
    _messages.add(
      Message(
        id: 'msg2',
        senderId: _currentUser,
        receiverId: _adminOfficer,
        content: 'Hi! I have a question regarding my recent exam results.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
        isRead: true,
      ),
    );
    _messages.add(
      Message(
        id: 'msg3',
        senderId: _adminOfficer,
        receiverId: _currentUser,
        content: 'Certainly, please provide your roll number and the exam name.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        isRead: false,
      ),
    );
    _messages.add(
      Message(
        id: 'msg4',
        senderId: _currentUser,
        receiverId: _adminOfficer,
        content: 'My roll number is 001 and the exam is Unit Test 1.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        isRead: false,
      ),
    );
  }

  /// Returns the current user's ID.
  String getCurrentUserId() {
    return _currentUser;
  }

  /// Returns the admin/officer's ID.
  String getAdminOfficerId() {
    return _adminOfficer;
  }

  /// Fetches all messages relevant to the current user (sent by or to the current user).
  ///
  /// In a multi-user system, this would filter by conversation or recipient.
  Future<List<Message>> getMessagesForCurrentUser() async {
    // Ensure sample data is initialized if not already.
    if (_messages.isEmpty) {
      initializeSampleData();
    }
    // Filter messages to include only those involving the current user and admin/officer.
    // In a real app, this would query a backend for messages in a specific conversation.
    final relevantMessages = _messages.where((msg) =>
    (msg.senderId == _currentUser && msg.receiverId == _adminOfficer) ||
        (msg.senderId == _adminOfficer && msg.receiverId == _currentUser)
    ).toList();

    // Sort messages by timestamp to display them in chronological order.
    relevantMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return Future.value(relevantMessages);
  }

  /// Sends a new message and adds it to the in-memory store.
  Future<bool> sendMessage(String content, String senderId, String receiverId) async {
    try {
      final newMessage = Message(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}',
        senderId: senderId,
        receiverId: receiverId,
        content: content,
        timestamp: DateTime.now(),
        isRead: false, // Initially unread by the receiver
      );
      _messages.add(newMessage);
      return true;
    } catch (e) {
      debugPrint('Error sending message: $e');
      return false;
    }
  }

  /// Marks a specific message as read.
  Future<void> markMessageAsRead(String messageId) async {
    final index = _messages.indexWhere((msg) => msg.id == messageId);
    if (index != -1 && !_messages[index].isRead) {
      _messages[index] = _messages[index].copyWith(isRead: true);
    }
  }
}
