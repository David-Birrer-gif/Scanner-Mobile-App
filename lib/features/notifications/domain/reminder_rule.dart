class ReminderRule {
  const ReminderRule({required this.daysBefore});
  final List<int> daysBefore;
}

class ReminderSchedule {
  const ReminderSchedule({
    required this.notificationId,
    required this.scheduledAt,
    required this.offsetDays,
  });

  final int notificationId;
  final DateTime scheduledAt;
  final int offsetDays;
}
