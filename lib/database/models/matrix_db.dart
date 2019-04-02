import 'package:competency_matrix/entities/matrix_entity.dart';

class MatrixDb extends MatrixEntity{
  MatrixDb(BigInt id,
      String name,
      String description,
      String category,
      bool isEmbedded,
      int progress) :
        super (id, name, description, category, isEmbedded, progress);
}
