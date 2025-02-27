import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:translator/translator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final TextEditingController _textController = TextEditingController();
  final translator = GoogleTranslator();
  String translatedText = '';
  bool isLoading = false;
  String selectedSourceLang = 'en';
  String selectedTargetLang = 'es';
  bool _isDarkMode = true;
  bool _isFavorite = false;
  List<String> _recentTranslations = [];

  final List<Map<String, String>> languages = [
    {'code': 'af', 'name': 'Afrikaans'},
    {'code': 'ar', 'name': 'Arabic'},
    {'code': 'bn', 'name': 'Bengali'},
    {'code': 'bg', 'name': 'Bulgarian'},
    {'code': 'ca', 'name': 'Catalan'},
    {'code': 'zh-cn', 'name': 'Chinese (Simplified)'},
    {'code': 'zh-tw', 'name': 'Chinese (Traditional)'},
    {'code': 'hr', 'name': 'Croatian'},
    {'code': 'cs', 'name': 'Czech'},
    {'code': 'da', 'name': 'Danish'},
    {'code': 'nl', 'name': 'Dutch'},
    {'code': 'en', 'name': 'English'},
    {'code': 'et', 'name': 'Estonian'},
    {'code': 'tl', 'name': 'Filipino'},
    {'code': 'fi', 'name': 'Finnish'},
    {'code': 'fr', 'name': 'French'},
    {'code': 'de', 'name': 'German'},
    {'code': 'el', 'name': 'Greek'},
    {'code': 'gu', 'name': 'Gujarati'},
    {'code': 'he', 'name': 'Hebrew'},
    {'code': 'hi', 'name': 'Hindi'},
    {'code': 'hu', 'name': 'Hungarian'},
    {'code': 'is', 'name': 'Icelandic'},
    {'code': 'id', 'name': 'Indonesian'},
    {'code': 'ga', 'name': 'Irish'},
    {'code': 'it', 'name': 'Italian'},
    {'code': 'ja', 'name': 'Japanese'},
    {'code': 'kn', 'name': 'Kannada'},
    {'code': 'ko', 'name': 'Korean'},
    {'code': 'lv', 'name': 'Latvian'},
    {'code': 'lt', 'name': 'Lithuanian'},
    {'code': 'ms', 'name': 'Malay'},
    {'code': 'ml', 'name': 'Malayalam'},
    {'code': 'mr', 'name': 'Marathi'},
    {'code': 'ne', 'name': 'Nepali'},
    {'code': 'no', 'name': 'Norwegian'},
    {'code': 'fa', 'name': 'Persian'},
    {'code': 'pl', 'name': 'Polish'},
    {'code': 'pt', 'name': 'Portuguese'},
    {'code': 'pa', 'name': 'Punjabi'},
    {'code': 'ro', 'name': 'Romanian'},
    {'code': 'ru', 'name': 'Russian'},
    {'code': 'sr', 'name': 'Serbian'},
    {'code': 'si', 'name': 'Sinhala'},
    {'code': 'sk', 'name': 'Slovak'},
    {'code': 'sl', 'name': 'Slovenian'},
    {'code': 'es', 'name': 'Spanish'},
    {'code': 'sw', 'name': 'Swahili'},
    {'code': 'sv', 'name': 'Swedish'},
    {'code': 'ta', 'name': 'Tamil'},
    {'code': 'te', 'name': 'Telugu'},
    {'code': 'th', 'name': 'Thai'},
    {'code': 'tr', 'name': 'Turkish'},
    {'code': 'uk', 'name': 'Ukrainian'},
    {'code': 'ur', 'name': 'Urdu'},
    {'code': 'vi', 'name': 'Vietnamese'},
    {'code': 'cy', 'name': 'Welsh'},
  ];

  Future<void> translateText() async {
    if (_textController.text.isEmpty) {
      showErrorDialog('Please enter text to translate');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var translation = await translator.translate(
        _textController.text,
        from: selectedSourceLang,
        to: selectedTargetLang,
      );

      setState(() {
        translatedText = translation.text;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showErrorDialog('Translation failed. Please try again.');
    }
  }

  void showErrorDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.scale,
      title: 'Error',
      titleTextStyle: TextStyle(
        color: _isDarkMode ? Colors.white : Colors.red,
        fontWeight: FontWeight.bold,
      ),
      desc: message,
      descTextStyle: TextStyle(
        color: _isDarkMode ? Colors.white70 : Colors.black87,
      ),
      btnOkColor: _isDarkMode ? Colors.blue[700] : Colors.blue,
      dialogBackgroundColor: _isDarkMode ? const Color(0xFF252542) : Colors.white,
      btnOkOnPress: () {},
    ).show();
  }

  Future<void> scanImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final source = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: _isDarkMode ? const Color(0xFF252542) : Colors.white,
          title: Text(
            'Choose Image Source',
            style: TextStyle(
              color: _isDarkMode ? Colors.white : Colors.blue[700],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: _isDarkMode ? Colors.white70 : Colors.blue,
                ),
                title: Text(
                  'Camera',
                  style: TextStyle(
                    color: _isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: _isDarkMode ? Colors.white70 : Colors.blue,
                ),
                title: Text(
                  'Gallery',
                  style: TextStyle(
                    color: _isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      );

      if (source == null) return;

      final XFile? imageFile = await picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 100,
      );

      if (imageFile == null) return;

      setState(() {
        isLoading = true;
      });

      // For now, we'll just show an error message since we removed ML Kit
      showErrorDialog('Image text recognition is not available in this version.');
      
    } catch (e) {
      print('General error: $e');
      showErrorDialog('An error occurred. Please try again.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _isDarkMode ? const Color(0xFF252542) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LoadingAnimationWidget.staggeredDotsWave(
                color: _isDarkMode ? Colors.blue : Theme.of(context).primaryColor,
                size: 40,
              ),
              const SizedBox(height: 16),
              Text(
                'Processing Image...',
                style: TextStyle(
                  color: _isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Copied to clipboard',
          style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black87),
        ),
        backgroundColor: _isDarkMode ? Color(0xFF252542) : Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _shareTranslation() {
    if (translatedText.isNotEmpty) {
      Share.share(
        'Original: ${_textController.text}\n\nTranslation: $translatedText',
        subject: 'Translation Share',
      );
    }
  }

  void _clearText() {
    setState(() {
      _textController.clear();
      translatedText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = _isDarkMode;
    
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF1A1A2E) : Colors.blue[50],
      body: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(
              painter: DotPatternPainter(
                color: isDarkMode 
                    ? Colors.white.withOpacity(0.03)
                    : Colors.blue.withOpacity(0.05),
              ),
            ),
          ),

          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              // Enhanced Glass Effect Header
              SliverAppBar(
                floating: true,
                pinned: true,
                expandedHeight: 180,
                backgroundColor: Colors.transparent,
                flexibleSpace: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: FlexibleSpaceBar(
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDarkMode 
                                ? [Color(0xFF4C4DDC), Color(0xFF1A1A2E)]
                                : [Colors.blue[400]!, Colors.blue[100]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: SafeArea(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.translate,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'TRANSLATOR',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ).animate()
                                      .fadeIn(delay: 200.ms)
                                      .slideX(),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            isDarkMode ? Icons.light_mode : Icons.dark_mode,
                                            color: Colors.white,
                                          ),
                                          onPressed: _toggleTheme,
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.camera_alt,
                                            color: Colors.white,
                                          ),
                                          onPressed: scanImage,
                                        ),
                                      ],
                                    ).animate()
                                      .fadeIn(delay: 300.ms)
                                      .slideX(),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Text Recognition\n& Translation',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                ).animate()
                                  .fadeIn(delay: 400.ms)
                                  .slideY(),
                                SizedBox(height: 8),
                                Text(
                                  'Translate text between multiple languages',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                ).animate()
                                  .fadeIn(delay: 500.ms)
                                  .slideY(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Card(
                        elevation: 8,
                        shadowColor: isDarkMode 
                            ? Colors.blue.withOpacity(0.2) 
                            : Colors.blue.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isDarkMode 
                                ? Colors.white.withOpacity(0.1)
                                : Colors.blue.withOpacity(0.1),
                          ),
                        ),
                        color: isDarkMode ? const Color(0xFF252542) : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownSearch<Map<String, String>>(
                                  items: languages,
                                  selectedItem: languages.firstWhere(
                                    (lang) => lang['code'] == selectedSourceLang,
                                  ),
                                  itemAsString: (Map<String, String>? lang) => lang?['name'] ?? '',
                                  onChanged: (Map<String, String>? value) {
                                    if (value != null) {
                                      setState(() {
                                        selectedSourceLang = value['code']!;
                                      });
                                    }
                                  },
                                  dropdownBuilder: (context, selectedItem) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(vertical: 8),
                                      child: Text(
                                        selectedItem?['name'] ?? '',
                                        style: TextStyle(
                                          color: isDarkMode ? Colors.white : Colors.black87,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  },
                                  popupProps: PopupProps.menu(
                                    searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                        hintText: 'Search language...',
                                        hintStyle: TextStyle(
                                          color: isDarkMode ? Colors.white60 : Colors.grey[600],
                                        ),
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: isDarkMode ? Colors.white70 : Colors.blue[700],
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                            color: isDarkMode ? Colors.white30 : Colors.blue[200]!,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                            color: isDarkMode ? Colors.white24 : Colors.blue[100]!,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                            color: isDarkMode ? Colors.white : Colors.blue,
                                            width: 2,
                                          ),
                                        ),
                                        fillColor: isDarkMode ? Color(0xFF1E1E30) : Colors.white,
                                        filled: true,
                                      ),
                                      style: TextStyle(
                                        color: isDarkMode ? Colors.white : Colors.black87,
                                        fontSize: 16,
                                      ),
                                    ),
                                    showSearchBox: true,
                                    searchDelay: Duration(milliseconds: 0),
                                    constraints: BoxConstraints(maxHeight: 350),
                                    menuProps: MenuProps(
                                      backgroundColor: isDarkMode ? Color(0xFF252542) : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    containerBuilder: (context, popupWidget) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: isDarkMode ? Colors.white12 : Colors.blue[100]!,
                                            width: 1,
                                          ),
                                        ),
                                        child: popupWidget,
                                      );
                                    },
                                    loadingBuilder: (context, searchEntry) => Center(
                                      child: LoadingAnimationWidget.staggeredDotsWave(
                                        color: isDarkMode ? Colors.white : Colors.blue,
                                        size: 40,
                                      ),
                                    ),
                                    emptyBuilder: (context, searchEntry) => Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 20),
                                        child: Text(
                                          'No languages found',
                                          style: TextStyle(
                                            color: isDarkMode ? Colors.white70 : Colors.grey[600],
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    itemBuilder: (context, item, isSelected) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        child: Text(
                                          item['name'] ?? '',
                                          style: TextStyle(
                                            color: isDarkMode ? Colors.white : Colors.black87,
                                            fontSize: 16,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  dropdownDecoratorProps: DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText: 'From',
                                      labelStyle: TextStyle(
                                        color: isDarkMode ? Colors.white : Colors.blue[700],
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isDarkMode 
                                        ? Colors.blue.withOpacity(0.15)
                                        : Colors.blue[50],
                                    border: Border.all(
                                      color: isDarkMode 
                                          ? Colors.white.withOpacity(0.1)
                                          : Colors.blue[200]!,
                                    ),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.swap_horiz),
                                    color: isDarkMode ? Colors.white : Colors.blue[700],
                                    onPressed: () {
                                      setState(() {
                                        final temp = selectedSourceLang;
                                        selectedSourceLang = selectedTargetLang;
                                        selectedTargetLang = temp;
                                        setState(() {});
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: DropdownSearch<Map<String, String>>(
                                  items: languages,
                                  selectedItem: languages.firstWhere(
                                    (lang) => lang['code'] == selectedTargetLang,
                                  ),
                                  itemAsString: (Map<String, String>? lang) => lang?['name'] ?? '',
                                  onChanged: (Map<String, String>? value) {
                                    if (value != null) {
                                      setState(() {
                                        selectedTargetLang = value['code']!;
                                      });
                                    }
                                  },
                                  dropdownBuilder: (context, selectedItem) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(vertical: 8),
                                      child: Text(
                                        selectedItem?['name'] ?? '',
                                        style: TextStyle(
                                          color: isDarkMode ? Colors.white : Colors.black87,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  },
                                  popupProps: PopupProps.menu(
                                    searchFieldProps: TextFieldProps(
                                      decoration: InputDecoration(
                                        hintText: 'Search language...',
                                        hintStyle: TextStyle(
                                          color: isDarkMode ? Colors.white60 : Colors.grey[600],
                                        ),
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: isDarkMode ? Colors.white70 : Colors.blue[700],
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                            color: isDarkMode ? Colors.white30 : Colors.blue[200]!,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                            color: isDarkMode ? Colors.white24 : Colors.blue[100]!,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                            color: isDarkMode ? Colors.white : Colors.blue,
                                            width: 2,
                                          ),
                                        ),
                                        fillColor: isDarkMode ? Color(0xFF1E1E30) : Colors.white,
                                        filled: true,
                                      ),
                                      style: TextStyle(
                                        color: isDarkMode ? Colors.white : Colors.black87,
                                        fontSize: 16,
                                      ),
                                    ),
                                    showSearchBox: true,
                                    searchDelay: Duration(milliseconds: 0),
                                    constraints: BoxConstraints(maxHeight: 350),
                                    menuProps: MenuProps(
                                      backgroundColor: isDarkMode ? Color(0xFF252542) : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    containerBuilder: (context, popupWidget) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: isDarkMode ? Colors.white12 : Colors.blue[100]!,
                                            width: 1,
                                          ),
                                        ),
                                        child: popupWidget,
                                      );
                                    },
                                    loadingBuilder: (context, searchEntry) => Center(
                                      child: LoadingAnimationWidget.staggeredDotsWave(
                                        color: isDarkMode ? Colors.white : Colors.blue,
                                        size: 40,
                                      ),
                                    ),
                                    emptyBuilder: (context, searchEntry) => Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 20),
                                        child: Text(
                                          'No languages found',
                                          style: TextStyle(
                                            color: isDarkMode ? Colors.white70 : Colors.grey[600],
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    itemBuilder: (context, item, isSelected) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        child: Text(
                                          item['name'] ?? '',
                                          style: TextStyle(
                                            color: isDarkMode ? Colors.white : Colors.black87,
                                            fontSize: 16,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  dropdownDecoratorProps: DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText: 'To',
                                      labelStyle: TextStyle(
                                        color: isDarkMode ? Colors.white : Colors.blue[700],
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).animate()
                        .fadeIn(delay: 200.ms)
                        .slideY(begin: 0.2),

                      const SizedBox(height: 16),

                      Card(
                        elevation: 8,
                        shadowColor: isDarkMode 
                            ? Colors.blue.withOpacity(0.2) 
                            : Colors.blue.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isDarkMode 
                                ? Colors.white.withOpacity(0.1)
                                : Colors.blue.withOpacity(0.1),
                          ),
                        ),
                        color: isDarkMode ? const Color(0xFF252542) : Colors.white,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Input Text',
                                    style: TextStyle(
                                      color: isDarkMode ? Colors.white : Colors.blue[700],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.clear,
                                          color: isDarkMode ? Colors.white70 : Colors.grey[600],
                                        ),
                                        tooltip: 'Clear text',
                                        onPressed: _clearText,
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                                          color: _isFavorite ? Colors.red : (isDarkMode ? Colors.white70 : Colors.grey[600]),
                                        ),
                                        tooltip: 'Add to favorites',
                                        onPressed: () {
                                          setState(() {
                                            _isFavorite = !_isFavorite;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: isDarkMode ? Colors.white12 : Colors.blue[50],
                              height: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextField(
                                controller: _textController,
                                maxLines: 5,
                                style: TextStyle(
                                  color: isDarkMode ? Colors.white : Colors.black87,
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Enter text to translate...',
                                  hintStyle: TextStyle(
                                    color: isDarkMode ? Colors.white60 : Colors.grey[400],
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).animate()
                        .fadeIn(delay: 400.ms)
                        .slideY(begin: 0.2),

                      const SizedBox(height: 16),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: ElevatedButton.icon(
                          onPressed: translateText,
                          icon: const Icon(Icons.translate, size: 24),
                          label: const Text(
                            'Translate',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDarkMode ? Colors.blue[700] : Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            shadowColor: isDarkMode 
                                ? Colors.blue.withOpacity(0.3)
                                : Colors.blue.withOpacity(0.4),
                          ),
                        ),
                      ).animate()
                        .fadeIn(delay: 600.ms)
                        .slideY(begin: 0.2),

                      const SizedBox(height: 16),

                      if (isLoading)
                        Center(
                          child: LoadingAnimationWidget.staggeredDotsWave(
                            color: isDarkMode ? Colors.blue : Theme.of(context).primaryColor,
                            size: 50,
                          ),
                        ).animate()
                          .fadeIn()
                          .scale()
                      else if (translatedText.isNotEmpty)
                        Card(
                          elevation: 8,
                          shadowColor: isDarkMode 
                              ? Colors.blue.withOpacity(0.2) 
                              : Colors.blue.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isDarkMode 
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.blue.withOpacity(0.1),
                            ),
                          ),
                          color: isDarkMode ? const Color(0xFF252542) : Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Translation',
                                      style: TextStyle(
                                        color: isDarkMode ? Colors.white : Colors.blue[700],
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.copy,
                                            color: isDarkMode ? Colors.white : Colors.blue[700],
                                          ),
                                          tooltip: 'Copy to clipboard',
                                          onPressed: () => _copyToClipboard(translatedText),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.share,
                                            color: isDarkMode ? Colors.white : Colors.blue[700],
                                          ),
                                          tooltip: 'Share translation',
                                          onPressed: _shareTranslation,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                color: isDarkMode ? Colors.white12 : Colors.blue[50],
                                height: 1,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  translatedText,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isDarkMode ? Colors.white : Colors.black87,
                                    height: 1.5,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).animate()
                          .fadeIn(delay: 200.ms)
                          .slideY(begin: 0.2),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

class DotPatternPainter extends CustomPainter {
  final Color color;
  
  DotPatternPainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final double spacing = 20;
    final double radius = 1;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
      
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }
  
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
