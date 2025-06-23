import 'package:flutter/material.dart';
import 'database/database_helper.dart';

class WarehousesPage extends StatefulWidget {
  @override
  _WarehousesPageState createState() => _WarehousesPageState();
}

class _WarehousesPageState extends State<WarehousesPage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  late Future<List<Map<String, dynamic>>> warehousesFuture;

  @override
  void initState() {
    super.initState();
    fetchWarehouses();
  }

  void fetchWarehouses() {
    setState(() {
      warehousesFuture = dbHelper.getAllWarehouses();
    });
  }

  void openAddWarehouseDialog() {
    final nameController = TextEditingController();
    final locationController = TextEditingController();
    final phoneController = TextEditingController();
    String status = 'Active';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Warehouse'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Warehouse Name'),
                ),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(labelText: 'Location'),
                ),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                ),
                DropdownButtonFormField<String>(
                  value: status,
                  items: ['Active', 'Inactive']
                      .map(
                        (status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => status = value!,
                  decoration: InputDecoration(labelText: 'Status'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await dbHelper.insertWarehouse({
                  'name': nameController.text,
                  'location': locationController.text,
                  'phone': phoneController.text,
                  'status': status,
                });
                fetchWarehouses();
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void openWarehouseOptions(Map<String, dynamic> warehouse) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Warehouse'),
              onTap: () {
                Navigator.pop(context);
                openEditWarehouseDialog(warehouse);
              },
            ),
            ListTile(
              leading: Icon(Icons.toggle_on),
              title: Text('Change Status'),
              onTap: () {
                Navigator.pop(context);
                toggleWarehouseStatus(warehouse);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete Warehouse'),
              onTap: () async {
                await dbHelper.deleteWarehouse(warehouse['id']);
                fetchWarehouses();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void openEditWarehouseDialog(Map<String, dynamic> warehouse) {
    final nameController = TextEditingController(text: warehouse['name']);
    final locationController = TextEditingController(
      text: warehouse['location'],
    );
    final phoneController = TextEditingController(text: warehouse['phone']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Warehouse'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Warehouse Name'),
                ),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(labelText: 'Location'),
                ),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await dbHelper.updateWarehouse(warehouse['id'], {
                  'name': nameController.text,
                  'location': locationController.text,
                  'phone': phoneController.text,
                });
                fetchWarehouses();
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void toggleWarehouseStatus(Map<String, dynamic> warehouse) async {
    final newStatus = warehouse['status'] == 'Active' ? 'Inactive' : 'Active';
    await dbHelper.updateWarehouse(warehouse['id'], {'status': newStatus});
    fetchWarehouses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Warehouses')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: warehousesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No warehouses found.'));
          }

          final warehouses = snapshot.data!;
          return ListView.builder(
            itemCount: warehouses.length,
            itemBuilder: (context, index) {
              final warehouse = warehouses[index];
              final isInactive = warehouse['status'] == 'Inactive';

              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          child: Text(
                            warehouse['name'],
                            style: TextStyle(fontSize: 16),
                          ),
                          margin: EdgeInsets.only(right: 20),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            warehouse['status'] == 'Active'
                                ? Icons.toggle_on
                                : Icons.toggle_off,
                            color: warehouse['status'] == 'Active'
                                ? Colors.green
                                : const Color.fromARGB(255, 159, 7, 7),
                          ),
                          onPressed: () => toggleWarehouseStatus(warehouse),
                        ),
                      ],
                    ),
                  ],
                ),
                subtitle: isInactive
                    ? Text(
                        'Inactive',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 218, 28, 28),
                        ),
                      )
                    : null,
                onTap: () => openWarehouseOptions(warehouse),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: openAddWarehouseDialog,
      ),
    );
  }
}
