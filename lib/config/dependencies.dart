import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:qwixx/data/repository/session/session_repository.dart';
import 'package:qwixx/data/service/game_server/game_server_service.dart';
import 'package:qwixx/data/service/local_storage/local_data_service.dart';

List<SingleChildWidget> get providers {
  return [
    Provider(create: (context) => GameServerService()),
    Provider(create: (context) => LocalDataService()),
    Provider(create: (context) => SessionRepository(context.read())),
  ];
}
