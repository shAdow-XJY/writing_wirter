import 'package:get_it/get_it.dart';
import 'package:writing_writer/service/file/IOBase.dart';
import 'package:event_bus/event_bus.dart';
import 'package:writing_writer/service/file/export_IOBase.dart';

/// get_it to easy make Singleton Class
GetIt appGetIt = GetIt.instance;

Future<void> setupAppGetIt({bool test = false}) async {
  /// tool one -- IOBase : file IO tool class register
  appGetIt.registerSingleton<IOBase>(IOBase(), instanceName: "IOBase");

  /// tool two -- EventBus : EventBus Stream tool class register
  appGetIt.registerSingleton<EventBus>(EventBus(), instanceName: "EventBus");

  /// tool three -- ExportIOBase : Export file IO tool class register, depends on IOBase
  appGetIt.registerSingleton<ExportIOBase>(ExportIOBase(appGetIt.get(instanceName: "IOBase")), instanceName: "ExportIOBase");
}
