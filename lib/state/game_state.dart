import '../data/symbols.dart';

enum SpinPhase { idle, spinning, resolving, event, doubling }

enum DoubleResult { none, won, lost }

class GameState {
  final int credits;
  final int winnings;
  final int lastWin;
  final SpinPhase phase;
  final int currentLightIndex;
  final int? activeSlotId;
  final Set<int> activeSnakeSlots;
  final Set<int> winnerSlots;
  final Set<int> eventWonSlots;
  final Set<int> deactivatedSlots;
  final Map<String, int> selectedBets;
  final Map<String, int> lastBet;
  final List<GameSymbol> symbolsOnBoard;
  final String? messageSymbol;
  final String? messageTitle;
  final String? messageDetails;
  final bool showLogo;

  // Double-up state
  final bool doublingActive;
  final String? doubleHighlight; // 'left' | 'right' | null
  final String? doubleWinner;    // 'left' | 'right' | null
  final DoubleResult doubleResult;

  final bool flashCredits;

  const GameState({
    required this.credits,
    required this.winnings,
    required this.lastWin,
    required this.phase,
    required this.currentLightIndex,
    required this.activeSlotId,
    required this.activeSnakeSlots,
    required this.winnerSlots,
    required this.eventWonSlots,
    required this.deactivatedSlots,
    required this.selectedBets,
    required this.lastBet,
    required this.symbolsOnBoard,
    required this.messageSymbol,
    required this.messageTitle,
    required this.messageDetails,
    required this.showLogo,
    required this.doublingActive,
    required this.doubleHighlight,
    required this.doubleWinner,
    required this.doubleResult,
    required this.flashCredits,
  });

  factory GameState.initial({
    int credits = 100,
    required List<GameSymbol> board,
  }) {
    return GameState(
      credits: credits,
      winnings: 0,
      lastWin: 0,
      phase: SpinPhase.idle,
      currentLightIndex: 0,
      activeSlotId: null,
      activeSnakeSlots: const {},
      winnerSlots: const {},
      eventWonSlots: const {},
      deactivatedSlots: const {},
      selectedBets: const {},
      lastBet: const {},
      symbolsOnBoard: board,
      messageSymbol: null,
      messageTitle: null,
      messageDetails: null,
      showLogo: true,
      doublingActive: false,
      doubleHighlight: null,
      doubleWinner: null,
      doubleResult: DoubleResult.none,
      flashCredits: false,
    );
  }

  int get totalSelectedBet =>
      selectedBets.values.fold<int>(0, (a, b) => a + b);
  int get totalLastBet =>
      lastBet.values.fold<int>(0, (a, b) => a + b);

  bool get isBusy =>
      phase == SpinPhase.spinning ||
      phase == SpinPhase.resolving ||
      phase == SpinPhase.event ||
      phase == SpinPhase.doubling;

  bool get canDouble => winnings > 0 && !isBusy;

  GameState copyWith({
    int? credits,
    int? winnings,
    int? lastWin,
    SpinPhase? phase,
    int? currentLightIndex,
    Object? activeSlotId = _sentinel,
    Set<int>? activeSnakeSlots,
    Set<int>? winnerSlots,
    Set<int>? eventWonSlots,
    Set<int>? deactivatedSlots,
    Map<String, int>? selectedBets,
    Map<String, int>? lastBet,
    List<GameSymbol>? symbolsOnBoard,
    Object? messageSymbol = _sentinel,
    Object? messageTitle = _sentinel,
    Object? messageDetails = _sentinel,
    bool? showLogo,
    bool? doublingActive,
    Object? doubleHighlight = _sentinel,
    Object? doubleWinner = _sentinel,
    DoubleResult? doubleResult,
    bool? flashCredits,
  }) {
    return GameState(
      credits: credits ?? this.credits,
      winnings: winnings ?? this.winnings,
      lastWin: lastWin ?? this.lastWin,
      phase: phase ?? this.phase,
      currentLightIndex: currentLightIndex ?? this.currentLightIndex,
      activeSlotId: identical(activeSlotId, _sentinel)
          ? this.activeSlotId
          : activeSlotId as int?,
      activeSnakeSlots: activeSnakeSlots ?? this.activeSnakeSlots,
      winnerSlots: winnerSlots ?? this.winnerSlots,
      eventWonSlots: eventWonSlots ?? this.eventWonSlots,
      deactivatedSlots: deactivatedSlots ?? this.deactivatedSlots,
      selectedBets: selectedBets ?? this.selectedBets,
      lastBet: lastBet ?? this.lastBet,
      symbolsOnBoard: symbolsOnBoard ?? this.symbolsOnBoard,
      messageSymbol: identical(messageSymbol, _sentinel)
          ? this.messageSymbol
          : messageSymbol as String?,
      messageTitle: identical(messageTitle, _sentinel)
          ? this.messageTitle
          : messageTitle as String?,
      messageDetails: identical(messageDetails, _sentinel)
          ? this.messageDetails
          : messageDetails as String?,
      showLogo: showLogo ?? this.showLogo,
      doublingActive: doublingActive ?? this.doublingActive,
      doubleHighlight: identical(doubleHighlight, _sentinel)
          ? this.doubleHighlight
          : doubleHighlight as String?,
      doubleWinner: identical(doubleWinner, _sentinel)
          ? this.doubleWinner
          : doubleWinner as String?,
      doubleResult: doubleResult ?? this.doubleResult,
      flashCredits: flashCredits ?? this.flashCredits,
    );
  }
}

const _sentinel = Object();
