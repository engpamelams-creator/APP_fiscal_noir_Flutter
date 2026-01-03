import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fiscal_noir/core/theme/app_theme.dart';
import 'package:fiscal_noir/modules/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:fiscal_noir/modules/dashboard/presentation/cubit/dashboard_state.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _cubit = GetIt.I<DashboardCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _cubit, // loadData() called in constructor
      child: Scaffold(
        backgroundColor: AppTheme.black,
        appBar: AppBar(
          title: Text(
            'FISCAL NOIR',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w900, letterSpacing: 1),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: AppTheme.white),
              onPressed: () => _cubit.loadData(),
            )
          ],
        ),
        body: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(
                  child: CircularProgressIndicator(color: AppTheme.white));
            } else if (state is DashboardError) {
              return Center(child: Text(state.message));
            } else if (state is DashboardLoaded) {
              final formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.darkGrey,
                        border: Border.all(color: AppTheme.white),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TOTAL SPENT',
                            style: GoogleFonts.inter(
                              color: AppTheme.lightGrey,
                              fontSize: 12,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            formatter.format(state.totalAmount),
                            style: GoogleFonts.inter(
                              color: AppTheme.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'RECENT ACTIVITY',
                      style: GoogleFonts.inter(
                        color: AppTheme.lightGrey,
                        fontSize: 12,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // List
                    Expanded(
                      child: ListView.separated(
                        itemCount: state.expenses.length,
                        separatorBuilder: (_, __) =>
                            const Divider(color: AppTheme.darkGrey),
                        itemBuilder: (context, index) {
                          final expense = state.expenses[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              expense.merchantName,
                              style: GoogleFonts.inter(
                                color: AppTheme.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${DateFormat('dd/MM HH:mm').format(expense.date)} • ${expense.category}',
                              style:
                                  GoogleFonts.inter(color: AppTheme.lightGrey),
                            ),
                            trailing: Text(
                              formatter.format(expense.amount),
                              style: GoogleFonts.inter(
                                color: AppTheme.white,
                                fontSize: 16,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppTheme.white,
          foregroundColor: AppTheme.black,
          shape: const RoundedRectangleBorder(),
          child: const Icon(Icons.add),
          onPressed: () {
            // Navigate to Scanner (Assuming we are integrating)
            // For now we can just show a snackbar or actually pop if this page was pushed
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Go to Scanner')));
          },
        ),
      ),
    );
  }
}
