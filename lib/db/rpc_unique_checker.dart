import 'package:eva_data_validator/db/unique_checker.dart';
import 'package:eva_sdk/eva_sdk.dart';

class RpcUniqueChecker implements UniqueChecker {
  @override
  Future<bool> exists({
    required String serviceId,
    required String column,
    required dynamic value,
    dynamic exceptId,
  }) async {
    final where = exceptId != null
        ? [
            [column, '=', value],
            ['id', '!=', exceptId],
          ]
        : [column, '=', value];

    final rpcRes = await svc().rpc.call(
      serviceId,
      'select',
      params: serialize({
        'where': where,
        'with_count': true,
        'limit': 1,
      }),
    );
    final frame = await rpcRes.waitCompleted();
    if (frame == null) {
      throw EvaError(EvaErrorKind.io, 'empty rpc result');
    }

    final result = deserialize(frame.payload) as Map;
    return (result['count'] as int? ?? 0) > 0;
  }
}
