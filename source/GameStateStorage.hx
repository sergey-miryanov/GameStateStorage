package ;

import haxe.Json;
import nme.net.SharedObject;

#if cpp
import sys.io.File;
import sys.io.FileOutput;
import haxe.io.Bytes;
#end

using StringTools;

import GameState;

class GameStateStorage
{
  public static function isValidState () : Bool
  {
    return isValidStateImpl ();
  }
  public static function readState () : GameStateHandler
  {
    var data : Dynamic = readStateImpl ();
    if (data != null)
    {
      var state : GameState = new GameState ();
      state.restore(data.state.scorePoints,
          data.state.turnsCount,
          data.state.figures);

      var stateHandler : GameStateHandler = new GameStateHandler (state);
      if (data.version >= 2)
      {
        // handle next version;
      }

      return stateHandler;
    }

    return null;
  }

  public static function writeState (stateHandler : GameStateHandler) : Void
  {
    var state = {
      scorePoints : stateHandler.state.scorePoints,
      turnsCount : stateHandler.state.turnsCount,
      figures : stateHandler.state.figures,
    };
    var data = {
      version : 2,
      state : state,
    };

    writeStateImpl (data);
  }

  public static function clearState () : Void
  {
    clearStateImpl ();
  }

#if android
  public static function isValidStateImpl () : Bool
  {
    try
    {
      var dump : String = InternalStorage.readStorage ();
      if (dump.trim ().length == 0)
        return false;

      var data = Json.parse (dump);
      return Reflect.hasField (data, "version");
    }
    catch (u : Dynamic)
    {
      return false;
    }
  }
  public static function readStateImpl () : Dynamic
  {
    try
    {
      var dump : String = InternalStorage.readStorage ();
      if (dump.trim ().length == 0)
        return null;

      return Json.parse (dump);
    }
    catch (unknown : Dynamic)
    {
      return null;
    }
  }
  public static function writeStateImpl (data : Dynamic)
  {
    var dump : String = Json.stringify (data);
    InternalStorage.writeStorage (dump);
  }
  public static function clearStateImpl ()
  {
    InternalStorage.writeStorage ("");
  }
#else
#if cpp
  public static function isValidStateImpl () : Bool
  {
    try
    {
      var dump : String = File.getContent (".temp.data");
      if (dump.trim ().length == 0)
        return false;

      var data = Json.parse (dump);
      return Reflect.hasField (data, "version");
    }
    catch (u : Dynamic)
    {
      return false;
    }
  }
  public static function readStateImpl () : Dynamic
  {
    try
    {
      var dump : String = File.getContent (".temp.data");
      if (dump.trim ().length == 0)
        return null;

      return Json.parse (dump);
    }
    catch (u : Dynamic)
    {
      return null;
    }
  }
  public static function writeStateImpl (data : Dynamic) : Void
  {
    try
    {
      var dump : String = Json.stringify (data);
      writeData (".temp.data", dump);
    }
    catch (u : Dynamic)
    {
    }
  }
  public static function clearStateImpl () : Void
  {
    try
    {
      writeData (".temp.data", "");
    }
    catch (u : Dynamic)
    {
    }
  }

  private static function writeData (filename : String, data : String) : Void
  {
    var f : FileOutput = File.write (filename);
    var b = Bytes.ofString (data);

    f.writeBytes (b, 0, b.length);
    f.flush ();
    f.close ();
  }
#end
#end

#if flash
  public static function isValidStateImpl () : Bool
  {
    try
    {
      var shared : SharedObject = SharedObject.getLocal ("temp.data");
      return Reflect.hasField (shared.data, "version");
    }
    catch (u : Dynamic)
    {
      return false;
    }
  }
  public static function readStateImpl () : Dynamic
  {
    try
    {
      var shared : SharedObject = SharedObject.getLocal ("temp.data");
      if (Reflect.hasField (shared.data, "version"))
      {
        return shared.data;
      }

      return null;
    }
    catch (unknown : Dynamic)
    {
      return null;
    }
  }
  public static function writeStateImpl (data : Dynamic) : Void
  {
    try
    {
      var shared : SharedObject = SharedObject.getLocal ("temp.data");
      shared.data.version = data.version;
      shared.data.state = data.state;

      shared.flush (); // maybe don't flash
    }
    catch (unknown : Dynamic)
    {
    }
  }
  public static function clearStateImpl () : Void
  {
    var shared : SharedObject = SharedObject.getLocal ("temp.data");
    shared.clear ();
  }
#end
}
