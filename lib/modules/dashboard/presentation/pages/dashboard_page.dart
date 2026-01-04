import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fiscal_noir/core/theme/app_colors.dart';
import 'package:fiscal_noir/models/transaction_model.dart';
import 'package:fiscal_noir/services/firestore_service.dart';
import 'package:fiscal_noir/modules/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:fiscal_noir/modules/dashboard/presentation/pages/transaction_details_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _cubit = GetIt.I<DashboardCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Colors
            .transparent, // Allow gradient to shine if needed, or just let body cover
        appBar: _buildAppBar(),
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Gap(24),
                _buildBalanceHeader(),
                const Gap(32),
                _buildTransactionsList(),
              ],
            ),
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
    String selectedCategory = 'Alimentação';
    final categories = [
      'Alimentação',
      'Transporte',
      'Lazer',
      'Despesas',
      'Outros'
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
              items: categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                selectedCategory = newValue!;
              },
            ),
            const Gap(32),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isEmpty ||
                    valueController.text.isEmpty) {
                  return;
                }

                final double? value =
                    double.tryParse(valueController.text.replaceAll(',', '.'));
                if (value == null) return;

                final transaction = TransactionModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleController.text,
                    value: value,
                    date: DateTime.now(),
                    category: selectedCategory,
                    status: 'analyzed');

                await FirestoreService().addTransaction(transaction);

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
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.grid_view_rounded, color: AppColors.textPrimary),
        onPressed: () {},
      ),
      title: Text(
        'Dashboard',
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded,
              color: AppColors.textPrimary),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildBalanceHeader() {
    // Logic for "Munição/Budget Integrity"
    // Mocking current balance for demo logic, in real app this comes from state
    final double currentBalance = 1250.00; // Example value

    Color statusColor;
    String statusText;
    double progressValue;

    if (currentBalance > 500) {
      statusColor = const Color(0xFF00E676); // Bright Green
      statusText = "SOB CONTROLE";
      progressValue = 0.85;
    } else if (currentBalance >= 100) {
      statusColor = const Color(0xFFFF9100); // Orange
      statusText = "ALERTA TÁTICO";
      progressValue = 0.45;
    } else {
      statusColor = const Color(0xFFFF1744); // Red
      statusText = "PERIGO IMINENTE";
      progressValue = 0.15;
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
                '1.250,00',
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
  }

  Widget _buildTransactionsList() {
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
          StreamBuilder<List<TransactionModel>>(
            stream: FirestoreService().getTransactions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
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

              final transactions = snapshot.data!;

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
                          HapticFeedback.lightImpact();
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
                                '-R\$ ${item.value.toStringAsFixed(2)}',
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
