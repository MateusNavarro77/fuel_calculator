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
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
      //  borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.tertiary.withAlpha(100),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.monetization_on,
                  color: theme.colorScheme.tertiary,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  'Resumo da Estimativa (RF08)',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.tertiary,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            // Distância de Ida
            _buildRow(
              icon: Icons.east,
              iconColor: const Color(0xFF0284C7),
              label: 'Distância de Ida:',
              value: AppFormatters.formatDistance(calc.outboundDistanceKm),
            ),

            // Distância de Volta (se aplicável)
            if (calc.isRoundTrip && calc.returnDistanceKm != null) ...[
              const SizedBox(height: 8),
              _buildRow(
                icon: Icons.west,
                iconColor: const Color(0xFF9333EA),
                label: 'Distância de Volta (RN05):',
                value: AppFormatters.formatDistance(calc.returnDistanceKm!),
              ),
            ],

            const SizedBox(height: 8),
            // Distância Total
            _buildRow(
              icon: Icons.alt_route,
              iconColor: Colors.blueGrey,
              label: 'Distância Total:',
              value: AppFormatters.formatDistance(calc.totalDistanceKm),
              isBold: true,
            ),

            const SizedBox(height: 8),
            // Litros Estimados
            _buildRow(
              icon: Icons.local_gas_station_outlined,
              iconColor: Colors.amber.shade800,
              label: 'Combustível Estimado:',
              value: AppFormatters.formatLitres(calc.litresNeeded),
            ),

            const Divider(height: 24),

            // Custo Total Estimado
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiary.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Custo Estimado:',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.tertiary,
                    ),
                  ),
                  Text(
                    AppFormatters.formatCurrency(calc.estimatedCost),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.tertiary,
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
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    bool isBold = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: Colors.grey.shade800,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: isBold ? Colors.black : Colors.grey.shade900,
          ),
        ),
      ],
    );
  }
}
