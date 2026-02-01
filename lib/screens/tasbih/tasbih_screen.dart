import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/tasbih_provider.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  FlutterTts? _flutterTts;
  bool _ttsInitialized = false;

  @override
  void initState() {
    super.initState();
    _initTts();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final provider = context.read<TasbihProvider>();
        provider.loadSettings();
        provider.loadHistory();
      }
    });
  }

  Future<void> _initTts() async {
    try {
      _flutterTts = FlutterTts();
      final tts = _flutterTts;
      if (tts == null) return;

      // iOS specific settings
      await tts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
        ],
        IosTextToSpeechAudioMode.voicePrompt,
      );

      await tts.setLanguage('en-US');
      await tts.setSpeechRate(0.6);
      await tts.setVolume(1.0);
      await tts.setPitch(1.0);
      await tts.awaitSpeakCompletion(false);

      if (mounted) {
        setState(() {
          _ttsInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('TTS initialization error: $e');
    }
  }

  @override
  void dispose() {
    _flutterTts?.stop();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    final tts = _flutterTts;
    if (!_ttsInitialized || tts == null || !mounted) {
      return;
    }
    final provider = context.read<TasbihProvider>();
    if (provider.soundEnabled) {
      // Stop any ongoing speech before speaking new text
      await tts.stop();
      await tts.speak(text);
    }
  }

  void _onIncrement() {
    final provider = context.read<TasbihProvider>();
    final previousLapCount = provider.lapCount;

    if (provider.vibrationEnabled) {
      HapticFeedback.lightImpact();
    }

    provider.increment();

    if (provider.lapCount > previousLapCount) {
      HapticFeedback.heavyImpact();
      _speak('1 Tasbih complete');
    } else {
      _speak('${provider.count}');
    }
  }

  void _onDecrement() {
    final provider = context.read<TasbihProvider>();

    if (provider.vibrationEnabled) {
      HapticFeedback.lightImpact();
    }

    provider.decrement();
    _speak('${provider.count}');
  }

  void _showAddNoteDialog() {
    final noteController = TextEditingController();
    final countController = TextEditingController(text: '0');
    final lang = context.languageProvider;
    final addNoteText = lang.translate('add_note');
    final noteHintText = lang.translate('enter_note');
    final countText = lang.translate('count');
    final cancelText = lang.translate('cancel');
    final saveText = lang.translate('save');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(addNoteText),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                hintText: noteHintText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: countController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: countText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () {
              if (noteController.text.trim().isNotEmpty) {
                final count = int.tryParse(countController.text) ?? 0;
                context.read<TasbihProvider>().addNoteToHistoryWithCount(
                  noteController.text.trim(),
                  count,
                );
                Navigator.pop(dialogContext);
              }
            },
            child: Text(saveText),
          ),
        ],
      ),
    );
  }

  void _showEditCountDialog(int index, TasbihHistoryItem item) {
    final countController = TextEditingController(text: item.count.toString());
    final lapsController = TextEditingController(text: item.laps.toString());
    final lang = context.languageProvider;
    final editCountText = lang.translate('edit_count');
    final countText = lang.translate('count');
    final lapsText = lang.translate('laps');
    final cancelText = lang.translate('cancel');
    final saveText = lang.translate('save');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(editCountText),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: countController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: countText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: lapsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: lapsText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () {
              final newCount = int.tryParse(countController.text) ?? item.count;
              final newLaps = int.tryParse(lapsController.text) ?? item.laps;
              context.read<TasbihProvider>().editHistoryCount(
                index,
                newCount,
                newLaps,
              );
              Navigator.pop(dialogContext);
            },
            child: Text(saveText),
          ),
        ],
      ),
    );
  }

  void _showEditNoteDialog(int index, TasbihHistoryItem item) {
    final noteController = TextEditingController(text: item.notes ?? '');
    final countController = TextEditingController(text: item.count.toString());
    final lang = context.languageProvider;
    final editNoteText = lang.translate('edit_note');
    final noteHintText = lang.translate('enter_note');
    final countText = lang.translate('count');
    final cancelText = lang.translate('cancel');
    final saveText = lang.translate('save');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(editNoteText),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                hintText: noteHintText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: countController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: countText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () {
              final newCount = int.tryParse(countController.text) ?? item.count;
              context.read<TasbihProvider>().editHistoryItemWithCount(
                index,
                noteController.text.trim(),
                newCount,
              );
              Navigator.pop(dialogContext);
            },
            child: Text(saveText),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(int index) {
    final lang = context.languageProvider;
    final deleteText = lang.translate('delete');
    final deleteConfirmText = lang.translate('delete_confirm');
    final cancelText = lang.translate('cancel');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(deleteText),
        content: Text(deleteConfirmText),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(cancelText),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<TasbihProvider>().deleteHistoryItem(index);
              Navigator.pop(dialogContext);
            },
            child: Text(
              deleteText,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
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
        actions: [
          Consumer<TasbihProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: Icon(
                  provider.soundEnabled ? Icons.volume_up : Icons.volume_off,
                ),
                onPressed: () {
                  provider.setSoundEnabled(!provider.soundEnabled);
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<TasbihProvider>(
        builder: (context, provider, child) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Counter Section
                  _buildCounterButton(provider),
                  SizedBox(height: responsive.spacing(40)),
                  // Action Buttons Row (Reset & Add Note)
                  Padding(
                    padding: responsive.paddingSymmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        // Reset Button
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.refresh,
                            label: context.tr('reset'),
                            borderColor: AppColors.primary,
                            onTap: () {
                              final lang = context.languageProvider;
                              final resetText = lang.translate('reset_counter');
                              final resetMessageText = lang.translate(
                                'reset_counter_message',
                              );
                              final cancelText = lang.translate('cancel');
                              final resetBtnText = lang.translate('reset');

                              showDialog(
                                context: context,
                                builder: (dialogContext) => AlertDialog(
                                  title: Text(resetText),
                                  content: Text(resetMessageText),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(dialogContext),
                                      child: Text(cancelText),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        provider.reset();
                                        Navigator.pop(dialogContext);
                                      },
                                      child: Text(resetBtnText),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        responsive.hSpaceMedium,
                        // Add Note Button
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.edit_note,
                            label: context.tr('add_note'),
                            borderColor: AppColors.secondary,
                            onTap: _showAddNoteDialog,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: responsive.spacing(10)),

                  // History Section
                  _buildHistorySection(provider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    final responsive = context.responsive;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: responsive.paddingSymmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(responsive.spacing(30)),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: borderColor, size: responsive.iconSmall),
            responsive.hSpaceSmall,
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: responsive.textRegular,
                  fontWeight: FontWeight.w600,
                  color: borderColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterButton(TasbihProvider provider) {
    final responsive = context.responsive;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: responsive.spacing(30)),

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
                responsive.hSpaceSmall,
                Text(
                  '${provider.lapCount}',
                  style: TextStyle(
                    fontSize: responsive.fontSize(28),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: responsive.spacing(130)),

          // Main Counter with +/- buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Decrement Button
              GestureDetector(
                onTap: _onDecrement,
                child: Container(
                  width: responsive.spacing(80),
                  height: responsive.spacing(80),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: AppColors.primary, width: 2),
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
                    size: responsive.fontSize(32),
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(width: responsive.spacing(24)),

              // Main Counter Display (non-tappable)
              Container(
                width: responsive.spacing(140),
                height: responsive.spacing(140),
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
                child: Center(
                  child: Text(
                    '${provider.count}',
                    style: TextStyle(
                      fontSize: responsive.fontSize(48),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: responsive.spacing(24)),

              // Increment Button
              GestureDetector(
                onTap: _onIncrement,
                child: Container(
                  width: responsive.spacing(80),
                  height: responsive.spacing(80),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: AppColors.primary, width: 2),
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
                    size: responsive.fontSize(32),
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          responsive.vSpaceMedium,
        ],
      ),
    );
  }

  Widget _buildHistorySection(TasbihProvider provider) {
    final responsive = context.responsive;

    // Pre-store translations to avoid Provider errors in callbacks
    final noHistoryText = context.tr('no_history');
    final historyText = context.tr('history');

    if (provider.history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: responsive.iconXLarge,
              color: AppColors.textSecondary,
            ),
            responsive.vSpaceSmall,
            Text(
              noHistoryText,
              style: TextStyle(
                fontSize: responsive.textRegular,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: responsive.paddingSymmetric(horizontal: 16),
          child: Text(
            historyText,
            style: TextStyle(
              fontSize: responsive.textLarge,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(height: responsive.spacing(10)),

        Padding(
          padding: responsive.paddingSymmetric(horizontal: 16),
          child: Column(
            children: provider.history.asMap().entries.map((entry) {
              return _buildHistoryCard(entry.value, entry.key);
            }).toList(),
          ),
        ),
        SizedBox(height: responsive.spacing(20)),
      ],
    );
  }

  Widget _buildHistoryCard(TasbihHistoryItem item, int index) {
    final responsive = context.responsive;
    final isNote = item.dhikr == 'Note' && item.notes != null;

    return Container(
      margin: EdgeInsets.only(bottom: responsive.spacing(10)),
      padding: responsive.paddingAll(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusMedium),
        border: Border.all(color: AppColors.primary, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: isNote
                    ? Row(
                        children: [
                          const Text('📝 ', style: TextStyle(fontSize: 16)),
                          Flexible(
                            child: Text(
                              context.tr('note_label'),
                              style: TextStyle(
                                fontSize: responsive.textRegular,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (item.count > 0) ...[
                            responsive.hSpaceSmall,
                            Container(
                              padding: responsive.paddingSymmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${item.count}',
                                style: TextStyle(
                                  fontSize: responsive.textSmall,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      )
                    : Text(
                        item.dhikr,
                        style: TextStyle(
                          fontSize: responsive.textRegular,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
              // Edit button
              GestureDetector(
                onTap: () {
                  if (isNote) {
                    _showEditNoteDialog(index, item);
                  } else {
                    _showEditCountDialog(index, item);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(responsive.spacing(6)),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.edit,
                    size: responsive.iconSmall,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(width: responsive.spacing(8)),
              // Delete button
              GestureDetector(
                onTap: () => _showDeleteConfirmDialog(index),
                child: Container(
                  padding: EdgeInsets.all(responsive.spacing(6)),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    size: responsive.iconSmall,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.spacing(6)),
          if (isNote)
            Container(
              width: double.infinity,
              padding: responsive.paddingAll(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(responsive.radiusMedium),
              ),
              child: Text(
                item.notes!,
                style: TextStyle(
                  fontSize: responsive.textSmall,
                  color: AppColors.textPrimary,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            )
          else
            Row(
              children: [
                Flexible(
                  child: _buildStatBadge(
                    context.tr('count'),
                    '${item.count}',
                    AppColors.primary,
                  ),
                ),
                responsive.hSpaceSmall,
                Flexible(
                  child: _buildStatBadge(
                    context.tr('laps'),
                    '${item.laps}',
                    AppColors.secondary,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStatBadge(String label, String value, Color color) {
    final responsive = context.responsive;

    return Container(
      padding: responsive.paddingSymmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(responsive.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              '$label: ',
              style: TextStyle(fontSize: responsive.textSmall, color: color),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: responsive.textSmall,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
