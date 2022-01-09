import 'dart:ui';

import 'package:dash_puzzle/colors/colors.dart';
import 'package:dash_puzzle/l10n/l10n.dart';
import 'package:dash_puzzle/layout/layout.dart';
import 'package:dash_puzzle/models/models.dart';
import 'package:dash_puzzle/puzzle/puzzle.dart';
import 'package:dash_puzzle/theme/theme.dart';
import 'package:dash_puzzle/timer/bloc/timer_bloc.dart';
import 'package:dash_puzzle/typography/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

/// {@template simple_puzzle_layout_delegate}
/// A delegate for computing the layout of the puzzle UI
/// that uses a [SimpleTheme].
/// {@endtemplate}
class SimplePuzzleLayoutDelegate extends PuzzleLayoutDelegate {
  /// {@macro simple_puzzle_layout_delegate}
  const SimplePuzzleLayoutDelegate();

  @override
  Widget startSectionBuilder(PuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => Padding(
        padding: const EdgeInsets.only(left: 50, right: 32),
        child: child,
      ),
      child: (_) => SimpleStartSection(state: state),
    );
  }

  @override
  Widget endSectionBuilder(PuzzleState state) {
    return Column(
      children: [
        const ResponsiveGap(
          small: 32,
          medium: 48,
        ),
        ResponsiveLayoutBuilder(
          small: (_, child) => state.puzzleStatus == PuzzleStatus.incomplete
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SimplePuzzleStartButton(),
                    Gap(10),
                    SimplePuzzleShuffleButton(),
                  ],
                )
              : const SimplePuzzleNextButton(),
          medium: (_, child) => state.puzzleStatus == PuzzleStatus.incomplete
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SimplePuzzleStartButton(),
                    Gap(10),
                    SimplePuzzleShuffleButton(),
                  ],
                )
              : const SimplePuzzleNextButton(),
          large: (_, __) => const SizedBox(),
        ),
        const ResponsiveGap(
          small: 32,
          medium: 48,
        ),
      ],
    );
  }

  @override
  Widget boardBuilder(int size, List<Widget> tiles) {
    return Column(
      children: [
        const ResponsiveGap(
          small: 32,
          medium: 48,
          large: 96,
        ),
        ResponsiveLayoutBuilder(
          small: (_, __) => SizedBox.square(
            dimension: _BoardSize.small,
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_small'),
              size: size,
              tiles: tiles,
              spacing: 5,
            ),
          ),
          medium: (_, __) => SizedBox.square(
            dimension: _BoardSize.medium,
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_medium'),
              size: size,
              tiles: tiles,
            ),
          ),
          large: (_, __) => SizedBox.square(
            dimension: _BoardSize.large,
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_large'),
              size: size,
              tiles: tiles,
            ),
          ),
        ),
        const ResponsiveGap(
          large: 96,
        ),
      ],
    );
  }

  @override
  Widget tileBuilder(Tile tile, PuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, __) => SimplePuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_small'),
        tile: tile,
        tileFontSize: _TileFontSize.small,
        state: state,
      ),
      medium: (_, __) => SimplePuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_medium'),
        tile: tile,
        tileFontSize: _TileFontSize.medium,
        state: state,
      ),
      large: (_, __) => SimplePuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_large'),
        tile: tile,
        tileFontSize: _TileFontSize.large,
        state: state,
      ),
    );
  }

  @override
  Widget whitespaceTileBuilder() {
    return const SizedBox();
  }

  @override
  List<Object?> get props => [];
}

/// {@template simple_start_section}
/// Displays the start section of the puzzle based on [state].
/// {@endtemplate}
@visibleForTesting
class SimpleStartSection extends StatelessWidget {
  /// {@macro simple_start_section}
  const SimpleStartSection({
    Key? key,
    required this.state,
  }) : super(key: key);

