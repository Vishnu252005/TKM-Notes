import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../../../firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';  // Add this import for clipboard
import 'event_create.dart';

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
  
  // Firebase instances
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  // Stream of events from Firestore
  late Stream<QuerySnapshot> _eventsStream;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _eventsStream = _firestore.collection('events')
          .orderBy('date', descending: true)
          .snapshots();
      setState(() {}); // Refresh UI after initialization
    } catch (e) {
      print('Error initializing Firebase: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error initializing Firebase: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _createEvent(Map<String, dynamic> eventData) async {
    try {
      // Get current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Get user data from Firestore
      final userData = await _firestore.collection('users').doc(user.uid).get();
      final creatorData = userData.data() ?? {};

      // Add creator ID, creator info and timestamp to event data
      final Map<String, dynamic> finalEventData = {
        ...eventData,
        'createdAt': FieldValue.serverTimestamp(),
        'creatorId': user.uid,
        'creatorInfo': {
          'name': creatorData['name'] ?? 'Unknown User',
          'email': user.email ?? '',
          'photoURL': user.photoURL ?? '',
          'department': creatorData['department'] ?? '',
          'role': creatorData['role'] ?? 'Student',
        },
        'image': 'https://images.unsplash.com/photo-1505373877841-8d25f7d46678', // Default event image
        'registeredUsers': [], // Initialize empty array for registered users
        'registrationCount': 0, // Track number of registrations
        'hasReferralSystem': eventData['hasReferralSystem'] ?? false, // Add referral system flag
        'referralReward': eventData['hasReferralSystem'] ? eventData['referralReward'] : null, // Add referral reward if enabled
      };
      
      // Add to Firestore and get the event reference
      DocumentReference eventRef = await _firestore.collection('events').add(finalEventData);
      
      // Create an empty document in the registrations subcollection to initialize it
      await eventRef.collection('registrations').doc('_info').set({
        'createdAt': FieldValue.serverTimestamp(),
        'totalRegistrations': 0,
        'referrals': [] // Track referrals if enabled
      });
      
    } catch (e) {
      print('Error creating event: $e');
      throw e;
    }
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
            
            CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  expandedHeight: 120,
                  floating: true,
                  pinned: true,
                  backgroundColor: _isDarkMode ? Color(0xFF252542) : Colors.white,
                  flexibleSpace: FlexibleSpaceBar(
                    background: _buildHeader(),
                  ),
                ),

                // Search Bar
                SliverToBoxAdapter(
                  child: _buildSearchBar(),
                ),

                // Featured Events Section
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Featured Events',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Handle see all featured events
                              },
                              child: Text(
                                'See All',
                                style: TextStyle(
                                  color: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 280,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: _firestore.collection('events')
                              .where('isFeatured', isEqualTo: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }

                            final featuredEvents = snapshot.data!.docs;
                            return ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              scrollDirection: Axis.horizontal,
                              itemCount: featuredEvents.length,
                              itemBuilder: (context, index) {
                                final event = featuredEvents[index].data() as Map<String, dynamic>;
                                return _buildFeaturedEventCard(event);
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),

                // Categories Section
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
                        child: Text(
                          'Browse by Category',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        height: 120,
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: _filters.length,
                          itemBuilder: (context, index) {
                            return _buildCategoryCard(_filters[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // All Events Section Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'All Events',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.sort,
                                color: _isDarkMode ? Colors.white70 : Colors.grey[700],
                              ),
        onPressed: () {
                                // Show sort options
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.filter_list,
                                color: _isDarkMode ? Colors.white70 : Colors.grey[700],
                              ),
                              onPressed: () => _showFilterBottomSheet(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Events List
                StreamBuilder<QuerySnapshot>(
                  stream: _eventsStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Text('Error loading events: ${snapshot.error}'),
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final events = _filterEvents(snapshot.data!.docs);
                    
                    if (events.isEmpty) {
                      return SliverToBoxAdapter(
                        child: _buildEmptyState(),
                      );
                    }

                    return SliverPadding(
                      padding: EdgeInsets.fromLTRB(24, 0, 24, 100),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _buildEventCard(events[index]),
                          childCount: events.length,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateEventForm(),
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

  Widget _buildFeaturedEventCard(Map<String, dynamic> event) {
    return Container(
      width: 300,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: _isDarkMode ? Color(0xFF252542) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _isDarkMode 
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Featured Event Image
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            child: Image.network(
              event['image'],
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Gradient Overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 160,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),

          // Featured Badge
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: (_isDarkMode ? Color(0xFF4C4DDC) : Colors.blue).withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 14,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Featured',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Event Info
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isDarkMode ? Color(0xFF252542) : Colors.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event['title'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _isDarkMode ? Colors.white : Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: _isDarkMode ? Colors.white60 : Colors.grey[600],
                      ),
                      SizedBox(width: 4),
                      Text(
                        event['date'],
                        style: TextStyle(
                          fontSize: 12,
                          color: _isDarkMode ? Colors.white60 : Colors.grey[600],
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: _isDarkMode ? Colors.white60 : Colors.grey[600],
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event['location'],
                          style: TextStyle(
                            fontSize: 12,
                            color: _isDarkMode ? Colors.white60 : Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${event['price']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                        ),
                      ),
                      TextButton(
                        onPressed: () => _showEventDetails(context, event),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          backgroundColor: (_isDarkMode ? Color(0xFF4C4DDC) : Colors.blue).withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'View Details',
                          style: TextStyle(
                            color: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn()
      .slideX(begin: 0.2, end: 0);
  }

  Widget _buildCategoryCard(String category) {
    final isSelected = _selectedFilter == category;
    final color = _getEventTypeColor(category);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = isSelected ? 'All' : category;
        });
      },
      child: Container(
        width: 100,
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.1)
              : (_isDarkMode ? Color(0xFF252542) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: _isDarkMode 
                  ? Colors.black.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? color
                    : color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getEventTypeIcon(category),
                color: isSelected
                    ? Colors.white
                    : color,
                size: 24,
              ),
            ),
            SizedBox(height: 8),
            Text(
              category,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? color
                    : (_isDarkMode ? Colors.white70 : Colors.grey[700]),
              ),
            ),
          ],
        ),
      ),
    ).animate()
      .fadeIn()
      .scale(delay: Duration(milliseconds: 100));
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(24),
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _isDarkMode ? Colors.white38 : Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your filters or search terms',
            style: TextStyle(
              fontSize: 16,
              color: _isDarkMode ? Colors.white24 : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _filterEvents(List<QueryDocumentSnapshot> docs) {
    List<Map<String, dynamic>> events = docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final Timestamp timestamp = data['date'] as Timestamp;
      final DateTime eventDate = timestamp.toDate();
      
      return {
        ...data,
        'id': doc.id,
        'dateTime': eventDate,
        'date': '${eventDate.day} ${_getMonthName(eventDate.month)}, ${eventDate.year}',
      };
    }).toList();

    if (_searchQuery.isNotEmpty) {
      events = events.where((event) {
        return event['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
               event['description'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    if (_selectedFilter != 'All') {
      events = events.where((event) => event['type'] == _selectedFilter).toList();
    }

    events = events.where((event) {
      final price = (event['price'] ?? 0) as num;
      return price >= _priceRange.start && price <= _priceRange.end;
    }).toList();

    events = events.where((event) {
      final points = (event['points'] ?? 0) as num;
      return points >= _pointsRange.start && points <= _pointsRange.end;
    }).toList();

    if (_selectedCapacity != 'All') {
      events = events.where((event) {
        final registrations = (event['registrations'] ?? 0) as num;
        final capacity = (event['capacity'] ?? 0) as num;
        if (capacity == 0) return false;
        
        final percentage = (registrations / capacity * 100).round();
        switch (_selectedCapacity) {
          case 'Available':
            return percentage < 80;
          case 'Almost Full':
            return percentage >= 80 && percentage < 100;
          case 'Full':
            return percentage >= 100;
          default:
            return true;
        }
      }).toList();
    }

    if (_selectedDate != 'All') {
      final now = DateTime.now();
      events = events.where((event) {
        final eventDate = event['dateTime'] as DateTime;
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

    return events;
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

  Widget _buildEventCard(Map<String, dynamic> event) {
    final registrationPercentage = (event['registrations'] / event['capacity'] * 100).round();
    final spotsLeft = event['capacity'] - event['registrations'];
    final bool isFull = spotsLeft == 0;
    final eventColor = _getEventTypeColor(event['type']);

    return Container(
      margin: EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: _isDarkMode ? Color(0xFF252542) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _isDarkMode 
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: _isDarkMode 
              ? eventColor.withOpacity(0.3)
              : Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and overlay section
          Stack(
            children: [
              // Event image with gradient overlay
              Container(
                        height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  image: DecorationImage(
                    image: NetworkImage(event['image']),
                        fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.2),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Event type badge
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                    color: eventColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: eventColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                        _getEventTypeIcon(event['type']),
                        color: Colors.white,
                        size: 16,
                      ),
                      SizedBox(width: 6),
                          Text(
                        event['type'],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                          fontSize: 12,
                            ),
                          ),
                        ],
                  ),
                      ),
                    ).animate()
                .fadeIn(delay: Duration(milliseconds: 300))
                .slideX(begin: -0.2, end: 0),

              // Points and price badges
              Positioned(
                top: 16,
                right: 16,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: (_isDarkMode ? Color(0xFF4C4DDC) : Colors.blue).withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: (_isDarkMode ? Color(0xFF4C4DDC) : Colors.blue).withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${event['points']} pts',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                            Icons.currency_rupee_rounded,
                            color: Colors.white,
                            size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                            '${event['price']}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                              fontSize: 12,
                        ),
                      ),
                    ],
                  ),
              ),
            ],
          ),
              ).animate()
                .fadeIn(delay: Duration(milliseconds: 400))
                .slideX(begin: 0.2, end: 0),

              // Event title and date at the bottom of image
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    Text(
                      event['title'],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 4,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                          children: [
                            Icon(
                          Icons.calendar_today,
                          color: Colors.white70,
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                          event['date'],
                              style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 16),
                        Icon(
                          Icons.location_on,
                          color: Colors.white70,
                          size: 16,
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            event['location'],
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                            ),
                          ],
                        ),
                      ).animate()
                .fadeIn(delay: Duration(milliseconds: 500))
                .slideY(begin: 0.2, end: 0),
            ],
          ),

          // Content section
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['description'],
                  style: TextStyle(
                    fontSize: 16,
                    color: _isDarkMode ? Colors.white70 : Colors.grey[600],
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 20),

                // Registration progress bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Registration Progress',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _isDarkMode ? Colors.white70 : Colors.grey[700],
                          ),
                        ),
                        Text(
                          '$registrationPercentage% Full',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isFull
                                ? Colors.red[400]
                                : registrationPercentage > 80
                                    ? Colors.orange[400]
                                    : Colors.green[400],
                          ),
                      ),
                    ],
                  ),
                    SizedBox(height: 8),
                    Stack(
                      children: [
                        // Background
                Container(
                          height: 8,
                  decoration: BoxDecoration(
                    color: _isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        // Progress
                        Container(
                          height: 8,
                          width: (MediaQuery.of(context).size.width - 88) * (registrationPercentage / 100),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isFull
                                  ? [Colors.red[700]!, Colors.red[400]!]
                                  : registrationPercentage > 80
                                      ? [Colors.orange[700]!, Colors.orange[400]!]
                                      : [Colors.green[700]!, Colors.green[400]!],
                            ),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: isFull
                                    ? Colors.red.withOpacity(0.3)
                                    : registrationPercentage > 80
                                        ? Colors.orange.withOpacity(0.3)
                                        : Colors.green.withOpacity(0.3),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${event['registrations']}/${event['capacity']} registered',
                      style: TextStyle(
                        fontSize: 12,
                        color: _isDarkMode ? Colors.white60 : Colors.grey[600],
                          ),
                        ),
                        if (!isFull)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.green.withOpacity(0.2),
                              ),
                            ),
                            child: Text(
                              '$spotsLeft spots left',
                      style: TextStyle(
                        fontSize: 12,
                                color: Colors.green[400],
                        fontWeight: FontWeight.bold,
                              ),
                      ),
                    ),
                  ],
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          _showEventDetails(context, event);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: _isDarkMode 
                              ? Colors.white.withOpacity(0.1)
                              : Colors.blue.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 20,
                              color: _isDarkMode ? Colors.white70 : Colors.blue,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                                color: _isDarkMode ? Colors.white70 : Colors.blue,
                          ),
                        ),
                          ],
                      ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isFull ? null : () {
                          _handleRegistration(event);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                          disabledBackgroundColor: _isDarkMode 
                              ? Colors.grey[800]
                              : Colors.grey[300],
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isFull ? Icons.event_busy : Icons.how_to_reg,
                              size: 20,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              isFull ? 'Full' : 'Register',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                              ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: Duration(milliseconds: 600))
      .scale(begin: Offset(0.95, 0.95), end: Offset(1, 1))
      .then()
      .shimmer(duration: Duration(milliseconds: 1200));
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
        return _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue;
      case 'seminar':
        return _isDarkMode ? Color(0xFF4C4DDC).withBlue(220) : Colors.blue[600]!;
      case 'conference':
        return _isDarkMode ? Color(0xFF4C4DDC).withGreen(100) : Colors.blue[700]!;
      case 'hackathon':
        return _isDarkMode ? Color(0xFF4C4DDC).withRed(100) : Colors.blue[800]!;
      default:
        return _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue;
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
    final bool isCreator = FirebaseAuth.instance.currentUser?.uid == event['creatorId'];

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
              maxWidth: 600,
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
                      child: Row(
                        children: [
                          if (isCreator) ...[
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(Icons.edit, color: Colors.white),
                                onPressed: () {
                                  Navigator.pop(context);
                                  _showEditEventForm(event);
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(Icons.delete, color: Colors.white),
                                onPressed: () => _showDeleteEventConfirmation(event),
                              ),
                            ),
                            SizedBox(width: 8),
                          ],
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.close, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ],
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
                              // Event description
                              Text(
                                event['description'],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _isDarkMode ? Colors.white70 : Colors.grey[600],
                                  height: 1.5,
                                ),
                              ),
                              SizedBox(height: 24),
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
                                    // Creator Information Section
                                    Divider(
                                      height: 32,
                                      color: _isDarkMode ? Colors.white24 : Colors.grey[300],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.person_outline,
                                          color: _isDarkMode ? Colors.white70 : Colors.grey[700],
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Event Creator',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: _isDarkMode ? Colors.white : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: _isDarkMode ? Colors.black.withOpacity(0.3) : Colors.blue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: _isDarkMode ? Colors.white24 : Colors.blue.withOpacity(0.2),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: _isDarkMode ? Colors.white10 : Colors.blue.withOpacity(0.1),
                                                  image: event['creatorInfo']?['photoURL'] != null && event['creatorInfo']['photoURL'].isNotEmpty
                                                      ? DecorationImage(
                                                          image: NetworkImage(event['creatorInfo']['photoURL']),
                                                          fit: BoxFit.cover,
                                                        )
                                                      : null,
                                                ),
                                                child: event['creatorInfo']?['photoURL'] == null || event['creatorInfo']['photoURL'].isEmpty
                                                    ? Icon(
                                                        Icons.person,
                                                        color: _isDarkMode ? Colors.white70 : Colors.blue,
                                                        size: 24,
                                                      )
                                                    : null,
                                              ),
                                              SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      event['creatorInfo']?['name'] ?? 'Unknown User',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        color: _isDarkMode ? Colors.white : Colors.black,
                                                      ),
                                                    ),
                                                    if (event['creatorInfo']?['role'] != null)
                                                      Text(
                                                        event['creatorInfo']['role'],
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: _isDarkMode ? Colors.white70 : Colors.grey[600],
                                                        ),
                                                      ),
                                                    if (event['creatorInfo']?['department'] != null)
                                                      Text(
                                                        event['creatorInfo']['department'],
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: _isDarkMode ? Colors.white70 : Colors.grey[600],
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (event['creatorInfo']?['email'] != null) ...[
                                            SizedBox(height: 12),
                                            Divider(
                                              color: _isDarkMode ? Colors.white10 : Colors.grey[300],
                                            ),
                                            SizedBox(height: 12),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: _isDarkMode ? Colors.white10 : Colors.blue.withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Icon(
                                                    Icons.email,
                                                    color: _isDarkMode ? Colors.white70 : Colors.blue,
                                                    size: 20,
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    event['creatorInfo']['email'],
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: _isDarkMode ? Colors.white70 : Colors.grey[600],
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.copy,
                                                    color: _isDarkMode ? Colors.white70 : Colors.blue,
                                                  ),
                                                  onPressed: () async {
                                                    await Clipboard.setData(ClipboardData(
                                                      text: event['creatorInfo']['email'],
                                                    ));
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text('Email copied!'),
                                                        backgroundColor: Colors.green,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    // Contact Information Section
                                    if (event['contactDetails'] != null) ...[
                                      Divider(
                                        height: 32,
                                        color: _isDarkMode ? Colors.white24 : Colors.grey[300],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.contact_phone,
                                            color: _isDarkMode ? Colors.white70 : Colors.grey[700],
                                            size: 20,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Contact Information',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: _isDarkMode ? Colors.white : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12),
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: _isDarkMode ? Colors.black.withOpacity(0.2) : Colors.blue.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: _isDarkMode ? Colors.white24 : Colors.blue.withOpacity(0.2),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: _isDarkMode ? Colors.white10 : Colors.blue.withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Icon(
                                                    Icons.phone,
                                                    color: _isDarkMode ? Colors.white70 : Colors.blue,
                                                    size: 20,
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Phone',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: _isDarkMode ? Colors.white70 : Colors.grey[600],
                                                        ),
                                                      ),
                                                      SizedBox(height: 4),
                                                      Text(
                                                        event['contactDetails']['phone'],
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                          color: _isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.copy,
                                                    color: _isDarkMode ? Colors.white70 : Colors.blue,
                                                  ),
                                                  onPressed: () async {
                                                    await Clipboard.setData(ClipboardData(
                                                      text: event['contactDetails']['phone'],
                                                    ));
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text('Phone number copied!'),
                                                        backgroundColor: Colors.green,
                                                      ),
                                                    );
                                                  },
                        ),
                      ],
                    ),
                                            SizedBox(height: 12),
                                            Divider(
                                              color: _isDarkMode ? Colors.white10 : Colors.grey[300],
                                            ),
                                            SizedBox(height: 12),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: _isDarkMode ? Colors.white10 : Colors.blue.withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Icon(
                                                    Icons.email,
                                                    color: _isDarkMode ? Colors.white70 : Colors.blue,
                                                    size: 20,
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Email',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: _isDarkMode ? Colors.white70 : Colors.grey[600],
                                                        ),
                                                      ),
                                                      SizedBox(height: 4),
                                                      Text(
                                                        event['contactDetails']['email'],
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                          color: _isDarkMode ? Colors.white : Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.copy,
                                                    color: _isDarkMode ? Colors.white70 : Colors.blue,
                                                  ),
                                                  onPressed: () async {
                                                    await Clipboard.setData(ClipboardData(
                                                      text: event['contactDetails']['email'],
                                                    ));
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text('Email address copied!'),
                                                        backgroundColor: Colors.green,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
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

  void _handleRegistration(Map<String, dynamic> event) async {
    // Check if user is authenticated
    if (FirebaseAuth.instance.currentUser == null) {
      _showAuthRequiredDialog('register for events');
      return;
    }

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
    final _emailController = TextEditingController();
    final _phoneController = TextEditingController();
    final _collegeController = TextEditingController();
    final _deptController = TextEditingController();
    final _transactionIdController = TextEditingController();
    final _specialIdController = TextEditingController();
    final _referralIdController = TextEditingController();
    String _selectedYear = '1st Year';
    String _needsAccommodation = 'No';  // Default value
    Map<String, dynamic>? _selectedPriceCategory;

    // Set Non-IEEE Member as default
    if (event['hasSpecialPrices'] == true && event['specialPrices'] != null) {
      List<dynamic> prices = event['specialPrices'] as List;
      for (var price in prices) {
        if ((price['name'] as String).toLowerCase().contains('non-ieee')) {
          _selectedPriceCategory = price as Map<String, dynamic>;
          break;
        }
      }
      // If somehow Non-IEEE option is not found, take the first option
      if (_selectedPriceCategory == null && prices.isNotEmpty) {
        _selectedPriceCategory = prices.first as Map<String, dynamic>;
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool isIEEEMember() {
              if (_selectedPriceCategory == null) return false;
              String category = _selectedPriceCategory!['name'].toString().toLowerCase();
              // Only return true for IEEE Member, not for Non-IEEE Member
              return category == 'ieee member';
            }

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
                              Icon(Icons.app_registration, color: Colors.white, size: 24),
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
                // Form content
                        Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                              // Event Details Section
                              Text(
                                'Event Details',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                              SizedBox(height: 16),
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: _isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey[50],
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: _isDarkMode ? Colors.white10 : Colors.grey[200]!,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event['title'],
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: _isDarkMode ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 24),

                              // Personal Details Section
                              Text(
                                'Personal Details',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                              SizedBox(height: 16),
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
                                controller: _emailController,
                                label: 'Email Address',
                                icon: Icons.email,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email address';
                                  }
                                  if (!value.contains('@') || !value.contains('.')) {
                                    return 'Please enter a valid email address';
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
                              SizedBox(height: 24),

                              // Price Category Section (if applicable)
                              if (event['hasSpecialPrices'] == true && event['specialPrices'] != null) ...[
                                Text(
                                  'Price Category',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _isDarkMode ? Colors.white : Colors.black,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: _isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey[50],
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: _isDarkMode ? Colors.white10 : Colors.grey[200]!,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        decoration: BoxDecoration(
                                          color: _isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey[100],
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: _isDarkMode ? Colors.white24 : Colors.grey[300]!,
                                          ),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<Map<String, dynamic>>(
                                            value: _selectedPriceCategory,
                                            isExpanded: true,
                                            dropdownColor: _isDarkMode ? Color(0xFF252542) : Colors.white,
                                            style: TextStyle(
                                              color: _isDarkMode ? Colors.white : Colors.black,
                                              fontSize: 16,
                                            ),
                                            items: (event['specialPrices'] as List).map<DropdownMenuItem<Map<String, dynamic>>>((price) {
                                              return DropdownMenuItem<Map<String, dynamic>>(
                                                value: price as Map<String, dynamic>,
                                                child: Text('${price['name']} - Rs. ${price['amount']}'),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedPriceCategory = value;
                                                if (!isIEEEMember()) {
                                                  _specialIdController.clear();
                                                }
                                                // Force rebuild to update payment amount
                                                setState(() {});
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      if (isIEEEMember()) ...[
                                        SizedBox(height: 16),
                                        _buildFormField(
                                          controller: _specialIdController,
                                          label: 'IEEE ID',
                                          icon: Icons.badge,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'IEEE ID is required for IEEE members';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                SizedBox(height: 24),
                              ],

                              // Institution Details Section
                              Text(
                                'Institution Details',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _isDarkMode ? Colors.white : Colors.black,
                                ),
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
                          DropdownButtonFormField<String>(
                            value: _selectedYear,
                            decoration: InputDecoration(
                              labelText: 'Year of Study',
                                  labelStyle: TextStyle(
                                    color: _isDarkMode ? Colors.white70 : Colors.grey[700],
                                  ),
                                  prefixIcon: Icon(
                                    Icons.calendar_today,
                                    color: _isDarkMode ? Colors.white38 : Colors.grey[400],
                                  ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: _isDarkMode ? Colors.white24 : Colors.grey[300]!,
                                    ),
                                  ),
                                ),
                                dropdownColor: _isDarkMode ? Color(0xFF252542) : Colors.white,
                                style: TextStyle(
                                  color: _isDarkMode ? Colors.white : Colors.black,
                            ),
                            items: [
                              '1st Year',
                              '2nd Year',
                              '3rd Year',
                              '4th Year',
                              '5th Year',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        color: _isDarkMode ? Colors.white : Colors.black,
                                      ),
                                    ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                _selectedYear = newValue;
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select your year of study';
                              }
                              return null;
                            },
                              ),
                              SizedBox(height: 24),

                              // Payment Section
                              if (event['requiresPayment']) ...[
                                Text(
                                  'Payment Details',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _isDarkMode ? Colors.white : Colors.black,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: _isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey[50],
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: _isDarkMode ? Colors.white10 : Colors.grey[200]!,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Amount to Pay: Rs. ${_selectedPriceCategory != null ? _selectedPriceCategory!['amount'] : event['price']}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: _isDarkMode ? Colors.white : Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Pay using any of these methods:',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: _isDarkMode ? Colors.white70 : Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: _isDarkMode ? Colors.black.withOpacity(0.3) : Colors.blue.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: _isDarkMode ? Colors.white24 : Colors.blue.withOpacity(0.2),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: _isDarkMode ? Colors.white10 : Colors.blue.withOpacity(0.1),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Icon(
                                                    Icons.phone_android,
                                                    color: _isDarkMode ? Colors.white70 : Colors.blue,
                                                    size: 20,
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Phone Pay / GPay',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: _isDarkMode ? Colors.white70 : Colors.grey[600],
                                                        ),
                                                      ),
                                                      SizedBox(height: 4),
                                                      Text(
                                                        event['paymentDetails']['phoneNumber'],
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                          color: _isDarkMode ? Colors.white : Colors.black,
                                                        ),
                          ),
                        ],
                      ),
                    ),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.copy,
                                                    color: _isDarkMode ? Colors.white70 : Colors.blue,
                                                  ),
                                                  onPressed: () async {
                                                    await Clipboard.setData(ClipboardData(
                                                      text: event['paymentDetails']['phoneNumber'],
                                                    ));
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'Phone number copied!',
                                                          style: TextStyle(color: Colors.white),
                                                        ),
                                                        backgroundColor: Colors.green,
                                                        behavior: SnackBarBehavior.floating,
                                                        margin: EdgeInsets.all(16),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        duration: Duration(seconds: 2),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                            if (event['paymentDetails']['hasUpiId']) ...[
                                              SizedBox(height: 12),
                                              Divider(
                                                color: _isDarkMode ? Colors.white10 : Colors.grey[300],
                                              ),
                                              SizedBox(height: 12),
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: _isDarkMode ? Colors.white10 : Colors.blue.withOpacity(0.1),
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Icon(
                                                      Icons.account_balance_wallet,
                                                      color: _isDarkMode ? Colors.white70 : Colors.blue,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  SizedBox(width: 12),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'UPI ID',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: _isDarkMode ? Colors.white70 : Colors.grey[600],
                                                          ),
                                                        ),
                                                        SizedBox(height: 4),
                                                        Text(
                                                          event['paymentDetails']['upiId'],
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                            color: _isDarkMode ? Colors.white : Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.copy,
                                                      color: _isDarkMode ? Colors.white70 : Colors.blue,
                                                    ),
                                                    onPressed: () async {
                                                      await Clipboard.setData(ClipboardData(
                                                        text: event['paymentDetails']['upiId'],
                                                      ));
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            'UPI ID copied!',
                                                            style: TextStyle(color: Colors.white),
                                                          ),
                                                          backgroundColor: Colors.green,
                                                          behavior: SnackBarBehavior.floating,
                                                          margin: EdgeInsets.all(16),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(12),
                                                          ),
                                                          duration: Duration(seconds: 2),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'After payment, enter the transaction ID below:',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: _isDarkMode ? Colors.white70 : Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16),
                                _buildFormField(
                                  controller: _transactionIdController,
                                  label: 'Transaction ID',
                                  icon: Icons.receipt_long,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the transaction ID';
                                    }
                                    return null;
                                  },
                                  hintText: 'Enter your payment transaction ID',
                                ),
                              ],

                              // Accommodation Section
                              if (event['accommodation']['available']) ...[
                                SizedBox(height: 24),
                                Text(
                                  'Accommodation',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _isDarkMode ? Colors.white : Colors.black,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: _isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey[50],
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: _isDarkMode ? Colors.white10 : Colors.grey[200]!,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (event['accommodation']['hasPricing']) ...[
                                        Text(
                                          'Price: ₹${event['accommodation']['price']}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: _isDarkMode ? Colors.white : Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                      ],
                                      if (event['accommodation']['hasDetails'])
                                        Text(
                                          event['accommodation']['details'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: _isDarkMode ? Colors.white70 : Colors.grey[700],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  value: _needsAccommodation,
                                  decoration: InputDecoration(
                                    labelText: 'Need Accommodation?',
                                    labelStyle: TextStyle(
                                      color: _isDarkMode ? Colors.white70 : Colors.grey[700],
                                    ),
                                    prefixIcon: Icon(
                                      Icons.hotel,
                                      color: _isDarkMode ? Colors.white38 : Colors.grey[400],
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: _isDarkMode ? Colors.white24 : Colors.grey[300]!,
                                      ),
                                    ),
                                  ),
                                  dropdownColor: _isDarkMode ? Color(0xFF252542) : Colors.white,
                                  style: TextStyle(
                                    color: _isDarkMode ? Colors.white : Colors.black,
                                  ),
                                  items: ['Yes', 'No'].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          color: _isDarkMode ? Colors.white : Colors.black,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      _needsAccommodation = newValue;
                                    }
                                  },
                                ),
                              ],

                              // Add Referral ID section if enabled
                              if (event['hasReferralId'] == true) Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 24),
                                  Text(
                                    'Referral Details',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: _isDarkMode ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  _buildFormField(
                                    controller: _referralIdController,
                                    label: 'Referral ID',
                                    icon: Icons.person_add,
                                    validator: (value) {
                                      // Referral ID is optional
                                      return null;
                                    },
                                    hintText: 'Enter referral ID (optional)',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Submit button container
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: _isDarkMode ? Colors.white10 : Colors.grey[200]!,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                // Show loading
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );

                                // Get current user
                                final user = FirebaseAuth.instance.currentUser;
                                if (user == null) {
                                  Navigator.pop(context); // Close loading
                                  Navigator.pop(context); // Close form
                                  _showAuthRequiredDialog('register for events');
                                  return;
                                }

                                // Get event reference
                                final eventRef = FirebaseFirestore.instance
                                    .collection('events')
                                    .doc(event['id']);

                                // Create registration data
                                final registrationData = {
                                  'userId': user.uid,
                                  'name': _nameController.text,
                                  'email': _emailController.text,
                                  'phone': _phoneController.text,
                                  'college': _collegeController.text,
                                  'department': _deptController.text,
                                  'year': _selectedYear,
                                  'registeredAt': FieldValue.serverTimestamp(),
                                  'needsAccommodation': _needsAccommodation == 'Yes',
                                  'transaction_id': _transactionIdController.text.trim(),  // Save with consistent field name
                                  if (event['hasSpecialPrices'] == true)
                                    'priceCategory': _selectedPriceCategory,
                                  if (isIEEEMember())
                                    'ieeeId': _specialIdController.text,
                                  if (event['hasReferralId'] == true && _referralIdController.text.isNotEmpty)
                                    'referralId': _referralIdController.text,
                                };

                                // Start a batch write
                                final batch = FirebaseFirestore.instance.batch();

                                // 1. Add user to event's registeredUsers array
                                batch.update(eventRef, {
                                  'registeredUsers': FieldValue.arrayUnion([user.uid]),
                                  'registrations': FieldValue.increment(1)
                                });

                                // 2. Create registration document in event's registrations subcollection
                                    final registrationRef = eventRef.collection('registrations').doc();
                                batch.set(registrationRef, registrationData);

                                // 3. Create registration document in user's registrations collection
                                final userRegistrationRef = FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .collection('registrations')
                                        .doc(registrationRef.id);
                                batch.set(userRegistrationRef, registrationData);

                                // Commit the batch
                                await batch.commit();

                                // Close loading and form
                                Navigator.pop(context); // Close loading
                                Navigator.pop(context); // Close form

                                // Show success message
                                _showRegistrationDialog(
                                  'Registration Successful!',
                                      'You have successfully registered for ${event["title"]}. Your payment will be verified shortly.',
                                  true
                                );
                              } catch (e) {
                                // Close loading
                                Navigator.pop(context);
                                Navigator.pop(context);

                                // Show error message
                                _showRegistrationDialog(
                                  'Registration Failed',
                                  'An error occurred while registering. Please try again later.',
                                  false
                                );
                              }
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
            );
          },
        );
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
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: _isDarkMode ? Colors.white : Colors.grey[700],
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
                color: _isDarkMode ? Colors.white : Colors.blue,
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
            hintText: hintText,
            hintStyle: TextStyle(
              color: _isDarkMode ? Colors.white38 : Colors.grey[400],
            ),
            labelStyle: TextStyle(
              color: _isDarkMode ? Colors.white70 : Colors.grey[700],
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
    // Check if user is authenticated
    if (FirebaseAuth.instance.currentUser == null) {
      _showAuthRequiredDialog('create events');
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EventCreateScreen(
          isDarkMode: _isDarkMode,
          showSuccessMessage: _showSuccessMessage,
          showAuthRequiredDialog: _showAuthRequiredDialog,
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

  void _showAuthRequiredDialog(String action) {
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
                    color: Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_outline,
                    color: Colors.orange,
                    size: 48,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Authentication Required',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? Colors.white : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  'Please sign in or create an account to ${action}.',
                  style: TextStyle(
                    fontSize: 16,
                    color: _isDarkMode ? Colors.white70 : Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _isDarkMode ? Colors.white70 : Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Navigate to profile screen for authentication
                          Navigator.pushNamed(context, '/profile');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
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

  void _showEditEventForm(Map<String, dynamic> event) {
    if (FirebaseAuth.instance.currentUser?.uid != event['creatorId']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You don't have permission to edit this event")),
      );
      return;
    }

    final _formKey = GlobalKey<FormState>();
    final _titleController = TextEditingController(text: event['title']);
    final _descriptionController = TextEditingController(text: event['description']);
    final _locationController = TextEditingController(text: event['location']);
    final _priceController = TextEditingController(text: event['price'].toString());
    final _pointsController = TextEditingController(text: event['points'].toString());
    final _capacityController = TextEditingController(text: event['capacity'].toString());
    String _selectedType = event['type'];
    DateTime _selectedDate = (event['date'] as Timestamp).toDate();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.edit, color: Colors.blue[800]),
              SizedBox(width: 8),
              Text('Edit Event'),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildFormField(
                    controller: _titleController,
                    label: 'Event Title',
                    icon: Icons.title,
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedType,
                    decoration: InputDecoration(
                      labelText: 'Event Type',
                      prefixIcon: Icon(Icons.category),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: ['Workshop', 'Seminar', 'Conference', 'Hackathon']
                        .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                        .toList(),
                    onChanged: (value) => _selectedType = value!,
                  ),
                  SizedBox(height: 16),
                  _buildFormField(
                    controller: _descriptionController,
                    label: 'Description',
                    icon: Icons.description,
                    maxLines: 3,
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  SizedBox(height: 16),
                  ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: Text('Event Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (picked != null) {
                        _selectedDate = picked;
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  _buildFormField(
                    controller: _locationController,
                    label: 'Location',
                    icon: Icons.location_on,
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFormField(
                          controller: _priceController,
                          label: 'Price',
                          icon: Icons.currency_rupee,
                          keyboardType: TextInputType.number,
                          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildFormField(
                          controller: _pointsController,
                          label: 'Points',
                          icon: Icons.star,
                          keyboardType: TextInputType.number,
                          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
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
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    // Update event in Firestore
                    await _firestore.collection('events').doc(event['id']).update({
                      'title': _titleController.text,
                      'type': _selectedType,
                      'description': _descriptionController.text,
                      'date': Timestamp.fromDate(_selectedDate),
                      'location': _locationController.text,
                      'price': int.parse(_priceController.text),
                      'points': int.parse(_pointsController.text),
                      'capacity': int.parse(_capacityController.text),
                    });

                    Navigator.pop(context);
                    _showSuccessMessage('Event updated successfully!', Icons.check_circle);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error updating event: $e')),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
              ),
              child: Text('Update Event'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteEventConfirmation(Map<String, dynamic> event) {
    if (FirebaseAuth.instance.currentUser?.uid != event['creatorId']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You don't have permission to delete this event")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Event'),
          content: Text('Are you sure you want to delete this event? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _firestore.collection('events').doc(event['id']).delete();
                  Navigator.pop(context); // Close confirmation dialog
                  Navigator.pop(context); // Close event details dialog
                  _showSuccessMessage('Event deleted successfully!', Icons.check_circle);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting event: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessMessage(String message, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.all(16),
      ),
    );
  }
}
