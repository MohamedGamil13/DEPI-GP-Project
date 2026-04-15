import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillbridge/core/theme/app_colors.dart';
import 'package:skillbridge/features/saved_services/presentation/screens/widgets/list_view_builder.dart';
import 'package:skillbridge/features/saved_services/presentation/view_model/saved_services_cubit.dart';

class SavedServicesScreen extends StatelessWidget {
  const SavedServicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Saved Services',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.blue,
            unselectedLabelColor: AppColors.textLight,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Cleaning'),
              Tab(text: 'Maintenance'),
              Tab(text: 'Beauty'),
            ],
          ),
        ),

        body: BlocBuilder<SavedServicesCubit, SavedServicesState>(
          builder: (context, state) {
            if (state is SavedServicesLoading) {
              return const Center(child: CircularProgressIndicator(color: Colors.blue));
            } else if (state is SavedServicesError) {
              return Center(
                child: Text(
                  state.errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            } else if (state is SavedServicesLoaded) {
              final myData = state.savedServices;

              return TabBarView(
                children: [
                  listViewBuilder(myData),
                  listViewBuilder(myData.where((e) => e.category == 'Cleaning').toList()),
                  listViewBuilder(myData.where((e) => e.category == 'Maintenance').toList()),
                  listViewBuilder(myData.where((e) => e.category == 'Beauty').toList()),
                ],
              );
            }
            return const Center(child: Text('Getting things ready...'));
          },
        ),
      ),
    );
  }


}