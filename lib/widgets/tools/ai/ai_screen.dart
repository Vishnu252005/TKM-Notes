import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:Nexia/widgets/tools/ai/code_generator.dart';
import 'package:Nexia/widgets/tools/ai/image_generator.dart';
import 'package:Nexia/widgets/tools/ai/translation.dart';
import 'package:Nexia/ai/screens/HomePage.dart';
import 'package:Nexia/ai/screens/pdf_ai.dart';
import 'package:Nexia/ai/screens/VoiceChat.dart';
import 'package:Nexia/widgets/tools/ai/summarizer_ai.dart';

class AIScreen extends StatefulWidget {
  const AIScreen({super.key});

  @override
  State<AIScreen> createState() => _AIScreenState();
}

class _AIScreenState extends State<AIScreen> {
  bool _isDarkMode = true;

  Color get _backgroundColor => _isDarkMode 
      ? const Color(0xFF1A1A2E) 
      : const Color(0xFFF5F5F7);
  
  Color get _cardColor => _isDarkMode 
      ? const Color(0xFF252542) 
      : Colors.white;
  
  Color get _textColor => _isDarkMode 
      ? Colors.white 
      : const Color(0xFF2D2D3A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _isDarkMode 
                  ? const Color(0xFF2A2A4A)
                  : Colors.blue.withOpacity(0.05),
              _isDarkMode 
                  ? const Color(0xFF1A1A2E)
                  : Colors.purple.withOpacity(0.05),
            ],
          ),
        ),
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar.large(
              floating: true,
              pinned: true,
              backgroundColor: Colors.transparent,
              expandedHeight: 200,
              actions: [
                IconButton(
                  icon: Icon(
                    _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: _isDarkMode ? Colors.white : Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _isDarkMode = !_isDarkMode;
                    });
                  },
                ).animate()
                  .fadeIn(duration: 600.ms)
                  .slideX(begin: 0.2, end: 0),
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'AI Hub',
                  style: TextStyle(
                    color: _textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildPatternBackground(),
                    Positioned(
                      right: 20,
                      bottom: 70,
                      child: Icon(
                        Icons.smart_toy_outlined,
                        size: 80,
                        color: (_isDarkMode ? Colors.white : Colors.black).withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFeaturedTool(),
                    SizedBox(height: 24),
                    Text(
                      'AI Tools',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _textColor,
                      ),
                    ).animate()
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.2, end: 0),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.95,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final tool = aiTools[index];
                    return AIToolCard(
                      tool: tool,
                      isDarkMode: _isDarkMode,
                      cardColor: _cardColor,
                      textColor: _textColor,
                    ).animate()
                      .fadeIn(duration: 600.ms, delay: (index * 100).ms)
                      .slideY(begin: 0.2, end: 0);
                  },
                  childCount: aiTools.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatternBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _isDarkMode 
                ? const Color(0xFF2A2A4A).withOpacity(0.5)
                : Colors.blue.withOpacity(0.05),
            _isDarkMode 
                ? const Color(0xFF1A1A2E).withOpacity(0.5)
                : Colors.purple.withOpacity(0.05),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedTool() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _isDarkMode ? const Color(0xFF4C4DDC) : const Color(0xFF2563EB),
            _isDarkMode 
                ? const Color(0xFF4C4DDC).withOpacity(0.8)
                : const Color(0xFF2563EB).withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (_isDarkMode ? const Color(0xFF4C4DDC) : const Color(0xFF2563EB))
                .withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text(
                'Featured',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'Nexia Powered\nChat Assistant',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 8),
          Text(
            'Experience the power of advanced AI conversation',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Navigate to Chat Assistant
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text('Try Now'),
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 800.ms)
      .scale(begin: const Offset(0.8, 0.8));
  }
}

class AITool {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final Function(BuildContext) onTap;

  const AITool({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class AIToolCard extends StatelessWidget {
  final AITool tool;
  final bool isDarkMode;
  final Color cardColor;
  final Color textColor;

  const AIToolCard({
    super.key,
    required this.tool,
    required this.isDarkMode,
    required this.cardColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: cardColor,
      shadowColor: isDarkMode ? Colors.black38 : Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => tool.onTap(context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: tool.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  tool.icon,
                  size: 28,
                  color: tool.color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                tool.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Text(
                  tool.description,
                  style: TextStyle(
                    fontSize: 11,
                    color: textColor.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final List<AITool> aiTools = [
  AITool(
    name: 'Chat Assistant',
    description: 'Your personal AI assistant for conversations and help',
    icon: Icons.chat_bubble_outline,
    color: Colors.blue,
    onTap: (context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    },
  ),
  AITool(
    name: 'Image Generator',
    description: 'Create amazing AI-generated images and art',
    icon: Icons.image_outlined,
    color: Colors.purple,
    onTap: (context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ImageGenerator()),
      );
    },
  ),
  AITool(
    name: 'Code Assistant',
    description: 'Get help with coding and debugging',
    icon: Icons.code,
    color: Colors.orange,
    onTap: (context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CodeGenerator()),
      );
    },
  ),
  AITool(
    name: 'Text Summarizer',
    description: 'Generate concise summaries from long texts',
    icon: Icons.text_fields_outlined,
    color: Colors.green,
    onTap: (context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SummarizerAI()),
      );
    },
  ),
  AITool(
    name: 'Voice Assistant',
    description: 'Voice-based AI interaction and commands',
    icon: Icons.mic_none_outlined,
    color: Colors.red,
    onTap: (context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VoiceChat()),
      );
    },
  ),
  AITool(
    name: 'Translation',
    description: 'AI-powered language translation',
    icon: Icons.translate_outlined,
    color: Colors.teal,
    onTap: (context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TranslationScreen()),
      );
    },
  ),
  AITool(
    name: 'Document AI',
    description: 'Extract and analyze document content',
    icon: Icons.description_outlined,
    color: Colors.brown,
    onTap: (context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PdfChat()),
      );
    },
  ),
];
