import 'package:controlador_de_usuario_app/models/login_request.dart';
import 'package:controlador_de_usuario_app/models/usuario_logado.dart';
import 'package:controlador_de_usuario_app/services/base_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContaService extends BaseService {
  final String _controllerName = 'Conta';

  Future<void> logar(LoginRequest model) async {
    var data = {
      'Email': model.login.text,
      'Senha': model.senha.text,
    };

    Map<String, dynamic> response = await post('$_controllerName/Token', data);

    final int expiresIn = response['ExpiresIn'];
    final dataDeExpiracao = DateTime.now().add(Duration(seconds: expiresIn));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('DataDeExpiracao', dataDeExpiracao.toString());
    await prefs.setString('Token', response['Token'].toString());

    await UsuarioLogado.set(response);
  }

  Future<void> sair() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove('DataDeExpiracao');
    await prefs.remove('Token');
    await prefs.remove('UsuarioLogado');
  }
}