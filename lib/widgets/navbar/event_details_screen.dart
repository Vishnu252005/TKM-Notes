import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class EventDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> eventData;
  final bool isCreated;
  final bool isDarkMode;

  EventDetailsScreen({
    required this.eventData,
    required this.isCreated,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF1A1A2E) : Colors.blue[50],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image with Gradient Overlay
            Stack(
              children: [
                Image.network(
                  eventData['image'] ?? 'https://images.unsplash.com/photo-1505373877841-8d25f7d46678',
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 250,
                  decoration: BoxDecoration(
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
                // Back Button
                Positioned(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                // Event Title and Type
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getEventTypeColor(eventData['type']).withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          eventData['type'] ?? 'Event',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        eventData['title'] ?? 'Untitled Event',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Event Details
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date and Location
                  _buildDetailRow(
                    Icons.calendar_today,
                    'Date',
                    eventData['date'] ?? 'Not specified',
                    isDarkMode,
                  ),
                  SizedBox(height: 12),
                  _buildDetailRow(
                    Icons.location_on,
                    'Location',
                    eventData['location'] ?? 'Not specified',
                    isDarkMode,
                  ),
                  SizedBox(height: 12),
                  _buildDetailRow(
                    Icons.currency_rupee,
                    'Price',
                    '₹${eventData['price'] ?? 0}',
                    isDarkMode,
                  ),
                  SizedBox(height: 12),
                  _buildDetailRow(
                    Icons.star,
                    'Points',
                    '${eventData['points'] ?? 0} points',
                    isDarkMode,
                  ),
                  
                  // Description
                  SizedBox(height: 24),
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    eventData['description'] ?? 'No description available',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.white70 : Colors.grey[800],
                      height: 1.5,
                    ),
                  ),

                  // Registration Info
                  SizedBox(height: 24),
                  _buildRegistrationInfo(eventData, isDarkMode),

                  // Creator Info
                  if (eventData['creatorInfo'] != null) ...[
                    SizedBox(height: 24),
                    _buildCreatorInfo(eventData['creatorInfo'], isDarkMode),
                  ],

                  // Contact Details
                  if (eventData['contactDetails'] != null) ...[
                    SizedBox(height: 24),
                    _buildContactInfo(eventData['contactDetails'], isDarkMode),
                  ],

                  // WhatsApp Group Info
                  if (eventData['hasWhatsappGroup'] == true) ...[
                    SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDarkMode ? Colors.white24 : Colors.grey[300]!,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'WhatsApp Group',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(height: 12),
                          InkWell(
                            onTap: () async {
                              final link = eventData['whatsappLink'];
                              if (link != null) {
                                await Clipboard.setData(ClipboardData(text: link));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('WhatsApp group link copied to clipboard')),
                                );
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isDarkMode ? Colors.white24 : Colors.grey[300]!,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      eventData['whatsappLink'] ?? 'No link available',
                                      style: TextStyle(
                                        color: isDarkMode ? Colors.blue[400] : Colors.blue[700],
                                        decoration: TextDecoration.underline,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Icon(
                                    Icons.copy,
                                    size: 20,
                                    color: isDarkMode ? Colors.white70 : Colors.grey[600],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tap to copy the link',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkMode ? Colors.white60 : Colors.grey[600],
                            ),
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
      bottomNavigationBar: _buildBottomBar(context, eventData, isDarkMode),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, bool isDarkMode) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.blue[900]!.withOpacity(0.2) : Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isDarkMode ? Colors.blue[400] : Colors.blue[800],
          ),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white60 : Colors.grey[600],
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRegistrationInfo(Map<String, dynamic> eventData, bool isDarkMode) {
    final registrations = (eventData['registeredUsers'] as List?)?.length ?? 0;
    final capacity = eventData['capacity'] ?? 0;
    final isFull = registrations >= capacity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Registration',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available Spots',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.grey[700],
                    ),
                  ),
                  Text(
                    '$registrations/$capacity',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isFull ? Colors.red : Colors.green,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: capacity > 0 ? registrations / capacity : 0,
                  backgroundColor: isDarkMode ? Colors.white10 : Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(
                    isFull ? Colors.red : Colors.green,
                  ),
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCreatorInfo(Map<String, dynamic> creatorInfo, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event Creator',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: isDarkMode ? Colors.white10 : Colors.blue[50],
                backgroundImage: creatorInfo['photoURL'] != null
                    ? NetworkImage(creatorInfo['photoURL'])
                    : null,
                child: creatorInfo['photoURL'] == null
                    ? Icon(
                        Icons.person,
                        color: isDarkMode ? Colors.white70 : Colors.blue,
                      )
                    : null,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      creatorInfo['name'] ?? 'Unknown',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    if (creatorInfo['role'] != null)
                      Text(
                        creatorInfo['role'],
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                    if (creatorInfo['department'] != null)
                      Text(
                        creatorInfo['department'],
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo(Map<String, dynamic> contactDetails, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Information',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildContactRow(
                Icons.phone,
                'Phone',
                contactDetails['phone'],
                isDarkMode,
              ),
              SizedBox(height: 12),
              _buildContactRow(
                Icons.email,
                'Email',
                contactDetails['email'],
                isDarkMode,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactRow(IconData icon, String label, String? value, bool isDarkMode) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.white10 : Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isDarkMode ? Colors.white70 : Colors.blue,
            size: 20,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.grey[600],
                ),
              ),
              SizedBox(height: 4),
              Text(
                value ?? 'Not provided',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.copy,
            color: isDarkMode ? Colors.white70 : Colors.blue,
          ),
          onPressed: () {
            if (value != null) {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(GlobalKey<ScaffoldState>().currentContext!).showSnackBar(
                SnackBar(content: Text('$label copied to clipboard')),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, Map<String, dynamic> eventData, bool isDarkMode) {
    final registrations = (eventData['registeredUsers'] as List?)?.length ?? 0;
    final capacity = eventData['capacity'] ?? 0;
    final isFull = registrations >= capacity;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF252542) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Price',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white60 : Colors.grey[600],
                    ),
                  ),
                  Text(
                    '₹${eventData['price'] ?? 0}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: isFull ? null : () => _handleRegistration(context, eventData),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isFull ? 'Event Full' : 'Register Now',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleRegistration(BuildContext context, Map<String, dynamic> eventData) {
    // Check if user is authenticated
    if (FirebaseAuth.instance.currentUser == null) {
      _showAuthRequiredDialog(context);
      return;
    }

    // Check if event is full
    final registrations = (eventData['registeredUsers'] as List?)?.length ?? 0;
    final capacity = eventData['capacity'] ?? 0;
    if (registrations >= capacity) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sorry, this event is full')),
      );
      return;
    }

    // Show registration form
    _showRegistrationForm(context, eventData);
  }

  void _showAuthRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Authentication Required'),
        content: Text('Please sign in to register for events'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to authentication screen
              Navigator.pushNamed(context, '/profile');
            },
            child: Text('Sign In'),
          ),
        ],
      ),
    );
  }

  void _showRegistrationForm(BuildContext context, Map<String, dynamic> eventData) {
    // Show registration form dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Register for Event'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Event: ${eventData['title']}'),
              Text('Price: ₹${eventData['price']}'),
              // Add registration form fields here
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle registration submission
              Navigator.pop(context);
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  Color _getEventTypeColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'workshop':
        return Colors.blue;
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
} 