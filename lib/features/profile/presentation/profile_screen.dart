import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/fitness_palette.dart';
import '../application/profile_providers.dart';
import '../domain/profile_data.dart';
import 'widgets/labeled_input_field.dart';
import 'widgets/profile_header_card.dart';

/// The "Profile" branch of [HomeShell]'s bottom nav. Personal-details form
/// is editable inline; the blue "+" FAB commits changes via
/// `ProfileController.save`.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();

  UserProfile? _hydratedFrom;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    super.dispose();
  }

  void _hydrateControllersIfNeeded(UserProfile profile) {
    // Only overwrite the text fields the first time this profile object is
    // seen — otherwise every rebuild while the user is mid-edit would reset
    // their cursor/in-progress input.
    if (identical(_hydratedFrom, profile)) return;
    _hydratedFrom = profile;
    _nameController.text = profile.fullName;
    _emailController.text = profile.email;
    _heightController.text = profile.heightCm.toString();
    _weightController.text = profile.weightKg.toString();
    _caloriesController.text = profile.dailyCalories?.toString() ?? '';
    _proteinController.text = profile.proteinTargetG?.toString() ?? '';
  }

  Future<void> _onSaveTap(UserProfile current) async {
    setState(() => _isSaving = true);
    final updated = current.copyWith(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      heightCm: int.tryParse(_heightController.text) ?? current.heightCm,
      weightKg: int.tryParse(_weightController.text) ?? current.weightKg,
      dailyCalories: int.tryParse(_caloriesController.text),
      proteinTargetG: int.tryParse(_proteinController.text),
    );
    try {
      await ref.read(profileControllerProvider.notifier).save(updated);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
      }
    } catch (error) {
      if (mounted) {
        // Placeholder copy — replace with a mapped, human-readable message
        // once real error codes exist (skill §6.1).
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not save profile: $error')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileControllerProvider);

    return Scaffold(
      backgroundColor: FitnessPalette.profileHeaderEnd,
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Could not load profile: $error'),
        ),
        data: (profile) {
          _hydrateControllersIfNeeded(profile);
          return SafeArea(
            bottom: false,
            child: Column(
              children: [
                ProfileHeaderCard(initial: profile.initial, fullName: profile.fullName, email: profile.email),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: FitnessPalette.cardBackground,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
                      children: [
                        const Text(
                          'PERSONAL DETAILS',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: FitnessPalette.textSecondary, letterSpacing: 0.6),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(child: LabeledInputField(label: 'Full name', controller: _nameController)),
                            const SizedBox(width: 16),
                            Expanded(
                              child: LabeledInputField(
                                label: 'Email',
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: LabeledInputField(
                                label: 'Height (cm)',
                                controller: _heightController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: LabeledInputField(
                                label: 'Weight (kg)',
                                controller: _weightController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: LabeledInputField(
                                label: 'Daily calories',
                                controller: _caloriesController,
                                keyboardType: TextInputType.number,
                                hintText: '2200',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: LabeledInputField(
                                label: 'Protein target (g)',
                                controller: _proteinController,
                                keyboardType: TextInputType.number,
                                hintText: '170',
                              ),
                            ),
                          ],
                        ),
                        // Extra bottom space so the last row isn't hidden
                        // behind the floating "save" FAB.
                        const SizedBox(height: 72),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),

    );
  }
}