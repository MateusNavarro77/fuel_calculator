import 'package:flutter/material.dart';
import 'package:fuel_calculator/ui/core/theme.dart';
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
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.stackMd,
        vertical: AppSpacing.stackSm,
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: theme.colorScheme.outlineVariant, width: 1.0),
        borderRadius: BorderRadius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.stackMd + AppSpacing.unit),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: AppSpacing.stackSm,
                  height: AppSpacing.stackSm,
                  color: AppColors.heatOrange,
                ),
                const SizedBox(width: AppSpacing.stackSm),
                Text(
                  'Resumo da Estimativa (RF08)',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const Divider(height: AppSpacing.gutter),

            // Distância de Ida
            _buildRow(
              context: context,
              icon: Icons.east,
              iconColor: theme.colorScheme.primary,
              label: 'Distância de Ida:',
              value: AppFormatters.formatDistance(calc.outboundDistanceKm),
            ),

            // Distância de Volta (se aplicável)
            if (calc.isRoundTrip && calc.returnDistanceKm != null) ...[
              const SizedBox(height: AppSpacing.stackSm),
              _buildRow(
                context: context,
                icon: Icons.west,
                iconColor: theme.colorScheme.tertiary,
                label: 'Distância de Volta (RN05):',
                value: AppFormatters.formatDistance(calc.returnDistanceKm!),
              ),
            ],

            const SizedBox(height: AppSpacing.stackSm),
            // Distância Total
            _buildRow(
              context: context,
              icon: Icons.alt_route,
              iconColor: theme.colorScheme.primaryContainer,
              label: 'Distância Total:',
              value: AppFormatters.formatDistance(calc.totalDistanceKm),
              isBold: true,
            ),

            const SizedBox(height: AppSpacing.stackSm),
            // Litros Estimados
            _buildRow(
              context: context,
              icon: Icons.local_gas_station_outlined,
              iconColor: theme.colorScheme.tertiary,
              label: 'Combustível Estimado:',
              value: AppFormatters.formatLitres(calc.litresNeeded),
            ),

            const Divider(height: AppSpacing.gutter),

            // Custo Total Estimado
            Container(
              padding: const EdgeInsets.all(AppSpacing.stackMd),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                border: Border.fromBorderSide(
                  BorderSide(
                    color: theme.colorScheme.primaryContainer,
                    width: 1.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Custo Estimado:',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Text(
                    AppFormatters.formatCurrency(calc.estimatedCost),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.heatOrange,
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
        const SizedBox(width: AppSpacing.stackSm),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: isBold ? AppColors.heatOrange : theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
