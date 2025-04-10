import 'package:flutter/material.dart';
import '../models/moto.dart';
import '../services/moto_service.dart';

class MotoFormPage extends StatefulWidget {
  final Moto? moto;
  final void Function(Moto) onSalvar;

  const MotoFormPage({super.key, this.moto, required this.onSalvar});

  @override
  State<MotoFormPage> createState() => _MotoFormPageState();
}

class _MotoFormPageState extends State<MotoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _modeloController = TextEditingController();

  String? _marcaSelecionada;
  int? _anoSelecionado;

  final List<String> _marcas = [
    'Honda',
    'Yamaha',
    'Suzuki',
    'Kawasaki',
    'Harley-Davidson',
    'BMW',
    'Ducati',
    'Triumph'
  ];

  List<int> _anos = [];

  @override
  void initState() {
    super.initState();

    // gera a lista de anos de 2000 até o atual
    int anoAtual = DateTime.now().year;
    _anos = List.generate(anoAtual - 1999, (index) => 2000 + index);

    if (widget.moto != null) {
      _modeloController.text = widget.moto!.modelo;
      _marcaSelecionada = widget.moto!.marca;
      _anoSelecionado = widget.moto!.ano;
    }
  }

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      final novaMoto = Moto(
        id: widget.moto?.id ?? DateTime.now().millisecondsSinceEpoch,
        modelo: _modeloController.text,
        marca: _marcaSelecionada!,
        ano: _anoSelecionado!,
      );

      try {
        if (widget.moto == null) {
          await MotoService.addMoto(novaMoto);
        } else {
          await MotoService.updateMoto(novaMoto);
        }
        widget.onSalvar(novaMoto);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar moto: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          widget.moto == null ? 'Cadastrar Moto' : 'Editar Moto',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _modeloController,
                decoration: const InputDecoration(
                  labelText: 'Modelo',
                  prefixIcon: Icon(Icons.motorcycle),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Informe o modelo' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _marcaSelecionada,
                decoration: const InputDecoration(
                  labelText: 'Marca',
                  prefixIcon: Icon(Icons.factory),
                  border: OutlineInputBorder(),
                ),
                items: _marcas
                    .map((marca) => DropdownMenuItem(
                  value: marca,
                  child: Text(marca),
                ))
                    .toList(),
                onChanged: (value) => setState(() => _marcaSelecionada = value),
                validator: (value) =>
                value == null || value.isEmpty ? 'Selecione a marca' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _anoSelecionado,
                decoration: const InputDecoration(
                  labelText: 'Ano',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                items: _anos
                    .map((ano) => DropdownMenuItem(
                  value: ano,
                  child: Text(ano.toString()),
                ))
                    .toList(),
                onChanged: (value) => setState(() => _anoSelecionado = value),
                validator: (value) =>
                value == null ? 'Selecione o ano' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _salvar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white, // 👈 cor do texto e do ícone
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.save),
                  label: const Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
