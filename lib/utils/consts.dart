
class Consts {
  static const String STUDENT_LEVEL = "student";
  static const String BEGINNER_LEVEL = "junior";
  static const String MIDDLE_LEVEL = "middle";
  static const String EXPERT_LEVEL = "senior";

  static const String BASE_LEVEL = "pow(2, n)";
  static const String SIMPLE_LEVEL = "pow(n, 2)";
  static const String COMMON_LEVEL = "n";
  static const String COMPLEX_LEVEL = "log(n)";

  static const KNOWLEDGETOHUMANMAP = {
    BASE_LEVEL: STUDENT_LEVEL,
    SIMPLE_LEVEL: BEGINNER_LEVEL,
    COMMON_LEVEL: MIDDLE_LEVEL,
    COMPLEX_LEVEL: EXPERT_LEVEL
  };
}