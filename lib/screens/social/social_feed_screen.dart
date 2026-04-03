import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/helpers.dart';
import '../../models/session_model.dart';
import '../../models/user_model.dart';
import '../../providers/social_provider.dart';
import '../../providers/auth_provider.dart';
import 'leaderboard_screen.dart';
import 'friend_island_screen.dart';

class SocialFeedScreen extends StatefulWidget {
  const SocialFeedScreen({super.key});

  @override
  State<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends State<SocialFeedScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final uid = context.read<AuthProvider>().uid;
    if (uid.isNotEmpty) {
      await context.read<SocialProvider>().loadFeed(uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final socialProvider = context.watch<SocialProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.socialFeed),
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard_rounded),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person_add_rounded),
            onPressed: () => _showAddFriendDialog(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: socialProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : socialProvider.feedItems.isEmpty
                ? _EmptyFeed()
                : ListView.builder(
                    padding: const EdgeInsets.all(AppDimensions.paddingMD),
                    itemCount: socialProvider.feedItems.length,
                    itemBuilder: (context, index) {
                      final item = socialProvider.feedItems[index];
                      final session = item['session'] as SessionModel;
                      final user = item['user'] as UserModel?;

                      return _FeedCard(
                        displayName: user?.displayName ?? 'Unknown',
                        photoUrl: user?.photoUrl,
                        session: session,
                        onTapIsland: user != null
                            ? () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => FriendIslandScreen(
                                      userId: user.uid,
                                      displayName: user.displayName,
                                    ),
                                  ),
                                )
                            : null,
                      );
                    },
                  ),
      ),
    );
  }

  void _showAddFriendDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.addFriend),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (q) =>
                  dialogContext.read<SocialProvider>().searchUsers(q),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: Consumer<SocialProvider>(
                builder: (_, social, __) {
                  if (social.searchResults.isEmpty) {
                    return const Center(
                      child: Text('Search for friends by name'),
                    );
                  }
                  return ListView.builder(
                    itemCount: social.searchResults.length,
                    itemBuilder: (_, i) {
                      final user = social.searchResults[i];
                      final uid = context.read<AuthProvider>().uid;
                      final isSelf = user.uid == uid;
                      final isFriend =
                          social.friendIds.contains(user.uid);

                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(user.displayName[0].toUpperCase()),
                        ),
                        title: Text(user.displayName),
                        trailing: isSelf
                            ? const Text('You')
                            : isFriend
                                ? const Icon(Icons.check,
                                    color: AppColors.primary)
                                : IconButton(
                                    icon: const Icon(
                                        Icons.person_add_rounded),
                                    onPressed: () {
                                      social.sendFriendRequest(
                                          uid, user.uid);
                                      Navigator.pop(dialogContext);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Friend request sent!'),
                                          backgroundColor:
                                              AppColors.primary,
                                        ),
                                      );
                                    },
                                  ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _EmptyFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🏝️', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              'No activity yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add friends to see their focus sessions and islands!',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedCard extends StatelessWidget {
  final String displayName;
  final String? photoUrl;
  final SessionModel session;
  final VoidCallback? onTapIsland;

  const _FeedCard({
    required this.displayName,
    this.photoUrl,
    required this.session,
    this.onTapIsland,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    displayName[0].toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        Helpers.timeAgo(session.completedAt ?? session.startedAt),
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onTapIsland != null)
                  TextButton.icon(
                    onPressed: onTapIsland,
                    icon: const Icon(Icons.landscape_rounded, size: 16),
                    label: const Text('Island'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.secondary,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded,
                      color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Completed a ${session.actualMinutes}min ${session.typeLabel} session',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Text(
                    '+${session.xpEarned} XP',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
