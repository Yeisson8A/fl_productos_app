import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/models.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _baseUrlFirebase = 'flutter-varios-3d5dd-default-rtdb.firebaseio.com';
  final String _urlCloudinary = 'https://api.cloudinary.com/v1_1/dbyeelzfz/image/upload?upload_preset=x4kmrgga';
  final storage = FlutterSecureStorage();
  final List<Product> products = [];
  Product? selectedProduct;
  File? newPictureFile;
  bool isLoading = true;
  bool isSaving = false;

  ProductsService() {
    loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    // Indicar que se esta cargando la información
    isLoading = true;
    // Redibujar los widgets por cambio en la información
    notifyListeners();

    final url = Uri.https(_baseUrlFirebase, 'products.json', {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.get(url);
    final Map<String, dynamic> productsMap = json.decode(resp.body);
    productsMap.forEach((key, value) {
      final tempProduct = Product.fromJson(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });

    // Indicar que ya se cargo la información
    isLoading = false;
    // Redibujar los widgets por cambio en la información
    notifyListeners();
    return products;
  }

  Future saveOrCreateProduct(Product product) async {
    // Indicar que se esta guardando la información en la base de datos
    isSaving = true;
    // Redibujar los widgets por cambio en la información
    notifyListeners();

    if (product.id == null) {
      // Creación
      await createProduct(product);
    }
    else {
      // Actualización
      await updateProduct(product);
    }

    // Indicar que ya se guardo la información en la base de datos
    isSaving = false;
    // Redibujar los widgets por cambio en la información
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrlFirebase, 'products/${product.id}.json', {'auth': await storage.read(key: 'token') ?? ''});
    await http.put(url, body: product.toRawJson());

    // Buscar elemento en la lista y actualizar
    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;
    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseUrlFirebase, 'products.json', {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.post(url, body: product.toRawJson());
    final decodedData = json.decode(resp.body);

    // Agregar id obtenido de firebase y almacenar nuevo producto en la lista
    product.id = decodedData['name'];
    products.add(product);
    return product.id!;
  }

  void updateSelectedProductImage(String path) {
    selectedProduct?.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    // Validar si se tiene una imagen local seleccionada
    if (newPictureFile == null) return null;

    // Indicar que se esta guardando la información en la base de datos
    isSaving = true;
    // Redibujar los widgets por cambio en la información
    notifyListeners();

    final url = Uri.parse(_urlCloudinary);
    // Crear petición http
    final imageUploadReq = http.MultipartRequest('POST', url);
    // Crear archivo a enviar
    final file = await http.MultipartFile.fromPath('file', newPictureFile!.path);
    // Adjuntar archivo a petición http
    imageUploadReq.files.add(file);
    // Enviar petición http
    final streamResp = await imageUploadReq.send();
    // Obtener respuesta del stream devuelto al subir la imagen
    final resp = await http.Response.fromStream(streamResp);

    // Colocar objeto con imagen seleccionada en null, indicando que ya se subió a cloudinary
    newPictureFile = null;
    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }
}