import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/database_helper.dart';
import '../services/prayer_time_api_service.dart';
import '../models/prayer_schedule.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final PrayerTimeApiService _prayerApiService = PrayerTimeApiService();
  
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, bool> _cachedDates = {};
  bool _isHijriPrimary = false; // false = Masehi primary, true = Hijri primary

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadCalendarPreference();
    _loadCachedDates();
  }

  // Load calendar mode preference
  Future<void> _loadCalendarPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final isHijriPrimary = prefs.getBool('calendar_hijri_primary') ?? false;
    
    if (mounted) {
      setState(() {
        _isHijriPrimary = isHijriPrimary;
      });
    }
  }

  // Save calendar mode preference
  Future<void> _saveCalendarPreference(bool isHijriPrimary) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('calendar_hijri_primary', isHijriPrimary);
  }

  // Load dates that have cached prayer schedule
  Future<void> _loadCachedDates() async {
    // For now, we'll implement this to check which dates have data
    // This will be used to show markers on calendar
    setState(() {
      // Example: mark today as having data
      _cachedDates[DateTime(_focusedDay.year, _focusedDay.month, _focusedDay.day)] = true;
    });
  }

  // Format month name to Indonesian
  String _getMonthName(DateTime date) {
    final List<String> months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  // Get Hijri month name in Indonesian
  String _getHijriMonthName(HijriCalendar hijri) {
    final List<String> hijriMonths = [
      'Muharram', 'Safar', 'Rabi\'ul Awwal', 'Rabi\'ul Akhir',
      'Jumadal Ula', 'Jumadal Akhir', 'Rajab', 'Sya\'ban',
      'Ramadan', 'Syawal', 'Dzulqa\'dah', 'Dzulhijjah'
    ];
    return '${hijriMonths[hijri.hMonth - 1]} ${hijri.hYear} H';
  }

  // Convert DateTime to Hijri date string
  String _toHijriDateString(DateTime date) {
    final hijri = HijriCalendar.fromDate(date);
    return '${hijri.hDay}';
  }

  // Check if currently viewing today's month
  bool _isViewingCurrentMonth() {
    final now = DateTime.now();
    return _focusedDay.year == now.year && _focusedDay.month == now.month;
  }

  // Jump to today with animation
  void _jumpToToday() {
    final today = DateTime.now();
    setState(() {
      _focusedDay = today;
      _selectedDay = today;
    });
  }

  // Build toggle button for calendar mode
  Widget _buildToggleButton(String label, bool isActive) {
    return InkWell(
      onTap: () async {
        final newValue = label == 'Hijriyah';
        setState(() {
          _isHijriPrimary = newValue;
        });
        // Save preference
        await _saveCalendarPreference(newValue);
      },
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.green.shade600 : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.green.shade700,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final showFAB = !_isViewingCurrentMonth();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalender'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Month/Year Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              border: Border(
                bottom: BorderSide(color: Colors.green.shade200, width: 1),
              ),
            ),
            child: Column(
              children: [
                // Calendar mode toggle
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade300),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildToggleButton('Masehi', !_isHijriPrimary),
                      _buildToggleButton('Hijriyah', _isHijriPrimary),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.calendar_month, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      _isHijriPrimary 
                          ? _getHijriMonthName(HijriCalendar.fromDate(_focusedDay))
                          : _getMonthName(_focusedDay),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _isHijriPrimary 
                      ? _getMonthName(_focusedDay)
                      : _getHijriMonthName(HijriCalendar.fromDate(_focusedDay)),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // Calendar
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildCalendar(),
                    const SizedBox(height: 20),
                    _buildLegend(),
                    const SizedBox(height: 20),
                    _buildSelectedDateInfo(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: showFAB
          ? FloatingActionButton.extended(
              onPressed: _jumpToToday,
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.today),
              label: const Text('Hari Ini'),
            )
          : null,
    );
  }

  Widget _buildCalendar() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            
            // Show bottomsheet with prayer schedule
            _showPrayerScheduleBottomSheet(selectedDay);
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        
        // Styling
        calendarStyle: CalendarStyle(
          // Today
          todayDecoration: BoxDecoration(
            color: Colors.teal.shade400,
            shape: BoxShape.circle,
          ),
          todayTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          
          // Selected day
          selectedDecoration: BoxDecoration(
            color: Colors.green.shade600,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          
          // Weekend
          weekendTextStyle: TextStyle(
            color: Colors.red.shade600,
          ),
          
          // Default
          defaultTextStyle: const TextStyle(
            color: Colors.black87,
          ),
          
          // Outside month
          outsideTextStyle: TextStyle(
            color: Colors.grey.shade400,
          ),
          
          // Hide markers (bullets)
          markerDecoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          markersMaxCount: 1,
          markerSize: 0,
        ),
        
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.green.shade900,
          ),
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: Colors.green.shade700,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: Colors.green.shade700,
          ),
          // Custom title formatter based on mode
          titleTextFormatter: (date, locale) {
            if (_isHijriPrimary) {
              final hijri = HijriCalendar.fromDate(date);
              final hijriMonths = [
                'Muharram', 'Safar', 'Rabi\'ul Awwal', 'Rabi\'ul Akhir',
                'Jumadal Ula', 'Jumadal Akhir', 'Rajab', 'Sya\'ban',
                'Ramadan', 'Syawal', 'Dzulqa\'dah', 'Dzulhijjah'
              ];
              return '${hijriMonths[hijri.hMonth - 1]} ${hijri.hYear} H';
            } else {
              final months = [
                'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
                'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
              ];
              return '${months[date.month - 1]} ${date.year}';
            }
          },
        ),
        
        daysOfWeekStyle: DaysOfWeekStyle(
          dowTextFormatter: (date, locale) {
            // Custom day names based on mode
            final dayNames = _isHijriPrimary 
                ? ['Ahad', 'Isnin', 'Selasa', 'Rabu', 'Kamis', 'Jumaat', 'Sabtu']
                : ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
            return dayNames[date.weekday % 7];
          },
          weekdayStyle: TextStyle(
            color: Colors.green.shade700,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          weekendStyle: TextStyle(
            color: Colors.red.shade600,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        
        // Markers for dates with cached data
        eventLoader: (day) {
          final normalizedDay = DateTime(day.year, day.month, day.day);
          if (_cachedDates.containsKey(normalizedDay) && _cachedDates[normalizedDay]!) {
            return ['•']; // Return a marker
          }
          return [];
        },
        
        // Locale
        locale: 'id_ID',
        
        // Custom cell builder for dual calendar
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            return _buildCalendarCell(day, isToday: false, isSelected: false, isOutside: false);
          },
          todayBuilder: (context, day, focusedDay) {
            return _buildCalendarCell(day, isToday: true, isSelected: false, isOutside: false);
          },
          selectedBuilder: (context, day, focusedDay) {
            return _buildCalendarCell(day, isToday: false, isSelected: true, isOutside: false);
          },
          outsideBuilder: (context, day, focusedDay) {
            return _buildCalendarCell(day, isToday: false, isSelected: false, isOutside: true);
          },
        ),
      ),
    );
  }

  // Build custom calendar cell with Hijri date
  Widget _buildCalendarCell(DateTime day, {required bool isToday, required bool isSelected, required bool isOutside}) {
    final hijriDate = _toHijriDateString(day);
    final isWeekend = day.weekday == DateTime.saturday || day.weekday == DateTime.sunday;
    
    Color backgroundColor;
    Color textColor;
    Color hijriTextColor;
    
    if (isSelected) {
      backgroundColor = Colors.green.shade600;
      textColor = Colors.white;
      hijriTextColor = Colors.white.withOpacity(0.8);
    } else if (isToday) {
      backgroundColor = Colors.teal.shade400;
      textColor = Colors.white;
      hijriTextColor = Colors.white.withOpacity(0.8);
    } else if (isOutside) {
      backgroundColor = Colors.transparent;
      textColor = Colors.grey.shade400;
      hijriTextColor = Colors.grey.shade300;
    } else if (isWeekend) {
      backgroundColor = Colors.transparent;
      textColor = Colors.red.shade600;
      hijriTextColor = Colors.red.shade300;
    } else {
      backgroundColor = Colors.transparent;
      textColor = Colors.black87;
      hijriTextColor = Colors.grey.shade600;
    }
    
    // Swap primary and secondary based on mode
    final primaryText = _isHijriPrimary ? hijriDate : '${day.day}';
    final secondaryText = _isHijriPrimary ? '${day.day}' : hijriDate;
    
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              primaryText,
              style: TextStyle(
                color: textColor,
                fontWeight: (isToday || isSelected) ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              secondaryText,
              style: TextStyle(
                color: hijriTextColor,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Keterangan:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildLegendItem(
                  Colors.teal.shade400,
                  'Hari Ini',
                ),
                const SizedBox(width: 16),
                _buildLegendItem(
                  Colors.green.shade600,
                  'Dipilih',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSelectedDateInfo() {
    if (_selectedDay == null) return const SizedBox.shrink();
    
    final List<String> days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    final List<String> months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    
    final dayName = days[_selectedDay!.weekday - 1];
    final monthName = months[_selectedDay!.month - 1];
    final dateString = '$dayName, ${_selectedDay!.day} $monthName ${_selectedDay!.year}';
    
    // Get Hijri date
    final hijri = HijriCalendar.fromDate(_selectedDay!);
    final hijriMonthNames = [
      'Muharram', 'Safar', 'Rabi\'ul Awwal', 'Rabi\'ul Akhir',
      'Jumadal Ula', 'Jumadal Akhir', 'Rajab', 'Sya\'ban',
      'Ramadan', 'Syawal', 'Dzulqa\'dah', 'Dzulhijjah'
    ];
    final hijriDateString = '${hijri.hDay} ${hijriMonthNames[hijri.hMonth - 1]} ${hijri.hYear} H';
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.event, color: Colors.green.shade700),
                const SizedBox(width: 8),
                const Text(
                  'Tanggal Dipilih',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Masehi date
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    dateString,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green.shade900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Hijri date
            Row(
              children: [
                Icon(Icons.mosque, size: 16, color: Colors.green.shade600),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    hijriDateString,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (_selectedDay != null) {
                    _showPrayerScheduleBottomSheet(_selectedDay!);
                  }
                },
                icon: const Icon(Icons.schedule),
                label: const Text('Lihat Jadwal Sholat'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show bottomsheet with prayer schedule for selected date
  Future<void> _showPrayerScheduleBottomSheet(DateTime selectedDate) async {
    // Get city ID from cache
    final locationCache = await _dbHelper.getLocationCache();
    
    if (locationCache == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lokasi belum tersedia. Silakan buka halaman Home terlebih dahulu.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final cityId = locationCache['city_id'];
    final cityName = locationCache['city_name'];

    if (!mounted) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _PrayerScheduleBottomSheet(
        selectedDate: selectedDate,
        cityId: cityId,
        cityName: cityName,
        prayerApiService: _prayerApiService,
        dbHelper: _dbHelper,
      ),
    );
  }
}

// Bottom Sheet Widget for Prayer Schedule
class _PrayerScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate;
  final String cityId;
  final String cityName;
  final PrayerTimeApiService prayerApiService;
  final DatabaseHelper dbHelper;

  const _PrayerScheduleBottomSheet({
    required this.selectedDate,
    required this.cityId,
    required this.cityName,
    required this.prayerApiService,
    required this.dbHelper,
  });

  @override
  State<_PrayerScheduleBottomSheet> createState() => _PrayerScheduleBottomSheetState();
}

class _PrayerScheduleBottomSheetState extends State<_PrayerScheduleBottomSheet> {
  PrayerSchedule? _prayerSchedule;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPrayerSchedule();
  }

  Future<void> _loadPrayerSchedule() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Format date for API and cache
      final dateString = '${widget.selectedDate.year}-${widget.selectedDate.month.toString().padLeft(2, '0')}-${widget.selectedDate.day.toString().padLeft(2, '0')}';
      
      // Check cache first
      final cachedSchedule = await widget.dbHelper.getPrayerScheduleCache(
        widget.cityId,
        dateString,
      );

      if (cachedSchedule != null) {
        // Load from cache
        setState(() {
          _prayerSchedule = PrayerSchedule.fromJson(cachedSchedule['prayer_data']);
          _isLoading = false;
        });
        return;
      }

      // Fetch from API
      final schedule = await widget.prayerApiService.getPrayerScheduleByComponents(
        widget.cityId,
        widget.selectedDate.year,
        widget.selectedDate.month,
        widget.selectedDate.day,
      );

      if (schedule == null) {
        setState(() {
          _errorMessage = 'Jadwal sholat tidak tersedia untuk tanggal ini.';
          _isLoading = false;
        });
        return;
      }

      // Save to cache
      await widget.dbHelper.savePrayerScheduleCache(
        cityId: widget.cityId,
        date: dateString,
        prayerData: {
          'id': schedule.id,
          'lokasi': schedule.lokasi,
          'daerah': schedule.daerah,
          'jadwal': schedule.jadwal.toJson(),
        },
      );

      setState(() {
        _prayerSchedule = schedule;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan: $e';
        _isLoading = false;
      });
    }
  }

  String _formatDate() {
    final List<String> days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    final List<String> months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    
    final dayName = days[widget.selectedDate.weekday - 1];
    final monthName = months[widget.selectedDate.month - 1];
    
    return '$dayName, ${widget.selectedDate.day} $monthName ${widget.selectedDate.year}';
  }

  String _formatHijriDate() {
    final hijri = HijriCalendar.fromDate(widget.selectedDate);
    final hijriMonthNames = [
      'Muharram', 'Safar', 'Rabi\'ul Awwal', 'Rabi\'ul Akhir',
      'Jumadal Ula', 'Jumadal Akhir', 'Rajab', 'Sya\'ban',
      'Ramadan', 'Syawal', 'Dzulqa\'dah', 'Dzulhijjah'
    ];
    return '${hijri.hDay} ${hijriMonthNames[hijri.hMonth - 1]} ${hijri.hYear} H';
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  border: Border(
                    bottom: BorderSide(color: Colors.green.shade200, width: 1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.event, color: Colors.green.shade700, size: 24),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formatDate(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade900,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Icon(Icons.mosque, size: 14, color: Colors.green.shade600),
                                  const SizedBox(width: 4),
                                  Text(
                                    _formatHijriDate(),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: Colors.green.shade600),
                        const SizedBox(width: 4),
                        Text(
                          widget.cityName,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _errorMessage != null
                        ? _buildErrorWidget()
                        : _buildPrayerTimesList(scrollController),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Terjadi kesalahan',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadPrayerSchedule,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerTimesList(ScrollController scrollController) {
    if (_prayerSchedule == null) {
      return const Center(child: Text('Tidak ada data'));
    }

    final jadwal = _prayerSchedule!.jadwal;

    final List<Map<String, dynamic>> prayerTimes = [
      {'name': 'Imsak', 'time': jadwal.imsak, 'icon': Icons.nightlight_round, 'color': Colors.indigo},
      {'name': 'Subuh', 'time': jadwal.subuh, 'icon': Icons.wb_twilight, 'color': Colors.blue},
      {'name': 'Terbit', 'time': jadwal.terbit, 'icon': Icons.wb_sunny, 'color': Colors.orange},
      {'name': 'Dhuha', 'time': jadwal.dhuha, 'icon': Icons.wb_sunny_outlined, 'color': Colors.amber},
      {'name': 'Dzuhur', 'time': jadwal.dzuhur, 'icon': Icons.light_mode, 'color': Colors.yellow},
      {'name': 'Ashar', 'time': jadwal.ashar, 'icon': Icons.wb_cloudy, 'color': Colors.deepOrange},
      {'name': 'Maghrib', 'time': jadwal.maghrib, 'icon': Icons.wb_twilight, 'color': Colors.deepPurple},
      {'name': 'Isya', 'time': jadwal.isya, 'icon': Icons.nights_stay, 'color': Colors.purple},
    ];

    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: prayerTimes.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final prayer = prayerTimes[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: (prayer['color'] as Color).withOpacity(0.1),
              child: Icon(
                prayer['icon'] as IconData,
                color: prayer['color'] as Color,
                size: 24,
              ),
            ),
            title: Text(
              prayer['name'] as String,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                prayer['time'] as String,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
