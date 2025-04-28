// lib/utils/app_design_system.dart
import 'package:flutter/material.dart';
import 'theme.dart';

class AppDesignSystem {
  // App-wide padding constants
  static const EdgeInsets defaultPadding = EdgeInsets.all(16);
  static const EdgeInsets cardPadding = EdgeInsets.all(16);
  static const EdgeInsets sectionPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  );

  // App-wide border radius
  static const BorderRadius defaultBorderRadius = BorderRadius.all(
    Radius.circular(16),
  );
  static const BorderRadius messageBorderRadius = BorderRadius.only(
    topLeft: Radius.circular(16),
    topRight: Radius.circular(16),
    bottomLeft: Radius.circular(4),
    bottomRight: Radius.circular(16),
  );

  // App-wide durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  // App Bar Style
  static AppBar appBar(
    BuildContext context,
    String title, {
    List<Widget>? actions,
  }) {
    return AppBar(
      title: Text(title),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      actions: actions,
    );
  }

  // Card Style
  static Card card({required Widget child, VoidCallback? onTap}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: defaultBorderRadius),
      child: InkWell(
        borderRadius: defaultBorderRadius,
        onTap: onTap,
        child: Padding(padding: cardPadding, child: child),
      ),
    );
  }

  // Gradient Background
  static BoxDecoration gradientBackground() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.primary.withOpacity(0.1), AppColors.background],
      ),
    );
  }

  // Section Header
  static Widget sectionHeader(
    BuildContext context,
    String title, {
    String? actionText,
    VoidCallback? onAction,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (actionText != null)
            TextButton(
              onPressed: onAction,
              child: Text(
                actionText,
                style: TextStyle(color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }

  // Stat Card
  static Widget statCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: defaultBorderRadius),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: defaultBorderRadius,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(label, style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  // Message Input Field
  static Widget messageInput({
    required TextEditingController controller,
    required FocusNode focusNode,
    required VoidCallback onSend,
    VoidCallback? onAttach,
  }) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.add, color: AppColors.primary),
            onPressed: onAttach,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: onSend,
            ),
          ),
        ],
      ),
    );
  }

  static Widget fancyBottomNavigationBar({
    required int currentIndex,
    required ValueChanged<int> onTap,
    required BuildContext context,
  }) {
    return Container(
      height: 80, // Increased height for better spacing
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Stack(
        children: [
          // Main navigation items
          Row(
            children: [
              // Left side items - now with more balanced spacing
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                    right: 28,
                  ), // Added margin to push items left
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(
                        icon: Icons.calendar_today_outlined,
                        label: 'Attendance',
                        isSelected: currentIndex == 0,
                        onTap: () => onTap(0),
                      ),
                      _buildNavItem(
                        icon: Icons.assessment_outlined,
                        label: 'Assessment',
                        isSelected: currentIndex == 1,
                        onTap: () => onTap(1),
                      ),
                    ],
                  ),
                ),
              ),

              // Right side items - now with more balanced spacing
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 28,
                  ), // Added margin to push items right
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(
                        icon: Icons.chat_outlined,
                        label: 'Chat',
                        isSelected: currentIndex == 3,
                        onTap: () => onTap(3),
                      ),
                      _buildNavItem(
                        icon: Icons.settings,
                        label: 'Settings',
                        isSelected: currentIndex == 4,
                        onTap: () => onTap(4),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Center button - adjusted positioning
          Center(
            child: Transform.translate(
              offset: const Offset(
                0,
                -24,
              ), // Slightly higher to accommodate new height
              child: GestureDetector(
                onTap: () => onTap(2),
                child: Container(
                  width: 60, // Slightly larger
                  height: 60, // Slightly larger
                  decoration: BoxDecoration(
                    color: currentIndex == 2 ? AppColors.primary : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(
                      color:
                          currentIndex == 2
                              ? AppColors.primary
                              : Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    currentIndex == 2 ? Icons.home : Icons.home_outlined,
                    color: currentIndex == 2 ? Colors.white : AppColors.primary,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Updated _buildNavItem with better spacing
  static Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 8,
          ), // Reduced horizontal padding
          constraints: const BoxConstraints(
            minWidth: 56,
          ), // Minimum width for each item
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 22, // Slightly smaller icon
                color: isSelected ? AppColors.primary : Colors.grey.shade600,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11, // Slightly smaller font
                  color: isSelected ? AppColors.primary : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
