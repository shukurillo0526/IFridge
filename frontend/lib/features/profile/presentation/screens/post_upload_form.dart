import 'package:flutter/material.dart';
import 'package:ifridge_app/core/theme/app_theme.dart';
import 'package:ifridge_app/core/services/auth_helper.dart';

class PostUploadForm extends StatefulWidget {
  const PostUploadForm({super.key});

  @override
  State<PostUploadForm> createState() => _PostUploadFormState();
}

class _PostUploadFormState extends State<PostUploadForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _caption = '';
  String _videoUrl = '';
  String _recipeId = '';
  bool _isUploading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isUploading = true);

    // Mock upload delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isUploading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Post uploaded safely! It will appear in the Community Feed shortly.'),
        backgroundColor: IFridgeTheme.freshGreen,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('New Post', style: TextStyle(fontWeight: FontWeight.w700)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (!_isUploading)
            TextButton(
              onPressed: _submit,
              child: const Text('Post', style: TextStyle(color: IFridgeTheme.primary, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
        ],
      ),
      body: _isUploading
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: IFridgeTheme.primary),
                  SizedBox(height: 16),
                  Text('Uploading your amazing content...', style: TextStyle(color: Colors.white70)),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Media Upload Box
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: IFridgeTheme.bgElevated,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white24, style: BorderStyle.solid),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.video_library, size: 48, color: Colors.white.withValues(alpha: 0.2)),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.upload_file),
                            label: const Text('Select Video / Image'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: IFridgeTheme.primary,
                              side: const BorderSide(color: IFridgeTheme.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Fields
                    const Text('Post Details', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                        filled: true,
                        fillColor: IFridgeTheme.bgElevated,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                      onSaved: (val) => _title = val ?? '',
                    ),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Caption & Tags',
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                        filled: true,
                        fillColor: IFridgeTheme.bgElevated,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                      onSaved: (val) => _caption = val ?? '',
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'External Video URL (YouTube Shorts/TikTok)',
                        hintText: 'https://...',
                        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
                        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                        filled: true,
                        fillColor: IFridgeTheme.bgElevated,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        prefixIcon: const Icon(Icons.link, color: Colors.white54),
                      ),
                      onSaved: (val) => _videoUrl = val ?? '',
                    ),
                    const SizedBox(height: 24),

                    // Recipe Link attachment
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: IFridgeTheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: IFridgeTheme.primary.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: IFridgeTheme.primary.withValues(alpha: 0.2), shape: BoxShape.circle),
                            child: const Icon(Icons.restaurant_menu, color: IFridgeTheme.primary),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Attach Recipe', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                Text('Link an existing recipe to this post', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle, color: IFridgeTheme.primary, size: 28),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Recipe selector modal opens here')));
                            },
                          )
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }
}
