class AdListHelper {
  static const int defaultInterval = 7;

  /// Calculate total item count including ad slots
  static int totalCount(int dataCount, {int interval = defaultInterval}) {
    if (dataCount == 0) return 0;
    final adCount = dataCount ~/ interval;
    return dataCount + adCount;
  }

  /// Check if the given index in the mixed list is an ad position
  static bool isAdPosition(int index, {int interval = defaultInterval}) {
    if (index == 0) return false;
    return (index + 1) % (interval + 1) == 0;
  }

  /// Convert a mixed-list index to the original data index
  static int dataIndex(int index, {int interval = defaultInterval}) {
    final adsBefore = index ~/ (interval + 1);
    return index - adsBefore;
  }
}
