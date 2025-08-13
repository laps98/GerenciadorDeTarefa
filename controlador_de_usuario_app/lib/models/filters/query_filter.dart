class QueryFilter {
  String search;
  String predicate;
  bool reverse;
  int itemsPerPage;
  int currentPage;

  QueryFilter({
    required this.predicate,
    this.search = '',
    this.reverse = false,
    this.itemsPerPage = 10,
    this.currentPage = 1,
  });

  Map<String, String?> toJson() => {
    'Search': search,
    'Predicate': predicate,
    'Reverse': reverse.toString(),
    'ItemsPerPage': itemsPerPage.toString(),
    'CurrentPage': currentPage.toString(),
  };
}
