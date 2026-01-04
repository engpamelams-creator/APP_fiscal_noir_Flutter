import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fiscal_noir/modules/dashboard/presentation/widgets/neon_filter_bar.dart';
import 'package:fiscal_noir/modules/dashboard/presentation/widgets/tactical_radar_chart.dart';
import 'package:fiscal_noir/core/theme/app_colors.dart';
import 'package:fiscal_noir/models/transaction_model.dart';
import 'package:fiscal_noir/services/firestore_service.dart';
import 'package:fiscal_noir/modules/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:fiscal_noir/modules/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:fiscal_noir/modules/dashboard/presentation/pages/transaction_details_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _cubit = GetIt.I<DashboardCubit>();
  String _selectedFilter = 'Tudo'; // '7 Dias', '30 Dias', 'Tudo'

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: _buildDrawer(context),
        appBar: _buildAppBar(context),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              colors: [Color(0xFF1A1A1A), Colors.black],
              center: Alignment.center,
              radius: 0.85,
            ),
          ),
          child: StreamBuilder<List<TransactionModel>>(
            stream: FirestoreService().getTransactions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Erro na conexão: ${snapshot.error}",
                    style: GoogleFonts.spaceMono(color: AppColors.error),
                  ),
                );
              }

              final allTransactions = snapshot.data ?? [];
              List<TransactionModel> filteredTransactions = allTransactions;

              // Filter Logic (Investigation Window)
              final now = DateTime.now();
              if (_selectedFilter == '7 Dias') {
                filteredTransactions = allTransactions.where((t) {
                  return now.difference(t.date).inDays <= 7;
                }).toList();
              } else if (_selectedFilter == '30 Dias') {
                filteredTransactions = allTransactions.where((t) {
                  return now.difference(t.date).inDays <= 30;
                }).toList();
              }

              // Calculate Balance Logic
              const double budget = 5000.00;
              final double totalSpent =
                  filteredTransactions.fold(0, (sum, item) => sum + item.value);
              final double currentBalance = budget - totalSpent;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    const Gap(24),
                    _buildBalanceHeader(currentBalance),
                    const Gap(32),
                    // Investigation Window (Filters)
                    NeonFilterBar(
                      filters: const ['7 Dias', '30 Dias', 'Tudo'],
                      selectedFilter: _selectedFilter,
                      onFilterSelected: (val) {
                        setState(() => _selectedFilter = val);
                      },
                    ),
                    const Gap(24),
                    // Threat Radar (Chart)
                    if (filteredTransactions.isNotEmpty)
                      TacticalRadarChart(transactions: filteredTransactions)
                    else
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Text(
                          "Aguardando dados para triangulação...",
                          style: GoogleFonts.spaceMono(
                              color: Colors.white24, fontSize: 12),
                        ),
                      ),

                    _buildTransactionsList(filteredTransactions),
                  ],
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddEvidenceModal(context),
          backgroundColor: AppColors.primary,
          icon:
              const Icon(Icons.add_location_alt_outlined, color: Colors.white),
          label: Text(
            'ARQUIVAR EVIDÊNCIA',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }

  void _showAddEvidenceModal(BuildContext context) {
    final titleController = TextEditingController();
    final valueController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    String selectedCategory = 'Alimentação';

    // Categories with Icons
    final Map<String, IconData> categories = {
      'Alimentação': Icons.fastfood_outlined,
      'Transporte': Icons.directions_car_outlined,
      'Lazer': Icons.local_activity_outlined,
      'Despesas': Icons.receipt_long_outlined,
      'Outros': Icons.category_outlined,
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF1E1E1E),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(color: Colors.black54, blurRadius: 20, spreadRadius: 5),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Gap(24),
              Text(
                'ARQUIVAR NOVA EVIDÊNCIA',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(24),
              // Date Picker Field
              InkWell(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: AppColors.primary,
                            onPrimary: Colors.black,
                            surface: Color(0xFF1E1E1E),
                            onSurface: Colors.white,
                          ),
                          dialogBackgroundColor: const Color(0xFF1E1E1E),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null && picked != selectedDate) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          color: AppColors.primary),
                      const Gap(12),
                      Text(
                        'DATA: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(16),
              TextField(
                controller: titleController,
                style: GoogleFonts.poppins(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'DETALHE DA PISTA',
                  labelStyle: GoogleFonts.poppins(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.black26,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.description_outlined,
                      color: AppColors.primary),
                ),
              ),
              const Gap(16),
              TextField(
                controller: valueController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: GoogleFonts.poppins(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'CUSTO DA OPERAÇÃO',
                  labelStyle: GoogleFonts.poppins(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.black26,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon:
                      const Icon(Icons.attach_money, color: AppColors.primary),
                ),
              ),
              const Gap(16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                dropdownColor: const Color(0xFF2C2C2C),
                style: GoogleFonts.poppins(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'CLASSIFICAÇÃO DO SUSPEITO',
                  labelStyle: GoogleFonts.poppins(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.black26,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.category_outlined,
                      color: AppColors.primary),
                ),
                items: categories.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key,
                    child: Row(
                      children: [
                        Icon(entry.value, size: 18, color: Colors.white70),
                        const Gap(8),
                        Text(entry.key),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
              ),
              const Gap(32),
              ElevatedButton(
                onPressed: () async {
                  if (titleController.text.isEmpty ||
                      valueController.text.isEmpty) {
                    return;
                  }

                  final double? value = double.tryParse(
                      valueController.text.replaceAll(',', '.'));
                  if (value == null) return;

                  final transaction = TransactionModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleController.text,
                      value: value,
                      date: selectedDate,
                      category: selectedCategory,
                      status: 'analyzed');

                  await FirestoreService().addTransaction(transaction);

                  try {
                    HapticFeedback.mediumImpact();
                  } catch (_) {}

                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Evidência processada com sucesso.',
                          style: GoogleFonts.poppins(color: Colors.black),
                        ),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'ARQUIVAR NO DOSSIÊ',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Text on primary
                  ),
                ),
              ),
              const Gap(32),
            ],
          ),
        ),
      ),
    );
  }

  // AppBar remains unchanged...
  // NOTE: Removed internal _buildBottomNav as it's now handled by MainPage

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Builder(builder: (context) {
        return IconButton(
          icon:
              const Icon(Icons.grid_view_rounded, color: AppColors.textPrimary),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        );
      }),
      // Title removed for minimalist stealth look
      actions: [
        BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            final isStealth =
                (state is DashboardLoaded) ? state.isStealthMode : false;

            return IconButton(
              icon: Icon(
                isStealth ? Icons.visibility : Icons.visibility_off,
                color: AppColors.textPrimary,
              ),
              onPressed: () {
                context.read<DashboardCubit>().toggleStealthMode();

                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isStealth
                          ? 'Modo Furtivo: Desativado.'
                          : 'Modo Furtivo: Ativado. Valores ocultos.',
                      style: GoogleFonts.spaceMono(color: Colors.black),
                    ),
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded,
              color: AppColors.textPrimary),
          onPressed: () {},
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2.0),
        child: Container(
          height: 2.0,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary,
                blurRadius: 10.0,
                spreadRadius: 1.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1A1A1A),
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                opacity: 0.2,
                fit: BoxFit.cover,
              ),
            ),
            currentAccountPicture: Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.5),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(Icons.person, color: Colors.black, size: 36),
            ),
            accountName: Text(
              "Agente Operacional",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            accountEmail: Text(
              "agente@fiscalnoir.com",
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.dashboard_rounded,
                  text: 'QG Operacional',
                  onTap: () => Navigator.pop(context),
                  isSelected: true,
                ),
                _buildDrawerItem(
                  icon: Icons.lock_outline,
                  text: 'Cofre de Evidências',
                  onTap: () {
                    Navigator.pop(context);
                    _showFeatureSnackBar(
                        context, "Acesso ao Cofre em desenvolvimento.");
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.folder_open_outlined,
                  text: 'Arquivos Mortos',
                  onTap: () {
                    Navigator.pop(context);
                    _showFeatureSnackBar(
                        context, "Arquivos indisponíveis no momento.");
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.label_important_outline,
                  text: 'Perfil de Suspeitos',
                  onTap: () {
                    Navigator.pop(context);
                    _showFeatureSnackBar(
                        context, "Banco de dados de suspeitos offline.");
                  },
                ),
                Divider(color: Colors.grey[800]),
                _buildDrawerItem(
                  icon: Icons.settings_outlined,
                  text: 'Configurações',
                  onTap: () {
                    Navigator.pop(context);
                    _showFeatureSnackBar(
                        context, "Ajustes de protocolo bloqueados.");
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildDrawerItem(
              icon: Icons.exit_to_app_outlined,
              text: 'ABORTAR MISSÃO',
              color: AppColors.error,
              onTap: () async {
                Navigator.pop(context); // Close drawer
                Navigator.of(context)
                    .pushReplacementNamed('/'); // Back to Login
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color color = AppColors.primary,
    bool isSelected = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: GoogleFonts.poppins(
          color: color == AppColors.error ? color : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: AppColors.primary.withOpacity(0.1),
      onTap: onTap,
    );
  }

  void _showFeatureSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins()),
        backgroundColor: const Color(0xFF333333),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildBalanceHeader(double currentBalance) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        // Logic for "Munição/Budget Integrity"
        // Using real calculated balance passed from parent

        final bool isStealth =
            (state is DashboardLoaded) ? state.isStealthMode : false;

        Color statusColor;
        String statusText;
        double progressValue;

        // Budget R$ 5000.00
        // Calculate progress based on remaining/total
        // If currentBalance is 1250 / 5000 = 0.25
        progressValue = (currentBalance / 5000.0).clamp(0.0, 1.0);

        if (currentBalance > 2500) {
          statusColor = const Color(0xFF00E676); // Bright Green
          statusText = "SOB CONTROLE";
        } else if (currentBalance >= 1000) {
          statusColor = const Color(0xFFFF9100); // Orange
          statusText = "ALERTA TÁTICO";
        } else {
          statusColor = const Color(0xFFFF1744); // Red
          statusText = "PERIGO IMINENTE";
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.shield_outlined,
                        color: AppColors.primary, size: 20),
                  ),
                  const Gap(12),
                  Text(
                    'MUNIÇÃO RESTANTE',
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              const Gap(24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    'R\$',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary.withOpacity(0.8),
                    ),
                  ),
                  const Gap(4),
                  Text(
                    isStealth ? '****' : currentBalance.toStringAsFixed(2),
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      shadows: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        statusText,
                        style: GoogleFonts.spaceMono(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        '${(progressValue * 100).toInt()}%',
                        style: GoogleFonts.spaceMono(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const Gap(10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progressValue,
                      backgroundColor: Colors.white10,
                      valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTransactionsList(List<TransactionModel> transactions) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.search, color: AppColors.primary, size: 20),
              const Gap(8),
              Text(
                'ÚLTIMAS PISTAS IDENTIFICADAS',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const Gap(20),
          BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, state) {
              final isStealth =
                  (state is DashboardLoaded) ? state.isStealthMode : false;

              if (transactions.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      const Gap(40),
                      Icon(Icons.folder_off_outlined,
                          size: 48, color: Colors.white24),
                      const Gap(16),
                      Text(
                        'Nenhuma evidência arquivada.',
                        style: GoogleFonts.poppins(color: Colors.white38),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                separatorBuilder: (_, __) => const Gap(16),
                itemBuilder: (context, index) {
                  final item = transactions[index];

                  // "Pista" Icon Logic
                  IconData icon = Icons.fingerprint; // Default "Digital"
                  if (item.category.toLowerCase().contains('alimentação')) {
                    icon = Icons.fastfood_outlined;
                  } else if (item.category
                      .toLowerCase()
                      .contains('transporte')) {
                    icon = Icons.directions_car_outlined;
                  } else if (item.category.toLowerCase().contains('lazer')) {
                    icon = Icons.local_activity_outlined;
                  }

                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        splashColor: AppColors.primary.withOpacity(0.1),
                        highlightColor: AppColors.primary.withOpacity(0.05),
                        onTap: () {
                          // HapticFeedback can crash on web during hot restart or if unsupported
                          try {
                            HapticFeedback.lightImpact();
                          } catch (_) {}

                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 600),
                              pageBuilder: (_, __, ___) =>
                                  TransactionDetailsPage(
                                title: item.title,
                                amount: 'R\$ ${item.value.toStringAsFixed(2)}',
                                date: item.date.toString(),
                                icon: icon,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                height: 48,
                                width: 48,
                                decoration: BoxDecoration(
                                  color: Colors.black45,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white10),
                                ),
                                child: Icon(
                                  icon,
                                  color: AppColors.primary.withOpacity(0.8),
                                  size: 24,
                                ),
                              ),
                              const Gap(16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Hero(
                                      tag: 'title_${item.title}_$index',
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Text(
                                          item.title,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Gap(4),
                                    Text(
                                      'DETECTADO EM: ${item.date.day}/${item.date.month}/${item.date.year}',
                                      style: GoogleFonts.spaceMono(
                                        color: Colors.white38,
                                        fontSize: 10,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                isStealth
                                    ? '-R\$ ****'
                                    : '-R\$ ${item.value.toStringAsFixed(2)}',
                                style: GoogleFonts.spaceGrotesk(
                                  color: Colors.white, // High contrast
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // NOTE: Removed internal _buildBottomNav as it's now handled by MainPage
}
