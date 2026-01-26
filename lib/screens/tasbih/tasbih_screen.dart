import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
import '../../providers/tasbih_provider.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TasbihProvider>().loadSettings();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTap() {
    final provider = context.read<TasbihProvider>();
    final previousLapCount = provider.lapCount;

    // Animate
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    // Vibrate if enabled
    if (provider.vibrationEnabled) {
      HapticFeedback.lightImpact();
    }

    // Increment
    provider.increment();

    // Check if lap completed (lap count increased)
    if (provider.lapCount > previousLapCount) {
      HapticFeedback.heavyImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          context.tr('tasbih_counter'),
          style: TextStyle(fontSize: responsive.textLarge),
        ),
      ),
      body: Consumer<TasbihProvider>(
        builder: (context, provider, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withValues(alpha: 0.1),
                  Colors.white,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: _buildCounterButton(provider),
                  ),
                  // Reset Button
                  Padding(
                    padding: EdgeInsets.only(bottom: responsive.spacing(30)),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(context.tr('reset_counter')),
                            content: Text(context.tr('reset_counter_message')),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(context.tr('cancel')),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  provider.reset();
                                  Navigator.pop(context);
                                },
                                child: Text(context.tr('reset')),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        padding: responsive.paddingSymmetric(horizontal: 32, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(responsive.spacing(30)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.refresh,
                              color: AppColors.primary,
                              size: responsive.iconMedium,
                            ),
                            SizedBox(width: responsive.spaceSmall),
                            Text(
                              context.tr('reset'),
                              style: TextStyle(
                                fontSize: responsive.textRegular,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildCounterButton(TasbihProvider provider) {
    final responsive = context.responsive;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lap Counter
          Container(
            padding: responsive.paddingSymmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(responsive.radiusXLarge),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.repeat,
                  color: Colors.white,
                  size: responsive.iconSmall,
                ),
                SizedBox(width: responsive.spaceSmall),
                Text(
                  '${provider.lapCount}',
                  style: TextStyle(
                    fontSize: responsive.textXXLarge,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: responsive.spaceLarge),

          // Main Counter with +/- buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Decrement Button
              GestureDetector(
                onTap: () {
                  if (provider.vibrationEnabled) {
                    HapticFeedback.lightImpact();
                  }
                  provider.decrement();
                },
                child: Container(
                  width: responsive.spacing(60),
                  height: responsive.spacing(60),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: responsive.spacing(10),
                        offset: Offset(0, responsive.spacing(4)),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.remove,
                    size: responsive.iconXLarge,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(width: responsive.spaceXLarge),

              // Main Counter Button
              GestureDetector(
                onTap: _onTap,
                child: AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        width: responsive.spacing(180),
                        height: responsive.spacing(180),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.headerGradient,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: responsive.spacing(30),
                              offset: Offset(0, responsive.spacing(10)),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${provider.count}',
                              style: TextStyle(
                                fontSize: responsive.fontSize(56),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              context.tr('tap'),
                              style: TextStyle(
                                fontSize: responsive.textSmall,
                                color: Colors.white70,
                                letterSpacing: 4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: responsive.spaceXLarge),

              // Increment Button
              GestureDetector(
                onTap: _onTap,
                child: Container(
                  width: responsive.spacing(60),
                  height: responsive.spacing(60),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: responsive.spacing(10),
                        offset: Offset(0, responsive.spacing(4)),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.add,
                    size: responsive.iconXLarge,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
