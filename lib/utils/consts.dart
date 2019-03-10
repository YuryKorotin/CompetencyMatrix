
class Consts {
  static const String STUDENT_LEVEL = "student";
  static const String BEGINNER_LEVEL = "junior";
  static const String MIDDLE_LEVEL = "middle";
  static const String EXPERT_LEVEL = "senior";

  static const String BASE_KNOWLEDGE_LEVEL = "pow(2, n)";
  static const String SIMPLE_KNOWLEDGE_LEVEL = "pow(n, 2)";
  static const String SERIOUS_KNOWLEDGE_LEVEL = "n";
  static const String COMPLEX_KNOWLEDGE_LEVEL = "log(n)";

  static const KNOWLEDGE_TO_HUMAN_MAP = {
    BASE_KNOWLEDGE_LEVEL: STUDENT_LEVEL,
    SIMPLE_KNOWLEDGE_LEVEL: BEGINNER_LEVEL,
    SERIOUS_KNOWLEDGE_LEVEL: MIDDLE_LEVEL,
    COMPLEX_KNOWLEDGE_LEVEL: EXPERT_LEVEL
  };
}