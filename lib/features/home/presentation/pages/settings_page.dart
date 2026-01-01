import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tube_filter/core/database/app_database.dart';
import 'package:tube_filter/core/services/backup_service.dart';
import 'package:tube_filter/features/home/presentation/widgets/theme_selector.dart';
import 'package:tube_filter/features/home/presentation/pages/about_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Colors.grey.shade900 : Colors.white;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // Theme Section
          const ThemeSelector(),

          // Data & Sync Section
          _SettingsCard(
            icon: Icons.cloud_sync_outlined,
            title: 'Data & Sync',
            color: primaryColor,
            cardColor: cardColor,
            children: [
              _SettingsTile(
                icon: Icons.upload_rounded,
                iconBg: Colors.blue.shade50,
                iconColor: Colors.blue,
                title: 'Export Backup',
                subtitle: 'Save channels and filters',
                onTap: () => _exportData(context),
              ),
              const _SettingsDivider(),
              _SettingsTile(
                icon: Icons.download_rounded,
                iconBg: Colors.green.shade50,
                iconColor: Colors.green,
                title: 'Import Backup',
                subtitle: 'Restore from file',
                onTap: () => _importData(context),
              ),
            ],
          ),

          // Content Section
          _SettingsCard(
            icon: Icons.movie_filter_outlined,
            title: 'Content',
            color: primaryColor,
            cardColor: cardColor,
            children: [
              _SettingsSwitch(
                icon: Icons.timer_off_outlined,
                iconBg: Colors.orange.shade50,
                iconColor: Colors.orange,
                title: 'Block Shorts',
                subtitle: 'Hide videos under 60 seconds',
                value: true,
                onChanged: (val) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Shorts blocking is always enabled'),
                      backgroundColor: primaryColor,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),

          // About Section
          _SettingsCard(
            icon: Icons.info_outline,
            title: 'About',
            color: primaryColor,
            cardColor: cardColor,
            children: [
              _SettingsTile(
                icon: Icons.apps_rounded,
                iconBg: primaryColor.withAlpha(30),
                iconColor: primaryColor,
                title: 'About FixTube',
                subtitle: 'Version 1.0.0 • By Sarfaraz',
                trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutPage()),
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Future<void> _exportData(BuildContext context) async {
    final db = context.read<AppDatabase>();
    final service = BackupService(db);
    final messenger = ScaffoldMessenger.of(context);

    try {
      final jsonStr = await service.exportData();
      if (jsonStr != null) {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/fixtube_backup.json');
        await file.writeAsString(jsonStr);
        await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
      }
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Export Failed: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _importData(BuildContext context) async {
    final db = context.read<AppDatabase>();
    final messenger = ScaffoldMessenger.of(context);

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final jsonStr = await file.readAsString();
        final service = BackupService(db);
        await service.importData(jsonStr);
        messenger.showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Import Successful!'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Import Failed: $e'), backgroundColor: Colors.red),
      );
    }
  }
}

// ============ REUSABLE WIDGETS ============

class _SettingsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final Color cardColor;
  final List<Widget> children;

  const _SettingsCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.cardColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          ...children,
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsSwitch extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitch({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            thumbColor: WidgetStateProperty.resolveWith((states) {
              return states.contains(WidgetState.selected) ? primaryColor : null;
            }),
            trackColor: WidgetStateProperty.resolveWith((states) {
              return states.contains(WidgetState.selected) 
                  ? primaryColor.withAlpha(100) 
                  : null;
            }),
          ),
        ],
      ),
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(height: 1, color: Colors.grey.shade200),
    );
  }
}
