import 'package:flutter/material.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';

void main() {
  runApp(const MeuAppV2Ray());
}

class MeuAppV2Ray extends StatelessWidget {
  const MeuAppV2Ray({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MEU V2RAY TIM',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PaginaPrincipal(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({super.key});

  @override
  State<PaginaPrincipal> createState() => _PaginaPrincipalState();
}

class _PaginaPrincipalState extends State<PaginaPrincipal> {
  final FlutterV2ray _v2ray = FlutterV2ray();
  bool _conectado = false;
  String _status = "DESCONECTADO ❌";
  Color _cor = Colors.red;

  // ✅ SUA CONFIGURAÇÃO QUE JÁ FUNCIONA
  final String _link = "vless://b9c52619-31eb-486c-ad0a-90a5d6c550e0@ofertas.tim.com.br:443?mode=auto&path=%2F&security=tls&encryption=none&host=recargapro.azion.app&type=xhttp&sni=www.microsoft.com#MEU-SERVIDOR-TIM";

  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  Future<void> _iniciar() async {
    await _v2ray.initializeV2Ray();
    _v2ray.onStatusChanged.listen((estado) {
      setState(() {
        _conectado = estado == V2RayStatus.CONNECTED;
        if (_conectado) { _status = "CONECTADO ✅"; _cor = Colors.green; }
        else if (estado == V2RayStatus.CONNECTING) { _status = "CONECTANDO... ⏳"; _cor = Colors.orange; }
        else { _status = "DESCONECTADO ❌"; _cor = Colors.red; }
      });
    });
  }

  Future<void> _ligarDesligar() async {
    if (!_conectado) {
      if (await _v2ray.requestPermission()) {
        final cfg = FlutterV2ray.parseFromURL(_link);
        await _v2ray.startV2Ray(remark: cfg.remark, config: cfg.getFullConfiguration());
      }
    } else {
      await _v2ray.stopV2Ray();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MEU V2RAY TIM", style: TextStyle(fontWeight: FontWeight.bold)), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi, size: 100, color: _cor),
            const SizedBox(height:20),
            Text(_status, style: TextStyle(fontSize:24, fontWeight: FontWeight.bold, color: _cor)),
            const SizedBox(height:50),
            ElevatedButton(
              onPressed: _ligarDesligar,
              style: ElevatedButton.styleFrom(
                backgroundColor: _conectado ? Colors.red : Colors.green,
                padding: const EdgeInsets.symmetric(horizontal:50, vertical:18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Text(_conectado ? "DESCONECTAR" : "CONECTAR", style: const TextStyle(fontSize:20, color:Colors.white)),
            )
          ]
        )
      )
    );
  }
}
