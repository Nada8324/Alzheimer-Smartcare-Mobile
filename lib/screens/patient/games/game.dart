import 'dart:async';
import 'dart:math';
import 'package:card_game/card_game.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/custom_widgets/custom_text.dart';
import 'controller.dart';

class MemoryMatchState {
  final List<SuitedCard> cardLayout;
  final List<SuitedCard> selectedCards;
  final List<SuitedCard> completedCards;
  final int attemptedMatches;

  const MemoryMatchState({
    required this.cardLayout,
    required this.selectedCards,
    required this.completedCards,
    required this.attemptedMatches,
  });

  static MemoryMatchState get initialState {
    final deck = List<SuitedCard>.from(SuitedCard.deck);
    deck.shuffle();
    return MemoryMatchState(
      cardLayout: deck,
      selectedCards: [],
      completedCards: [],
      attemptedMatches: 0,
    );
  }

  MemoryMatchState withSelection(SuitedCard card) {
    return MemoryMatchState(
      cardLayout: cardLayout,
      selectedCards: selectedCards + [card],
      completedCards: completedCards,
      attemptedMatches: attemptedMatches,
    );
  }

  bool get canSelect =>
      completedCards.length < cardLayout.length && selectedCards.length < 2;

  MemoryMatchState withClearSelectionAndMaybeComplete() {
    final completed = selectedCards[0].value == selectedCards[1].value;
    return MemoryMatchState(
      cardLayout: cardLayout,
      selectedCards: [],
      completedCards: [
        ...completedCards,
        if (completed) ...selectedCards,
      ],
      attemptedMatches: attemptedMatches + 1,
    );
  }
}

class MemoryMatch extends HookWidget {
  final MemoryMatchState initialState;

  static MemoryMatchState? savedState;

  MemoryMatch({Key? key, MemoryMatchState? initialState})
      : initialState = initialState ?? MemoryMatchState.initialState,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useState<MemoryMatchState>(initialState);
    final showFinishedOverlay = useState<bool>(false);
    final hasNavigated = useState<bool>(false);

    // Track mounted state and timer
    final isMounted = useRef(true);
    final timerRef = useRef<Timer?>(null);

    useEffect(() {
      return () {
        isMounted.value = false;
        timerRef.value?.cancel();
      };
    }, []);

    useEffect(() {
      if (!hasNavigated.value &&
          state.value.completedCards.length == state.value.cardLayout.length) {
        hasNavigated.value = true;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!isMounted.value) return;

          final controller = Get.find<PatientGameController>();
          controller.updateHighScore(state.value.attemptedMatches);
          showFinishedOverlay.value = true;

          timerRef.value = Timer(const Duration(seconds: 3), () {
            if (isMounted.value) {
              MemoryMatch.savedState = null;
              Get.back();
            }
          });
        });
      }
      return null;
    }, [state.value.completedCards]);

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(
          constraints.maxWidth - MediaQuery.paddingOf(context).horizontal,
          constraints.maxHeight - MediaQuery.paddingOf(context).vertical,
        );

        final totalCardWidth = 6 * 64;
        final totalCardHeight = 9 * 89;
        final totalHorizontalPadding = (6 - 1) * 4;
        final totalVerticalPadding = (9 - 1) * 4;
        final widthMultiplier =
            (size.width - totalHorizontalPadding) / totalCardWidth;
        final heightMultiplier =
            (size.height - totalVerticalPadding) / totalCardHeight;
        final cardRatio = min(widthMultiplier, heightMultiplier);

        return Stack(
          children: [
            CardGame<SuitedCard, dynamic>(
              style: deckCardStyle(sizeMultiplier: cardRatio),
              children: [
                SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: state.value.cardLayout
                        .slices(6)
                        .mapIndexed(
                          (rowNum, row) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ...row.mapIndexed(
                                (colNum, card) => CardDeck<SuitedCard, dynamic>(
                              value: card,
                              values: state.value.completedCards.contains(card)
                                  ? []
                                  : [card],
                              isCardFlipped: (_, __) =>
                              !state.value.selectedCards.contains(card),
                              canGrab: false,
                              onCardPressed: (value) async {
                                if (state.value.canSelect &&
                                    !state.value.selectedCards.contains(value)) {
                                  state.value = state.value.withSelection(value);
                                  MemoryMatch.savedState = state.value;
                                  if (!state.value.canSelect) {
                                    await Future.delayed(
                                        const Duration(milliseconds: 800));
                                    state.value = state.value.withClearSelectionAndMaybeComplete();
                                    MemoryMatch.savedState = state.value;
                                  }
                                }
                              },
                            ),
                          ),
                          if (rowNum ==
                              state.value.cardLayout.length ~/ 6) ...[
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppText(
                                    state.value.attemptedMatches.toString(),
                                  ),
                                  AppText('matches'.tr,)
                                ],
                              ),
                            ),
                            CardDeck<SuitedCard, dynamic>(
                              value: 'completed',
                              values: state.value.completedCards,
                            ),
                          ],
                        ],
                      ),
                    )
                        .toList(),
                  ),
                ),
              ],
            ),
            if (showFinishedOverlay.value)
              Container(
                color: AppColors.black.withValues(alpha: 0.7),
                child: Center(
                  child: AppText(
                    "Game Finished".tr,
                    color: AppColors.white,
                    fontSize: 48.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}