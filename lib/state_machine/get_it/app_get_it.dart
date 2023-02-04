import 'package:get_it/get_it.dart';
import 'package:writing_writer/server/file/IOBase.dart';

/// get_it to easy make Singleton Class
GetIt appGetIt = GetIt.instance;

Future<void> setupAppGetIt({bool test = false}) async {
  /// tool one -- IOBase : file IO tool class register
  appGetIt.registerSingleton<IOBase>(IOBase());
}