  /// The state of the puzzle.
  final PuzzleState state;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final timer = context.select((TimerBloc bloc) => bloc.state);
    final hours = timer.secondsElapsed ~/ 3600;
    final minutes = (timer.secondsElapsed - hours * 3600) ~/ 60;
    final seconds = timer.secondsElapsed - (hours * 3600) - (minutes * 60);
    final hourLeft = hours.toString().length < 2
        ? '0$hours'
        : hours.toString();
    final minuteLeft = minutes.toString().length < 2
        ? '0$minutes'
        : minutes.toString();
    final secondsLeft = seconds.toString().length < 2
        ? '0$seconds'
        : seconds.toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ResponsiveGap(
          large: 80,
        ),
        PuzzleName(
            title: toBeginningOfSentenceCase(state.puzzleLevel.name) ??
                state.puzzleLevel.name),
        const ResponsiveGap(large: 16),
        SimplePuzzleTitle(
          status: state.puzzleStatus,
        ),
        const ResponsiveGap(
          small: 12,
          medium: 12,
          large: 32,
        ),
        NumberOfMovesAndTilesLeft(
          numberOfMoves: state.numberOfMoves,
          numberOfTilesLeft: state.numberOfTilesLeft,
        ),
        const ResponsiveGap(large: 10),
        ResponsiveLayoutBuilder(
            small: (_, __) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$hourLeft:$minuteLeft:$secondsLeft',
                  style: PuzzleTextStyle.bodyLargeBold.copyWith(
                    color: theme.defaultColor,
                  ),
                )
              ],
            ),
            medium: (_, __) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$hourLeft:$minuteLeft:$secondsLeft',
                  style: PuzzleTextStyle.bodyLargeBold.copyWith(
                    color: theme.defaultColor,
                  ),
                )
              ],
            ),
            large: (_, __) => Text(
              '$hourLeft:$minuteLeft:$secondsLeft',
              style: PuzzleTextStyle.bodyLargeBold.copyWith(
                color: theme.defaultColor,
              ),
            ),
        ),
        const ResponsiveGap(large: 10),
        ResponsiveLayoutBuilder(
          small: (_, __) => Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: Image.asset(
                'images/dash_${state.puzzleLevel.name}.png',
              ),
            ),
          ),
          medium: (_, __) => Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: Image.asset(
                'images/dash_${state.puzzleLevel.name}.png',
              ),
            ),
          ),
          large: (_, __) => Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: Image.asset(
                'images/dash_${state.puzzleLevel.name}.png',
              ),
            ),
          ),
        ),
        const ResponsiveGap(large: 10),
        ResponsiveLayoutBuilder(
          small: (_, __) => const SizedBox(),
          medium: (_, __) => const SizedBox(),
          large: (_, __) => state.puzzleStatus == PuzzleStatus.incomplete
              ? Row(
                  children: const [
                    SimplePuzzleStartButton(),
                    Gap(10),
                    SimplePuzzleShuffleButton(),
                  ],
                )
              : const SimplePuzzleNextButton(),
        ),
      ],
    );
  }
}

/// {@template simple_puzzle_title}
/// Displays the title of the puzzle based on [status].
///
/// Shows the success state when the puzzle is completed,
/// otherwise defaults to the Puzzle Challenge title.
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleTitle extends StatelessWidget {
  /// {@macro simple_puzzle_title}
  const SimplePuzzleTitle({
    Key? key,
    required this.status,
  }) : super(key: key);

  /// The state of the puzzle.
  final PuzzleStatus status;

  @override
  Widget build(BuildContext context) {
    return PuzzleTitle(
      title: status == PuzzleStatus.complete
          ? context.l10n.puzzleCompleted
          : context.l10n.puzzleChallengeTitle,
    );
  }
}

abstract class _BoardSize {
  static double small = 312;
  static double medium = 424;
  static double large = 472;
}

/// {@template simple_puzzle_board}
/// Display the board of the puzzle in a [size]x[size] layout
/// filled with [tiles]. Each tile is spaced with [spacing].
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleBoard extends StatelessWidget {
  /// {@macro simple_puzzle_board}
  const SimplePuzzleBoard({
    Key? key,
    required this.size,
    required this.tiles,
    this.spacing = 8,
  }) : super(key: key);

  /// The size of the board.
  final int size;

  /// The tiles to be displayed on the board.
  final List<Widget> tiles;

  /// The spacing between each tile from [tiles].
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: size,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      children: tiles,
    );
  }
}

abstract class _TileFontSize {
  static double small = 36;
  static double medium = 50;
  static double large = 54;
}

