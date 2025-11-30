class HomeState {
  final bool hasUnfinishedGame;

  const HomeState({
    this.hasUnfinishedGame = false,
  });

  HomeState copyWith({bool? hasUnfinishedGame}) {
    return HomeState(
      hasUnfinishedGame: hasUnfinishedGame ?? this.hasUnfinishedGame,
    );
  }
}
