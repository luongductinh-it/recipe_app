import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/info_row.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 32),
            const CircleAvatar(
              radius: AppDimensions.avatarRadius,
              backgroundColor: AppColors.accentAmber,
              child: Icon(Icons.restaurant,
                  size: AppDimensions.avatarIconSize, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.appTitle,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.profileTagline,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.greyDark),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const InfoRow(
              icon: Icons.info_outline,
              label: AppStrings.profileVersion,
              value: '1.0.0',
            ),
            const Divider(),
            const InfoRow(
              icon: Icons.language,
              label: AppStrings.profileDataSource,
              value: 'TheMealDB',
            ),
            const Divider(),
            const Spacer(),
            Text(
              AppStrings.profileCopyright,
              style: TextStyle(color: AppColors.greyMedium),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