/// {@template simple_puzzle_tile}
/// Displays the puzzle tile associated with [tile] and
/// the font size of [tileFontSize] based on the puzzle [state].
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleTile extends StatelessWidget {
  /// {@macro simple_puzzle_tile}
  const SimplePuzzleTile({
    Key? key,
    required this.tile,
    required this.tileFontSize,
    required this.state,
  }) : super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  /// The font size of the tile to be displayed.
  final double tileFontSize;

  /// The state of the puzzle.
  final PuzzleState state;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final timer = context.select((TimerBloc bloc) => bloc.state);
    final state = context.select((PuzzleBloc bloc) => bloc.state);

    return GestureDetector(
      onTap: timer.isRunning && state.puzzleStatus == PuzzleStatus.incomplete
          ? () => context.read<PuzzleBloc>().add(TileTapped(tile))
          : null,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.defaultColor,
            width: 4,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          child: !timer.isRunning && state.puzzleLevel != PuzzleLevel.hard
              ? ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Image.asset(
                      'images/${state.puzzleLevel.name}/${tile.value}.png'),
                )
              : Image.asset(
                  'images/${state.puzzleLevel.name}/${tile.value}.png'),
        ),
      ),
    );
  }
}

/// {@template puzzle_next_button}
/// Displays the button to go to the next puzzle.
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleStartButton extends StatelessWidget {
  /// {@macro puzzle_shuffle_button}
  const SimplePuzzleStartButton({Key? key}) : super(key: key);

  void onTap(TimerState timer, BuildContext context) {
    if (timer.isRunning) {
      context.read<TimerBloc>().add(const TimerReset());
      context.read<PuzzleBloc>().add(const PuzzleReset());
    } else {
      context.read<TimerBloc>().add(const TimerStarted());
    }
  }

  @override
  Widget build(BuildContext context) {
    final timer = context.select((TimerBloc bloc) => bloc.state);
    return PuzzleButton(
      textColor: PuzzleColors.primary0,
      backgroundColor: PuzzleColors.primary6,
      onPressed: () => onTap(timer, context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            timer.isRunning ? 'images/reset.png' : 'images/arrow_right.png',
            width: 20,
            height: 20,
          ),
          const Gap(10),
          Text(timer.isRunning
              ? context.l10n.puzzleReset
              : context.l10n.puzzleStart),
        ],
      ),
    );
  }
}

/// {@template puzzle_shuffle_button}
/// Displays the button to shuffle the puzzle.
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleShuffleButton extends StatelessWidget {
  /// {@macro puzzle_shuffle_button}
  const SimplePuzzleShuffleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timer = context.select((TimerBloc bloc) => bloc.state);
    if (timer.isRunning) {
      return PuzzleButton(
        textColor: PuzzleColors.primary0,
        backgroundColor: PuzzleColors.primary6,
        onPressed: () => context.read<PuzzleBloc>().add(const PuzzleShuffle()),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/shuffle_icon.png',
              width: 20,
              height: 20,
            ),
            const Gap(10),
            Text(context.l10n.puzzleShuffle),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

/// {@template puzzle_next_button}
/// Displays the button to go to the next puzzle.
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleNextButton extends StatelessWidget {
  /// {@macro puzzle_shuffle_button}
  const SimplePuzzleNextButton({Key? key}) : super(key: key);

  void onTap(PuzzleState puzzleState, TimerState timerState, BuildContext context) {
    if (puzzleState.puzzleLevel == PuzzleLevel.hard) {
      context.read<TimerBloc>().add(const TimerReset());
      context.read<PuzzleBloc>().add(const PuzzleReset());
    } else {
      context.read<PuzzleBloc>().add(const PuzzleNext());
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.select((PuzzleBloc bloc) => bloc.state);
    final timer = context.select((TimerBloc bloc) => bloc.state);
    return PuzzleButton(
      textColor: PuzzleColors.primary0,
      backgroundColor: PuzzleColors.primary6,
      onPressed: () => onTap(state, timer, context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            state.puzzleLevel == PuzzleLevel.hard ? 'images/reset.png' : 'images/arrow_right.png',
            width: 20,
            height: 20,
          ),
          const Gap(10),
          Text(state.puzzleLevel == PuzzleLevel.hard ? context.l10n.puzzleReset : context.l10n.puzzleNext),
        ],
      ),
    );
  }
}
