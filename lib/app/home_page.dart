import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../modules/liturgical_engine/application/services/calendar_service.dart';
import '../modules/liturgical_engine/domain/entities/liturgical_day.dart';

class LiturgicalHomePage extends StatelessWidget {
  const LiturgicalHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final calendar = context.watch<CalendarService>();
    final today = DateTime.now();
    final todayEntry = calendar.getDay(today);
    final year = calendar.getYear(today.year);
    final upcomingDays = year.days
        .where((day) => !day.date.isBefore(today))
        .take(7)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catholic Calendar'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _TodayCard(day: todayEntry),
          const SizedBox(height: 16),
          Text(
            'Upcoming this year',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ...upcomingDays.map((day) => _DayItem(day: day)),
        ],
      ),
    );
  }
}

class _TodayCard extends StatelessWidget {
  const _TodayCard({required this.day});

  final LiturgicalDay day;

  @override
  Widget build(BuildContext context) {
    final title = _humanize(day.celebration.value);
    final season = day.season.name;
    final dateLabel = DateFormat('EEEE, d MMMM y').format(day.date);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              dateLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text(_humanize(day.rank.name))),
                Chip(label: Text(_humanize(season))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DayItem extends StatelessWidget {
  const _DayItem({required this.day});

  final LiturgicalDay day;

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('d MMM').format(day.date);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(_humanize(day.celebration.value)),
        subtitle: Text('${_humanize(day.season.name)} · ${_humanize(day.rank.name)}'),
        leading: CircleAvatar(
          child: Text(formattedDate),
        ),
        trailing: Text(DateFormat('EEE').format(day.date)),
      ),
    );
  }
}

String _humanize(String value) {
  if (value.isEmpty) {
    return value;
  }

  return value
      .split('_')
      .where((segment) => segment.isNotEmpty)
      .map((segment) => segment[0].toUpperCase() + segment.substring(1))
      .join(' ');
}
