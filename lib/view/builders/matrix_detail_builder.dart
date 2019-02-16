import 'package:competency_matrix/view/models/heading_item.dart';
import 'package:competency_matrix/view/models/knowledge_item.dart';
import 'package:competency_matrix/view/models/list_item.dart';

class MatrixDetailBuilder {

  List<ListItem> buildStaticItems() {
    List<ListItem> items = new List();

    items.add(new HeadingItem("Data structures"));

    items.add(new KnowledgeItem.origin(
        "pow(2, n)",
        "Doesn’t know the difference between Array and LinkedList",
        false));
    items.add(new KnowledgeItem.origin(
        "pow(n, 2)",
        "Able to explain and use Arrays, LinkedLists, Dictionaries etc in practical programming tasks",
        false));

    items.add(new KnowledgeItem.origin(
        "n",
        "Knows space and time tradeoffs of the basic data structures, Arrays vs LinkedLists, Able to explain how hashtables can be implemented and can handle collisions, Priority queues and ways to implement them etc.",
        false));

    items.add(new KnowledgeItem.origin(
        "log(n)",
        "Knowledge of advanced data structures like B-trees, binomial and fibonacci heaps, AVL/Red Black trees, Splay Trees, Skip Lists, tries etc.",
        false));

    items.add(new HeadingItem("Algorithms"));

    items.add(new KnowledgeItem.origin(
        "pow(2, n)",
        "Unable to find the average of numbers in an array (It’s hard to believe but I’ve interviewed such candidates)",
        false));
    items.add(new KnowledgeItem.origin(
        "pow(n, 2)",
        "Basic sorting, searching and data structure traversal and retrieval algorithms",
        false));

    items.add(new KnowledgeItem.origin(
        "n",
        "Tree, Graph, simple greedy and divide and conquer algorithms, is able to understand the relevance of the levels of this matrix.",
        false));

    items.add(new KnowledgeItem.origin(
        "log(n)",
        "Able to recognize and code dynamic programming solutions, good knowledge of graph algorithms, good knowledge of numerical computation algorithms, able to identify NP problems etc.",
        false));

    return items;
  }
}