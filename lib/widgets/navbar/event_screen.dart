import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isDarkMode = true;
  String _selectedFilter = 'All';
  List<String> _filters = ['All', 'Workshop', 'Seminar', 'Conference', 'Hackathon'];
  RangeValues _priceRange = RangeValues(0, 2000);
  RangeValues _pointsRange = RangeValues(0, 30);
  String _selectedCapacity = 'All';
  String _selectedDate = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Color(0xFF1A1A2E) : Color(0xFFF0F8FF),
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient with animation
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _isDarkMode 
                      ? [Color(0xFF1A1A2E), Color(0xFF1A1A2E)]
                      : [Colors.blue.shade50, Colors.white],
                ),
              ),
            ).animate()
              .fadeIn(duration: Duration(milliseconds: 800))
              .shimmer(duration: Duration(seconds: 2)),
            // Main content
            Column(
              children: [
                _buildHeader()
                  .animate()
                  .fadeIn(duration: Duration(milliseconds: 600))
                  .slideY(begin: -0.2, end: 0)
                  .then()
                  .shimmer(delay: Duration(seconds: 1)),
                _buildSearchBar()
                  .animate()
                  .fadeIn(delay: Duration(milliseconds: 200))
                  .scaleXY(begin: 0.8)
                  .then()
                  .shake(delay: Duration(seconds: 1), duration: Duration(milliseconds: 700)),
                /* Commenting out TabBar
                _buildTabBar()
                  .animate()
                  .fadeIn(delay: Duration(milliseconds: 400))
                  .slideX(begin: -0.2)
                  .then()
                  .shimmer(delay: Duration(seconds: 1)),
                */
                Expanded(
                  // Replacing TabBarView with single event list
                  child: _buildEventList([..._upcomingEvents, ..._currentEvents, ..._pastEvents])
                    .animate()
                    .fadeIn(delay: Duration(milliseconds: 600)),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showCreateEventForm();
        },
        backgroundColor: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
        icon: Icon(Icons.add),
        label: Text('Create Event'),
      ).animate(
        onPlay: (controller) => controller.repeat(reverse: true),
      )
        .scaleXY(
          begin: 1,
          end: 1.05,
          duration: Duration(seconds: 2),
          curve: Curves.easeInOut,
        )
        .shimmer(delay: Duration(milliseconds: 800)),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        color: _isDarkMode ? Color(0xFF252542) : Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: _isDarkMode 
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Events',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: _isDarkMode ? Colors.white : Colors.blue[900],
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: _isDarkMode 
                      ? Color(0xFF4C4DDC).withOpacity(0.1)
                      : Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.calendar_today,
                    color: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                  ),
                  onPressed: () {
                    _showCalendarView(context);
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Discover amazing events happening around you',
            style: TextStyle(
              fontSize: 14,
              color: _isDarkMode ? Colors.white60 : Colors.grey[600],
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  void _showCalendarView(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: _isDarkMode ? Color(0xFF252542) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Calendar View',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: _isDarkMode ? Colors.white60 : Colors.grey[600],
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: _isDarkMode ? Colors.white12 : Colors.grey[200]),
                Container(
                  height: 400,
                  padding: EdgeInsets.all(20),
                  child: ListView(
                    children: [
                      _buildCalendarEventGroup('Upcoming Events', _upcomingEvents),
                      SizedBox(height: 20),
                      _buildCalendarEventGroup('Current Events', _currentEvents),
                      SizedBox(height: 20),
                      _buildCalendarEventGroup('Past Events', _pastEvents),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ).animate()
          .fadeIn()
          .scaleXY(begin: 0.9, end: 1.0);
      },
    );
  }

  Widget _buildCalendarEventGroup(String title, List<Map<String, dynamic>> events) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        SizedBox(height: 12),
        ...events.map((event) => _buildCalendarEventItem(event)).toList(),
      ],
    );
  }

  Widget _buildCalendarEventItem(Map<String, dynamic> event) {
    final eventColor = _getEventTypeColor(event['type']);
    
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: eventColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: eventColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getEventTypeIcon(event['type']),
              color: eventColor,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['title'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _isDarkMode ? Colors.white : Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  '${event['date']} • ${event['location']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: _isDarkMode ? Colors.white60 : Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: _isDarkMode ? Colors.white38 : Colors.grey[400],
            ),
            onPressed: () {
              Navigator.pop(context);
              _showEventDetails(context, event);
            },
          ),
        ],
      ),
    ).animate()
      .fadeIn()
      .slideX(begin: 0.2, end: 0)
      .then()
      .shimmer(duration: Duration(milliseconds: 800));
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.fromLTRB(24, 24, 24, 16),
      decoration: BoxDecoration(
        color: _isDarkMode ? Color(0xFF252542) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _isDarkMode 
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              style: TextStyle(
                color: _isDarkMode ? Colors.white : Colors.black,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: 'Search events...',
                hintStyle: TextStyle(
                  color: _isDarkMode ? Colors.white38 : Colors.grey[400],
                  fontSize: 16,
                ),
                prefixIcon: Container(
                  padding: EdgeInsets.all(12),
                  child: Icon(
                    Icons.search,
                    color: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                    size: 24,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                suffixIcon: _searchQuery.isNotEmpty
                    ? Container(
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _isDarkMode 
                              ? Colors.red.withOpacity(0.1)
                              : Colors.red[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                            size: 18,
                            color: _isDarkMode ? Colors.red[300] : Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        ),
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: _isDarkMode 
                  ? Color(0xFF4C4DDC).withOpacity(0.1)
                  : Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.filter_list,
                    color: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                    size: 24,
                  ),
                  if (_selectedFilter != 'All')
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '1',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: () => _showFilterBottomSheet(),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: _isDarkMode ? Color(0xFF252542) : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _isDarkMode ? Colors.white24 : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Filter Events',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedFilter = 'All';
                                _priceRange = RangeValues(0, 2000);
                                _pointsRange = RangeValues(0, 30);
                                _selectedCapacity = 'All';
                                _selectedDate = 'All';
                              });
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Reset All',
                              style: TextStyle(
                                color: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      _buildFilterSection(
                        'Event Type',
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _filters.map((filter) => _buildFilterChip(filter)).toList(),
                        ),
                      ),
                      _buildFilterSection(
                        'Price Range',
                        Column(
                          children: [
                            RangeSlider(
                              values: _priceRange,
                              min: 0,
                              max: 2000,
                              divisions: 20,
                              activeColor: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                              inactiveColor: _isDarkMode ? Colors.white24 : Colors.grey[300],
                              labels: RangeLabels(
                                '₹${_priceRange.start.round()}',
                                '₹${_priceRange.end.round()}',
                              ),
                              onChanged: (RangeValues values) {
                                setState(() {
                                  _priceRange = values;
                                });
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '₹${_priceRange.start.round()}',
                                  style: TextStyle(
                                    color: _isDarkMode ? Colors.white70 : Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  '₹${_priceRange.end.round()}',
                                  style: TextStyle(
                                    color: _isDarkMode ? Colors.white70 : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      _buildFilterSection(
                        'Points Range',
                        Column(
                          children: [
                            RangeSlider(
                              values: _pointsRange,
                              min: 0,
                              max: 30,
                              divisions: 6,
                              activeColor: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                              inactiveColor: _isDarkMode ? Colors.white24 : Colors.grey[300],
                              labels: RangeLabels(
                                '${_pointsRange.start.round()} pts',
                                '${_pointsRange.end.round()} pts',
                              ),
                              onChanged: (RangeValues values) {
                                setState(() {
                                  _pointsRange = values;
                                });
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${_pointsRange.start.round()} pts',
                                  style: TextStyle(
                                    color: _isDarkMode ? Colors.white70 : Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  '${_pointsRange.end.round()} pts',
                                  style: TextStyle(
                                    color: _isDarkMode ? Colors.white70 : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      _buildFilterSection(
                        'Capacity Status',
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildCapacityChip('All', Icons.all_inclusive),
                            _buildCapacityChip('Available', Icons.event_available),
                            _buildCapacityChip('Almost Full', Icons.warning_amber),
                            _buildCapacityChip('Full', Icons.event_busy),
                          ],
                        ),
                      ),
                      _buildFilterSection(
                        'Date',
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildDateChip('All', Icons.date_range),
                            _buildDateChip('Today', Icons.today),
                            _buildDateChip('This Week', Icons.calendar_view_week),
                            _buildDateChip('This Month', Icons.calendar_month),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _isDarkMode ? Color(0xFF252542) : Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: _isDarkMode 
                                ? Color(0xFF4C4DDC).withOpacity(0.5)
                                : Colors.blue.withOpacity(0.5),
                          ),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Apply filters
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Apply Filters',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 3,
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().slideY(begin: 1, end: 0, duration: Duration(milliseconds: 300), curve: Curves.easeOut),
    );
  }

  Widget _buildFilterSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        SizedBox(height: 16),
        content,
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildFilterChip(String filter) {
    final isSelected = _selectedFilter == filter;
    return FilterChip(
      selected: isSelected,
      label: Text(filter),
      labelStyle: TextStyle(
        color: isSelected
            ? Colors.white
            : (_isDarkMode ? Colors.white70 : Colors.black87),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: _isDarkMode 
          ? Color(0xFF1A1A2E)
          : Colors.grey[100],
      selectedColor: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
      checkmarkColor: Colors.white,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = selected ? filter : 'All';
        });
      },
    ).animate()
      .fadeIn(delay: Duration(milliseconds: 100))
      .scaleXY(begin: 0.8);
  }

  Widget _buildCapacityChip(String label, IconData icon) {
    final isSelected = _selectedCapacity == label;
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected
                ? Colors.white
                : (_isDarkMode ? Colors.white70 : Colors.black87),
          ),
          SizedBox(width: 4),
          Text(label),
        ],
      ),
      labelStyle: TextStyle(
        color: isSelected
            ? Colors.white
            : (_isDarkMode ? Colors.white70 : Colors.black87),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: _isDarkMode 
          ? Color(0xFF1A1A2E)
          : Colors.grey[100],
      selectedColor: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
      checkmarkColor: Colors.white,
      onSelected: (selected) {
        setState(() {
          _selectedCapacity = selected ? label : 'All';
        });
      },
    ).animate()
      .fadeIn(delay: Duration(milliseconds: 100))
      .scaleXY(begin: 0.8);
  }

  Widget _buildDateChip(String label, IconData icon) {
    final isSelected = _selectedDate == label;
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected
                ? Colors.white
                : (_isDarkMode ? Colors.white70 : Colors.black87),
          ),
          SizedBox(width: 4),
          Text(label),
        ],
      ),
      labelStyle: TextStyle(
        color: isSelected
            ? Colors.white
            : (_isDarkMode ? Colors.white70 : Colors.black87),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: _isDarkMode 
          ? Color(0xFF1A1A2E)
          : Colors.grey[100],
      selectedColor: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
      checkmarkColor: Colors.white,
      onSelected: (selected) {
        setState(() {
          _selectedDate = selected ? label : 'All';
        });
      },
    ).animate()
      .fadeIn(delay: Duration(milliseconds: 100))
      .scaleXY(begin: 0.8);
  }

  Widget _buildEventList(List<Map<String, dynamic>> events) {
    if (_searchQuery.isNotEmpty) {
      events = events.where((event) {
        return event['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
               event['description'].toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    if (_selectedFilter != 'All') {
      events = events.where((event) => event['type'] == _selectedFilter).toList();
    }

    // Apply price range filter
    events = events.where((event) {
      return event['price'] >= _priceRange.start && event['price'] <= _priceRange.end;
    }).toList();

    // Apply points range filter
    events = events.where((event) {
      return event['points'] >= _pointsRange.start && event['points'] <= _pointsRange.end;
    }).toList();

    // Apply capacity status filter
    if (_selectedCapacity != 'All') {
      events = events.where((event) {
        final registrationPercentage = (event['registrations'] / event['capacity'] * 100).round();
        switch (_selectedCapacity) {
          case 'Available':
            return registrationPercentage < 80;
          case 'Almost Full':
            return registrationPercentage >= 80 && registrationPercentage < 100;
          case 'Full':
            return registrationPercentage == 100;
          default:
            return true;
        }
      }).toList();
    }

    // Apply date filter
    if (_selectedDate != 'All') {
      final now = DateTime.now();
      events = events.where((event) {
        final eventDate = DateTime.parse(event['date'].replaceAll(RegExp(r'[a-zA-Z\s,]'), ''));
        switch (_selectedDate) {
          case 'Today':
            return eventDate.year == now.year &&
                   eventDate.month == now.month &&
                   eventDate.day == now.day;
          case 'This Week':
            final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
            final endOfWeek = startOfWeek.add(Duration(days: 6));
            return eventDate.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
                   eventDate.isBefore(endOfWeek.add(Duration(days: 1)));
          case 'This Month':
            return eventDate.year == now.year && eventDate.month == now.month;
          default:
            return true;
        }
      }).toList();
    }

    return events.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_busy,
                  size: 80,
                  color: _isDarkMode ? Colors.white12 : Colors.grey[300],
                ),
                SizedBox(height: 16),
                Text(
                  'No events found',
                  style: TextStyle(
                    color: _isDarkMode ? Colors.white38 : Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Try adjusting your search',
                  style: TextStyle(
                    color: _isDarkMode ? Colors.white24 : Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: Duration(milliseconds: 300))
        : ListView.builder(
            padding: EdgeInsets.fromLTRB(24, 24, 24, 100),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return _buildEventCard(event).animate().fadeIn(
                delay: Duration(milliseconds: index * 100),
                duration: Duration(milliseconds: 300),
              ).slideX(
                begin: 0.2,
                end: 0,
                delay: Duration(milliseconds: index * 100),
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            },
          );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    final registrationPercentage = (event['registrations'] / event['capacity'] * 100).round();
    final spotsLeft = event['capacity'] - event['registrations'];
    final bool isFull = spotsLeft == 0;

    return Container(
      margin: EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: _isDarkMode ? Color(0xFF252542) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _isDarkMode 
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                child: Image.network(
                  event['image'],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ).animate()
                  .fadeIn(duration: Duration(milliseconds: 500))
                  .scaleXY(begin: 1.2, end: 1.0),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white24,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 18,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${event['points']} pts',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ).animate()
                      .fadeIn(delay: Duration(milliseconds: 500))
                      .slideX(begin: -0.2, end: 0)
                      .then()
                      .shimmer(),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white24,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.currency_rupee_rounded,
                            color: Colors.green[300],
                            size: 18,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${event['price']}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ).animate()
                      .fadeIn(delay: Duration(milliseconds: 600))
                      .slideX(begin: -0.2, end: 0)
                      .then()
                      .shimmer(),
                  ],
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.bookmark_border,
                    color: Colors.white,
                    size: 20,
                  ),
                ).animate()
                  .fadeIn(delay: Duration(milliseconds: 500))
                  .scaleXY(begin: 0.5)
                  .then()
                  .shimmer(delay: Duration(milliseconds: 800)),
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white24,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.people,
                        color: isFull ? Colors.red[300] : Colors.green[300],
                        size: 18,
                      ),
                      SizedBox(width: 4),
                      Text(
                        isFull ? 'Full' : '$spotsLeft spots left',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ).animate()
                  .fadeIn(delay: Duration(milliseconds: 700))
                  .slideY(begin: 0.2, end: 0)
                  .then()
                  .shimmer(),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getEventTypeColor(event['type']).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _getEventTypeColor(event['type']).withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getEventTypeIcon(event['type']),
                              color: _getEventTypeColor(event['type']),
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              event['type'],
                              style: TextStyle(
                                color: _getEventTypeColor(event['type']),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ).animate()
                        .fadeIn(delay: Duration(milliseconds: 300))
                        .slideX(begin: -0.2)
                        .then()
                        .shimmer(),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  event['title'],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : Colors.black,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ).animate()
                  .fadeIn(delay: Duration(milliseconds: 400))
                  .slideX(begin: -0.2),
                SizedBox(height: 8),
                Text(
                  event['description'],
                  style: TextStyle(
                    fontSize: 16,
                    color: _isDarkMode ? Colors.white60 : Colors.grey[600],
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ).animate()
                  .fadeIn(delay: Duration(milliseconds: 500))
                  .slideX(begin: -0.2),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: _buildEventDetail(
                          Icons.calendar_today,
                          event['date'],
                          _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                        ).animate()
                          .fadeIn(delay: Duration(milliseconds: 600))
                          .slideX(begin: -0.2),
                      ),
                      SizedBox(width: 16),
                      Flexible(
                        child: _buildEventDetail(
                          Icons.location_on,
                          event['location'],
                          Colors.purple,
                        ).animate()
                          .fadeIn(delay: Duration(milliseconds: 700))
                          .slideX(begin: -0.2),
                      ),
                    ],
                  ),
                ).animate()
                  .fadeIn(delay: Duration(milliseconds: 600))
                  .scaleXY(begin: 0.9),
                SizedBox(height: 20),
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: _isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        flex: registrationPercentage,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isFull
                                  ? [Colors.red[700]!, Colors.red[300]!]
                                  : registrationPercentage > 80
                                      ? [Colors.orange[700]!, Colors.orange[300]!]
                                      : [Colors.green[700]!, Colors.green[300]!],
                            ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      if (!isFull)
                        Flexible(
                          flex: (100 - registrationPercentage).toInt(),
                          child: Container(),
                        ),
                    ],
                  ),
                ).animate()
                  .fadeIn(delay: Duration(milliseconds: 800))
                  .slideX(begin: -0.2, end: 0),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${event['registrations']}/${event['capacity']} registered',
                      style: TextStyle(
                        fontSize: 12,
                        color: _isDarkMode ? Colors.white60 : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '$registrationPercentage% full',
                      style: TextStyle(
                        fontSize: 12,
                        color: isFull
                            ? Colors.red[300]
                            : registrationPercentage > 80
                                ? Colors.orange[300]
                                : Colors.green[300],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ).animate()
                  .fadeIn(delay: Duration(milliseconds: 900))
                  .slideY(begin: 0.2, end: 0),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          _showEventDetails(context, event);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: _isDarkMode 
                                  ? Color(0xFF4C4DDC).withOpacity(0.5)
                                  : Colors.blue.withOpacity(0.5),
                            ),
                          ),
                        ),
                        child: Text(
                          'View Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ).animate()
                      .fadeIn(delay: Duration(milliseconds: 800))
                      .slideY(begin: 0.2),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isFull ? null : () {
                          _handleRegistration(event);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 1),
                                blurRadius: 3,
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).animate()
                      .fadeIn(delay: Duration(milliseconds: 900))
                      .slideY(begin: 0.2)
                      .then()
                      .shimmer(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: Duration(milliseconds: 600))
      .scaleXY(begin: 0.95)
      .then()
      .animate(
        onPlay: (controller) => controller.repeat(reverse: true),
      )
      .scaleXY(
        begin: 1,
        end: 1.02,
        duration: Duration(seconds: 2),
        curve: Curves.easeInOut,
      );
  }

  Widget _buildEventDetail(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: color,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: _isDarkMode ? Colors.white70 : Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  IconData _getEventTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'workshop':
        return Icons.build;
      case 'seminar':
        return Icons.people;
      case 'conference':
        return Icons.business;
      case 'hackathon':
        return Icons.code;
      default:
        return Icons.event;
    }
  }

  Color _getEventTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'workshop':
        return Colors.orange;
      case 'seminar':
        return Colors.green;
      case 'conference':
        return Colors.purple;
      case 'hackathon':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  // Sample event data
  final List<Map<String, dynamic>> _upcomingEvents = [
    {
      'title': 'Flutter Workshop 2024',
      'description': 'Learn Flutter development from industry experts',
      'date': 'Mar 25, 2024',
      'location': 'Tech Hub',
      'type': 'Workshop',
      'points': 20,
      'price': 499,
      'registrations': 45,
      'capacity': 50,
      'image': 'https://images.unsplash.com/photo-1551818255-e6e10975bc17',
    },
    {
      'title': 'AI Conference',
      'description': 'Exploring the future of Artificial Intelligence',
      'date': 'Apr 15, 2024',
      'location': 'Convention Center',
      'type': 'Conference',
      'points': 25,
      'price': 999,
      'registrations': 180,
      'capacity': 200,
      'image': 'https://images.unsplash.com/photo-1505373877841-8d25f7d46678',
    },
  ];

  final List<Map<String, dynamic>> _currentEvents = [
    {
      'title': 'Tech Hackathon',
      'description': 'Build innovative solutions in 48 hours',
      'date': 'Mar 15-17, 2024',
      'location': 'Innovation Lab',
      'type': 'Hackathon',
      'points': 30,
      'price': 1499,
      'registrations': 95,
      'capacity': 100,
      'image': 'https://images.unsplash.com/photo-1504384764586-bb4cdc1707b0',
    },
  ];

  final List<Map<String, dynamic>> _pastEvents = [
    {
      'title': 'Web Development Seminar',
      'description': 'Modern web development practices and tools',
      'date': 'Feb 28, 2024',
      'location': 'Online',
      'type': 'Seminar',
      'points': 10,
      'price': 299,
      'registrations': 150,
      'capacity': 150,
      'image': 'https://images.unsplash.com/photo-1511795409834-ef04bbd61622',
    },
    {
      'title': 'IoT Workshop',
      'description': 'Hands-on experience with IoT devices',
      'date': 'Feb 15, 2024',
      'location': 'Electronics Lab',
      'type': 'Workshop',
      'points': 15,
      'price': 399,
      'registrations': 30,
      'capacity': 30,
      'image': 'https://images.unsplash.com/photo-1518770660439-4636190af475',
    },
  ];

  void _showEventDetails(BuildContext context, Map<String, dynamic> event) {
    final registrationPercentage = (event['registrations'] / event['capacity'] * 100).round();
    final spotsLeft = event['capacity'] - event['registrations'];
    final bool isFull = spotsLeft == 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
              maxWidth: 400,
            ),
            decoration: BoxDecoration(
              color: _isDarkMode ? Color(0xFF252542) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      child: Image.network(
                        event['image'],
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Event type and points
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _getEventTypeColor(event['type']).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _getEventTypeIcon(event['type']),
                                          color: _getEventTypeColor(event['type']),
                                          size: 16,
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          event['type'],
                                          style: TextStyle(
                                            color: _getEventTypeColor(event['type']),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star_rounded,
                                        color: Colors.amber,
                                        size: 20,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '${event['points']} points',
                                        style: TextStyle(
                                          color: _isDarkMode ? Colors.white70 : Colors.grey[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              // Event title
                              Text(
                                event['title'],
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: _isDarkMode ? Colors.white : Colors.black,
                                  height: 1.2,
                                ),
                              ),
                              SizedBox(height: 16),
                              // Event details
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: _isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey[50],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    _buildDetailRow(
                                      Icons.calendar_today,
                                      event['date'],
                                      _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                                    ),
                                    SizedBox(height: 12),
                                    _buildDetailRow(
                                      Icons.location_on,
                                      event['location'],
                                      Colors.purple,
                                    ),
                                    SizedBox(height: 12),
                                    _buildDetailRow(
                                      Icons.currency_rupee_rounded,
                                      '${event['price']}',
                                      Colors.green,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Bottom action bar
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _isDarkMode ? Color(0xFF252542) : Colors.white,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Price',
                              style: TextStyle(
                                color: _isDarkMode ? Colors.white60 : Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '₹${event['price']}',
                              style: TextStyle(
                                color: _isDarkMode ? Colors.white : Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isFull ? null : () {
                            Navigator.pop(context);
                            _handleRegistration(event);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            isFull ? 'Event Full' : 'Register Now',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 3,
                                  color: Colors.black.withOpacity(0.3),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ).animate()
          .fadeIn()
          .scaleXY(begin: 0.95);
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: _isDarkMode ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  void _handleRegistration(Map<String, dynamic> event) {
    if (event['registrations'] >= event['capacity']) {
      _showRegistrationDialog(
        'Event Full',
        'Sorry, this event has reached its maximum capacity.',
        false
      );
      return;
    }

    _showRegistrationForm(event);
  }

  void _showRegistrationForm(Map<String, dynamic> event) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _phoneController = TextEditingController();
    final _collegeController = TextEditingController();
    final _deptController = TextEditingController();
    String _selectedYear = '1st Year';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
              maxWidth: 400,
            ),
            decoration: BoxDecoration(
              color: _isDarkMode ? Color(0xFF252542) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.app_registration,
                        color: Colors.white,
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Registration Form',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                // Form
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Event: ${event['title']}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            SizedBox(height: 24),
                            _buildFormField(
                              controller: _nameController,
                              label: 'Full Name',
                              icon: Icons.person,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            _buildFormField(
                              controller: _phoneController,
                              label: 'Phone Number',
                              icon: Icons.phone,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                if (value.length != 10) {
                                  return 'Please enter a valid 10-digit phone number';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            _buildFormField(
                              controller: _collegeController,
                              label: 'College Name',
                              icon: Icons.school,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your college name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            _buildFormField(
                              controller: _deptController,
                              label: 'Department',
                              icon: Icons.business,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your department';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Year',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: _isDarkMode ? Colors.white70 : Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: _isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey[100],
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: _isDarkMode ? Colors.white24 : Colors.grey[300]!,
                                ),
                              ),
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  return DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedYear,
                                      isExpanded: true,
                                      dropdownColor: _isDarkMode ? Color(0xFF252542) : Colors.white,
                                      style: TextStyle(
                                        color: _isDarkMode ? Colors.white : Colors.black,
                                        fontSize: 16,
                                      ),
                                      items: ['1st Year', '2nd Year', '3rd Year', '4th Year']
                                          .map((year) => DropdownMenuItem(
                                                value: year,
                                                child: Text(year),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedYear = value!;
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Submit button
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: _isDarkMode ? Color(0xFF252542) : Colors.white,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: _isDarkMode 
                                    ? Color(0xFF4C4DDC).withOpacity(0.5)
                                    : Colors.blue.withOpacity(0.5),
                              ),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Process registration
                              Navigator.pop(context);
                              setState(() {
                                event['registrations']++;
                              });
                              _showRegistrationDialog(
                                'Registration Successful!',
                                'You have successfully registered for ${event["title"]}. We look forward to seeing you!',
                                true
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 3,
                                  color: Colors.black.withOpacity(0.3),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ).animate()
          .fadeIn()
          .scaleXY(begin: 0.95);
      },
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int? maxLines,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: _isDarkMode ? Colors.white70 : Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(
            color: _isDarkMode ? Colors.white : Colors.black,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: _isDarkMode ? Colors.white38 : Colors.grey[400],
            ),
            filled: true,
            fillColor: _isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: _isDarkMode ? Colors.white24 : Colors.grey[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: _isDarkMode ? Colors.white24 : Colors.grey[300]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.red,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
          ),
          validator: validator,
          maxLines: maxLines,
        ),
      ],
    );
  }

  void _showRegistrationDialog(String title, String message, bool isSuccess) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _isDarkMode ? Color(0xFF252542) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSuccess 
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSuccess ? Icons.check_circle : Icons.error,
                    color: isSuccess ? Colors.green : Colors.red,
                    size: 48,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                    color: _isDarkMode ? Colors.white70 : Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSuccess 
                        ? (_isDarkMode ? Color(0xFF4C4DDC) : Colors.blue)
                        : Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    isSuccess ? 'Great!' : 'OK',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ).animate()
          .fadeIn()
          .scaleXY(begin: 0.8);
      },
    );
  }

  void _showCreateEventForm() {
    final _formKey = GlobalKey<FormState>();
    final _titleController = TextEditingController();
    final _descriptionController = TextEditingController();
    final _locationController = TextEditingController();
    final _priceController = TextEditingController();
    final _pointsController = TextEditingController();
    final _capacityController = TextEditingController();
    String _selectedType = 'Workshop';
    DateTime _selectedDate = DateTime.now();
    File? _selectedImage;
    final _imagePicker = ImagePicker();

    Future<void> _pickImage() async {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                  maxWidth: 500,
                ),
                decoration: BoxDecoration(
                  color: _isDarkMode ? Color(0xFF252542) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.event_available,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Create New Event',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    // Form
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFormField(
                                  controller: _titleController,
                                  label: 'Event Title',
                                  icon: Icons.title,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter event title';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Event Type',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: _isDarkMode ? Colors.white70 : Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: _isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: _isDarkMode ? Colors.white24 : Colors.grey[300]!,
                                    ),
                                  ),
                                  child: StatefulBuilder(
                                    builder: (context, setState) {
                                      return DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: _selectedType,
                                          isExpanded: true,
                                          dropdownColor: _isDarkMode ? Color(0xFF252542) : Colors.white,
                                          style: TextStyle(
                                            color: _isDarkMode ? Colors.white : Colors.black,
                                            fontSize: 16,
                                          ),
                                          items: _filters
                                              .where((type) => type != 'All')
                                              .map((type) => DropdownMenuItem(
                                                    value: type,
                                                    child: Text(type),
                                                  ))
                                              .toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedType = value!;
                                            });
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 16),
                                _buildFormField(
                                  controller: _descriptionController,
                                  label: 'Description',
                                  icon: Icons.description,
                                  maxLines: 3,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter event description';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Event Date',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: _isDarkMode ? Colors.white70 : Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: _isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: _isDarkMode ? Colors.white24 : Colors.grey[300]!,
                                    ),
                                  ),
                                  child: StatefulBuilder(
                                    builder: (context, setState) {
                                      return ListTile(
                                        leading: Icon(
                                          Icons.calendar_today,
                                          color: _isDarkMode ? Colors.white38 : Colors.grey[400],
                                        ),
                                        title: Text(
                                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                          style: TextStyle(
                                            color: _isDarkMode ? Colors.white : Colors.black,
                                          ),
                                        ),
                                        onTap: () async {
                                          final DateTime? picked = await showDatePicker(
                                            context: context,
                                            initialDate: _selectedDate,
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime.now().add(Duration(days: 365)),
                                          );
                                          if (picked != null) {
                                            setState(() {
                                              _selectedDate = picked;
                                            });
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 16),
                                _buildFormField(
                                  controller: _locationController,
                                  label: 'Location',
                                  icon: Icons.location_on,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter event location';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildFormField(
                                        controller: _priceController,
                                        label: 'Price (₹)',
                                        icon: Icons.currency_rupee,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Enter price';
                                          }
                                          if (int.tryParse(value) == null) {
                                            return 'Invalid price';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: _buildFormField(
                                        controller: _pointsController,
                                        label: 'Points',
                                        icon: Icons.star,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Enter points';
                                          }
                                          if (int.tryParse(value) == null) {
                                            return 'Invalid points';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                _buildFormField(
                                  controller: _capacityController,
                                  label: 'Capacity',
                                  icon: Icons.people,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter capacity';
                                    }
                                    if (int.tryParse(value) == null) {
                                      return 'Invalid capacity';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Event Image',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: _isDarkMode ? Colors.white70 : Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 8),
                                GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    width: double.infinity,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: _isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: _isDarkMode ? Colors.white24 : Colors.grey[300]!,
                                      ),
                                    ),
                                    child: _selectedImage != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(16),
                                          child: Image.file(
                                            _selectedImage!,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add_photo_alternate,
                                              size: 48,
                                              color: _isDarkMode ? Colors.white38 : Colors.grey[400],
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Click to add event image',
                                              style: TextStyle(
                                                color: _isDarkMode ? Colors.white38 : Colors.grey[400],
                                              ),
                                            ),
                                          ],
                                        ),
                                  ),
                                ).animate()
                                  .fadeIn()
                                  .scaleXY(begin: 0.95)
                                  .then()
                                  .shimmer(delay: Duration(milliseconds: 800)),
                                SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Submit button
                    Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: _isDarkMode ? Color(0xFF252542) : Colors.white,
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(
                                    color: _isDarkMode 
                                        ? Color(0xFF4C4DDC).withOpacity(0.5)
                                        : Colors.blue.withOpacity(0.5),
                                  ),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if (_selectedImage == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Please select an event image'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }
                                  // Create new event
                                  final newEvent = {
                                    'title': _titleController.text,
                                    'type': _selectedType,
                                    'description': _descriptionController.text,
                                    'date': '${_selectedDate.day} ${_getMonthName(_selectedDate.month)}, ${_selectedDate.year}',
                                    'location': _locationController.text,
                                    'image': _selectedImage!.path,
                                    'price': int.parse(_priceController.text),
                                    'points': int.parse(_pointsController.text),
                                    'capacity': int.parse(_capacityController.text),
                                    'registrations': 0,
                                  };

                                  setState(() {
                                    _upcomingEvents.insert(0, newEvent);
                                  });

                                  Navigator.pop(context);
                                  _showEventCreatedDialog();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Create Event',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 3,
                                      color: Colors.black.withOpacity(0.3),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ).animate()
              .fadeIn()
              .scaleXY(begin: 0.95);
          },
        );
      },
    );
  }

  void _showEventCreatedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _isDarkMode ? Color(0xFF252542) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 48,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Event Created Successfully!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  'Your event has been created and is now visible in the upcoming events section.',
                  style: TextStyle(
                    fontSize: 16,
                    color: _isDarkMode ? Colors.white70 : Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Great!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ).animate()
          .fadeIn()
          .scaleXY(begin: 0.8);
      },
    );
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1: return 'Jan';
      case 2: return 'Feb';
      case 3: return 'Mar';
      case 4: return 'Apr';
      case 5: return 'May';
      case 6: return 'Jun';
      case 7: return 'Jul';
      case 8: return 'Aug';
      case 9: return 'Sep';
      case 10: return 'Oct';
      case 11: return 'Nov';
      case 12: return 'Dec';
      default: return '';
    }
  }
}
