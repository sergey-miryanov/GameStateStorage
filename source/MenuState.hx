package;

import nme.Assets;
import nme.geom.Rectangle;
import nme.net.SharedObject;
import org.flixel.FlxButton;
import org.flixel.FlxG;
import org.flixel.FlxPath;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxU;
import GameState;

class MenuState extends FlxState
{
  override public function create():Void
  {
    #if !neko
    FlxG.bgColor = 0xff131c1b;
    #else
    FlxG.camera.bgColor = {rgb: 0x131c1b, a: 0xff};
    #end    
    FlxG.mouse.show();

    var stateHandler = new GameStateHandler(new GameState());
    if (GameStateStorage.isValidState())
    {
      stateHandler = GameStateStorage.readState();
    }

    add(new FlxText(10, 10, 200, Std.string(stateHandler.state.scorePoints)));

    stateHandler.state.scorePoints += 10;

    GameStateStorage.writeState(stateHandler);
  }
  
  override public function destroy():Void
  {
    super.destroy();
  }

  override public function update():Void
  {
    super.update();
  } 
}
