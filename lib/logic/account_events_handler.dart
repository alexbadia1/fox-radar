class AccountEventsHandler {
  final List<String> eventIds;
  int _curr;

  AccountEventsHandler(this.eventIds) {
    print('Event Handler received: ${this.eventIds.toString()}');
    this._curr = 0;
  } // AccountEventsHandler

  List<String> getEventIdsPaginated(int limit) {
    if (this._curr == eventIds.length) { return []; } // No more events left to get
    if (limit <= 0) { return []; } // Can't get negative pages

    final int start = this._curr;
    int end = start + limit;

    if (end >= eventIds.length) { end = eventIds.length; } // Ran out of events

    this._curr = end;

    return eventIds.getRange(start, end).toList();
  } // getEventIdsPaginated

  bool isEmpty() {
    return this.eventIds.isEmpty;
  }// isEmpty
} // class
