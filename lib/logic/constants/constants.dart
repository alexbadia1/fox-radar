/// Page Views
const int HOME_PAGE_VIEW_INDEX = 0;
const int ACCOUNT_PAGE_VIEW_INDEX = 1;

/// Event Categories
const String ACADEMIC = 'Academic';
const String CLUB_SPORTS = 'Club Sports';
const String COLLEGE_SPORTS = 'College Sports';
const String CULTURE = 'Culture';
const String FRATERNITY = 'Fraternity';
const String FREE_FOOD = 'Free Food';
const String INTRAMURAL = 'Intramural';
const String MARIST_DINING = 'Marist Dining';
const String MEDIA_PUBLICATION = 'Media & Publication';
const String MOVIES_THEATRE = 'Movies & Theatre';
const String MUSIC_AND_DANCE = 'Music & Dance';
const String OCCASIONS = 'Occasions';
const String POLITICAL = 'Political';
const String RELIGION = 'Religion';
const String RUSHES = 'Rushes';
const String SPIRITUAL = 'Spiritual';
const String SORORITY = 'Sorority';

const List<String> CATEGORIES = [
  ACADEMIC,
  CLUB_SPORTS,
  COLLEGE_SPORTS,
  CULTURE,
  FRATERNITY,
  FREE_FOOD,
  INTRAMURAL,
  MARIST_DINING,
  MEDIA_PUBLICATION,
  MOVIES_THEATRE,
  MUSIC_AND_DANCE,
  OCCASIONS,
  POLITICAL,
  RELIGION,
  RUSHES,
  SPIRITUAL,
  SORORITY,
];

/// Pagination Limit
const int PAGINATION_LIMIT = 3;

/// Highlights Limit
const int HIGHLIGHTS_LIMIT = 5;

/// Sorting Keys
const SORT_KEY_ALPHABETICAL = "A-Z";
const SORT_KEY_END_DATE_TIME = "Ends";
const SORT_KEY_START_DATE_TIME = "Starts";

/// Marist email syntax filter
/// ECMAScript: ^(([a-z]|[0-9])*\.([a-z]|[0-9])*|([a-z]|[0-9])+)@marist\.edu$
final MARIST_EMAIL_REGEX = RegExp(r"^(([a-z]|[0-9])*\.([a-z]|[0-9])*|([a-z]|[0-9])+)@marist\.edu$");