import 'package:competency_matrix/entities/matrix_detail_entity.dart';
import 'package:competency_matrix/entities/matrix_entity.dart';
import 'package:competency_matrix/entities/matrix_load_result.dart';
import 'package:competency_matrix/firestore/fire_matrix.dart';
import 'package:competency_matrix/firestore/fire_matrix_detail.dart';
import 'package:competency_matrix/repositories/base_matrix_repository.dart';
import 'package:competency_matrix/repositories/remote_repository.dart';
import 'package:dcache/dcache.dart';

class MatrixFireRepository extends BaseMatrixRepository {
  final RemoteRepository _repository;
  Cache detailMatrixCache;
  Cache shortMatrixCache;

  static const detailCacheSize = 10;
  static const shortCacheSize = 20;
  static const cacheKeepLatency = 3600000;

  static const shortCacheKey = "short_matrix_key";
  static const detailCacheKey = "detail_matrix_key";

  MatrixFireRepository(this._repository){
    detailMatrixCache = new SimpleCache<String, MatrixDetailEntity>(storage: new SimpleStorage(size: detailCacheSize));
    shortMatrixCache = new SimpleCache<String, List<MatrixEntity>>(storage: new SimpleStorage(size: shortCacheSize));

    //shortMatrixCache.expiration = Duration(hours: 1);
    //detailMatrixCache.expiration = Duration(hours: 1);
  }

  @override
  Future<List<MatrixEntity>> load() async {
    var list = new List<MatrixEntity>();

    if (shortMatrixCache.containsKey(shortCacheKey)) {
      list = shortMatrixCache.get(shortCacheKey);
      print("YES");
    } else {
      list = await _repository.load();
      shortMatrixCache.set(shortCacheKey, list);
      print("NO");
    }
    return list;
  }

  @override
  Future<MatrixLoadResult> loadSingle(BigInt id) async {
    MatrixLoadResult item;
    if (shortMatrixCache.containsKey(detailCacheKey + id.toString())) {
      var matrix = detailMatrixCache.get(detailCacheKey + id.toString());
      item = await _repository.getLoadResult(matrix);
    } else {
      item = await _repository.loadSingle(id);
      detailMatrixCache.set(detailCacheKey + id.toString(), item.matrixDetail);
    }
    return item;
  }

  @override
  Future<MatrixEntity> matrixWithProgress(MatrixEntity matrix) async{
    return _repository.matrixWithProgress(matrix);
  }
}