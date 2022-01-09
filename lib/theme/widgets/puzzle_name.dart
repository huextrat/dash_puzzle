import 'package:dash_puzzle/colors/colors.dart';
import 'package:dash_puzzle/layout/layout.dart';
import 'package:dash_puzzle/typography/typography.dart';
import 'package:flutter/material.dart';

/// {@template puzzle_name}
/// Displays the name of the current puzzle theme.
/// Visible only on a large layout.
/// {@endtemplate}
class PuzzleName extends StatelessWidget {
  /// {@macro puzzle_name}
  const PuzzleName({Key? key, required this.title}) : super(key: key);

  /// The title of the puzzle.
  final String title;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (context, child) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: PuzzleTextStyle.headline5.copyWith(
              color: PuzzleColors.grey1,
            ),
          ),
        ],
      ),
      medium: (context, child) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: PuzzleTextStyle.headline5.copyWith(
              color: PuzzleColors.grey1,
            ),
          ),
        ],
      ),
      large: (context, child) => Text(
        title,
        style: PuzzleTextStyle.headline5.copyWith(
          color: PuzzleColors.grey1,
        ),
      ),
    );
  }
}
