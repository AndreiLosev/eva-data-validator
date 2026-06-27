import 'dart:io';

import 'package:eva_data_validator/config/config.dart';
import 'package:eva_data_validator/db/rpc_unique_checker.dart';
import 'package:eva_data_validator/eapi/validate.dart';
import 'package:eva_data_validator/validator/validator_engine.dart';
import 'package:eva_sdk/eva_sdk.dart';
import 'package:eva_sdk/src/debug_log.dart';

const author = 'Losev Andrei';
const version = '1.0.0';
const description = 'Laravel-like data validation service';

int exitCode = 1;

void main(List<String> arguments) async {
  try {
    final info = ServiceInfo(author, version, description)
      ..addMethod(Validate.createMethod());

    if (arguments.contains('--local')) {
      await svc().debugLoad(
        '/home/andrei/documents/my/eva-data-validator/example-config.yaml',
        'softkip.data.validator',
      );
      dbgInit('console');
    } else {
      await svc().load();
    }
    await svc().init(info);

    final config = Config.fromMap(
      svc().config.config,
      uniqueChecker: RpcUniqueChecker(),
    );
    ValidatorEngine.getInstance(config);

    await svc().block();
    exitCode = 0;
  } catch (e, s) {
    svc().logger.error([e, s]);
  } finally {
    exit(exitCode);
  }
}
