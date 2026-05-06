import 'package:flutter/material.dart';
import 'databasehelpers.dart';
import 'addpneus.dart';

class PneusPage extends StatefulWidget {
  const PneusPage({super.key});

  @override
  State<PneusPage> createState() => _PneusPageState();
}

class _PneusPageState extends State<PneusPage> {
  List<Map<String, dynamic>> itens = [];
  String search = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future loadData() async {
    final data = await DatabaseHelper.instance.getAll("pneus");
    setState(() => itens = data);
  }

  Future deleteItem(int id) async {
    await DatabaseHelper.instance.delete("pneus", id);
    loadData();
  }

  void editItem(Map item) {
    TextEditingController nome =
        TextEditingController(text: item["nome"]);
    TextEditingController qtd =
        TextEditingController(text: item["quantidade"].toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text("Editar", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nome,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "Nome"),
            ),
            TextField(
              controller: qtd,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "Quantidade"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await DatabaseHelper.instance.update("pneus", {
                "id": item["id"],
                "nome": nome.text,
                "quantidade": int.parse(qtd.text)
              });
              Navigator.pop(context);
              loadData();
            },
            child: const Text("Salvar", style: TextStyle(color: Colors.red)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var filtered = itens
        .where((e) =>
            e["nome"].toLowerCase().contains(search.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Pneus"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        elevation: 10,
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddPneus()));
          loadData();
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                  )
                ],
              ),
              child: TextField(
                onChanged: (v) => setState(() => search = v),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Pesquisar pneus...",
                  hintStyle: TextStyle(color: Colors.white54),
                  prefixIcon: Icon(Icons.search, color: Colors.red),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                var item = filtered[i];
                return Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.2),
                        blurRadius: 8,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      item["nome"],
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Quantidade: ${item["quantidade"]}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.edit, color: Colors.blueAccent),
                          onPressed: () => editItem(item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteItem(item["id"]),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}