import 'package:flutter/material.dart';

class ExpandableFab extends StatefulWidget {
  const ExpandableFab({super.key});

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> with SingleTickerProviderStateMixin {
  bool _isFabExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleFab() {
    setState(() {
      _isFabExpanded = !_isFabExpanded;
      if (_isFabExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _expandAnimation.value,
                child: Transform.translate(
                  offset: Offset(0, _expandAnimation.value * -10),
                  child: Opacity(
                    opacity: _expandAnimation.value,
                    child: _buildOptionsCard(context),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            onPressed: _toggleFab,
            backgroundColor: Colors.blue, // Replace with your AppTheme if needed
            elevation: 8,
            child: AnimatedRotation(
              turns: _isFabExpanded ? 0.125 : 0,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                _isFabExpanded ? Icons.close_rounded : Icons.add_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade800.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOptionItem(
            context,
            icon: Icons.chat_rounded,
            label: 'Message',
            color: Colors.blue,
            badge: '2',
            onTap: () {
              _toggleFab();
              Navigator.pushNamed(context, '/main-chat');
            },
          ),
          const SizedBox(height: 8),
          _buildOptionItem(
            context,
            icon: Icons.notifications_rounded,
            label: 'Notifications',
            color: Colors.orange,
            badge: '3',
            onTap: () {
              _toggleFab();
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          const SizedBox(height: 8),
          _buildOptionItem(
            context,
            icon: Icons.chat_rounded,
            label: 'Complain',
            color: Colors.blue,
            badge: '2',
            onTap: () {
              _toggleFab();
              Navigator.pushNamed(context, '/complain');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionItem(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Color color,
        required VoidCallback onTap,
        String? badge,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 36, // Increased to accommodate badge overflow
              height: 36, // Increased to accommodate badge overflow
              child: Stack(
                clipBehavior: Clip.none, // This allows the badge to overflow
                children: [
                  Positioned(
                    left: 2,
                    top: 2,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(icon, color: Colors.white, size: 18),
                    ),
                  ),
                  if (badge != null)
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.shade600,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          badge,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 6), // Reduced slightly since we increased the icon container
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}