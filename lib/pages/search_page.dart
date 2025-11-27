import 'package:diary/main.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class SearchResult {
  final String type;
  final String referenceId;
  final String title;
  final String subtitle;
  final String? details;

  const SearchResult({
    required this.type,
    required this.referenceId,
    required this.title,
    required this.subtitle,
    this.details,
  });
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<SearchResult> _searchResults = [];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _errorMessage = '';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await supabase
          .from('global_search_view')
          .select()
          .ilike('search_text', '%$query%')
          .order('title');

      final List<SearchResult> results = (response as List)
          .map(
            (item) => SearchResult(
              type: item['type'] ?? '',
              referenceId: item['reference_id'] ?? '',
              title: item['title'] ?? '',
              subtitle: item['subtitle'] ?? '',
              details: item['details'],
            ),
          )
          .toList();

      setState(() {
        _searchResults = results;
        _isLoading = false;
        if (results.isEmpty) {
          _errorMessage = 'No results found for "$query"';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error searching: $e';
      });
    }
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'teacher':
        return Icons.school;
      case 'staff':
        return Icons.people;
      case 'dean_office':
        return Icons.account_balance;
      case 'admin':
        return Icons.admin_panel_settings;
      case 'course':
        return Icons.book;
      default:
        return Icons.help_outline;
    }
  }

  String _getDisplayType(String type) {
    switch (type) {
      case 'teacher':
        return 'Teacher';
      case 'staff':
        return 'Staff';
      case 'dean_office':
        return 'Dean Office';
      case 'admin':
        return 'Admin';
      case 'course':
        return 'Course';
      default:
        return type;
    }
  }

  void _handleResultTap(SearchResult result) {
    // For now, show a snackbar. You can implement navigation based on type
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_getDisplayType(result.type)}: ${result.title}'),
        action: SnackBarAction(label: 'OK', onPressed: () {}),
      ),
    );

    // TODO: Implement proper navigation based on type
    // Example:
    // if (result.type == 'teacher') {
    //   context.push('/teacher-detail', extra: result.referenceId);
    // } else if (result.type == 'course') {
    //   context.push('/course-detail', extra: result.referenceId);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Database')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search teachers, staff, admins, courses...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {}); // Update UI for clear button
              },
              onSubmitted: _performSearch,
            ),
          ),
          if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_errorMessage.isNotEmpty)
            Expanded(
              child: Center(
                child: Text(
                  _errorMessage,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else if (_searchResults.isEmpty && _searchController.text.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search,
                      size: 64,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Search for teachers, staff, admins, or courses',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final result = _searchResults[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(_getIconForType(result.type)),
                      ),
                      title: Text(result.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(result.subtitle),
                          if (result.details != null)
                            Text(
                              result.details!,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                        ],
                      ),
                      trailing: Chip(
                        label: Text(
                          _getDisplayType(result.type),
                          style: const TextStyle(fontSize: 11),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onTap: () => _handleResultTap(result),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
