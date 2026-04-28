import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillbridge/features/home/presentation/cubits/home_cubit.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/ad_list_section.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/categories_section.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/filter_section.dart';
import 'package:skillbridge/features/home/presentation/screens/widgets/home_header.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return CustomScrollView(
          slivers: [
            const HomeHeader(),
            const CategoriesSection(),
            const FiltersSection(),
            if (state is HomeLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state is HomeError)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.read<HomeCubit>().getPosts(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              )
            else if (state is HomeSuccess)
              AdListSection(ads: state.posts)
            else
              SliverFillRemaining(
                child: Center(
                  child: ElevatedButton(
                    onPressed: () => context.read<HomeCubit>().getPosts(),
                    child: const Text('Load Posts'),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
