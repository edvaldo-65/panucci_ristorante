// product_scanner_screen.dart
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // 1. Para o scanner
import 'package:http/http.dart' as http; // 2. Para chamadas na internet
import 'dart:convert'; // 3. Para lidar com JSON

class ProductScannerScreen extends StatefulWidget {
  const ProductScannerScreen({super.key});

  @override
  State<ProductScannerScreen> createState() => _ProductScannerScreenState();
}

class _ProductScannerScreenState extends State<ProductScannerScreen> {
  // Variáveis para guardar o estado da nossa tela:
  String? _barcodeValue; // Guarda o último código de barras lido
  Map<String, dynamic>? _productInfo; // Guarda as informações do produto vindas da API
  bool _isLoading = false; // Indica se estamos carregando dados da API

  // --- Função Principal: Buscar Informações do Produto ---
  Future<void> fetchProductInfo(String barcode) async {
    if (barcode.isEmpty) return; // Não faz nada se o código for vazio

    // Atualiza a tela para mostrar que estamos carregando
    setState(() {
      _isLoading = true;
      _productInfo = null; // Limpa informações de produto anteriores
      _barcodeValue = barcode; // Guarda o código que estamos buscando
    });

    // 1. Montar a URL da API
    // A API do Open Food Facts tem um padrão:
    // https://world.openfoodfacts.org/api/v0/product/CODIGO_DE_BARRAS.json
    final url = Uri.parse('https://world.openfoodfacts.org/api/v0/product/$barcode.json');
    debugPrint('Buscando na URL: $url'); // Para vermos no console o que está acontecendo

    try {
      // 2. Fazer a Requisição HTTP GET
      // 'http.get(url)' envia um pedido para a URL e espera uma resposta.
      // 'await' faz com que nosso código espere a resposta antes de continuar.
      final response = await http.get(url);

      // 3. Verificar se a Requisição foi Bem-Sucedida
      // Códigos de status HTTP: 200 significa "OK, tudo certo!"
      if (response.statusCode == 200) {
        // 4. Decodificar a Resposta JSON
        // A resposta vem como texto (response.body), mas em formato JSON.
        // 'json.decode()' transforma esse texto JSON em um Map do Dart.
        final data = json.decode(response.body);

        // 5. Verificar se o Produto Foi Encontrado na API
        // O Open Food Facts retorna 'status: 1' se o produto foi encontrado.
        if (data['status'] == 1 && data['product'] != null) {
          // Produto encontrado! Guardamos as informações do produto.
          setState(() {
            _productInfo = data['product']; // 'product' é a chave que contém os dados do produto
          });
          debugPrint('Produto encontrado: ${_productInfo!['product_name']}');
        } else {
          // Produto não encontrado ou dados incompletos
          setState(() {
            _productInfo = {'error': 'Produto não encontrado na base de dados.'};
          });
          debugPrint('Produto não encontrado pela API. Resposta: ${data['status_verbose']}');
        }
      } else {
        // A API retornou um erro (ex: 404 Não Encontrado, 500 Erro no Servidor)
        setState(() {
          _productInfo = {'error': 'Falha ao buscar dados (código: ${response.statusCode})'};
        });
        debugPrint('Erro da API: ${response.statusCode}, Corpo: ${response.body}');
      }
    } catch (e) {
      // Erro de conexão (sem internet, URL errada, etc.) ou ao processar a resposta
      setState(() {
        _productInfo = {'error': 'Erro de conexão ou ao processar os dados.'};
      });
      debugPrint('Exceção ao buscar informações do produto: $e');
    } finally {
      // Independentemente de sucesso ou falha, paramos de mostrar o "carregando"
      setState(() {
        _isLoading = false;
      });
    }
  }

  // --- Construção da Interface da Tela ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leitor e Buscador de Produto')),
      body: Column(
        children: <Widget>[
          // Parte 1: O Scanner da Câmera
          Expanded(
            flex: 2, // Quanto espaço essa parte ocupa (2 de 5 no total, por exemplo)
            child: MobileScanner(
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  final barcodeScanned = barcodes.first.rawValue;
                  // Só busca se for um código novo e não nulo
                  if (barcodeScanned != null && barcodeScanned.isNotEmpty && barcodeScanned != _barcodeValue) {
                    // Não chamamos setState aqui para _barcodeValue diretamente
                    // pois fetchProductInfo já fará isso e evitará reconstruções desnecessárias.
                    fetchProductInfo(barcodeScanned);
                  }
                }
              },
            ),
          ),
          // Parte 2: Exibição das Informações do Produto
          Expanded(
            flex: 3, // Ocupa mais espaço para mostrar os resultados
            child: Center( // Centraliza o conteúdo desta parte
              child: _isLoading // Se _isLoading for true...
                  ? const CircularProgressIndicator() // Mostra um círculo de carregamento
                  : _productInfo != null // Senão, se _productInfo NÃO for nulo (temos dados ou erro)...
                  ? Padding( // Adiciona um espaçamento interno
                padding: const EdgeInsets.all(16.0),
                child: _productInfo!['error'] != null // Se tiver uma chave 'error' nos dados...
                    ? Text('Erro: ${_productInfo!['error']}', style: const TextStyle(color: Colors.red))
                    : ListView( // Se não tiver erro, mostra os dados do produto em uma lista
                  children: [
                    Text('Código Lido: $_barcodeValue', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10), // Espaço
                    // Acessando campos do JSON. O '??' significa "se for nulo, use este valor padrão"
                    Text('Produto: ${_productInfo!['product_name_pt'] ?? _productInfo!['product_name'] ?? 'Nome não disponível'}', style: const TextStyle(fontSize: 18)),
                    Text('Marca: ${_productInfo!['brands'] ?? 'Marca não disponível'}'),
                    Text('Quantidade: ${_productInfo!['quantity'] ?? 'Quantidade não disponível'}'),
                    // Adicione mais campos que você achar úteis do JSON retornado pela API
                    // Por exemplo, ingredientes: Text('Ingredientes: ${_productInfo!['ingredients_text_pt'] ?? 'N/A'}'),

                    if (_productInfo!['image_front_url'] != null) // Se tiver URL da imagem...
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Image.network( // Carrega e mostra a imagem da internet
                          _productInfo!['image_front_url'],
                          height: 150, // Define uma altura para a imagem
                          errorBuilder: (context, error, stackTrace) {
                            return const Text('Imagem não pôde ser carregada.');
                          },
                        ),
                      ),
                    const SizedBox(height: 10),
                    Text('Países: ${_productInfo!['countries'] ?? 'N/A'}'),
                    // Você pode explorar o JSON de resposta para ver mais campos!
                  ],
                ),
              )
                  : Text( // Se _productInfo for nulo (antes da primeira leitura ou se limpamos)...
                _barcodeValue == null // Se _barcodeValue também for nulo...
                    ? 'Aponte a câmera para um código de barras' // Mensagem inicial
                    : 'Buscando informações para: $_barcodeValue...', // Mensagem enquanto _isLoading era true mas agora é false
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // É uma boa prática limpar controladores, mas o MobileScanner lida com isso internamente
    // se você não criou um MobileScannerController explicitamente e passou para ele.
    super.dispose();
  }
}
