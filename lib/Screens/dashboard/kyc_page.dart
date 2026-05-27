import 'package:flutter/material.dart';

import '../../Utils/color/color.dart';
import '../../Utils/dimens.dart';
import '../../Widgets/footer_page.dart';

class KycPage extends StatefulWidget {
  const KycPage({super.key});

  @override
  State<KycPage> createState() => _KycPageState();
}

class _KycPageState extends State<KycPage> {
  int _currentStep = 0;

  final List<Map<String, dynamic>> _steps = [
    {
      'title': 'Personal Information',
      'subtitle': 'Provide your basic details',
      'icon': Icons.person_outline,
      'status': 'completed',
    },
    {
      'title': 'Identity Document',
      'subtitle': 'Upload a government-issued ID',
      'icon': Icons.badge_outlined,
      'status': 'active',
    },
    {
      'title': 'Selfie Verification',
      'subtitle': 'Take a live photo to confirm identity',
      'icon': Icons.camera_alt_outlined,
      'status': 'pending',
    },
    {
      'title': 'Address Proof',
      'subtitle': 'Provide proof of residence',
      'icon': Icons.home_outlined,
      'status': 'pending',
    },
    {
      'title': 'Review & Submit',
      'subtitle': 'Confirm and submit your documents',
      'icon': Icons.check_circle_outline,
      'status': 'pending',
    },
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
                  Expanded(flex: 1, child: _stepper()),
                  SizedBox(width: 24),
                  Expanded(flex: 2, child: _stepContent()),
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
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.orange, size: 14),
                    SizedBox(width: 6),
                    Text('Verification In Progress',
                        style: TextStyle(
                            color: Colors.orange,
                            fontSize: kTextMini,
                            fontWeight: fWLargeFont)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'KYC Verification',
            style: TextStyle(
              color: white,
              fontSize: kTextLarge,
              fontWeight: fWLargeFont,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Complete identity verification to unlock full platform features and higher transaction limits.',
            style: TextStyle(color: Colors.grey, fontSize: kTextSmaller),
          ),
          SizedBox(height: 16),
          _progressBar(),
        ],
      ),
    );
  }

  Widget _progressBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Progress',
                style: TextStyle(color: Colors.grey, fontSize: kTextMini)),
            Text('1 / 5 Steps',
                style: TextStyle(color: amber, fontSize: kTextMini)),
          ],
        ),
        SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: 0.2,
            backgroundColor: Color(0xFF18191D),
            valueColor: AlwaysStoppedAnimation<Color>(amber),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _stepper() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF18191D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: List.generate(_steps.length, (i) {
          final step = _steps[i];
          final isActive = i == 1;
          final isCompleted = step['status'] == 'completed';
          final isPending = step['status'] == 'pending';
          return Column(
            children: [
              GestureDetector(
                onTap: () => setState(() => _currentStep = i),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isActive
                        ? amber.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: isActive
                        ? Border.all(color: amber.withOpacity(0.3))
                        : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompleted
                              ? Colors.green
                              : isActive
                                  ? amber
                                  : Color(0xFF141416),
                          border: isPending
                              ? Border.all(
                                  color: Colors.grey.withOpacity(0.3))
                              : null,
                        ),
                        child: Icon(
                          isCompleted ? Icons.check : step['icon'],
                          color: isCompleted || isActive
                              ? black
                              : Colors.grey,
                          size: 16,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(step['title'],
                                style: TextStyle(
                                    color: isPending
                                        ? Colors.grey
                                        : white,
                                    fontSize: kTextMini,
                                    fontWeight: fWLargeFont)),
                            Text(step['subtitle'],
                                style: TextStyle(
                                    color: Colors.grey.withOpacity(0.6),
                                    fontSize: 11),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (i < _steps.length - 1)
                Padding(
                  padding: EdgeInsets.only(left: 28),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 2,
                      height: 16,
                      color: isCompleted
                          ? Colors.green.withOpacity(0.5)
                          : Colors.grey.withOpacity(0.2),
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _stepContent() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFF18191D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Upload Identity Document',
              style: TextStyle(
                  color: white,
                  fontSize: kTextSmallHigh,
                  fontWeight: fWLargeFont)),
          SizedBox(height: 8),
          Text(
            'Please upload a clear photo of a valid government-issued ID. Accepted documents: Passport, National ID, Driver\'s License.',
            style: TextStyle(color: Colors.grey, fontSize: kTextSmaller),
          ),
          SizedBox(height: 24),
          Row(
            children: [
              _docTypeCard(
                  'Passport', Icons.menu_book_outlined, true),
              SizedBox(width: 12),
              _docTypeCard('National ID', Icons.credit_card, false),
              SizedBox(width: 12),
              _docTypeCard(
                  "Driver's License", Icons.directions_car_outlined, false),
            ],
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _uploadBox('Front Side')),
              SizedBox(width: 16),
              Expanded(child: _uploadBox('Back Side')),
            ],
          ),
          SizedBox(height: 24),
          _requirementsList(),
          SizedBox(height: 24),
          SizedBox(
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
              child: Text('Continue to Next Step',
                  style: TextStyle(
                      fontWeight: fWLargeFont, fontSize: kTextSmaller)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _docTypeCard(String label, IconData icon, bool selected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected
                ? amber.withOpacity(0.1)
                : Color(0xFF141416),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: selected
                    ? amber
                    : Colors.grey.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Icon(icon,
                  color: selected ? amber : Colors.grey, size: 24),
              SizedBox(height: 6),
              Text(label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: selected ? amber : Colors.grey,
                      fontSize: kTextMini)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _uploadBox(String label) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Color(0xFF141416),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: Colors.grey.withOpacity(0.2),
            style: BorderStyle.solid),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_upload_outlined, color: Colors.grey, size: 36),
          SizedBox(height: 8),
          Text(label,
              style:
                  TextStyle(color: white, fontSize: kTextSmaller)),
          SizedBox(height: 4),
          Text('Click to upload or drag & drop',
              style:
                  TextStyle(color: Colors.grey, fontSize: kTextMini)),
          SizedBox(height: 4),
          Text('PNG, JPG (max 5MB)',
              style: TextStyle(
                  color: Colors.grey.withOpacity(0.5),
                  fontSize: 11)),
        ],
      ),
    );
  }

  Widget _requirementsList() {
    final items = [
      'Document must be valid and not expired',
      'All four corners of the document must be visible',
      'Document must be in focus and well-lit',
      'No black and white photos or photocopies',
    ];
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue, size: 16),
              SizedBox(width: 6),
              Text('Requirements',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: kTextSmaller,
                      fontWeight: fWLargeFont)),
            ],
          ),
          SizedBox(height: 10),
          ...items.map((item) => Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Icon(Icons.check_circle,
                        color: Colors.green, size: 14),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(item,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: kTextMini)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
