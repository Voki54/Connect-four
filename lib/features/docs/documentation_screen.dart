import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/logger.dart';

class DocumentationScreen extends StatefulWidget {
  final String initialUrl;

  const DocumentationScreen({
    super.key,
    this.initialUrl = 'https://voki54.github.io/connect-four-docs/README.md',
  });

  @override
  DocumentationScreenState createState() => DocumentationScreenState();
}

class DocumentationScreenState extends State<DocumentationScreen> {
  static const String _docsBaseUrl =
      'https://voki54.github.io/connect-four-docs/';

  late String _currentUrl;
  bool _isLoading = true;
  String _markdownContent = '';

  @override
  void initState() {
    super.initState();
    _currentUrl = widget.initialUrl;
    _loadMarkdown(_currentUrl);
  }

  Future<void> _loadMarkdown(String url) async {
    setState(() => _isLoading = true);

    try {
      final response = await http.get(Uri.parse(url));

      logger.info('_loadMarkdown: $url → ${response.statusCode}');

      if (response.statusCode == 200) {
        setState(() {
          _currentUrl = url;
          _markdownContent = response.body;
          _isLoading = false;
        });
      } else {
        _showError('Ошибка загрузки: ${response.statusCode}');
      }
    } catch (e) {
      _showError('Ошибка подключения: $e');
    }
  }

  void _showError(String message) {
    setState(() {
      _markdownContent =
          '''
# Ошибка загрузки документации

$message

Проверьте подключение к интернету или попробуйте позже.
''';
      _isLoading = false;
    });
  }

  Future<void> _handleLinkTap(String url) async {
    logger.info('_handleLinkTap: $url');

    if (url.isEmpty) return;

    if (url.startsWith('#')) {
      return;
    }

    if (_isInternalDocumentationLink(url)) {
      final resolvedUrl = _resolveInternalLink(url);
      logger.info('Resolved internal link: $resolvedUrl');
      await _loadMarkdown(resolvedUrl);
    } else {
      await _launchExternalUrl(url);
    }
  }

  bool _isInternalDocumentationLink(String url) {
    if (!url.contains('://')) return true;
    return url.contains('github.io');
  }

  String _resolveInternalLink(String url) {
    final Uri baseUri = Uri.parse(_docsBaseUrl);

    if (url.startsWith('http')) {
      return url;
    }

    final cleaned = url.startsWith('/')
        ? url.substring(1)
        : url.startsWith('./')
        ? url.substring(2)
        : url;

    return baseUri.resolve(cleaned).toString();
  }

  Future<void> _launchExternalUrl(String url) async {
    final uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showSnack('Не удалось открыть ссылку');
      }
    } catch (e) {
      _showSnack('Ошибка открытия ссылки');
    }
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(text), backgroundColor: Colors.red));
  }

  Future<void> _refresh() async {
    await _loadMarkdown(_currentUrl);
  }

  String _toHostedPageUrl(String markdownUrl) {
    final uri = Uri.parse(markdownUrl);

    var path = uri.path;

    if (path.endsWith('README.md')) {
      path = path.replaceAll('README.md', '');
    } else if (path.endsWith('.md')) {
      path = path.replaceAll('.md', '/');
    }

    return uri.replace(path: path).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Документация'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refresh),
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: () => _launchExternalUrl(_toHostedPageUrl(_currentUrl)),
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: MarkdownBody(
                  data: _markdownContent,
                  onTapLink: (text, href, title) async {
                    if (href != null && href.isNotEmpty) {
                      await _handleLinkTap(href);
                    }
                  },
                ),
              ),
      ),
    );
  }
}
