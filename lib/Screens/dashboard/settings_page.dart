import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../Utils/color/color.dart';
import '../../Utils/dimens.dart';
import '../../Widgets/footer_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _storage = GetStorage();
  int _selectedSection = 0;

  bool _emailNotifs = true;
  bool _pushNotifs = true;
  bool _smsNotifs = false;
  bool _marketAlerts = true;
  bool _loginAlerts = true;
  bool _twoFactor = false;

  final List<Map<String, dynamic>> _sections = [
    {'label': 'Profile', 'icon': Icons.person_outline},
    {'label': 'Security', 'icon': Icons.security_outlined},
    {'label': 'Notifications', 'icon': Icons.notifications_outlined},
    {'label': 'Preferences', 'icon': Icons.tune_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Color(0xFF141416)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            _header(),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sidebar(),
                  SizedBox(width: 24),
                  Expanded(child: _content()),
                ],
              ),
            ),
            SizedBox(height: 30),
            FooterPage(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Account Settings',
              style: TextStyle(
                  color: white,
                  fontSize: kTextLarge,
                  fontWeight: fWLargeFont)),
          SizedBox(height: 6),
          Text('Manage your profile, security, and preferences.',
              style: TextStyle(color: Colors.grey, fontSize: kTextSmaller)),
        ],
      ),
    );
  }

  Widget _sidebar() {
    return Container(
      width: 200,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF18191D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: List.generate(_sections.length, (i) {
          final sec = _sections[i];
          final isSelected = _selectedSection == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedSection = i),
            child: Container(
              margin: EdgeInsets.only(bottom: 4),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? amber.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: isSelected
                    ? Border.all(color: amber.withOpacity(0.3))
                    : null,
              ),
              child: Row(
                children: [
                  Icon(sec['icon'],
                      color: isSelected ? amber : Colors.grey, size: 18),
                  SizedBox(width: 10),
                  Text(sec['label'],
                      style: TextStyle(
                          color: isSelected ? amber : Colors.grey,
                          fontSize: kTextSmaller,
                          fontWeight: isSelected
                              ? fWLargeFont
                              : fWSmallFont)),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _content() {
    switch (_selectedSection) {
      case 0:
        return _profileSection();
      case 1:
        return _securitySection();
      case 2:
        return _notificationsSection();
      case 3:
        return _preferencesSection();
      default:
        return _profileSection();
    }
  }

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFF18191D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: white,
                  fontSize: kTextSmallHigh,
                  fontWeight: fWLargeFont)),
          Divider(color: Colors.grey.withOpacity(0.15), height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _profileSection() {
    final email = FirebaseAuth.instance.currentUser?.email ?? 'user@example.com';
    final name = _storage.read('fullName') ?? 'User';
    return Column(
      children: [
        _sectionCard(
          title: 'Profile Information',
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: amber.withOpacity(0.2),
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : 'U',
                      style: TextStyle(
                          color: amber,
                          fontSize: kTextXLarge,
                          fontWeight: fWLargeFont),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: amber, shape: BoxShape.circle),
                      child: Icon(Icons.edit, size: 12, color: black),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            _inputField('Full Name', name, Icons.person_outline),
            SizedBox(height: 12),
            _inputField('Email Address', email, Icons.email_outlined,
                enabled: false),
            SizedBox(height: 12),
            _inputField('Phone Number', '+1 (555) 000-0000',
                Icons.phone_outlined),
            SizedBox(height: 20),
            _saveButton('Save Changes'),
          ],
        ),
      ],
    );
  }

  Widget _securitySection() {
    return Column(
      children: [
        _sectionCard(
          title: 'Password',
          children: [
            _inputField('Current Password', '••••••••',
                Icons.lock_outline,
                obscure: true),
            SizedBox(height: 12),
            _inputField(
                'New Password', '••••••••', Icons.lock_outline,
                obscure: true),
            SizedBox(height: 12),
            _inputField('Confirm New Password', '••••••••',
                Icons.lock_outline,
                obscure: true),
            SizedBox(height: 20),
            _saveButton('Update Password'),
          ],
        ),
        SizedBox(height: 16),
        _sectionCard(
          title: 'Two-Factor Authentication',
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Enable 2FA',
                          style: TextStyle(
                              color: white, fontSize: kTextSmaller)),
                      SizedBox(height: 4),
                      Text(
                          'Add an extra layer of security to your account.',
                          style: TextStyle(
                              color: Colors.grey, fontSize: kTextMini)),
                    ],
                  ),
                ),
                Switch(
                  value: _twoFactor,
                  onChanged: (v) => setState(() => _twoFactor = v),
                  activeColor: amber,
                ),
              ],
            ),
            if (_twoFactor) ...[
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: Colors.green.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.verified_user,
                        color: Colors.green, size: 16),
                    SizedBox(width: 8),
                    Text('2FA is now active on your account',
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: kTextMini)),
                  ],
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 16),
        _sectionCard(
          title: 'Active Sessions',
          children: [
            _sessionItem('Chrome on Windows',
                'United States • Current session', true),
            SizedBox(height: 8),
            _sessionItem('Safari on iPhone',
                'United States • 2 hours ago', false),
          ],
        ),
      ],
    );
  }

  Widget _sessionItem(String device, String info, bool isCurrent) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF141416),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.computer, color: Colors.grey, size: 18),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(device,
                  style:
                      TextStyle(color: white, fontSize: kTextSmaller)),
              Text(info,
                  style: TextStyle(
                      color: Colors.grey, fontSize: kTextMini)),
            ],
          ),
        ),
        isCurrent
            ? Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('Current',
                    style: TextStyle(
                        color: Colors.green, fontSize: kTextMini)),
              )
            : TextButton(
                onPressed: () {},
                child: Text('Revoke',
                    style: TextStyle(
                        color: Colors.red, fontSize: kTextMini)),
              ),
      ],
    );
  }

  Widget _notificationsSection() {
    return _sectionCard(
      title: 'Notification Preferences',
      children: [
        _notifToggle('Email Notifications',
            'Receive updates via email', _emailNotifs, (v) {
          setState(() => _emailNotifs = v);
        }),
        Divider(color: Colors.grey.withOpacity(0.1)),
        _notifToggle('Push Notifications',
            'Browser and device push alerts', _pushNotifs, (v) {
          setState(() => _pushNotifs = v);
        }),
        Divider(color: Colors.grey.withOpacity(0.1)),
        _notifToggle(
            'SMS Notifications', 'Receive text message alerts', _smsNotifs,
            (v) {
          setState(() => _smsNotifs = v);
        }),
        Divider(color: Colors.grey.withOpacity(0.1)),
        _notifToggle(
            'Market Price Alerts',
            'Get notified on significant price movements',
            _marketAlerts, (v) {
          setState(() => _marketAlerts = v);
        }),
        Divider(color: Colors.grey.withOpacity(0.1)),
        _notifToggle('Login Alerts',
            'Get notified of new sign-ins to your account', _loginAlerts,
            (v) {
          setState(() => _loginAlerts = v);
        }),
        SizedBox(height: 16),
        _saveButton('Save Preferences'),
      ],
    );
  }

  Widget _notifToggle(
      String title, String subtitle, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        TextStyle(color: white, fontSize: kTextSmaller)),
                Text(subtitle,
                    style: TextStyle(
                        color: Colors.grey, fontSize: kTextMini)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: amber,
          ),
        ],
      ),
    );
  }

  Widget _preferencesSection() {
    return _sectionCard(
      title: 'Display & Preferences',
      children: [
        _prefItem('Default Currency', 'USD - US Dollar', Icons.attach_money),
        Divider(color: Colors.grey.withOpacity(0.1)),
        _prefItem('Language', 'English (US)', Icons.language),
        Divider(color: Colors.grey.withOpacity(0.1)),
        _prefItem('Timezone', 'UTC-5 (Eastern Time)', Icons.access_time),
        Divider(color: Colors.grey.withOpacity(0.1)),
        _prefItem('Theme', 'Dark Mode', Icons.dark_mode_outlined),
        SizedBox(height: 20),
        _dangerZone(),
      ],
    );
  }

  Widget _prefItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 18),
          SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: TextStyle(color: white, fontSize: kTextSmaller)),
          ),
          Text(value,
              style: TextStyle(color: Colors.grey, fontSize: kTextSmaller)),
          SizedBox(width: 8),
          Icon(Icons.chevron_right, color: Colors.grey, size: 18),
        ],
      ),
    );
  }

  Widget _dangerZone() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Danger Zone',
              style: TextStyle(
                  color: Colors.red,
                  fontSize: kTextSmaller,
                  fontWeight: fWLargeFont)),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Delete Account',
                      style: TextStyle(
                          color: white, fontSize: kTextSmaller)),
                  Text('This action cannot be undone.',
                      style: TextStyle(
                          color: Colors.grey, fontSize: kTextMini)),
                ],
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: BorderSide(color: Colors.red.withOpacity(0.5)),
                ),
                child: Text('Delete',
                    style: TextStyle(fontSize: kTextSmaller)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _inputField(String label, String hint, IconData icon,
      {bool enabled = true, bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(color: Colors.grey, fontSize: kTextMini)),
        SizedBox(height: 6),
        TextField(
          enabled: enabled,
          obscureText: obscure,
          style: TextStyle(color: white, fontSize: kTextSmaller),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.4)),
            prefixIcon: Icon(icon, color: Colors.grey, size: 18),
            filled: true,
            fillColor: Color(0xFF141416),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(color: Colors.grey.withOpacity(0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(color: Colors.grey.withOpacity(0.2)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(color: Colors.grey.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: amber),
            ),
            contentPadding:
                EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          ),
        ),
      ],
    );
  }

  Widget _saveButton(String label) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: amber,
          foregroundColor: black,
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(label,
            style: TextStyle(
                fontWeight: fWLargeFont, fontSize: kTextSmaller)),
      ),
    );
  }
}
