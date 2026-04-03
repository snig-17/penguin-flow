import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../models/island_model.dart';
import '../../providers/social_provider.dart';

class FriendIslandScreen extends StatefulWidget {
  final String userId;
  final String displayName;

  const FriendIslandScreen({
    super.key,
    required this.userId,
    required this.displayName,
  });

  @override
  State<FriendIslandScreen> createState() => _FriendIslandScreenState();
}

class _FriendIslandScreenState extends State<FriendIslandScreen> {
  IslandModel? _island;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadIsland();
  }

  Future<void> _loadIsland() async {
    final island =
        await context.read<SocialProvider>().getFriendIsland(widget.userId);
    if (mounted) {
      setState(() {
        _island = island;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.displayName}'s Island"),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _island == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🏝️', style: TextStyle(fontSize: 64)),
                      const SizedBox(height: 16),
                      Text(
                        '${widget.displayName} hasn\'t built their island yet!',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    // Background
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: _themeGradient(_island!.theme),
                        ),
                      ),
                    ),

                    // Island
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: MediaQuery.of(context).size.width * 0.85,
                        decoration: BoxDecoration(
                          color: _groundColor(_island!.theme),
                          borderRadius: BorderRadius.circular(200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            ..._island!.buildings.map((b) => Positioned(
                                  left: b.x *
                                      MediaQuery.of(context).size.width *
                                      0.85 -
                                      30,
                                  top: b.y *
                                      MediaQuery.of(context).size.width *
                                      0.85 -
                                      30,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(b.emoji,
                                          style: const TextStyle(
                                              fontSize: 36)),
                                      Text(b.name,
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                )),
                            ..._island!.decorations.map((d) => Positioned(
                                  left: d.x *
                                      MediaQuery.of(context).size.width *
                                      0.85 -
                                      15,
                                  top: d.y *
                                      MediaQuery.of(context).size.width *
                                      0.85 -
                                      15,
                                  child: Text(d.emoji,
                                      style: const TextStyle(fontSize: 24)),
                                )),
                          ],
                        ),
                      ),
                    ),

                    // Info card
                    Positioned(
                      bottom: 24,
                      left: 16,
                      right: 16,
                      child: Card(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(AppDimensions.paddingMD),
                          child: Row(
                            children: [
                              const Text('🏝️',
                                  style: TextStyle(fontSize: 28)),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _island!.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    '${_island!.buildings.length} buildings \u2022 ${_island!.decorations.length} decorations',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  List<Color> _themeGradient(IslandTheme theme) => switch (theme) {
        IslandTheme.tropical => [
            const Color(0xFF87CEEB),
            AppColors.tropicalWater
          ],
        IslandTheme.arctic => [
            const Color(0xFFE3F2FD),
            AppColors.arcticWater
          ],
        IslandTheme.volcanic => [
            const Color(0xFF37474F),
            const Color(0xFF263238)
          ],
        IslandTheme.forest => [
            const Color(0xFF81C784),
            const Color(0xFF388E3C)
          ],
      };

  Color _groundColor(IslandTheme theme) => switch (theme) {
        IslandTheme.tropical => AppColors.tropicalSand,
        IslandTheme.arctic => AppColors.arcticIce,
        IslandTheme.volcanic => AppColors.volcanicRock,
        IslandTheme.forest => AppColors.forestGround,
      };
}
