import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/calculations.dart';
import '../providers/history.dart';
import '../core/index.dart';
import '../providers/theme_provider.dart';

import '../widgets/answer_text.dart';
import '../widgets/buttons_grid.dart';
import '../widgets/custom_animated_switcher.dart';
import '../widgets/custom_icon.dart';
import '../widgets/custom_switch.dart';
import '../widgets/gradient_divider.dart';
import '../widgets/input_feild.dart';
import '../widgets/last_answer.dart';
import '../widgets/responsive.dart';
import '../widgets/switch_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final calc = Provider.of<Calculations>(context, listen: false);
    final history = Provider.of<History>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final lGrid = Provider.of<Calculations>(context).lGrid;
    final colorScheme = Theme.of(context).colorScheme;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    if (isLandscape) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ]);
    }

    void _onExpand() {
      if (isLandscape) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitDown,
          DeviceOrientation.portraitUp,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      }
    }

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.background,
                colorScheme.background.withOpacity(0.85),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 8, bottom: 4),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.glassBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.glassBorder,
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: colorScheme.buttonText,
                          size: 20,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ).animate()
                      .fadeIn(delay: 100.ms)
                      .slideX(),
                    
                    const SizedBox(width: 16),
                    const CustomSwitch()
                        .animate()
                        .fadeIn(delay: 200.ms)
                        .slideX(),
                    const SwitchText()
                        .animate()
                        .fadeIn(delay: 300.ms)
                        .slideX(),
                  ],
                ),
              ),
              if (isLandscape)
                Expanded(
                  flex: 7,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const Expanded(
                              flex: 5,
                              child: InputFeild(),
                            ).animate().fadeIn(delay: 400.ms).scale(),
                            Expanded(
                              flex: isLandscape ? 4 : 2,
                              child: const AnswerText(),
                            ).animate().fadeIn(delay: 500.ms).scale(),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              else ...[
                const Expanded(flex: 4, child: InputFeild())
                    .animate()
                    .fadeIn(delay: 400.ms)
                    .scale(),
                const Expanded(flex: 2, child: AnswerText())
                    .animate()
                    .fadeIn(delay: 500.ms)
                    .scale(),
              ],
              if (!isLandscape) const SizedBox(height: 5),
              const GradientDivider()
                  .animate()
                  .fadeIn(delay: 600.ms)
                  .shimmer(duration: 1.seconds),
              Expanded(
                flex: isLandscape ? 14 : 12,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.gridBg,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Column(
                    children: [
                      Container(
                        height: 33,
                        margin: EdgeInsets.symmetric(
                          horizontal: 3,
                          vertical: isLandscape ? 0 : 5,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomIcon(
                              AppIcon.history,
                              onPressed: history.toggleShowHistory,
                              isSelected: history.isShowHistory,
                            ).animate().fadeIn(delay: 700.ms).slideX(),
                            const SizedBox(width: 10),
                            CustomIcon(
                              AppIcon.expand,
                              onPressed: _onExpand,
                              isSelected: isLandscape,
                            ).animate().fadeIn(delay: 800.ms).slideX(),
                            const Spacer(),
                            Consumer<Calculations>(
                              builder: (context, calc, child) {
                                return LastAnswer(
                                  calc.result,
                                  onPressed: calc.addAns,
                                ).animate().fadeIn(delay: 900.ms).slideX();
                              },
                            ),
                            const SizedBox(width: 15),
                            CustomIcon(
                              AppIcon.delete,
                              onPressed: calc.delete,
                            ).animate().fadeIn(delay: 1000.ms).slideX(),
                          ],
                        ),
                      ),
                      if (!isLandscape) const SizedBox(height: 5),
                      Expanded(
                        child: Responsive(
                          portrait: Column(
                            children: [
                              Expanded(
                                flex: 2,
                                child: CustomAnimatedSwitcher(
                                  grid: ButtonsGrid(grid: lGrid),
                                ),
                              ).animate().fadeIn(delay: 1100.ms).scale(),
                              Expanded(
                                flex: 4,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: ButtonsGrid(grid: AppConstant.grid),
                                    ).animate()
                                        .fadeIn(delay: 1200.ms)
                                        .slideY(begin: 0.2),
                                    Expanded(
                                      child: ButtonsGrid(grid: AppConstant.opGrid),
                                    ).animate()
                                        .fadeIn(delay: 1300.ms)
                                        .slideX(begin: 0.2),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          landscape: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: CustomAnimatedSwitcher(
                                  grid: ButtonsGrid(grid: lGrid),
                                ),
                              ).animate().fadeIn(delay: 1100.ms).slideX(),
                              Expanded(
                                flex: 3,
                                child: ButtonsGrid(grid: AppConstant.grid),
                              ).animate().fadeIn(delay: 1200.ms).slideY(),
                              Expanded(
                                child: ButtonsGrid(grid: AppConstant.opGrid),
                              ).animate().fadeIn(delay: 1300.ms).slideX(),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: isLandscape ? 2 : 5),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 600.ms).scale(),
            ],
          ),
        ),
      ),
    );
  }
}
