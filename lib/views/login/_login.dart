import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:super_app/utility/color.dart';
import 'package:super_app/widget/myIcon.dart';
import 'package:super_app/widget/textfont.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

class _LoginScreen extends StatefulWidget {
  const _LoginScreen({super.key});

  @override
  State<_LoginScreen> createState() => __LoginScreenState();
}

class __LoginScreenState extends State<_LoginScreen> {
  DateTime _selectedDate = DateTime.now();
  final List<Appointment> _appointments = [
    Appointment(
      startTime: DateTime(2025, 2, 22, 10, 0),
      endTime: DateTime(2025, 2, 22, 12, 0),
      subject: 'LTC PARTY',
      color: Colors.blue,
    ),
    Appointment(
      startTime: DateTime(2025, 2, 22, 10, 0),
      endTime: DateTime(2025, 2, 22, 12, 0),
      subject: 'LTC PARTY 2',
      color: Colors.red,
    ),
    Appointment(
      startTime: DateTime(2025, 2, 23, 14, 0),
      endTime: DateTime(2025, 2, 23, 16, 0),
      subject: 'Team Meeting',
      color: Colors.green,
    ),
  ];

  List<Appointment> _eventsOnSelectedDate = [];

  // Custom Data Source
  _CalendarDataSource _getCalendarDataSource() {
    return _CalendarDataSource(_appointments);
  }

  void _onDateTapped(DateTime date) {
    // Filter appointments based on the selected date
    List<Appointment> eventsOnDate = _appointments
        .where(
          (appointment) => appointment.startTime.year == date.year && appointment.startTime.month == date.month && appointment.startTime.day == date.day,
        )
        .toList();

    setState(() {
      _selectedDate = date;
      _eventsOnSelectedDate = eventsOnDate; // Update events for selected date
    });

    if (eventsOnDate.isNotEmpty) {
      // You can show the bottom sheet if necessary, but now you have the correct events to display
      // _showCalendarBottomSheet(context, eventsOnDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFont(text: 'Calendar View'),
      ),
      body: Column(
        children: [
          SfCalendar(
            todayTextStyle: GoogleFonts.poppins(color: color_fff),
            monthViewSettings: MonthViewSettings(
              agendaStyle: AgendaStyle(
                appointmentTextStyle: GoogleFonts.poppins(fontSize: 14),
              ),
              navigationDirection: MonthNavigationDirection.horizontal,
              dayFormat: 'EEE',
              showAgenda: false, // Hide built-in agenda view
              monthCellStyle: MonthCellStyle(
                textStyle: GoogleFonts.poppins(),
                trailingDatesBackgroundColor: Colors.black.withOpacity(0.2),
                trailingDatesTextStyle: GoogleFonts.poppins(color: Colors.white),
                leadingDatesBackgroundColor: Colors.black.withOpacity(0.2),
                leadingDatesTextStyle: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
            view: CalendarView.month,
            todayHighlightColor: Theme.of(context).colorScheme.onPrimary,
            backgroundColor: Colors.white,
            showNavigationArrow: true,
            dataSource: _getCalendarDataSource(),
            onTap: (details) {
              if (details.date != null) {
                _onDateTapped(details.date!);
              }
            },
          ),
          buildEventDetail(_eventsOnSelectedDate),
        ],
      ),
      bottomNavigationBar: GestureDetector(
        // onTap: () => _showCalendarBottomSheet(context, _appointments),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 25),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(MyIcon.ic_arrowUp),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFont(
                      text: _selectedDate.day.toString(),
                      color: color_primary_light,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      poppin: true,
                    ),
                    TextFont(
                      text: "${_selectedDate.month}/${_selectedDate.year}",
                      color: color_primary_light,
                      poppin: true,
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      color: color_f4f4,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextFont(
                                text: 'Upcoming Events',
                                maxLines: 3,
                              ),
                            ),
                            GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: cr_ef33,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: TextFont(
                                    text: 'View Calendar',
                                    color: color_fff,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEventDetail(List<Appointment> events) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFont(
          text: "Events on ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 10),
        if (events.isEmpty)
          TextFont(text: "No events available for this day")
        else
          ...events.map((event) {
            return Card(
              color: event.color.withOpacity(0.2),
              child: ListTile(
                title: TextFont(
                  text: event.subject,
                  fontWeight: FontWeight.bold,
                ),
                subtitle: TextFont(
                  text: "${event.startTime.hour}:${event.startTime.minute} - ${event.endTime.hour}:${event.endTime.minute}",
                ),
              ),
            );
          }).toList(),
      ],
    );
  }
}

// Custom Data Source class
class _CalendarDataSource extends CalendarDataSource {
  _CalendarDataSource(List<Appointment> source) {
    appointments = source;
  }
}
