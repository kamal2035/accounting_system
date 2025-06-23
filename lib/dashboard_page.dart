import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to the Dashboard!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/warehouses');
                    },
                    child: Text('Manage Warehouses'),
                  ),

                  _buildDashboardTile(
                    context,
                    title: 'Branches',
                    icon: Icons.business,
                    onTap: () {
                      // فتح صفحة إدارة الفروع
                      Navigator.pushNamed(context, '/branches');
                    },
                  ),
                  _buildDashboardTile(
                    context,
                    title: 'Users',
                    icon: Icons.people,
                    onTap: () {
                      // فتح صفحة إدارة المستخدمين
                      Navigator.pushNamed(context, '/users');
                    },
                  ),
                  _buildDashboardTile(
                    context,
                    title: 'Reports',
                    icon: Icons.bar_chart,
                    onTap: () {
                      // فتح صفحة التقارير
                      Navigator.pushNamed(context, '/reports');
                    },
                  ),
                  _buildDashboardTile(
                    context,
                    title: 'Settings',
                    icon: Icons.settings,
                    onTap: () {
                      // فتح صفحة الإعدادات
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Theme.of(context).primaryColor),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
