import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/festival_provider.dart';

class FestivalScreen extends StatefulWidget {
  const FestivalScreen({super.key});

  @override
  State<FestivalScreen> createState() => _FestivalScreenState();
}

class _FestivalScreenState extends State<FestivalScreen> {
  final TextEditingController yearController = TextEditingController(
    text: "2026",
  );

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<FestivalProvider>().loadFestivals("2026");
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FestivalProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Festivals")),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: yearController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Enter Year"),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    provider.loadFestivals(yearController.text);
                  },
                  child: const Text("Load"),
                ),
              ],
            ),
          ),

          Expanded(
            child: Builder(
              builder: (_) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.error != null) {
                  return Center(child: Text(provider.error!));
                }

                if (provider.festivals.isEmpty) {
                  return const Center(child: Text("No festivals found"));
                }

                return ListView.builder(
                  itemCount: provider.festivals.length,
                  itemBuilder: (context, index) {
                    final festival = provider.festivals[index];

                    return ListTile(
                      title: Text(festival.name),
                      subtitle: Text(festival.date),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
