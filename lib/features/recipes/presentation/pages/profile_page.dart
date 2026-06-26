import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/theme_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            CircleAvatar(
              radius: 52,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
              child: CircleAvatar(
                radius: 48,
                backgroundColor: theme.colorScheme.primary,
                child: Icon(Icons.restaurant,
                    size: AppDimensions.avatarIconSize, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Text(AppStrings.appTitle, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text(
              AppStrings.profileTagline,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 32),

            _section(theme, 'Preferences', [
              _SettingTile(
                icon: isDark ? Icons.dark_mode : Icons.light_mode,
                iconColor: isDark ? Colors.amber : theme.colorScheme.primary,
                title: 'Dark Mode',
                trailing: Switch(
                  value: isDark,
                  onChanged: (_) => context.read<ThemeCubit>().toggle(),
                  activeTrackColor: Colors.amber,
                ),
              ),
            ]),

            const SizedBox(height: 24),
            _section(theme, 'About', [
              _SettingTile(
                icon: Icons.info_outline,
                title: 'Version',
                subtitle: '1.0.0',
              ),
              _SettingTile(
                icon: Icons.language,
                title: 'Data source',
                subtitle: 'TheMealDB',
              ),
            ]),

            const SizedBox(height: 24),
            _section(theme, 'More', [
              _SettingTile(
                icon: Icons.star_border,
                title: 'Rate this app',
                onTap: () {},
              ),
              _SettingTile(
                icon: Icons.share_outlined,
                title: 'Share app',
                onTap: () {},
              ),
            ]),

            const SizedBox(height: 40),
            Text(
              AppStrings.profileCopyright,
              style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.35), fontSize: 13),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _section(ThemeData theme, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                fontSize: 13,
              )),
        ),
        Card(
          elevation: 0,
          color: theme.colorScheme.surfaceContainerHighest,
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingTile({
    required this.icon,
    this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: iconColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.6)),
      title: Text(title, style: theme.textTheme.bodyMedium),
      subtitle: subtitle != null
          ? Text(subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ))
          : null,
      trailing: trailing ?? (onTap != null
          ? Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withValues(alpha: 0.3))
          : null),
      onTap: onTap,
      dense: true,
    );
  }
}