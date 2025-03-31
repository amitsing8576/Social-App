import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class WorkerAssistancePage extends StatefulWidget {
  const WorkerAssistancePage({Key? key}) : super(key: key);

  @override
  State<WorkerAssistancePage> createState() => _WorkerAssistancePageState();
}

class _WorkerAssistancePageState extends State<WorkerAssistancePage> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _concernText = '';
  final TextEditingController _concernController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  @override
  void dispose() {
    _concernController.dispose();
    super.dispose();
  }

  // Initialize speech recognition
  Future<void> _initSpeech() async {
    await _speech.initialize(
      onStatus: (status) {
        if (status == 'notListening') {
          setState(() => _isListening = false);
        }
      },
      onError: (error) {
        setState(() => _isListening = false);
        debugPrint('Speech recognition error: $error');
      },
    );
  }

  // Request microphone permission
  Future<bool> _requestMicPermission() async {
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      status = await Permission.microphone.request();
    }
    return status.isGranted;
  }

  // Start listening to voice input
  Future<void> _startListening() async {
    bool hasPermission = await _requestMicPermission();

    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Microphone permission is required for speech recognition')),
      );
      return;
    }

    if (_speech.isAvailable && !_isListening) {
      setState(() => _isListening = true);

      await _speech.listen(
        onResult: (result) {
          setState(() {
            _concernText = result.recognizedWords;
            _concernController.text = _concernText;
          });
        },
        localeId: 'en_IN', // Set to Indian English
      );
    }
  }

  // Stop listening to voice input
  void _stopListening() {
    if (_isListening) {
      _speech.stop();
      setState(() => _isListening = false);
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      await launchUrl(launchUri);
    } catch (e) {
      debugPrint('Could not launch $phoneNumber: $e');
    }
  }

  void _submitConcern() {
    String concern = _concernController.text.trim();
    if (concern.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter your concern before submitting')),
      );
      return;
    }

    // Here you would add code to submit the concern to your backend
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text(
              'Your concern has been submitted. Our team will contact you within a week.')),
    );

    // Clear the text field after submission
    _concernController.clear();
    setState(() {
      _concernText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Need help? You are NOT alone!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildInfoCard(
                leadingWidget: const CircleAvatar(
                  backgroundImage: AssetImage('assets/support_icon.png'),
                  radius: 25,
                ),
                title:
                    'Facing a workplace issue? Need guidance on safety, wages, workplace harassment, rights or anything else? Kaarighar is here to support you. Reach out to the helplines below for help.',
                trailingWidget: const CircleAvatar(
                  backgroundColor: Colors.white,
                ),
                onTap: () {},
              ),
              const SizedBox(height: 8),
              _buildInfoCard(
                title: 'Workers\' Voice Helpdesk - AIDER (Next Cop)',
                subtitle:
                    'Got a concern at workplace? The Workers\' Voice Helpdesk can support you with workplace safety issues, concerns about harassment, abuse, or discrimination, your right to form or join groups, and question about wages and statutory benefits. Press the call button below to make a call now!',
                note:
                    'Your identity stays private, and no one can take action against you for seeking help.',
                info: 'Timings: Monday to Saturday, 10:00 AM - 6:00 PM',
                phoneNumber: '+91-9310209482',
                trailingWidget: const CircleAvatar(
                  radius: 16,
                  child: Icon(Icons.call, color: Colors.black, size: 18),
                ),
                onTap: () => _makePhoneCall('+91-9310209482'),
                showPhone: true,
              ),
              const SizedBox(height: 8),
              _buildInfoCard(
                title: 'Delhi Labour Welfare Board',
                subtitle:
                    'Need legal help? The Delhi Legal Services Authority (DLSA) provides free legal assistance to workers facing issues related to wages, workplace disputes, harassment, or any other concerns. You can visit their Free Legal Aid Centers at Nimri Colony (Ashok Vihar) and Geeta Colony for in-person support.',
                info:
                    'For more queries, press the call button below now to call',
                phoneNumber: '011-20697824',
                trailingWidget: const CircleAvatar(
                  radius: 16,
                  child: Icon(Icons.call, color: Colors.black, size: 18),
                ),
                onTap: () => _makePhoneCall('011-20697824'),
                showPhone: true,
              ),
              const SizedBox(height: 8),
              _buildInfoCard(
                title: 'Need Assistance with Other Concerns?',
                subtitle:
                    'If you\'re unsure where to direct your query, please write your concern in the box below or use the record option to share it in your voice. Then, press the send button, and our team will review it and get back to you within a week.',
                note: 'Your voice matters! Don\'t hesitate to reach out!',
                trailingWidget: const CircleAvatar(
                  backgroundColor: Colors.white,
                ),
                onTap: () {},
              ),
              const SizedBox(height: 8),
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: TextField(
                          controller: _concernController,
                          decoration: const InputDecoration(
                            hintText: 'Write concern here...',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: _isListening ? Colors.red : Colors.grey,
                      ),
                      onPressed:
                          _isListening ? _stopListening : _startListening,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      margin: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send,
                            color: Colors.white, size: 16),
                        onPressed: _submitConcern,
                      ),
                    ),
                  ],
                ),
              ),
              if (_isListening)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Listening... Speak now',
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    Widget? leadingWidget,
    required String title,
    String? subtitle,
    String? note,
    String? info,
    String? phoneNumber,
    required Widget trailingWidget,
    required VoidCallback onTap,
    bool showPhone = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (leadingWidget != null) ...[
                  leadingWidget,
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: subtitle != null ? 14 : 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                      if (note != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          note,
                          style: const TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                      if (info != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                info,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            if (showPhone && phoneNumber != null)
                              Text(
                                phoneNumber,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                trailingWidget,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
