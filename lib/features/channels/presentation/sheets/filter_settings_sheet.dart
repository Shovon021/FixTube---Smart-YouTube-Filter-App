import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tube_filter/core/database/app_database.dart';
import 'package:tube_filter/features/channels/providers/channel_provider.dart';
import 'package:tube_filter/features/home/providers/feed_provider.dart';

class FilterSettingsSheet extends StatefulWidget {
  final Channel channel;
  const FilterSettingsSheet({super.key, required this.channel});

  @override
  State<FilterSettingsSheet> createState() => _FilterSettingsSheetState();
}

class _FilterSettingsSheetState extends State<FilterSettingsSheet>
    with SingleTickerProviderStateMixin {
  final _keywordController = TextEditingController();
  late TabController _tabController;
  
  // Track pending changes
  final List<_PendingFilter> _pendingAdds = [];
  final List<int> _pendingDeletes = [];
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _keywordController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _stageAddFilter(String keyword, bool isInclude) {
    if (keyword.trim().isEmpty) return;
    setState(() {
      _pendingAdds.add(_PendingFilter(keyword: keyword.trim(), isInclude: isInclude));
      _hasUnsavedChanges = true;
    });
    _keywordController.clear();
  }

  void _stageDeleteFilter(int filterId) {
    setState(() {
      _pendingDeletes.add(filterId);
      _hasUnsavedChanges = true;
    });
  }

  void _unstageAddFilter(int index) {
    setState(() {
      _pendingAdds.removeAt(index);
      _hasUnsavedChanges = _pendingAdds.isNotEmpty || _pendingDeletes.isNotEmpty;
    });
  }

  Future<void> _saveFilters() async {
    final provider = context.read<ChannelProvider>();
    
    // Apply all pending adds
    for (final pending in _pendingAdds) {
      await provider.addFilter(
        widget.channel.id,
        pending.keyword,
        pending.isInclude,
      );
    }
    
    // Apply all pending deletes
    for (final id in _pendingDeletes) {
      await provider.deleteFilter(id);
    }
    
    // Clear pending changes
    setState(() {
      _pendingAdds.clear();
      _pendingDeletes.clear();
      _hasUnsavedChanges = false;
    });
    
    // Refresh feed to apply filters - use forceRefresh to bypass cache!
    if (mounted) {
      context.read<FeedProvider>().refresh(forceRefresh: true);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Filters saved! Refreshing feed...'),
            ],
          ),
          backgroundColor: Theme.of(context).primaryColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Row(
            children: [
              CircleAvatar(
                backgroundColor: primaryColor.withAlpha(30),
                child: Icon(Icons.filter_alt, color: primaryColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.channel.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Set up your video filters',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              // Unsaved indicator
              if (_hasUnsavedChanges)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit, size: 14, color: Colors.orange.shade700),
                      const SizedBox(width: 4),
                      Text(
                        'Unsaved',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Tab Bar
          Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: isDark ? Colors.white70 : Colors.black87,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.visibility, size: 18),
                      SizedBox(width: 6),
                      Text('Show Only'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.visibility_off, size: 18),
                      SizedBox(width: 6),
                      Text('Hide'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Content
          Flexible(
            child: StreamBuilder<List<FilterRule>>(
              stream:
                  context.read<ChannelProvider>().getFilters(widget.channel.id),
              builder: (context, snapshot) {
                final filters = snapshot.data ?? [];
                // Filter out pending deletes
                final activeFilters = filters
                    .where((f) => !_pendingDeletes.contains(f.id))
                    .toList();
                final includes = activeFilters.where((f) => f.type == 0).toList();
                final excludes = activeFilters.where((f) => f.type == 1).toList();
                
                // Add pending adds to display
                final pendingIncludes = _pendingAdds.where((p) => p.isInclude).toList();
                final pendingExcludes = _pendingAdds.where((p) => !p.isInclude).toList();

                return TabBarView(
                  controller: _tabController,
                  children: [
                    // INCLUDE TAB
                    _buildFilterTab(
                      title: 'Only show videos containing:',
                      hint: 'e.g. "Gaming", "Tutorial", "Review"',
                      filters: includes,
                      pendingFilters: pendingIncludes,
                      isInclude: true,
                      emptyMessage: 'No filters = Show all videos from this channel',
                      emptyIcon: Icons.all_inclusive,
                      isDark: isDark,
                    ),

                    // EXCLUDE TAB
                    _buildFilterTab(
                      title: 'Hide videos containing:',
                      hint: 'e.g. "Reaction", "Drama", "Sponsor"',
                      filters: excludes,
                      pendingFilters: pendingExcludes,
                      isInclude: false,
                      emptyMessage: 'No videos are hidden',
                      emptyIcon: Icons.check_circle_outline,
                      isDark: isDark,
                    ),
                  ],
                );
              },
            ),
          ),
          
          // SAVE BUTTON
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _hasUnsavedChanges ? _saveFilters : null,
              icon: const Icon(Icons.save),
              label: Text(_hasUnsavedChanges ? 'Save Filters' : 'No Changes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab({
    required String title,
    required String hint,
    required List<FilterRule> filters,
    required List<_PendingFilter> pendingFilters,
    required bool isInclude,
    required String emptyMessage,
    required IconData emptyIcon,
    required bool isDark,
  }) {
    final primaryColor = Theme.of(context).primaryColor;
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _keywordController,
                  decoration: InputDecoration(
                    hintText: hint,
                    prefixIcon: Icon(
                      isInclude ? Icons.add_circle_outline : Icons.block,
                      color: isInclude ? primaryColor : Colors.red,
                    ),
                    filled: true,
                    fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  onSubmitted: (_) => _stageAddFilter(_keywordController.text, isInclude),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () => _stageAddFilter(_keywordController.text, isInclude),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isInclude ? primaryColor : Colors.red.shade400,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Section Title
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isInclude ? primaryColor : Colors.red,
            ),
          ),
          const SizedBox(height: 8),

          // Chips or Empty State
          if (filters.isEmpty && pendingFilters.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(emptyIcon, size: 32, color: Colors.grey),
                  const SizedBox(height: 8),
                  Text(
                    emptyMessage,
                    style: TextStyle(color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Existing filters
                ...filters.map((f) => _buildChip(f, isInclude)),
                // Pending adds (with different style)
                ...pendingFilters.asMap().entries.map((entry) => 
                  _buildPendingChip(entry.value, entry.key, isInclude)),
              ],
            ),

          const SizedBox(height: 16),

          // Help text
          if (isInclude)
            _buildHelpCard(
              icon: Icons.lightbulb_outline,
              text: 'Leave empty to see ALL videos. Add keywords to narrow down to specific topics.',
              isDark: isDark,
            )
          else
            _buildHelpCard(
              icon: Icons.info_outline,
              text: 'Videos containing these words will be hidden from your feed.',
              isDark: isDark,
            ),
        ],
      ),
    );
  }

  Widget _buildHelpCard({
    required IconData icon,
    required String text,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.blue.shade900.withAlpha(50)
            : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blue.shade600),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 12, color: Colors.blue.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(FilterRule filter, bool isInclude) {
    final primaryColor = Theme.of(context).primaryColor;
    
    return Chip(
      backgroundColor: isInclude 
          ? primaryColor.withAlpha(30) 
          : Colors.red.shade50,
      label: Text(filter.keyword),
      labelStyle: TextStyle(
        color: isInclude ? primaryColor : Colors.red.shade700,
        fontWeight: FontWeight.w500,
      ),
      deleteIcon: Icon(
        Icons.close,
        size: 16,
        color: isInclude ? primaryColor : Colors.red.shade400,
      ),
      onDeleted: () => _stageDeleteFilter(filter.id),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildPendingChip(_PendingFilter pending, int index, bool isInclude) {
    final primaryColor = Theme.of(context).primaryColor;
    
    return Chip(
      backgroundColor: isInclude 
          ? primaryColor.withAlpha(60) 
          : Colors.red.shade100,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.add, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(pending.keyword),
        ],
      ),
      labelStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      deleteIcon: const Icon(Icons.close, size: 16, color: Colors.white),
      onDeleted: () => _unstageAddFilter(_pendingAdds.indexOf(pending)),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}

class _PendingFilter {
  final String keyword;
  final bool isInclude;
  
  _PendingFilter({required this.keyword, required this.isInclude});
}
