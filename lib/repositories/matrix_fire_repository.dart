import 'package:competency_matrix/entities/matrix_detail_entity.dart';
import 'package:competency_matrix/entities/matrix_entity.dart';
import 'package:competency_matrix/entities/matrix_load_result.dart';
import 'package:competency_matrix/firestore/fire_matrix.dart';
import 'package:competency_matrix/firestore/fire_matrix_detail.dart';
import 'package:competency_matrix/repositories/base_matrix_repository.dart';
import 'package:competency_matrix/repositories/remote_repository.dart';

import 'matrix_file_repository.dart';

class MatrixFireRepository extends BaseMatrixRepository {
  final RemoteRepository _repository;
  MatrixFileRepository _fileRepository = MatrixFileRepository();

  static const cacheKeepLatency = 3600000;

  MatrixFireRepository(this._repository);

  @override
  Future<List<MatrixEntity>> load() async {
    var list = new List<MatrixEntity>();
    var wasListCached = await _fileRepository.wasListCached();

    var wasCachExpired = true;

    if (wasListCached) {
      var cachedList = await _fileRepository.readList();

      var firstItem = cachedList[0];

      var cacheTime = int.parse(firstItem.timestamp);

      wasCachExpired = new DateTime.now().millisecondsSinceEpoch - cacheTime > cacheKeepLatency;
    }

    if (!wasCachExpired) {
      list = await _fileRepository.readList();
      print("Read list from cache");
    } else {
      print("Read list from network");
      list = await _repository.load();
      var timeStamp = new DateTime.now().millisecondsSinceEpoch.toString();
      var fireList = list.map((matrix) {
        FireMatrix newMatrix = new FireMatrix(matrix.id, matrix.name, matrix.description, matrix.category, true, 0);
        newMatrix.timestamp = timeStamp;
        return newMatrix;
      }).toList();

      await _fileRepository.writeList(fireList);
    }
    List<MatrixEntity> matricesWithProgress = List();

    for (MatrixEntity matrix in list) {
      var matrixFilled = await matrixWithProgress(matrix);

      matricesWithProgress.add(matrixFilled);
    }

    return matricesWithProgress;
  }

  @override
  Future<MatrixLoadResult> loadSingle(BigInt id) async {
    var wasItemCached = await _fileRepository.wasItemCached(id);

    var wasCachExpired = true;

    if (wasItemCached) {
      var cachedItem = await _fileRepository.readItem(id);

      var cacheTime = int.parse(cachedItem.timestamp);

      wasCachExpired =
          new DateTime.now().millisecondsSinceEpoch - cacheTime > cacheKeepLatency;
    }

    MatrixLoadResult result;

    if (!wasCachExpired) {
      var item = await _fileRepository.readItem(id);
      result = await _repository.getLoadResult(item);
    } else {
      result = await _repository.loadSingle(id);
      var timeStamp = new DateTime.now().millisecondsSinceEpoch.toString();
      var matrix = result.matrixDetail as FireMatrixDetail;
      matrix.timestamp = timeStamp;

      _fileRepository.writeItem(matrix);
    }

    return result;
  }

  @override
  Future<MatrixEntity> matrixWithProgress(MatrixEntity matrix) async{
    return _repository.matrixWithProgress(matrix);
  }
}