import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../core/constants/app_colors.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  // Predefined Q&A database for Islamic knowledge
  final Map<String, String> _knowledgeBase = {
    // Pillars of Islam
    'pillars of islam': 'The Five Pillars of Islam are:\n\n1. **Shahada** (Declaration of Faith) - Testifying that there is no god but Allah and Muhammad ﷺ is His messenger\n\n2. **Salah** (Prayer) - Performing the five daily prayers\n\n3. **Zakat** (Charity) - Giving 2.5% of savings to those in need\n\n4. **Sawm** (Fasting) - Fasting during the month of Ramadan\n\n5. **Hajj** (Pilgrimage) - Making pilgrimage to Makkah at least once if able',

    'five pillars': 'The Five Pillars of Islam are:\n\n1. **Shahada** (Declaration of Faith) - Testifying that there is no god but Allah and Muhammad ﷺ is His messenger\n\n2. **Salah** (Prayer) - Performing the five daily prayers\n\n3. **Zakat** (Charity) - Giving 2.5% of savings to those in need\n\n4. **Sawm** (Fasting) - Fasting during the month of Ramadan\n\n5. **Hajj** (Pilgrimage) - Making pilgrimage to Makkah at least once if able',

    // Prayer
    'how to pray': 'To perform Salah (prayer):\n\n1. Make Wudu (ablution)\n2. Face the Qibla (direction of Kaaba)\n3. Make intention (Niyyah)\n4. Say "Allahu Akbar" (Takbir)\n5. Recite Al-Fatiha and another Surah\n6. Perform Ruku (bowing)\n7. Stand up (Qiyam)\n8. Perform Sujud (prostration) twice\n9. Complete the required Rakats\n10. End with Tashahhud and Salam\n\nEach prayer has a specific number of Rakats.',

    'prayer times': 'The five daily prayers are:\n\n1. **Fajr** - Dawn prayer (2 Rakats)\n2. **Dhuhr** - Noon prayer (4 Rakats)\n3. **Asr** - Afternoon prayer (4 Rakats)\n4. **Maghrib** - Sunset prayer (3 Rakats)\n5. **Isha** - Night prayer (4 Rakats)\n\nPrayer times vary based on your location and the position of the sun.',

    'wudu': 'Steps of Wudu (Ablution):\n\n1. Make intention (Niyyah)\n2. Say "Bismillah"\n3. Wash hands 3 times\n4. Rinse mouth 3 times\n5. Clean nose 3 times\n6. Wash face 3 times\n7. Wash arms up to elbows 3 times\n8. Wipe head once\n9. Clean ears once\n10. Wash feet up to ankles 3 times\n\nAlways use clean water and wash right side first.',

    // Ramadan & Fasting
    'ramadan': 'Ramadan is the ninth month of the Islamic calendar. It is a month of:\n\n• **Fasting** from dawn to sunset\n• **Increased worship** and Quran recitation\n• **Night prayers** (Taraweeh)\n• **Charity** and good deeds\n• **Self-reflection** and spiritual growth\n\nThe Night of Power (Laylatul Qadr) occurs in the last ten nights and is better than a thousand months.',

    'fasting': 'Fasting (Sawm) in Islam:\n\n**Rules:**\n• Abstain from food, drink, and marital relations from dawn to sunset\n• Make intention before Fajr\n• Break fast at Maghrib time\n\n**Exemptions:**\n• Illness\n• Pregnancy/nursing\n• Traveling\n• Elderly who cannot fast\n\n**Benefits:**\n• Spiritual purification\n• Self-discipline\n• Empathy for the needy\n• Physical detoxification',

    // Zakat
    'zakat': 'Zakat (Obligatory Charity):\n\n**Calculation:**\n• 2.5% of wealth held for one lunar year\n• Applies when wealth exceeds Nisab threshold\n\n**Nisab (minimum threshold):**\n• Gold: 87.48 grams\n• Silver: 612.36 grams\n\n**Who receives Zakat:**\n1. The poor\n2. The needy\n3. Zakat administrators\n4. Those whose hearts need softening\n5. Freeing slaves\n6. Those in debt\n7. In the cause of Allah\n8. Travelers in need',

    // Hajj
    'hajj': 'Hajj is the pilgrimage to Makkah, obligatory once in a lifetime for those who are physically and financially able.\n\n**Main rituals:**\n1. Ihram (sacred state)\n2. Tawaf (circling Kaaba 7 times)\n3. Sa\'i (walking between Safa and Marwa)\n4. Standing at Arafat\n5. Muzdalifah (collecting pebbles)\n6. Stoning the Jamarat\n7. Sacrifice (Qurbani)\n8. Farewell Tawaf\n\nHajj occurs from 8-12 Dhul Hijjah.',

    // Quran
    'quran': 'The Holy Quran is the final revelation from Allah to mankind through Prophet Muhammad ﷺ.\n\n**Facts:**\n• 114 Surahs (chapters)\n• 6,236 verses (ayat)\n• Revealed over 23 years\n• Preserved in original Arabic\n• Guidance for all humanity\n\n**Benefits of recitation:**\n• Spiritual reward\n• Peace of heart\n• Guidance in life\n• Intercession on Day of Judgment',

    // Prophet Muhammad
    'prophet muhammad': 'Prophet Muhammad ﷺ (570-632 CE):\n\n• Born in Makkah\n• Received first revelation at age 40\n• Known as "Al-Amin" (The Trustworthy)\n• Migrated to Madinah (Hijrah) in 622 CE\n• Final Prophet sent to all mankind\n• His life (Sunnah) is a perfect example\n• His sayings (Hadith) guide Muslims\n\nPeace and blessings be upon him.',

    // Allah
    'allah': 'Allah is the Arabic word for God - the One and Only Creator.\n\n**Key beliefs:**\n• Allah is One (Tawhid)\n• He has no partners or equals\n• He is the Most Merciful\n• He has 99 Beautiful Names\n• He created everything\n• He knows all things\n• He is Ever-Living\n• He hears all prayers\n\n"Say: He is Allah, the One. Allah, the Eternal Refuge." (Quran 112:1-2)',

    // 99 names
    '99 names': 'Allah has 99 Beautiful Names (Asma ul-Husna). Some include:\n\n• **Ar-Rahman** - The Most Merciful\n• **Ar-Rahim** - The Most Compassionate\n• **Al-Malik** - The King\n• **Al-Quddus** - The Holy\n• **As-Salam** - The Source of Peace\n• **Al-Khaliq** - The Creator\n• **Al-Ghaffar** - The Forgiver\n• **Al-Wadud** - The Loving\n• **Al-Hakeem** - The Wise\n\nThe Prophet ﷺ said: "Allah has 99 names. Whoever memorizes them will enter Paradise."',

    // General Islamic topics
    'halal': 'Halal means "permissible" in Islam.\n\n**Halal food requirements:**\n• Animal must be slaughtered in Allah\'s name\n• Blood must be drained\n• No pork or pork products\n• No alcohol\n• No carnivorous animals\n\n**Beyond food, Halal includes:**\n• Honest business dealings\n• Clean earnings\n• Modest clothing\n• Respectful behavior',

    'haram': 'Haram means "forbidden" in Islam.\n\n**Major prohibitions include:**\n• Shirk (associating partners with Allah)\n• Murder\n• Theft\n• Adultery/Fornication\n• Consuming alcohol/intoxicants\n• Eating pork\n• Gambling\n• Interest (Riba)\n• Backbiting\n• Lying\n\nAvoiding Haram brings blessings and protects from harm.',

    'dua': 'Dua is supplication/prayer to Allah.\n\n**Best times for Dua:**\n• Last third of the night\n• Between Adhan and Iqamah\n• While fasting, before breaking fast\n• On Fridays\n• While prostrating\n• While traveling\n\n**Etiquette:**\n• Face the Qibla\n• Raise hands\n• Begin with praise of Allah\n• Send blessings on the Prophet ﷺ\n• Be sincere and humble\n• Have certainty Allah will answer',

    'jannah': 'Jannah (Paradise) is the eternal reward for believers.\n\n**Description:**\n• Rivers of milk, honey, and pure water\n• Beautiful gardens and palaces\n• No sickness, aging, or death\n• Reunited with loved ones\n• Seeing Allah (greatest blessing)\n\n**How to enter:**\n• Faith and good deeds\n• Following Quran and Sunnah\n• Seeking forgiveness\n• Being patient in trials\n• Treating others well',

    'death': 'Islam teaches that death is a transition, not an end.\n\n**What happens after death:**\n1. Soul is taken by Angel of Death\n2. Questioning in the grave\n3. Life in Barzakh (waiting period)\n4. Day of Judgment (Resurrection)\n5. Accountability for deeds\n6. Eternal life in Jannah or Jahannam\n\n**Preparation:**\n• Live righteously\n• Repent regularly\n• Remember death often\n• Prepare good deeds',
  };

  final List<String> _suggestedQuestions = [
    'What are the Five Pillars of Islam?',
    'How do I perform Wudu?',
    'What is Ramadan?',
    'How to pray Salah?',
    'What are the 99 Names of Allah?',
    'What is Zakat?',
    'Tell me about Hajj',
    'What is Halal food?',
  ];

  @override
  void initState() {
    super.initState();
    _loadChat();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    if (_messages.isEmpty) {
      _messages.add(ChatMessage(
        text: 'Assalamu Alaikum! 👋\n\nI am AiDeen, your Islamic knowledge assistant. I can help you learn about:\n\n• Pillars of Islam\n• Prayer (Salah)\n• Fasting & Ramadan\n• Quran\n• Hajj & Umrah\n• And much more!\n\nAsk me any question about Islam.',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    }
  }

  Future<void> _loadChat() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('ai_chat_history');
    if (data != null) {
      final decoded = json.decode(data) as List;
      setState(() {
        _messages.clear();
        _messages.addAll(decoded.map((e) => ChatMessage.fromJson(e)).toList());
      });
    }
  }

  Future<void> _saveChat() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _messages.map((e) => e.toJson()).toList();
    await prefs.setString('ai_chat_history', json.encode(data));
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate AI response delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      final response = _getResponse(text);
      setState(() {
        _messages.add(ChatMessage(
          text: response,
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isTyping = false;
      });
      _saveChat();
      _scrollToBottom();
    });
  }

  String _getResponse(String query) {
    final lowerQuery = query.toLowerCase();

    // Check knowledge base
    for (final entry in _knowledgeBase.entries) {
      if (lowerQuery.contains(entry.key)) {
        return entry.value;
      }
    }

    // Greetings
    if (lowerQuery.contains('salam') || lowerQuery.contains('hello') || lowerQuery.contains('hi')) {
      return 'Wa Alaikum Assalam! 🤲\n\nHow can I help you learn about Islam today?';
    }

    // Thank you
    if (lowerQuery.contains('thank') || lowerQuery.contains('jazak')) {
      return 'Wa iyyakum (And to you too)! 😊\n\nMay Allah bless you. Is there anything else you\'d like to know?';
    }

    // Default response
    return 'I appreciate your question! While I may not have a specific answer for that, I encourage you to:\n\n1. Consult the Quran and authentic Hadith\n2. Ask a knowledgeable scholar\n3. Research from trusted Islamic sources\n\nYou can ask me about:\n• Pillars of Islam\n• Prayer & Wudu\n• Fasting & Ramadan\n• Zakat & Charity\n• Hajj pilgrimage\n• Basic Islamic concepts\n\nWhat would you like to learn about?';
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat'),
        content: const Text('Are you sure you want to clear the chat history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _messages.clear();
                _addWelcomeMessage();
              });
              _saveChat();
              Navigator.pop(context);
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: 18,
              child: Icon(Icons.auto_awesome, color: Colors.white, size: 20),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AiDeen', style: TextStyle(fontSize: 16)),
                Text(
                  'Islamic Knowledge Assistant',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _clearChat,
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

          // Suggested questions (show when few messages)
          if (_messages.length <= 2)
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _suggestedQuestions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text(
                        _suggestedQuestions[index],
                        style: const TextStyle(fontSize: 12),
                      ),
                      onPressed: () => _sendMessage(_suggestedQuestions[index]),
                    ),
                  );
                },
              ),
            ),

          // Input field
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ask about Islam...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () => _sendMessage(_messageController.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            const CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: 16,
              child: Icon(Icons.auto_awesome, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: message.isUser
                    ? AppColors.primary
                    : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(message.isUser ? 16 : 4),
                  bottomRight: Radius.circular(message.isUser ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser ? Colors.white : Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          fontSize: 10,
                          color: message.isUser
                              ? Colors.white70
                              : Colors.grey[600],
                        ),
                      ),
                      if (!message.isUser) ...[
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: message.text));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Copied to clipboard')),
                            );
                          },
                          child: Icon(
                            Icons.copy,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.primary,
            radius: 16,
            child: Icon(Icons.auto_awesome, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(1),
                const SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + (index * 200)),
      builder: (context, value, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'text': text,
        'isUser': isUser,
        'timestamp': timestamp.toIso8601String(),
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        text: json['text'],
        isUser: json['isUser'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}
