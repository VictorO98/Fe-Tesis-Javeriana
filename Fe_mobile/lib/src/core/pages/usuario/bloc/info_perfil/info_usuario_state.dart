part of 'info_usuario_bloc.dart';

@immutable
class InfoUsuarioState {
  final InfoUsuarioModel? infoUsuarioModel;

  InfoUsuarioState({this.infoUsuarioModel});

  InfoUsuarioState copyWith({InfoUsuarioModel? infoUsuarioModel}) =>
      new InfoUsuarioState(
          infoUsuarioModel: infoUsuarioModel ?? this.infoUsuarioModel);
}
