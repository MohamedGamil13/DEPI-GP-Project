import 'package:flutter/material.dart';
import 'package:skillbridge/features/saved_services/data/models/saved_service_model.dart';
import 'package:skillbridge/features/saved_services/presentation/screens/widgets/service_card.dart';

Widget listViewBuilder(List<SavedServiceModel> services) {
  if (services.isEmpty) {
    return const Center(child: Text('No saved services here yet.'));
  }

  return ListView.builder(
    padding: const EdgeInsets.all(16.0),
    itemCount: services.length,
    itemBuilder: (context, index) {
      return ServiceCard(service: services[index]);
    },
  );
}