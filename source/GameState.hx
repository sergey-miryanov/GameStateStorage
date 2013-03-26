package ;

class GameStateHandler
{
  public var state : GameState;

  public function new (s : GameState)
  {
    state = s;
  }
}

class GameState
{
  public var figures: Array <Int>;

  public var scorePoints : Int;
  public var turnsCount : Int;


  public function new ()
  {
    scorePoints = 0;
    turnsCount = 20;
    figures = new Array ();
  }

  public function restore (_scorePoints : Int,
      _turnsCount : Int,
      _figures : Array <Int>)
  {
    scorePoints = _scorePoints;
    turnsCount = _turnsCount;
    figures = _figures;

    // init state
  }
}
