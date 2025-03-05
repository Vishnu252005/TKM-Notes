import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventCreateScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(String, IconData) showSuccessMessage;
  final Function(String) showAuthRequiredDialog;

  const EventCreateScreen({
    Key? key,
    required this.isDarkMode,
    required this.showSuccessMessage,
    required this.showAuthRequiredDialog,
  }) : super(key: key);

  @override
  _EventCreateScreenState createState() => _EventCreateScreenState();
}

class _EventCreateScreenState extends State<EventCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final _pointsController = TextEditingController();
  final _capacityController = TextEditingController();
  final _accommodationPriceController = TextEditingController();
  final _paymentPhoneController = TextEditingController();
  final _gpayIdController = TextEditingController();
  String _selectedType = 'Workshop';
  DateTime _selectedDate = DateTime.now();
  bool _requiresPayment = true;
  bool _hasAccommodation = false;
  String _accommodationDetails = '';
  final List<String> _filters = ['Workshop', 'Seminar', 'Conference', 'Hackathon'];

  Future<void> _createEvent(Map<String, dynamic> eventData) async {
    try {
      // Add creator ID and timestamp to event data
      final Map<String, dynamic> finalEventData = {
        ...eventData,
        'createdAt': FieldValue.serverTimestamp(),
        'creatorId': FirebaseAuth.instance.currentUser?.uid,
        'image': 'https://images.unsplash.com/photo-1505373877841-8d25f7d46678', // Default event image
        'registeredUsers': [], // Initialize empty array for registered users
        'registrationCount': 0, // Track number of registrations
      };
      
      // Add to Firestore and get the event reference
      DocumentReference eventRef = await FirebaseFirestore.instance
          .collection('events')
          .add(finalEventData);
      
      // Create an empty document in the registrations subcollection to initialize it
      await eventRef.collection('registrations').doc('_info').set({
        'createdAt': FieldValue.serverTimestamp(),
        'totalRegistrations': 0
      });
      
    } catch (e) {
      print('Error creating event: $e');
      throw e;
    }
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int? maxLines,
    String? hintText,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: widget.isDarkMode ? Colors.white70 : Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(
            color: widget.isDarkMode ? Colors.white : Colors.black,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: widget.isDarkMode ? Colors.white38 : Colors.grey[400],
            ),
            filled: true,
            fillColor: widget.isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: widget.isDarkMode ? Colors.white24 : Colors.grey[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: widget.isDarkMode ? Colors.white24 : Colors.grey[300]!,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: widget.isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
            hintText: hintText,
          ),
          validator: validator,
          maxLines: maxLines,
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
          maxWidth: 500,
        ),
        decoration: BoxDecoration(
          color: widget.isDarkMode ? Color(0xFF252542) : Colors.white,
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
                color: widget.isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  Icon(Icons.event_available, color: Colors.white, size: 24),
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
                          validator: (value) => value?.isEmpty ?? true ? 'Please enter event title' : null,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Event Type',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: widget.isDarkMode ? Colors.white70 : Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: widget.isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey[100],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: widget.isDarkMode ? Colors.white24 : Colors.grey[300]!,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedType,
                              isExpanded: true,
                              dropdownColor: widget.isDarkMode ? Color(0xFF252542) : Colors.white,
                              style: TextStyle(
                                color: widget.isDarkMode ? Colors.white : Colors.black,
                                fontSize: 16,
                              ),
                              items: _filters.map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              )).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedType = value!;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildFormField(
                          controller: _descriptionController,
                          label: 'Description',
                          icon: Icons.description,
                          maxLines: 3,
                          validator: (value) => value?.isEmpty ?? true ? 'Please enter event description' : null,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Event Date',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: widget.isDarkMode ? Colors.white70 : Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: widget.isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey[100],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: widget.isDarkMode ? Colors.white24 : Colors.grey[300]!,
                            ),
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.calendar_today,
                              color: widget.isDarkMode ? Colors.white38 : Colors.grey[400],
                            ),
                            title: Text(
                              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                              style: TextStyle(
                                color: widget.isDarkMode ? Colors.white : Colors.black,
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
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildFormField(
                          controller: _locationController,
                          label: 'Location',
                          icon: Icons.location_on,
                          validator: (value) => value?.isEmpty ?? true ? 'Please enter event location' : null,
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
                                  if (value == null || value.isEmpty) return 'Enter price';
                                  if (int.tryParse(value) == null) return 'Invalid price';
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
                                  if (value == null || value.isEmpty) return 'Enter points';
                                  if (int.tryParse(value) == null) return 'Invalid points';
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
                            if (value == null || value.isEmpty) return 'Enter capacity';
                            if (int.tryParse(value) == null) return 'Invalid capacity';
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        SwitchListTile(
                          title: Text(
                            'Requires Payment',
                            style: TextStyle(
                              color: widget.isDarkMode ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            'Toggle if this event requires payment',
                            style: TextStyle(
                              color: widget.isDarkMode ? Colors.white60 : Colors.grey[600],
                            ),
                          ),
                          value: _requiresPayment,
                          onChanged: (value) => setState(() => _requiresPayment = value),
                          activeColor: widget.isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                        ),
                        if (_requiresPayment) ...[
                          SizedBox(height: 16),
                          Text(
                            'Payment Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: widget.isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(height: 16),
                          _buildFormField(
                            controller: _paymentPhoneController,
                            label: 'Payment Phone Number',
                            icon: Icons.phone,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Phone number is required';
                              if (value.length != 10) return 'Enter valid 10-digit number';
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          _buildFormField(
                            controller: _gpayIdController,
                            label: 'UPI ID (Optional)',
                            icon: Icons.payment,
                            validator: (value) {
                              if (value == null || value.isEmpty) return null;  // Optional
                              if (!value.contains('@')) return 'Enter valid UPI ID';
                              return null;
                            },
                            hintText: 'example@upi (optional)',
                          ),
                        ],
                        SizedBox(height: 16),
                        SwitchListTile(
                          title: Text(
                            'Accommodation Available',
                            style: TextStyle(
                              color: widget.isDarkMode ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            'Toggle if accommodation is available for participants',
                            style: TextStyle(
                              color: widget.isDarkMode ? Colors.white60 : Colors.grey[600],
                            ),
                          ),
                          value: _hasAccommodation,
                          onChanged: (value) => setState(() => _hasAccommodation = value),
                          activeColor: widget.isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                        ),
                        if (_hasAccommodation) ...[
                          SizedBox(height: 16),
                          _buildFormField(
                            controller: _accommodationPriceController,
                            label: 'Accommodation Price (₹) (Optional)',
                            icon: Icons.currency_rupee,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) return null;
                              if (int.tryParse(value) == null) return 'Invalid price';
                              return null;
                            },
                            hintText: 'Leave empty if accommodation is free',
                          ),
                          SizedBox(height: 16),
                          _buildFormField(
                            controller: TextEditingController(text: _accommodationDetails),
                            label: 'Accommodation Details (Optional)',
                            icon: Icons.hotel,
                            maxLines: 3,
                            onChanged: (value) {
                              _accommodationDetails = value;
                            },
                            hintText: 'Enter accommodation details if available (location, facilities, contact person, etc.)',
                            validator: (value) => null,
                          ),
                        ],
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
                color: widget.isDarkMode ? Color(0xFF252542) : Colors.white,
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
                            color: widget.isDarkMode 
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
                          color: widget.isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
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

                            // Create event data
                            final eventData = {
                              'title': _titleController.text,
                              'type': _selectedType,
                              'description': _descriptionController.text,
                              'date': Timestamp.fromDate(_selectedDate),
                              'location': _locationController.text,
                              'price': _requiresPayment ? int.parse(_priceController.text) : 0,
                              'points': int.parse(_pointsController.text),
                              'capacity': int.parse(_capacityController.text),
                              'requiresPayment': _requiresPayment,
                              'paymentDetails': _requiresPayment ? {
                                'phoneNumber': _paymentPhoneController.text,
                                'upiId': _gpayIdController.text.isNotEmpty ? _gpayIdController.text : null,
                                'hasUpiId': _gpayIdController.text.isNotEmpty,
                                'availablePaymentMethods': [
                                  'Phone Number',
                                  if (_gpayIdController.text.isNotEmpty) 'UPI ID',
                                ],
                              } : null,
                              'accommodation': {
                                'available': _hasAccommodation,
                                'price': _hasAccommodation && _accommodationPriceController.text.isNotEmpty 
                                    ? int.parse(_accommodationPriceController.text) 
                                    : 0,
                                'details': _hasAccommodation ? _accommodationDetails.trim() : '',
                                'hasPricing': _hasAccommodation && _accommodationPriceController.text.isNotEmpty,
                                'hasDetails': _hasAccommodation && _accommodationDetails.trim().isNotEmpty,
                              },
                              'registrations': 0,
                            };

                            // Create event
                            await _createEvent(eventData);

                            // Close loading and form
                            Navigator.pop(context); // Close loading
                            Navigator.pop(context); // Close form
                            
                            // Show success
                            widget.showSuccessMessage(
                              'Event created successfully!',
                              Icons.check_circle,
                            );
                          } catch (e) {
                            // Close loading
                            Navigator.pop(context);
                            
                            // Show error
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error creating event: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.isDarkMode ? Color(0xFF4C4DDC) : Colors.blue,
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
    );
  }
}

