import 'package:cole20/core/providers.dart';
import 'package:cole20/features/profile/application/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:cole20/core/colors.dart';
import 'package:cole20/core/commonWidgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AboutScreen extends ConsumerStatefulWidget {
  const AboutScreen({super.key});

  @override
  ConsumerState<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends ConsumerState<AboutScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileNotifierProvider.notifier).fetchAbout();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);
    return Scaffold(
      backgroundColor: AppColors.green,
      appBar: AppBar(
        backgroundColor: AppColors.green,
        title: commonText(
          "About",
          size: 20,
          isBold: true,
          color: AppColors.white,
        ),
        centerTitle: true,
      ),
      bottomSheet: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        child: _buildBody(profileState)),
    );
  }

  Widget _buildBody(ProfileState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.hasError) {
      return Center(
        child: commonText("Error: ${state.errorMessage}", color: Colors.red),
      );
    }

    final aboutHtml = state.about?.about ?? "<p>No information available.</p>";

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(profileNotifierProvider.notifier).fetchAbout();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(), // Needed for pull-to-refresh
        padding: const EdgeInsets.all(16),
        child: Html(
          data: aboutHtml,
          style: {
            "body": Style(
              fontSize: FontSize.medium,
              lineHeight: LineHeight.number(1.5),
            ),
          },
        ),
      ),
    );
  }
}
