import 'package:flutter/material.dart';

class BranchesPage extends StatefulWidget {
  @override
  _BranchesPageState createState() => _BranchesPageState();
}

class _BranchesPageState extends State<BranchesPage> {
  List<Map<String, dynamic>> branches = [
    {'id': 1, 'name': 'Main Branch', 'location': 'Downtown'},
    {'id': 2, 'name': 'West Branch', 'location': 'West City'},
  ];

  void addBranch(String name, String location) {
    setState(() {
      branches.add({
        'id': branches.length + 1,
        'name': name,
        'location': location,
      });
    });
  }

  void deleteBranch(int id) {
    setState(() {
      branches.removeWhere((branch) => branch['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Branches')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: branches.length,
              itemBuilder: (context, index) {
                final branch = branches[index];
                return ListTile(
                  title: Text(branch['name']),
                  subtitle: Text('Location: ${branch['location']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteBranch(branch['id']),
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
                  String location = '';
                  return AlertDialog(
                    title: Text('Add New Branch'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          onChanged: (value) => name = value,
                          decoration: InputDecoration(labelText: 'Branch Name'),
                        ),
                        TextField(
                          onChanged: (value) => location = value,
                          decoration: InputDecoration(labelText: 'Location'),
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
                          addBranch(name, location);
                          Navigator.pop(context);
                        },
                        child: Text('Add'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text('Add Branch'),
          ),
        ],
      ),
    );
  }
}
