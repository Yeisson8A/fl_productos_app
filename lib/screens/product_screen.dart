import 'package:fl_productos_app/theme/app_theme.dart';
import 'package:fl_productos_app/ui/input_decorations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';

class ProductScreen extends StatelessWidget {
   
  const ProductScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Obtener instancia del servicio
    final productService = Provider.of<ProductsService>(context);

    return ChangeNotifierProvider(
      create: ( _ ) => ProductFormProvider(productService.selectedProduct!),
      child: _ProductScreenBody(productService: productService),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  final ProductsService productService;
  const _ProductScreenBody({super.key, required this.productService});

  @override
  Widget build(BuildContext context) {
    // Obtener instancia del provider
    final productFormProvider = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // Imagen del producto
                ProductImage(url: productService.selectedProduct!.picture),
                // Botón para regresar a pantalla anterior
                Positioned(
                  top: 60, 
                  left: 20, 
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(), 
                    icon: const Icon(Icons.arrow_back_ios_rounded, size: 40, color: Colors.white)
                  )
                ),
                // Botón para abrir cámara o galeria
                Positioned(
                  top: 60, 
                  right: 20, 
                  child: _ProductImagePicker(productService: productService)
                )
              ],
            ),
            // Formulario
            const _ProductForm(),
            const SizedBox(height: 100)
          ],
        ),
      ),
      // Botón para guardar
      floatingActionButton: FloatingActionButton(
        onPressed: productService.isSaving ? null : () async {
          // Para cerrar el teclado al dar clic al botón
          FocusScope.of(context).unfocus();
          // Validar si el formulario es válido
          if (!productFormProvider.isValidForm()) return;
          // Subir imagen a cloudinary
          final String? imageUrl = await productService.uploadImage();
          // Asignar url de la imagen subida a cloudinary al producto seleccionado
          if (imageUrl != null) productFormProvider.product.picture = imageUrl;
          // Guardar cambios
          await productService.saveOrCreateProduct(productFormProvider.product);
          // Mostrar mensaje de confirmación
          NotificationsService.showSucessfullSnackbar();
        },
        child: productService.isSaving 
          ? const CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)) 
          : const Icon(Icons.save_rounded, color: Colors.white)
      ),
    );
  }
}

class _ProductImagePicker extends StatelessWidget {
  const _ProductImagePicker({super.key, required this.productService});
  final ProductsService productService;

  @override
  Widget build(BuildContext context) {
    // Instancia del selector de imagenes (Cámara y Galería)
    final picker = ImagePicker();

    return PopupMenuButton(
      icon: const Icon(Icons.camera_alt_rounded, size: 40, color: Colors.white),
      onSelected: (value) async {
        XFile? pickedFile;
    
        switch (value) {
          case 'camara':
            pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
            break;
          case 'galeria':
            pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
            break;
        }
    
        // Validar si seleccionó una foto
        if (pickedFile == null) return;
        // Actualizar imagen en pantalla
        productService.updateSelectedProductImage(pickedFile.path);
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'camara',
          child: Row(
            children: [
              Padding(padding: EdgeInsets.only(right: 8), child: Icon(Icons.camera)),
              Text('Cámara', style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'galeria',
          child: Row(
            children: [
              Padding(padding: EdgeInsets.only(right: 8), child: Icon(Icons.image)),
              Text('Galería', style: TextStyle(fontSize: 15)),
            ],
          ),
        )
      ],
    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({super.key});

  @override
  Widget build(BuildContext context) {
    const boxDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))]
    );
    // Obtener instancia del provider
    final productFormProvider = Provider.of<ProductFormProvider>(context);
    final product = productFormProvider.product;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: boxDecoration,
        child: Form(
          key: productFormProvider.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              const SizedBox(height: 10),
              TextFormField(
                initialValue: product.name,
                decoration: InputDecorations.authInputDecoration(hintText: 'Nombre', labelText: 'Nombre'),
                onChanged: (value) => product.name = value,
                validator: (value) {
                  return (value == null || value.isEmpty) ? 'El nombre es obligatorio' : null;
                }
              ),
              const SizedBox(height: 30),
              TextFormField(
                initialValue: '${product.price}',
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))], // Formato del input
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(hintText: 'Precio', labelText: 'Precio'),
                onChanged: (value) {
                  product.price = double.tryParse(value) == null ? 0 : double.parse(value);
                },
                validator: (value) {
                  return (value == null || value.isEmpty) ? 'El precio es obligatorio' : null;
                }
              ),
              const SizedBox(height: 30),
              SwitchListTile.adaptive(
                title: const Text('Disponible?'),
                activeColor: AppTheme.primary,
                value: product.available, 
                onChanged: productFormProvider.updateAvailability,
              ),
              const SizedBox(height: 30)
            ],
          )
        ),
      ),
    );
  }
}