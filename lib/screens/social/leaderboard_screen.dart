import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/helpers.dart';
import '../../providers/social_provider.dart';
import '../../providers/auth_provider.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SocialProvider>().loadLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    final socialProvider = context.watch<SocialProvider>();
    final uid = context.read<AuthProvider>().uid;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.weeklyRanking)),
      body: socialProvider.leaderboard.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(AppDimensions.paddingMD),
              itemCount: socialProvider.leaderboard.length,
              itemBuilder: (context, index) {
                final user = socialProvider.leaderboard[index];
                final isMe = user.uid == uid;
                final rank = index + 1;

                return Card(
                  color: isMe
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : null,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: SizedBox(
                      width: 40,
                      child: Center(
                        child: rank <= 3
                            ? Text(
                                ['🥇', '🥈', '🥉'][rank - 1],
                                style: const TextStyle(fontSize: 24),
                              )
                            : Text(
                                '#$rank',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                      ),
                    ),
                    title: Text(
                      '${user.displayName}${isMe ? ' (You)' : ''}',
                      style: TextStyle(
                        fontWeight: isMe ? FontWeight.w900 : FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      'Level ${user.level} \u2022 ${Helpers.levelTitle(user.level)}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${user.totalXp}',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'XP',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
