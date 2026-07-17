import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/rendering.dart';
import 'app_widgets.dart';
import 'app_theme.dart';
import 'JournalEntry.dart';
import 'JournalService.dart';

class SocialBatteryScreen extends StatefulWidget{
  const SocialBatteryScreen({super.key});

  @override
  State<SocialBatteryScreen> createState() => _SocialBatteryScreenState();
}

class _SocialBatteryScreenState extends State<SocialBatteryScreen>{
  late Future<List<JournalEntry>> _future;

  @override
  void initState(){
    super.initState();
    _future = JournalService.fetchEntries();
  }

  Color _batteryColor(double value) {
    if (value >= 65) return const Color(0xFF7FB5A8);
    if (value >= 35) return const Color(0xFFD4A96A);
    return const Color(0xFFB08090);
  }

  List<JournalEntry> _getLastSevenDays ( List<JournalEntry> entries ) {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    return entries
        .where((e) => (e.createdAt != null) && (e.createdAt.isAfter(sevenDaysAgo)))
        .toList()
        ..sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
  }


  String _dayLabel(DateTime date){
    const days = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
    return days[date.weekday % 7];
  }


  String _insight( List<JournalEntry> entries){
    if(entries.isEmpty) {
      return 'Start logging entries to see your energy patterns';
    }
    final avg = entries.map((e) => (e.socialBattery ?? 0)).reduce((a,b) => a+b)/entries.length;
    if (avg >= 65) return 'You\'ve been well charged this week. Keep it up!';
    if (avg >= 35) return 'Your energy has been balanced this week.';
    return 'Your energy has been low this week. Remember to recharge.';
    }

    @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Social Battery'),
        backgroundColor: AppTheme.background,
        foregroundColor: AppTheme.textDark,
        elevation: 0,
        centerTitle: true,
      ),

      body: FutureBuilder<List<JournalEntry>>(
          future: _future,
          builder:(context, snapshot) {
            if( snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(color: AppTheme.primary),
              );
            }

            if( snapshot.hasError){
              return Center(
                child: Text(
                  'Could not load data',
                  style: TextStyle(color: AppTheme.textMuted),
                ),
              );
            }

            final entries = _getLastSevenDays(snapshot.data ?? []);

            if( entries.isEmpty){
              return Center(
                child: Padding(
                    padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.battery_unknown,
                      size: 64, color: AppTheme.textMuted),

                      const SizedBox(height: 16),
                      Text(
                        'No entries this week yet.',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.textMuted,
                        ),
                      ),

                      const SizedBox(height: 8),
                      Text(
                        'Write your first reflection to start tracking your social energy.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textMuted
                        ),
                      ),
                    ],
                  ),
              ),
              );
            }


            final spots = entries.asMap().entries.map((e) {
              return FlSpot(e.key.toDouble(), (e.value.socialBattery ?? 0).toDouble());
            }).toList();

            final avgColor = _batteryColor(
              entries.map((e) => (e.socialBattery ?? 0)).reduce((a,b) => a+b)/entries.length,
            );

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  //Insight card
                  AppWidgets.card(
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: avgColor,
                              shape: BoxShape.circle,
                            ),
                          ),

                          const SizedBox(width: 12),
                          Expanded(
                              child: Text(
                                _insight(entries),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.textDark,
                                  height: 15,
                                ),
                              ),
                          ),
                        ],
                      ),
                  ),

                  const SizedBox(height: 24),

                  //Chart card

                  AppWidgets.card(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Last 7 Days',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textMuted,
                              letterSpacing: 0.5,
                            ),
                          ),

                          const SizedBox(height: 24),
                          SizedBox(
                            height: 200,
                            child: LineChart(
                              LineChartData(
                                minY: 0,
                                maxY: 100,
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  horizontalInterval: 25,
                                  getDrawingHorizontalLine: (value) => FlLine(
                                    color: AppTheme.border,
                                    strokeWidth: 1,
                                  ),
                                  ),

                                  borderData: FlBorderData(show: false),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 25,
                                      reservedSize: 32,
                                      getTitlesWidget: (value, meta) => Text(
                                        '${value.toInt()}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppTheme.textMuted,
                                        ),
                                      ),
                                    ),
                                  ),

                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles( showTitles: false),
                                  ),
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        final index = value.toInt();
                                        if ((index >= 0) &&
                                            (index < entries.length)) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8),
                                            child: Text(_dayLabel(
                                                entries[index].createdAt!),
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: AppTheme.textMuted,
                                              ),
                                            ),
                                          );
                                        }
                                        return const Text('');
                                      },
                                    ),
                                  ),
                                ),

                                lineBarsData: [
                                  LineChartBarData(
                                    spots: spots,
                                    isCurved: true,
                                    curveSmoothness: 0.4,
                                    color: avgColor,
                                    barWidth: 2.5,
                                    isStrokeCapRound: true,
                                    dotData: FlDotData(
                                      show: true,
                                      getDotPainter:
                                      (spot, percent, bar, index) =>
                                          FlDotCirclePainter(
                                            radius: 4,
                                            color: AppTheme.surface,
                                            strokeWidth: 2,
                                            strokeColor: avgColor,
                                          ),
                                    ),

                                    belowBarData: BarAreaData(
                                      show: true,
                                      gradient: LinearGradient(
                                          colors:[
                                            avgColor.withValues(alpha: 0.3),
                                            avgColor.withValues(alpha: 0.0),
                                          ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  ),
                                ],
                                ),
                              ),
                            ),
                        ],
                      ),
                  ),

                  const SizedBox(height: 24),

                  //Legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _legendItem( const Color(0xFF7FB5A8), 'High (65-100)'),
                        _legendItem( const Color(0xFFD4A96A), 'Medium (35-64)'),
                        _legendItem( const Color(0xFFB08090), 'Low (0-34)'),
                      ],
                  ),
                ],
              ),
            );
            },
      ),
    );
          }


          Widget _legendItem( Color color, String label){
    return Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textMuted,
            ),
          ),
    ],
    );
  }
}