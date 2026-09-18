import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qwixx/data/repository/session/session_repository.dart';
import 'package:qwixx/data/service/game_server/game_server_service.dart';
import 'package:qwixx/ui/game/view_model/game_view_model.dart';
import 'package:qwixx/ui/game/widget/game_screen.dart';
import 'package:qwixx/ui/home/view_model/game_discovery_view_model.dart';
import 'package:qwixx/ui/home/view_model/home_view_model.dart';
import 'package:qwixx/ui/home/view_model/settings_view_model.dart';
import 'package:qwixx/ui/home/widget/home_screen.dart';
import 'package:qwixx/ui/lobby/view_model/lobby_view_model.dart';
import 'package:qwixx/ui/lobby/widget/lobby_screen.dart';

abstract final class QwixxRoutes {
  static const String home = '/';
  static const String lobby = '/lobby';
  static const String game = '/game';
}

GoRouter get router => GoRouter(
  routes: [
    GoRoute(
      path: QwixxRoutes.home,
      builder: (context, state) {
        final session = context.read<SessionRepository>();
        final serverService = context.read<GameServerService>();
        final homeViewModel = HomeViewModel(
          session,
          serverService,
          context.read(),
        );
        final settingsViewModel = SettingsViewModel(session);
        final gameDiscoveryViewModel = GameDiscoveryViewModel(
          context.read(),
          session,
          context.read(),
        );
        return HomeScreen(
          viewModel: homeViewModel,
          settingsViewModel: settingsViewModel,
          gameDiscoveryViewModel: gameDiscoveryViewModel,
        );
      },
    ),
    GoRoute(
      path: QwixxRoutes.lobby,
      redirect: (context, state) {
        final session = context.read<SessionRepository>();
        if (session.gatewayController == null) {
          return QwixxRoutes.home;
        }
        return null;
      },
      builder: (context, state) {
        final session = context.read<SessionRepository>();
        final viewModel = LobbyViewModel(session, session.gatewayController!);
        return LobbyScreen(viewModel: viewModel);
      },
    ),
    GoRoute(
      path: QwixxRoutes.game,
      redirect: (context, state) {
        final session = context.read<SessionRepository>();
        if (session.gatewayController == null) {
          return QwixxRoutes.home;
        }
        if (session.gatewayController!.gameStateNotifier == null) {
          return QwixxRoutes.lobby;
        }
        return null;
      },
      builder: (context, state) {
        final session = context.read<SessionRepository>();
        final gateway = session.gatewayController!;
        final gameStateNotifier = gateway.gameStateNotifier!;
        return GameScreen(
          viewModel: GameViewModel(
            gameStateNotifier,
            gateway,
            session,
            gateway.user.uuid,
          ),
        );
      },
    ),
  ],
);
