import 'package:flutter/material.dart';
import '../models/airport_package.dart';
import '../services/hive_service.dart';

class PackageManagerScreen extends StatefulWidget {
  const PackageManagerScreen({Key? key}) : super(key: key);

  @override
  State<PackageManagerScreen> createState() => _PackageManagerScreenState();
}

class _PackageManagerScreenState extends State<PackageManagerScreen> {
  final HiveService _hiveService = HiveService();
  List<AirportPackage> _downloadedPackages = [];

  @override
  void initState() {
    super.initState();
    _refreshPackagesList();
  }

  void _refreshPackagesList() {
    setState(() {
      _downloadedPackages = _hiveService.getAllDownloadedAirports();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("إدارة حزم المطارات المحملة"),
        backgroundColor: Colors.teal,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: _downloadedPackages.isEmpty
            ? const Center(
                child: Text("لا توجد حزم مطارات محملة حالياً."),
              )
            : ListView.builder(
                itemCount: _downloadedPackages.length,
                itemBuilder: (context, index) {
                  final package = _downloadedPackages[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.flight_land, color: Colors.teal),
                      title: Text(package.airportName),
                      subtitle: Text("الدولة: ${package.country} (${package.airportCode})"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await _hiveService.deleteAirportPackage(package.airportCode);
                          _refreshPackagesList();
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}