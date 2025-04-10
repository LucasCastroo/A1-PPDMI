import 'package:flutter/material.dart';
import '../models/moto.dart';
import '../services/moto_service.dart';
import 'moto_form.dart';

class MotoListPage extends StatefulWidget {
  const MotoListPage({super.key});

  @override
  State<MotoListPage> createState() => _MotoListPageState();
}

class _MotoListPageState extends State<MotoListPage> {
  List<Moto> motos = [];
  List<Moto> motosFiltradas = [];
  final TextEditingController _buscaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    carregarMotos();
  }

  void carregarMotos() async {
    final lista = await MotoService.getMotos();
    setState(() {
      motos = lista;
      motosFiltradas = lista;
    });
  }

  void buscarMoto(String termo) {
    setState(() {
      if (termo.isEmpty) {
        motosFiltradas = motos;
      } else {
        motosFiltradas = motos
            .where((m) => m.modelo.toLowerCase().contains(termo.toLowerCase()))
            .toList();
      }
    });
  }

  void abrirFormulario({Moto? moto, int? index}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MotoFormPage(
          moto: moto,
          onSalvar: (motoSalva) {
            setState(() {
              if (moto == null) {
                motos.add(motoSalva);
              } else {
                motos[index!] = motoSalva;
              }
              _buscaController.clear();
              motosFiltradas = motos;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[80],
      appBar: AppBar(
        elevation: 4, // sombra padrão
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Image.asset('/images/logo.png', width: 72,height: 72),
            const SizedBox(width: 10),
            const Text('MOTO SHOP', style: TextStyle(color: Colors.white),),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Barra de busca e botão
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _buscaController,
                    decoration: InputDecoration(
                      hintText: 'Buscar modelo...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: buscarMoto,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => abrirFormulario(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: motosFiltradas.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.motorcycle, size: 60, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Nenhuma moto cadastrada.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount: motosFiltradas.length,
                itemBuilder: (context, index) {
                  final moto = motosFiltradas[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                moto.modelo,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.orange),
                                    onPressed: () => abrirFormulario(moto: moto, index: index),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      await MotoService.deleteMoto(moto.id);
                                      setState(() {
                                        motos.removeAt(index);
                                        buscarMoto(_buscaController.text);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Marca: ${moto.marca}'),
                          Text('Ano: ${moto.ano}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
