import 'package:flutter/material.dart';
import '../../../../../domain/repositories/fuel_calculator_repository.dart';
import '../../../../core/utils/formatters.dart';

class ResultCard extends StatelessWidget {
  final TripCalculationResult result;

  const ResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final calc = result.calculation;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          color: Color(0xFF5D4038),
          width: 1.0,
        ),
        borderRadius: BorderRadius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  color: const Color(0xFFFF4500),
                ),
                const SizedBox(width: 8),
                Text(
                  'Resumo da Estimativa (RF08)',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFFB5A0),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            // Distância de Ida
            _buildRow(
              context: context,
              icon: Icons.east,
              iconColor: const Color(0xFFFFB5A0),
              label: 'Distância de Ida:',
              value: AppFormatters.formatDistance(calc.outboundDistanceKm),
            ),

            // Distância de Volta (se aplicável)
            if (calc.isRoundTrip && calc.returnDistanceKm != null) ...[
              const SizedBox(height: 8),
              _buildRow(
                context: context,
                icon: Icons.west,
                iconColor: const Color(0xFFC9C6C5),
                label: 'Distância de Volta (RN05):',
                value: AppFormatters.formatDistance(calc.returnDistanceKm!),
              ),
            ],

            const SizedBox(height: 8),
            // Distância Total
            _buildRow(
              context: context,
              icon: Icons.alt_route,
              iconColor: const Color(0xFFFF5625),
              label: 'Distância Total:',
              value: AppFormatters.formatDistance(calc.totalDistanceKm),
              isBold: true,
            ),

            const SizedBox(height: 8),
            // Litros Estimados
            _buildRow(
              context: context,
              icon: Icons.local_gas_station_outlined,
              iconColor: const Color(0xFFC9C6C5),
              label: 'Combustível Estimado:',
              value: AppFormatters.formatLitres(calc.litresNeeded),
            ),

            const Divider(height: 24),

            // Custo Total Estimado
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF1C1B1B),
                border: Border.fromBorderSide(
                  BorderSide(color: Color(0xFFFF5625), width: 1.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Custo Estimado:',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFFB5A0),
                    ),
                  ),
                  Text(
                    AppFormatters.formatCurrency(calc.estimatedCost),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFF4500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    bool isBold = false,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 8),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: const Color(0xFFE5E2E1),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: isBold ? const Color(0xFFFF4500) : const Color(0xFFE5E2E1),
          ),
        ),
      ],
    );
  }
}
