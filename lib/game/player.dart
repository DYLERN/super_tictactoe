enum Player {
  X,
  O;

  Player get nextPlayer => switch (this) {
        Player.X => Player.O,
        Player.O => Player.X,
      };
}
