/*-
  Author Brian Tiffin
  Dedicated to the public domain

  Date started: February 2017
  Modified: 2017-02-24/04:23-0500 btiffin

  Tectonics:
      export CLASSPATH=...
      scalac JnaCob.scala
      cobc -debug -m -fimplicit-init libcobjna.cob
      LD_LIBRARY_PATH=. scala JnaCob Testing
+*/

import com.sun.jna.{Library, Native, Platform}

trait CobLibrary extends Library {
    def cob_init(argc: Int, argv: Array[String]): Void
    def cob_tidy(): Int
    def cobjna(s: String): Int
    def puts(s: String): Int
}

object CobLibrary {
    def Instance = Native.loadLibrary("cobjna",
        classOf[CobLibrary]).asInstanceOf[CobLibrary]
}

object JnaCob {
    def main(args: Array[String]) {

        /* Initialize libcob */
        /* Could pass the current args array, but this makes one up */
        CobLibrary.Instance.cob_init(4, 
            Array("JnaCob", "argv", "from", "Scala"))

        /* Call GnuCOBOL subprogram with a string */
        
        var rc: Int = CobLibrary.Instance.cobjna("Scala calling GnuCOBOL")
        println("RETURN-CODE from GnuCOBOL = " + rc)

        /* rundown libcob */
        CobLibrary.Instance.cob_tidy()

        /* Display arguments passed to scala using C puts */
        for ((arg, i) <- args.zipWithIndex) {
            CobLibrary.Instance.puts(
                "Argument %d: %s".format(i.asInstanceOf[AnyRef], arg))
        }

        println()
        /* Call GnuCOBOL again, with reinit because of previous cob_tidy */
        CobLibrary.Instance.cob_init(5, 
            Array("JnaCob", "argv", "from", "Scala", "a second time"))

        /* Call GnuCOBOL subprogram with a string */
        
        rc = CobLibrary.Instance.cobjna("Call GnuCOBOL again")
        println("RETURN-CODE from GnuCOBOL = " + rc)

        /* rundown libcob */
        CobLibrary.Instance.cob_tidy()
    }
}
