import 'package:intl/intl.dart';

String formatDeadline(DateTime dt) {
  final f = DateFormat('EEE, d MMM yyyy • HH:mm');
  return f.format(dt);
}
