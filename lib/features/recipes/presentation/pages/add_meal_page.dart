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
          SnackBar(
            content: Text('Could not pick image: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _clearImage() {
    setState(() {
      if (_localImagePath != null) {
        try {
          File(_localImagePath!).deleteSync();
        } catch (_) {}
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
    return PopScope(
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.addMealTitle),
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildImagePreview(),
                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _imageButton(
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      onTap: () => _pickImage(ImageSource.gallery),
                    ),
                    const SizedBox(width: 12),
                    _imageButton(
                      icon: Icons.camera_alt,
                      label: 'Camera',
                      onTap: () => _pickImage(ImageSource.camera),
                    ),
                    if (_localImagePath != null || _thumbnailController.text.isNotEmpty) ...[
                      const SizedBox(width: 12),
                      _imageButton(
                        icon: Icons.clear,
                        label: 'Clear',
                        color: Colors.red,
                        onTap: _clearImage,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'or paste URL',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _thumbnailController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.thumbnailUrl,
                    hintText: AppStrings.thumbnailUrlHint,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.link),
                  ),
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: AppStrings.mealName,
                    hintText: AppStrings.mealNameHint,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.restaurant),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? AppStrings.recipeRequired : null,
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
                          border: OutlineInputBorder(),
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
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.public),
                        ),
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.ingredients,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _addIngredient,
                      icon: const Icon(Icons.add),
                      label: const Text(AppStrings.addIngredient),
                    ),
                  ],
                ),
                ..._buildIngredientFields(),
                const SizedBox(height: 20),

                const Text(
                  'Instructions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _instructionsController,
                  decoration: const InputDecoration(
                    hintText: AppStrings.instructionsHint,
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    AppStrings.save,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.amber,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontSize: 13)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.15),
        foregroundColor: color.withValues(alpha: 1.0),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_localImagePath != null) {
      return Container(
        height: 180,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        width: double.infinity,
        child: Image.file(
          File(_localImagePath!),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildPlaceholder(),
        ),
      );
    }

    final url = _thumbnailController.text.trim();
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      width: double.infinity,
      child: url.isEmpty
          ? _buildPlaceholder()
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
                    Text('Loading...',
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              errorWidget: (_, __, ___) => const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Invalid image URL',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPlaceholder() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, size: 48, color: Colors.grey),
          SizedBox(height: 8),
          Text('Image preview', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  List<Widget> _buildIngredientFields() {
    if (_ingredients.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'No ingredients added yet',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      ];
    }

    return List.generate(_ingredients.length, (index) {
      final ing = _ingredients[index];
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: ing.nameController,
                decoration: InputDecoration(
                  labelText: '${AppStrings.ingredientName} ${index + 1}',
                  border: const OutlineInputBorder(),
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
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: Icon(Icons.remove_circle, color: Colors.red),
              onPressed: () => _removeIngredient(index),
            ),
          ],
        ),
      );
    });
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
