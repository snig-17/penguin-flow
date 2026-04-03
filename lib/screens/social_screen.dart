import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.paddingMedium,
                AppDimensions.paddingMedium,
                AppDimensions.paddingMedium,
                0,
              ),
              child: Text(
                'Community',
                style: textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            // Toggle tabs
            _buildTabs(textTheme),
            const SizedBox(height: AppDimensions.paddingSmall),
            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildFeedTab(textTheme),
                  _buildFriendsTab(textTheme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs(TextTheme textTheme) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
      ),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: AppColors.textPrimary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        unselectedLabelStyle: textTheme.titleMedium,
        tabs: const [
          Tab(text: 'Feed'),
          Tab(text: 'Friends'),
        ],
      ),
    );
  }

  Widget _buildFeedTab(TextTheme textTheme) {
    final posts = _samplePosts();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
        vertical: AppDimensions.paddingSmall,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return _buildPostCard(post, textTheme);
      },
    );
  }

  Widget _buildPostCard(_FeedPost post, TextTheme textTheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User row
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: post.avatarColor,
                child: Text(
                  post.userName[0],
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.paddingSmall),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.userName, style: textTheme.titleMedium),
                    Text(
                      post.timeAgo,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_horiz),
                color: AppColors.textSecondary,
                iconSize: 20,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
          // Post text
          Text(post.text, style: textTheme.bodyMedium),
          const SizedBox(height: AppDimensions.paddingSmall),
          // Stats tag
          if (post.statsTag != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusCircular),
              ),
              child: Text(
                post.statsTag!,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(height: AppDimensions.paddingSmall),
          // Like / Comment row
          Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    const Icon(Icons.favorite_border,
                        size: 18, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '${post.likes}',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.paddingMedium),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    const Icon(Icons.chat_bubble_outline,
                        size: 18, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '${post.comments}',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFriendsTab(TextTheme textTheme) {
    final friends = _sampleFriends();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMedium,
        vertical: AppDimensions.paddingSmall,
      ),
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        return Container(
          margin: const EdgeInsets.only(bottom: AppDimensions.paddingSmall),
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: friend.avatarColor,
                    child: Text(
                      friend.name[0],
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: friend.isOnline
                            ? AppColors.online
                            : AppColors.offline,
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: AppColors.surface, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: AppDimensions.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(friend.name, style: textTheme.titleMedium),
                    Text(
                      'Level ${friend.level} - ${friend.streak} day streak',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.secondary,
                  side: const BorderSide(
                      color: AppColors.secondary, width: 1.5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusLarge),
                  ),
                ),
                child: const Text('Visit'),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- Sample data ---

  List<_FeedPost> _samplePosts() => [
        _FeedPost(
          userName: 'Alice',
          avatarColor: AppColors.secondary,
          timeAgo: '10 min ago',
          text:
              'Just completed a 90-minute deep work session! Feeling super productive today.',
          statsTag: '90 min focused - 200 XP earned',
          likes: 12,
          comments: 3,
        ),
        _FeedPost(
          userName: 'Bob',
          avatarColor: AppColors.primary,
          timeAgo: '1h ago',
          text:
              'Reached a 30-day streak! Consistency really does pay off.',
          statsTag: '30 day streak',
          likes: 24,
          comments: 7,
        ),
        _FeedPost(
          userName: 'Charlie',
          avatarColor: AppColors.accent,
          timeAgo: '3h ago',
          text:
              'My island just leveled up to level 15! Check out the new lighthouse.',
          statsTag: null,
          likes: 8,
          comments: 2,
        ),
      ];

  List<_FriendItem> _sampleFriends() => [
        _FriendItem('Alice', AppColors.secondary, true, 12, 30),
        _FriendItem('Bob', AppColors.primary, true, 8, 14),
        _FriendItem('Charlie', AppColors.accent, false, 15, 45),
        _FriendItem('Diana', AppColors.level, true, 6, 7),
        _FriendItem('Eve', AppColors.streak, false, 3, 2),
      ];
}

class _FeedPost {
  final String userName;
  final Color avatarColor;
  final String timeAgo;
  final String text;
  final String? statsTag;
  final int likes;
  final int comments;

  _FeedPost({
    required this.userName,
    required this.avatarColor,
    required this.timeAgo,
    required this.text,
    required this.statsTag,
    required this.likes,
    required this.comments,
  });
}

class _FriendItem {
  final String name;
  final Color avatarColor;
  final bool isOnline;
  final int level;
  final int streak;

  _FriendItem(this.name, this.avatarColor, this.isOnline, this.level, this.streak);
}
