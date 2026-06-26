import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recipe_app/core/constants/app_strings.dart';
import 'package:recipe_app/features/recipes/domain/entities/meal_detail.dart';
import 'package:recipe_app/features/recipes/domain/entities/user_meal.dart';
import '../bloc/custom_meal_bloc/custom_meal_bloc.dart';
import '../bloc/custom_meal_bloc/custom_meal_event.dart';

bool get _isDesktop =>
    Platform.isWindows || Platform.isLinux || Platform.isMacOS;

class AddMealPage extends StatefulWidget {
  const AddMealPage({super.key});

  @override
  State<AddMealPage> createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _thumbnailController = TextEditingController();
  final _categoryController = TextEditingController();
  final _areaController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _imagePicker = ImagePicker();

  final List<_IngredientField> _ingredients = [];
  String? _localImagePath;
  bool _isDirty = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_markDirty);
    _thumbnailController.addListener(_onThumbnailChanged);
    _categoryController.addListener(_markDirty);
    _areaController.addListener(_markDirty);
    _instructionsController.addListener(_markDirty);
  }

  void _markDirty() {
    if (!_isDirty) setState(() => _isDirty = true);
  }

  void _onThumbnailChanged() {
    if (_thumbnailController.text.trim().isNotEmpty && _localImagePath != null) {
      setState(() => _localImagePath = null);
    }
    _markDirty();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _thumbnailController.dispose();
    _categoryController.dispose();
    _areaController.dispose();
    _instructionsController.dispose();
    for (final ing in _ingredients) {
      ing.nameController.dispose();
      ing.measureController.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final effectiveSource = _isDesktop && source == ImageSource.camera
          ? ImageSource.gallery
          : source;

      final XFile? pickedFile = await _imagePicker.pickImage(
        source: effectiveSource,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (pickedFile == null) return;

      try {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName =
            'recipe_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final savedPath = '${appDir.path}${Platform.pathSeparator}$fileName';
        final savedFile = await File(pickedFile.path).copy(savedPath);
        setState(() {
          _localImagePath = savedFile.path;
          _thumbnailController.clear();
          _isDirty = true;
        });
      } catch (_) {
        setState(() {
          _localImagePath = pickedFile.path;
          _thumbnailController.clear();
          _isDirty = true;
        });
      }
    } catch (e) {
      debugPrint('Image picker error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not pick image: $e')),
        );
      }
    }
  }

  void _clearImage() {
    setState(() {
      if (_localImagePath != null) {
        try { File(_localImagePath!).deleteSync(); } catch (_) {}
        _localImagePath = null;
      }
      _thumbnailController.clear();
      _isDirty = true;
    });
  }

  void _addIngredient() {
    setState(() {
      _ingredients.add(_IngredientField(
        nameController: TextEditingController(),
        measureController: TextEditingController(),
      ));
      _isDirty = true;
    });
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients[index].nameController.dispose();
      _ingredients[index].measureController.dispose();
      _ingredients.removeAt(index);
      _isDirty = true;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final thumbnail = _localImagePath ?? _thumbnailController.text.trim();
    final meal = UserMeal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      thumbnail: thumbnail,
      category: _categoryController.text.trim(),
      area: _areaController.text.trim(),
      instructions: _instructionsController.text.trim(),
      ingredients: _ingredients
          .map((e) => Ingredient(
                name: e.nameController.text.trim(),
                measure: e.measureController.text.trim(),
              ))
          .where((i) => i.name.isNotEmpty)
          .toList(),
      createdAt: DateTime.now(),
    );

    if (!mounted) return;
    context.read<CustomMealBloc>().add(SaveCustomMealEvent(meal));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(AppStrings.savedSuccess)),
    );
    Navigator.pop(context, true);
  }

  Future<bool> _onWillPop() async {
    if (!_isDirty) return true;
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.confirmDiscard),
        content: const Text(AppStrings.confirmDiscardMsg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.addMealTitle),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        body: Form(
          key: _formKey,
          child: Stepper(
            currentStep: _currentStep,
            onStepContinue: _currentStep < 2
                ? () => setState(() => _currentStep++)
                : _save,
            onStepCancel: _currentStep > 0
                ? () => setState(() => _currentStep--)
                : null,
            onStepTapped: (s) => setState(() => _currentStep = s),
            controlsBuilder: (ctx, details) => Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: Text(_currentStep == 2 ? AppStrings.save : 'Continue'),
                  ),
                  if (details.onStepCancel != null)
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Back'),
                    ),
                ],
              ),
            ),
            steps: [
              Step(
                title: const Text('Image'),
                isActive: _currentStep >= 0,
                state: _localImagePath != null || _thumbnailController.text.isNotEmpty
                    ? StepState.complete
                    : StepState.indexed,
                content: _stepImage(theme),
              ),
              Step(
                title: const Text('Details'),
                isActive: _currentStep >= 1,
                state: _nameController.text.trim().isNotEmpty
                    ? StepState.complete
                    : StepState.indexed,
                content: _stepDetails(theme),
              ),
              Step(
                title: const Text('Ingredients & Instructions'),
                isActive: _currentStep >= 2,
                state: _ingredients.isNotEmpty && _instructionsController.text.isNotEmpty
                    ? StepState.complete
                    : StepState.indexed,
                content: _stepIngredientsInstructions(theme),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepImage(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildImagePreview(theme),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageBtn(Icons.photo_library, 'Gallery', theme.colorScheme.primary,
                () => _pickImage(ImageSource.gallery)),
            const SizedBox(width: 12),
            _imageBtn(Icons.camera_alt, 'Camera', theme.colorScheme.primary,
                () => _pickImage(ImageSource.camera)),
            if (_localImagePath != null || _thumbnailController.text.isNotEmpty) ...[
              const SizedBox(width: 12),
              _imageBtn(Icons.clear, 'Clear', Colors.red, _clearImage),
            ],
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: Divider(color: theme.dividerColor)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('or paste URL',
                  style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 12)),
            ),
            Expanded(child: Divider(color: theme.dividerColor)),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _thumbnailController,
          decoration: const InputDecoration(
            labelText: AppStrings.thumbnailUrl,
            hintText: AppStrings.thumbnailUrlHint,
            prefixIcon: Icon(Icons.link),
          ),
          keyboardType: TextInputType.url,
        ),
      ],
    );
  }

  Widget _stepDetails(ThemeData theme) {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: AppStrings.mealName,
            hintText: AppStrings.mealNameHint,
            prefixIcon: Icon(Icons.restaurant),
          ),
          validator: (v) => (v == null || v.trim().isEmpty) ? AppStrings.recipeRequired : null,
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: AppStrings.mealCategory,
                  hintText: AppStrings.mealCategoryHint,
                  prefixIcon: Icon(Icons.category),
                ),
                textCapitalization: TextCapitalization.words,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _areaController,
                decoration: const InputDecoration(
                  labelText: AppStrings.mealArea,
                  hintText: AppStrings.mealAreaHint,
                  prefixIcon: Icon(Icons.public),
                ),
                textCapitalization: TextCapitalization.words,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _stepIngredientsInstructions(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Ingredients', style: theme.textTheme.titleMedium),
            TextButton.icon(
              onPressed: _addIngredient,
              icon: const Icon(Icons.add, size: 18),
              label: const Text(AppStrings.addIngredient),
            ),
          ],
        ),
        if (_ingredients.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text('No ingredients added yet',
                style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
          )
        else
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _ingredients.length,
            onReorderItem: (oldI, newI) {
              setState(() {
                final item = _ingredients.removeAt(oldI);
                _ingredients.insert(newI, item);
              });
            },
            itemBuilder: (_, i) {
              final ing = _ingredients[i];
              return Padding(
                key: ValueKey(ing.hashCode),
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    ReorderableDragStartListener(
                      index: i,
                      child: Icon(Icons.drag_handle, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: ing.nameController,
                        decoration: InputDecoration(
                          labelText: '${AppStrings.ingredientName} ${i + 1}',
                          isDense: true,
                        ),
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: ing.measureController,
                        decoration: const InputDecoration(
                          labelText: AppStrings.ingredientMeasure,
                          isDense: true,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.remove_circle, color: Colors.red[400], size: 20),
                      onPressed: () => _removeIngredient(i),
                    ),
                  ],
                ),
              );
            },
          ),
        const SizedBox(height: 16),
        Text('Instructions', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        TextFormField(
          controller: _instructionsController,
          decoration: const InputDecoration(
            hintText: AppStrings.instructionsHint,
            alignLabelWithHint: true,
          ),
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }

  Widget _imageBtn(IconData icon, String label, Color color, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontSize: 13)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.15),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
    );
  }

  Widget _buildImagePreview(ThemeData theme) {
    if (_localImagePath != null) {
      return Container(
        height: 180,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
        ),
        clipBehavior: Clip.antiAlias,
        width: double.infinity,
        child: Image.file(
          File(_localImagePath!),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(theme),
        ),
      );
    }

    final url = _thumbnailController.text.trim();
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      width: double.infinity,
      child: url.isEmpty
          ? _placeholder(theme)
          : CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              memCacheWidth: 360,
              memCacheHeight: 200,
              placeholder: (_, __) => const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(strokeWidth: 3),
                    SizedBox(height: 8),
                    Text('Loading...', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              errorWidget: (_, __, ___) => const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Invalid image URL', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _placeholder(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, size: 48,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
          const SizedBox(height: 8),
          Text('Image preview',
              style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
        ],
      ),
    );
  }
}

class _IngredientField {
  final TextEditingController nameController;
  final TextEditingController measureController;

  _IngredientField({
    required this.nameController,
    required this.measureController,
  });
}