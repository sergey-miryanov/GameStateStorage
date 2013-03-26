package ;

import nme.JNI;

class InternalStorage
{
  private static var jniReadStorage : Dynamic = null;
  private static var jniWriteStorage : Dynamic = null;

  public static function readStorage () : String
  {
    if (jniReadStorage == null)
    {
      jniReadStorage = JNI.createStaticMethod ("InternalStorage", "readStorage",
          "()Ljava/lang/String;");
    }

    return jniReadStorage ();
  }

  public static function writeStorage (data : String) : Void
  {
    if (jniWriteStorage == null)
    {
      jniWriteStorage = JNI.createStaticMethod ("InternalStorage", "writeStorage",
          "(Ljava/lang/String;)V");
    }

    jniWriteStorage (data);
  }

}
