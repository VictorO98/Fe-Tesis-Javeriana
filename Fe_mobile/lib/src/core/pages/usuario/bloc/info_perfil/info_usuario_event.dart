part of 'info_usuario_bloc.dart';

@immutable
abstract class InfoUsuarioEvent {}

class OnSetearInfoUsuario extends InfoUsuarioEvent {
  final InfoUsuarioModel infoUsuarioModel;

  OnSetearInfoUsuario(this.infoUsuarioModel);
}
