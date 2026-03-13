class CheckinRecord {
  // Represents a single student check-in event.
  // Will hold fields such as:
  //   - studentId (String)
  //   - sessionId decoded from QR (String)
  //   - latitude & longitude (double)
  //   - timestamp (DateTime)
  //   - previousTopic (String)
  //   - expectedTopic (String)
  //   - moodBefore (int, 1–5)
  // Also used for the finish-class record with additional fields:
  //   - learnedToday (String)
  //   - feedback (String)
  //   - moodAfter (int, 1–5)
}
