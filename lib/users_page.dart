import 'package:flutter/material.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<Map<String, dynamic>> users = [
    {'id': 1, 'name': 'Admin', 'email': 'admin@example.com', 'role': 'Admin'},
    {'id': 2, 'name': 'John Doe', 'email': 'john@example.com', 'role': 'User'},
  ];

  void addUser(String name, String email, String role) {
    setState(() {
      users.add({
        'id': users.length + 1,
        'name': name,
        'email': email,
        'role': role,
      });
    });
  }

  void deleteUser(int id) {
    setState(() {
      users.removeWhere((user) => user['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Users')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user['name']),
                  subtitle: Text('${user['email']} - Role: ${user['role']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteUser(user['id']),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  String name = '';
                  String email = '';
                  String role = '';
                  return AlertDialog(
                    title: Text('Add New User'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          onChanged: (value) => name = value,
                          decoration: InputDecoration(labelText: 'Name'),
                        ),
                        TextField(
                          onChanged: (value) => email = value,
                          decoration: InputDecoration(labelText: 'Email'),
                        ),
                        TextField(
                          onChanged: (value) => role = value,
                          decoration: InputDecoration(labelText: 'Role'),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          addUser(name, email, role);
                          Navigator.pop(context);
                        },
                        child: Text('Add'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text('Add User'),
          ),
        ],
      ),
    );
  }
}
