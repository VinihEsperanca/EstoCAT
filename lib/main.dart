import 'package:flutter/material.dart';
import 'pneus.dart';
import 'discos.dart';
import 'pastilhas.dart';
import 'filtros.dart';
import 'pecas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // 🔴 BOTÃO ANIMADO (cada um independente)
  Widget botao(BuildContext context, String nome, IconData icon, Widget page) {
    return BotaoAnimado(
      nome: nome,
      icon: icon,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
    );
  }

  Widget logoComGlow() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.6),
            blurRadius: 20,
            spreadRadius: 2,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/logo.jpeg', // mantido
          height: 100,
          width: 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              logoComGlow(),
              const SizedBox(height: 15),

              const Text(
                "C.A.T. ESTOQUE",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),

              const SizedBox(height: 30),

              // 🔘 BOTÕES (layout original)
              botao(context, "PNEUS", Icons.tire_repair, const PneusPage()),
              botao(context, "DISCOS", Icons.album, const DiscosPage()),
              botao(context, "PASTILHAS", Icons.build, const PastilhasPage()),
              botao(context, "FILTROS", Icons.filter_alt, const FiltrosPage()),
              botao(context, "PEÇAS", Icons.settings, const PecasPage()),
            ],
          ),
        ),
      ),
    );
  }
}

//
// 🔥 WIDGET DO BOTÃO ANIMADO (independente)
//
class BotaoAnimado extends StatefulWidget {
  final String nome;
  final IconData icon;
  final VoidCallback onTap;

  const BotaoAnimado({
    super.key,
    required this.nome,
    required this.icon,
    required this.onTap,
  });

  @override
  State<BotaoAnimado> createState() => _BotaoAnimadoState();
}

class _BotaoAnimadoState extends State<BotaoAnimado> {
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => scale = 0.95),
      onTapUp: (_) async {
        setState(() => scale = 1.0);
        await Future.delayed(const Duration(milliseconds: 100));
        widget.onTap();
      },
      onTapCancel: () => setState(() => scale = 1.0),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 100),
        scale: scale,
        child: Container(
          width: 340,
          height: 55,
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.4),
                blurRadius: 10,
                spreadRadius: 1,
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                widget.nome,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}