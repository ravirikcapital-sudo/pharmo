import 'package:flutter/material.dart';
import 'package:school/CommonLogic/tabBar.dart';
import 'package:school/customWidgets/commonCustomWidget/commonMainInput.dart';
import 'package:school/customWidgets/pagesMainHeading.dart';

// Parent Community Page
class ParentCommunity extends StatefulWidget {
  const ParentCommunity({Key? key}) : super(key: key);

  @override
  State<ParentCommunity> createState() => _ParentCommunityState();
}

class _ParentCommunityState extends State<ParentCommunity>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _postController = TextEditingController();
  List<CommunityPost> posts = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeSamplePosts();
  }

  void _initializeSamplePosts() {
    posts = [
      CommunityPost(
        id: '1',
        authorName: 'Sarah Johnson',
        authorInitials: 'SJ',
        content: 'Great parent-teacher meeting today! Really impressed with the new curriculum changes. My daughter seems much more engaged in her studies.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        likes: 15,
        comments: 8,
        category: 'Academic',
        isLiked: false,
      ),
      CommunityPost(
        id: '2',
        authorName: 'Mike Davis',
        authorInitials: 'MD',
        content: 'Looking for carpooling partners for the upcoming field trip to the Science Museum. Anyone from the north side of town interested?',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        likes: 7,
        comments: 12,
        category: 'Events',
        isLiked: true,
      ),
      CommunityPost(
        id: '3',
        authorName: 'Lisa Chen',
        authorInitials: 'LC',
        content: 'Reminder: School fundraiser bake sale is this Saturday! Still need volunteers to help with setup. Please let me know if you can spare 2 hours.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        likes: 23,
        comments: 6,
        category: 'Volunteer',
        isLiked: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppThemeColor.primaryGradient,
        ),
        child: SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: AppThemeResponsiveness.getMaxWidth(context),
            ),
            child: Column(
              children: [
                // Header Section
                HeaderSection(
                  title: 'Parent Community',
                  icon: Icons.group_add,
                ),

                // Tab Bar
                CustomTabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Feed'),
                    Tab(text: 'Events'),
                    Tab(text: 'Resource'),
                  ],
                  getSpacing: AppThemeResponsiveness.getDefaultSpacing,
                  getBorderRadius: AppThemeResponsiveness.getInputBorderRadius,
                  getFontSize: AppThemeResponsiveness.getTabFontSize,
                  backgroundColor: AppThemeColor.blue50,
                  selectedColor: AppThemeColor.primaryBlue,
                  unselectedColor: AppThemeColor.blue600,
                ),

                SizedBox(height: AppThemeResponsiveness.getDefaultSpacing(context)),

                // Tab Bar View
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: AppThemeResponsiveness.getDefaultSpacing(context),
                    ),
                    decoration: BoxDecoration(
                      color: AppThemeColor.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
                        topRight: Radius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
                      ),
                    ),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildFeedTab(),
                        _buildEventsTab(),
                        _buildResourcesTab(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreatePostDialog,
        backgroundColor: AppThemeColor.primaryBlue,
        icon: const Icon(Icons.add, color: AppThemeColor.white),
        label: Text(
          'New Post',
          style: TextStyle(
            color: AppThemeColor.white,
            fontSize: AppThemeResponsiveness.isMobile(context) ? 14 : 16,
          ),
        ),
      ),
    );
  }

  Widget _buildFeedTab() {
    return Column(
      children: [
        // Quick Stats
        Container(
          padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard('Active Parents', '156', Icons.people, Colors.blue),
              ),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Expanded(
                child: _buildStatCard('This Week', '24', Icons.forum, Colors.green),
              ),
              SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
              Expanded(
                child: _buildStatCard('Events', '8', Icons.event, Colors.orange),
              ),
            ],
          ),
        ),

        // Posts List
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: AppThemeResponsiveness.getDefaultSpacing(context),
            ),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return _buildPostCard(posts[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEventsTab() {
    final events = [
      {
        'title': 'Parent-Teacher Conference',
        'date': 'March 15, 2024',
        'time': '9:00 AM - 5:00 PM',
        'location': 'School Auditorium',
        'type': 'Academic',
      },
      {
        'title': 'Spring Fundraiser',
        'date': 'March 22, 2024',
        'time': '6:00 PM - 9:00 PM',
        'location': 'School Gymnasium',
        'type': 'Fundraiser',
      },
      {
        'title': 'Family Fun Day',
        'date': 'April 5, 2024',
        'time': '10:00 AM - 4:00 PM',
        'location': 'School Grounds',
        'type': 'Social',
      },
    ];

    return ListView.builder(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return _buildEventCard(event);
      },
    );
  }

  Widget _buildResourcesTab() {
    final resources = [
      {
        'title': 'Parent Handbook 2024',
        'description': 'Complete guide for parents including policies and procedures',
        'type': 'PDF',
        'category': 'Policy',
      },
      {
        'title': 'Academic Calendar',
        'description': 'Important dates and holidays for the academic year',
        'type': 'Calendar',
        'category': 'Academic',
      },
      {
        'title': 'Homework Help Resources',
        'description': 'Online tools and websites to help with homework',
        'type': 'Links',
        'category': 'Academic',
      },
      {
        'title': 'Mental Health Support',
        'description': 'Resources for student and family mental health',
        'type': 'Guide',
        'category': 'Wellness',
      },
    ];

    return ListView.builder(
      padding: EdgeInsets.all(AppThemeResponsiveness.getDefaultSpacing(context)),
      itemCount: resources.length,
      itemBuilder: (context, index) {
        final resource = resources[index];
        return _buildResourceCard(resource);
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(AppThemeResponsiveness.getSmallSpacing(context)),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: AppThemeResponsiveness.getIconSize(context)),
          SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
          Text(
            value,
            style: TextStyle(
              fontSize: AppThemeResponsiveness.isMobile(context) ? 18 : 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: AppThemeResponsiveness.isMobile(context) ? 10 : 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(CommunityPost post) {
    return Card(
      margin: EdgeInsets.only(bottom: AppThemeResponsiveness.getDefaultSpacing(context)),
      elevation: AppThemeResponsiveness.getCardElevation(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: Padding(
        padding: AppThemeResponsiveness.getCardPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post Header
            Row(
              children: [
                CircleAvatar(
                  radius: AppThemeResponsiveness.isMobile(context) ? 20 : 24,
                  backgroundColor: AppThemeColor.primaryBlue.withOpacity(0.1),
                  child: Text(
                    post.authorInitials,
                    style: TextStyle(
                      color: AppThemeColor.primaryBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: AppThemeResponsiveness.isMobile(context) ? 14 : 16,
                    ),
                  ),
                ),
                SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: AppThemeResponsiveness.getDashboardCardTitleStyle(context),
                      ),
                      Text(
                        _formatPostTime(post.timestamp),
                        style: AppThemeResponsiveness.getCaptionTextStyle(context),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppThemeResponsiveness.getSmallSpacing(context),
                    vertical: AppThemeResponsiveness.getSmallSpacing(context) / 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(post.category).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    post.category,
                    style: TextStyle(
                      color: _getCategoryColor(post.category),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

            // Post Content
            Text(
              post.content,
              style: AppThemeResponsiveness.getBodyTextStyle(context),
            ),

            SizedBox(height: AppThemeResponsiveness.getMediumSpacing(context)),

            // Post Actions
            Row(
              children: [
                InkWell(
                  onTap: () => _toggleLike(post.id),
                  child: Row(
                    children: [
                      Icon(
                        post.isLiked ? Icons.favorite : Icons.favorite_border,
                        color: post.isLiked ? Colors.red : Colors.grey[600],
                        size: AppThemeResponsiveness.getIconSize(context) * 0.9,
                      ),
                      SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context) / 2),
                      Text(
                        '${post.likes}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
                Row(
                  children: [
                    Icon(
                      Icons.comment_outlined,
                      color: Colors.grey[600],
                      size: AppThemeResponsiveness.getIconSize(context) * 0.9,
                    ),
                    SizedBox(width: AppThemeResponsiveness.getSmallSpacing(context) / 2),
                    Text(
                      '${post.comments}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Icon(
                  Icons.share_outlined,
                  color: Colors.grey[600],
                  size: AppThemeResponsiveness.getIconSize(context) * 0.9,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(Map<String, String> event) {
    return Card(
      margin: EdgeInsets.only(bottom: AppThemeResponsiveness.getDefaultSpacing(context)),
      elevation: AppThemeResponsiveness.getCardElevation(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: Padding(
        padding: AppThemeResponsiveness.getCardPadding(context),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _getEventTypeColor(event['type']!).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getEventTypeIcon(event['type']!),
                color: _getEventTypeColor(event['type']!),
                size: AppThemeResponsiveness.getIconSize(context),
              ),
            ),
            SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event['title']!,
                    style: AppThemeResponsiveness.getDashboardCardTitleStyle(context),
                  ),
                  SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
                  Text(
                    event['date']!,
                    style: AppThemeResponsiveness.getBodyTextStyle(context).copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    event['time']!,
                    style: AppThemeResponsiveness.getCaptionTextStyle(context),
                  ),
                  Text(
                    event['location']!,
                    style: AppThemeResponsiveness.getCaptionTextStyle(context),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: AppThemeResponsiveness.getIconSize(context) * 0.8,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceCard(Map<String, String> resource) {
    return Card(
      margin: EdgeInsets.only(bottom: AppThemeResponsiveness.getDefaultSpacing(context)),
      elevation: AppThemeResponsiveness.getCardElevation(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeResponsiveness.getCardBorderRadius(context)),
      ),
      child: Padding(
        padding: AppThemeResponsiveness.getCardPadding(context),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _getResourceTypeColor(resource['type']!).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getResourceTypeIcon(resource['type']!),
                color: _getResourceTypeColor(resource['type']!),
                size: AppThemeResponsiveness.getIconSize(context) * 0.9,
              ),
            ),
            SizedBox(width: AppThemeResponsiveness.getMediumSpacing(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resource['title']!,
                    style: AppThemeResponsiveness.getDashboardCardTitleStyle(context),
                  ),
                  SizedBox(height: AppThemeResponsiveness.getSmallSpacing(context) / 2),
                  Text(
                    resource['description']!,
                    style: AppThemeResponsiveness.getCaptionTextStyle(context),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppThemeResponsiveness.getSmallSpacing(context),
                vertical: AppThemeResponsiveness.getSmallSpacing(context) / 2,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                resource['category']!,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreatePostDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create New Post'),
          content: TextField(
            controller: _postController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'What would you like to share with the community?',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_postController.text.trim().isNotEmpty) {
                  _createNewPost(_postController.text.trim());
                  _postController.clear();
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppThemeColor.primaryBlue,
              ),
              child: const Text('Post', style: TextStyle(color: AppThemeColor.white)),
            ),
          ],
        );
      },
    );
  }

  void _createNewPost(String content) {
    setState(() {
      posts.insert(
        0,
        CommunityPost(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          authorName: 'You',
          authorInitials: 'ME',
          content: content,
          timestamp: DateTime.now(),
          likes: 0,
          comments: 0,
          category: 'General',
          isLiked: false,
        ),
      );
    });
  }

  void _toggleLike(String postId) {
    setState(() {
      final postIndex = posts.indexWhere((post) => post.id == postId);
      if (postIndex != -1) {
        posts[postIndex] = posts[postIndex].copyWith(
          isLiked: !posts[postIndex].isLiked,
          likes: posts[postIndex].isLiked
              ? posts[postIndex].likes - 1
              : posts[postIndex].likes + 1,
        );
      }
    });
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Academic':
        return Colors.blue;
      case 'Events':
        return Colors.green;
      case 'Volunteer':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getEventTypeColor(String type) {
    switch (type) {
      case 'Academic':
        return Colors.blue;
      case 'Fundraiser':
        return Colors.green;
      case 'Social':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getEventTypeIcon(String type) {
    switch (type) {
      case 'Academic':
        return Icons.school;
      case 'Fundraiser':
        return Icons.attach_money;
      case 'Social':
        return Icons.people;
      default:
        return Icons.event;
    }
  }

  Color _getResourceTypeColor(String type) {
    switch (type) {
      case 'PDF':
        return Colors.red;
      case 'Calendar':
        return Colors.blue;
      case 'Links':
        return Colors.green;
      case 'Guide':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getResourceTypeIcon(String type) {
    switch (type) {
      case 'PDF':
        return Icons.picture_as_pdf;
      case 'Calendar':
        return Icons.calendar_today;
      case 'Links':
        return Icons.link;
      case 'Guide':
        return Icons.book;
      default:
        return Icons.description;
    }
  }

  String _formatPostTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _postController.dispose();
    super.dispose();
  }
}

// Community Post Model
class CommunityPost {
  final String id;
  final String authorName;
  final String authorInitials;
  final String content;
  final DateTime timestamp;
  final int likes;
  final int comments;
  final String category;
  final bool isLiked;

  CommunityPost({
    required this.id,
    required this.authorName,
    required this.authorInitials,
    required this.content,
    required this.timestamp,
    required this.likes,
    required this.comments,
    required this.category,
    required this.isLiked,
  });

  CommunityPost copyWith({
    String? id,
    String? authorName,
    String? authorInitials,
    String? content,
    DateTime? timestamp,
    int? likes,
    int? comments,
    String? category,
    bool? isLiked,
  }) {
    return CommunityPost(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      authorInitials: authorInitials ?? this.authorInitials,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      category: category ?? this.category,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}