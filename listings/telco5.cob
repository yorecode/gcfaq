Update
      *>
      *> By Roger While, used with permission
      *>
       IDENTIFICATION DIVISION.
       PROGRAM-ID. telco5.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INFILE   ASSIGN TO
                "expon180.1e6"
                .
           SELECT OUTFILE  ASSIGN TO
                "TELCO.TXT"
                LINE SEQUENTIAL
                .
       DATA DIVISION.
       FILE SECTION.
       FD  INFILE.
       01  INREC            PIC S9(15)      PACKED-DECIMAL.
       01  INREC2.
           05               PIC  X(7).
           05               PIC  X.
             88  PREMIMUM-RATE
                    VALUES X"1C" X"3C" X"5C" X"7C" X"9C".
       FD  OUTFILE.
       01  OUTREC           PIC X(70).
       WORKING-STORAGE SECTION.
       01  DO-CALC          PIC X            VALUE "Y".
           88  NO-CALC                       VALUE "N".

       01  START-TIME       PIC X(21).
       01  END-TIME         PIC X(21).

       01  PRICE-TOT        PIC S9(07)V99    COMP-5.
       01  BTAX-TOT         PIC S9(07)V99    COMP-5.
       01  DTAX-TOT         PIC S9(07)V99    COMP-5.
       01  OUTPUT-TOT       PIC S9(07)V99    COMP-5.

       01  TEMP-PRICE       PIC S9(07)V99    COMP-5.
       01  TEMP-BTAX        PIC S9(07)V99    COMP-5.
       01  TEMP-DTAX        PIC S9(07)V99    COMP-5.

       01  HEADER-1         PIC X(70)       VALUE
           "  Time  Rate |        Price         Btax         Dtax | "
           &   "      Output".
       01  HEADER-2         PIC X(70)       VALUE
           "-------------+----------------------------------------+-"
           &   "------------".
       01  DETAIL-LINE.
           10               PIC X(01)         VALUE SPACE.
           10  NUMB-OUT     PIC ZZZZ9.
           10               PIC X(04)         VALUE SPACE.
           10  RATE-OUT     PIC X.
           10               PIC X(04)         VALUE "  | ".
           10  PRICE-OUT    PIC Z,ZZZ,ZZ9.99.
           10               PIC X(01)         VALUE SPACES.
           10  BTAX-OUT     PIC Z,ZZZ,ZZ9.99.
           10               PIC X(01)         VALUE SPACES.
           10  DTAX-OUT     PIC Z,ZZZ,ZZ9.99  BLANK WHEN ZERO.
           10               PIC X(03)         VALUE " | ".
           10  OUTPUT-OUT   PIC Z,ZZZ,ZZ9.99.
       PROCEDURE DIVISION.
       MAINLINE.
           OPEN INPUT  INFILE
                OUTPUT OUTFILE
           WRITE OUTREC FROM HEADER-1
           END-WRITE
           WRITE OUTREC FROM HEADER-2
           END-WRITE
           DISPLAY "Enter 'N' to skip calculations:" UPON CONSOLE
           END-DISPLAY
           ACCEPT DO-CALC FROM CONSOLE
           END-ACCEPT
       *>  Start timer
           MOVE FUNCTION CURRENT-DATE   TO START-TIME
       *>  Start loop
       *>  PERFORM UNTIL EXIT, changed to 0 = 1 for older compilers
           PERFORM UNTIL 0 = 1
               READ  INFILE AT END
                     EXIT PERFORM
               END-READ
               IF NOT NO-CALC
                   MOVE INREC   TO NUMB-OUT
                   IF PREMIMUM-RATE
                       MOVE "D"         TO RATE-OUT
                       COMPUTE TEMP-PRICE ROUNDED MODE NEAREST-EVEN
                                = INREC * 0.00894
                       END-COMPUTE
                       COMPUTE TEMP-DTAX
                                = TEMP-PRICE * 0.0341
                       END-COMPUTE
                       ADD TEMP-DTAX TO DTAX-TOT
                       END-ADD
                       MOVE TEMP-DTAX TO DTAX-OUT
                   ELSE
                       MOVE "L"         TO RATE-OUT
                       COMPUTE TEMP-PRICE ROUNDED MODE NEAREST-EVEN
                                = INREC * 0.00130
                       END-COMPUTE
                       MOVE ZERO TO TEMP-DTAX
                       MOVE ZERO TO DTAX-OUT
                   END-IF
                   MOVE TEMP-PRICE TO PRICE-OUT
                   COMPUTE TEMP-BTAX BTAX-OUT
                                = TEMP-PRICE * 0.0675
                   END-COMPUTE
                   ADD TEMP-PRICE TEMP-BTAX TEMP-DTAX TO OUTPUT-TOT
                   END-ADD
                   ADD TEMP-PRICE TEMP-BTAX TEMP-DTAX GIVING OUTPUT-OUT
                   END-ADD
                   ADD TEMP-BTAX        TO BTAX-TOT
                   END-ADD
                   ADD TEMP-PRICE       TO PRICE-TOT
                   END-ADD
               END-IF
               WRITE OUTREC FROM DETAIL-LINE
               END-WRITE
           END-PERFORM
       *>  End loop
       *>  End timer
           MOVE FUNCTION CURRENT-DATE TO END-TIME
           WRITE OUTREC         FROM HEADER-2
           END-WRITE
           MOVE PRICE-TOT       TO PRICE-OUT
           MOVE BTAX-TOT        TO BTAX-OUT
           MOVE DTAX-TOT        TO DTAX-OUT
           MOVE OUTPUT-TOT      TO OUTPUT-OUT
           MOVE "   Totals:"    TO DETAIL-LINE (1:12)
           WRITE OUTREC         FROM DETAIL-LINE
           END-WRITE
           MOVE SPACES          TO OUTREC
           STRING       "  Start-Time:"         DELIMITED BY SIZE
                        START-TIME (9:2)        DELIMITED BY SIZE
                        ":"                     DELIMITED BY SIZE
                        START-TIME (11:2)       DELIMITED BY SIZE
                        ":"                     DELIMITED BY SIZE
                        START-TIME (13:2)       DELIMITED BY SIZE
                        "."                     DELIMITED BY SIZE
                        START-TIME (15:2)       DELIMITED BY SIZE
                INTO OUTREC
           END-STRING
           WRITE OUTREC
           END-WRITE
           MOVE SPACES          TO OUTREC
           STRING       "    End-Time:"         DELIMITED BY SIZE
                        END-TIME (9:2)          DELIMITED BY SIZE
                        ":"                     DELIMITED BY SIZE
                        END-TIME (11:2)         DELIMITED BY SIZE
                        ":"                     DELIMITED BY SIZE
                        END-TIME (13:2)         DELIMITED BY SIZE
                        "."                     DELIMITED BY SIZE
                        END-TIME (15:2)         DELIMITED BY SIZE
                INTO OUTREC
           END-STRING
           WRITE OUTREC
           END-WRITE
           CLOSE INFILE
                 OUTFILE
           STOP RUN
           .
