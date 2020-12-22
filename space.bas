10 REM SPACE COMBAT
20 REM Version 1.1 2020 By Nextric
30 RUN AT 3
50 LET vidas=2
60 LET score=0
80 LET x=60:y=81: REM Posicion nave

90 driverok= PEEK 64000
100 IF driverok=1 THEN .uninstall"ayfx.drv"
110 .install "ayfx.drv"
115 rem clear 63999
120 POKE 64000,1
130 DRIVER 49,1,22
140 LOAD "sound.afb" BANK 22
150 LET v=5: REM Velocidad Nave
160 LET n=1
170 LET s=0
175 LET bossdie=0
178 LET l=0:rem Muerte del player
180 LET eneboss=10
190 LET %i=0
200 LET d=51: REM Sprite disparos enemigos desde el 51 hasta el 100
210 REM Cargamos sprites
220 LOAD "space.spr" BANK 16,0,11008
230 REM Ponemos el modo Layer2 para usar los Tiles
240 SPRITE CLEAR : LAYER 2,1: CLS : PAPER 0: INK 255: SPRITE PRINT 1: SPRITE BORDER 1: BORDER 0
250 REM Aqui el meollo del asunto de los tiles. Cargamos el conjunto de sprites que usamos en el Mapa de Sprites/Tiles.
260 LOAD "space.map" BANK 17: TILE BANK 16: SPRITE BANK 16
270 REM Aqui le indicamos las dimensiones de Mapa de Tiles. En este caso la pantalla completa 256x192 (16x16 y 12x16) y 256 colores
280 TILE DIM 17,0,45,16
290 REM Posicionamos x elementos en la posicion de filas y columnas definidas
300 LET g=0: REM LAYER
301 LET %e=0:REM PLAYER EN EXPLOSION
310 SPRITE 99,x,y,4,1

320 REM **********BLOQUE DE LOOP DE JUEGO*********
330 PROC crearmuro()
340 PROC puntos(0)
350 PROC lives(0)
360 FOR i=0 TO 20000: REM Despazamos el Layer a lo largo del TilesMap
361 if l=1 then if % sprite 71=0 then proc mensajevidas()
390 if %sprite 71=0 then proc movlayer()
400 if %sprite 71=0 then PROC movimiento()
410 IF i > 0 AND i < 50 THEN PROC crearene(1,6)
412 IF i > 100 AND i < 150 THEN PROC crearene(2,19)
413 IF i > 200 AND i < 250 THEN PROC crearene(3,20)
416 IF i > 250 AND i < 300 THEN PROC crearene(4,21)
430 PROC impactos()
440 IF i < 300 THEN PROC dispene()
450 PROC reset()
460 IF i=310 THEN PROC boss()
470 IF i=310 THEN PROC movboss2()
480 IF i > 310 THEN PROC dispboss()
490 IF i > 310 THEN PROC impactosboss()
500 IF eneboss < 0 AND bossdie=0 THEN PROC endlevel()
510 IF % SPRITE 113=0 THEN IF bossdie=1 THEN DRIVER 49,2,53: PRINT AT 10,10;"OLE con OLE": PAUSE 0: GO TO 8000
515 PROC impacmuro()
516 proc impacnave()
517 rem if %sprite 71=0 and l=1 then proc mensajevidas()
518 rem print at 12,12;l
519 rem print at 10,10;%sprite 71
525 SPRITE MOVE
530 NEXT i
540 REM ************fin bucle juego***************
550 DEFPROC movimiento(): REM RUTINA DE MOVIMIENTO
560 IF IN 64510=30 AND IN 57342=31 AND IN 65022=31 AND y > 30 THEN y=y-v: REM TECLA Q
570 IF IN 64510=31 AND IN 57342=31 AND IN 65022=30 AND y < 210 THEN y=y+v: REM TECLA A
580 IF IN 64510=31 AND IN 57342=30 AND IN 65022=31 AND x < 270 THEN x=x+v: REM TECLA P
590 IF IN 64510=31 AND IN 57342=29 AND IN 65022=31 AND x > 35 THEN x=x-v: REM TECLA O
600 IF IN 64510=30 AND IN 57342=30 AND IN 65022=31 AND y > 30 AND x < 270 THEN y=y-v:x=x+v: REM TECLA Q y P
610 IF IN 64510=30 AND IN 57342=29 AND IN 65022=31 AND y > 30 AND x > 35 THEN y=y-v:x=x-v: REM TECLA Q y O
620 IF IN 64510=31 AND IN 57342=30 AND IN 65022=30 AND y < 210 AND x < 270 THEN y=y+v:x=x+v: REM TECLA A y P
630 IF IN 64510=31 AND IN 57342=29 AND IN 65022=30 AND y < 210 AND x > 35 THEN y=y+v:x=x-v: REM TECLA A y O
640 IF IN 32766=30 THEN PROC gestshoot(): DRIVER 49,2,6,1: REM TECLA SPACE DISPARO
650 SPRITE 99,x,y,4
660 ENDPROC
670 DEFPROC gestshoot(): REM Rutina de Disparo del Player
680 LOCAL z
690 IF n >= 6 THEN n=1: GO TO %730: REM Mantenemos un cache de 6 disparos en pantalla
700 IF n < 6 AND n > 0 THEN SPRITE n,x,y,5,1
710 IF n < 6 AND n > 0 THEN SPRITE CONTINUE n,x TO 280 STEP 5 RUN ,,5, BIN 00000011
720 n=n+1
730 ENDPROC
740 DEFPROC impactos(): REM rutina impactos con los enemigos
750 LOCAL %s: LOCAL %a
760 FOR %s=1 TO 6
770 REM hay que hacero desde el 1 hasta el 6
780 %a=% SPRITE OVER (s,30 TO 50)
790 IF %a > 29 THEN SPRITE %s,,,,0: SPRITE %a+40,% SPRITE AT (a,0),% SPRITE AT (a,1),38,1: SPRITE CONTINUE %a+40,% SPRITE AT (a,0) RUN ,,38 TO 42, BIN 00100000: SPRITE %a,,,,0: DRIVER 49,2,11,2: PROC puntos(1)
800 NEXT %s
810 ENDPROC
820 DEFPROC dispene(): REM Gestion de disparos de los enemigos
830 LOCAL %r:%r=% RND 20:%r=%r+30
831 LOCAL x: LOCAL y
832 x=% SPRITE AT (r,0):y=% SPRITE AT (r,1)
840 IF d=65 THEN d=51
850 IF % SPRITE r=1 THEN SPRITE d,x,y,5,1: SPRITE CONTINUE d,0 TO y STEP -10 RUN ,,5, BIN 11: DRIVER 49,2,12:d=d+1
860 ENDPROC
870 DEFPROC mov1(%s,s)
871 LOCAL x
872 x=% SPRITE AT (s,0)
880 SPRITE CONTINUE %s,0 TO x STEP -5 RUN ,,s, BIN 11
890 ENDPROC
900 DEFPROC mov2(%s,s)
901 LOCAL x: LOCAL y
902 x=% SPRITE AT (s,0):y=% SPRITE AT (s,1)
910 SPRITE CONTINUE %s,0 TO x STEP -5 RUN ,y TO y+10 STEP 1 RUN ,s, BIN 001001
920 REM SPRITE s,,,,1
930 ENDPROC
940 DEFPROC movlayer(): REM Gestion del movimiento del layer
950 TILE 16,12
960 LAYER AT g,0
970 IF g > 254.99 THEN g=0
980 g=g+1
990 ENDPROC
1000 DEFPROC crearene(m,s): REM Gestion la creacion de enemigos
1010 LOCAL x: LOCAL showene
1020 IF PEEK 23672 > 70 AND PEEK 23672 < 110 THEN PROC buscahueco() TO x:showene=x: IF showene <> 0 THEN SPRITE showene,256,30+ RND *180,s,1: IF m=1 THEN PROC mov1(showene,s): ELSE IF m=2 THEN PROC mov2(showene,s): ELSE IF m=3 THEN PROC mov3(showene,s): ELSE IF m=4 THEN PROC mov4(showene,s)
1030 ENDPROC
1040 DEFPROC buscahueco(): REM Gestion de sprites para enemigos sin usar bucle para no penalizar
1050 LET %f=30
1060 LOCAL x:x=0
1070 IF % SPRITE f=0 THEN x=%f: GO TO %1110:
1080 %f=%f+1
1090 IF %f=50 THEN GO TO %1110
1100 GO TO %1070
1110 ENDPROC =x
1120 DEFPROC impacnave(): REM Gestion del impacto con el Player
1125 LOCAL %s:%s=% SPRITE OVER (99,30 TO 65,0,7)
1126 local x:local y
1127 x=%sprite at (99,0):y=%sprite at (99,1)
1130 IF %s > 0 THEN DRIVER 49,2,18: SPRITE %s,,,,0: SPRITE 71,x,y,38, BIN 00000001: SPRITE 99,,,,0: SPRITE CONTINUE 71,x run,y RUN,31 TO 41, BIN 00100000,1: PROC lives(1): FOR %s=30 TO 65: SPRITE %s,,,,0:NEXT %s:FOR %s=1 TO 6: SPRITE %s,,,,0:NEXT %s:l=1
1140 ENDPROC
1150 DEFPROC mov3(%s,s)
1151 LOCAL x: LOCAL y
1152 x=% SPRITE AT (s,0):y=% SPRITE AT (s,1)
1160 IF y < 96 THEN SPRITE CONTINUE %s,0 TO x STEP -5 RUN ,40 TO y STEP -1 RUN ,s, BIN 00000000
1170 IF y >= 96 THEN SPRITE CONTINUE %s,0 TO x STEP -5 RUN ,y TO 200 STEP 1 RUN ,s, BIN 0000000
1180 ENDPROC
1190 DEFPROC crearmuro()
1210 SPRITE 20,18,32,60,1,,,2
1220 SPRITE 21,18,96,60,1,,,3
1240 ENDPROC
1250 DEFPROC reset()
1260 IF INKEY$ ="r" THEN STOP
1270 ENDPROC
1280 DEFPROC puntos(x)
1290 score=score+x
1300 LOCAL %s:%s=score
1310 SPRITE 15,180,16,%s MOD 10+9,1
1320 %s=%s/10
1330 SPRITE 16,164,16,%s MOD 10+9,1
1340 %s=%s/10
1350 SPRITE 17,148,16,%s MOD 10+9,1
1360 %s=%s/10
1370 SPRITE 18,132,16,%s MOD 10+9,1
1380 ENDPROC
1390 DEFPROC lives(x)
1410 IF x=1 THEN vidas=vidas-x
1420 SPRITE 24,,,,0
1430 SPRITE 25,,,,0
1440 SPRITE 26,,,,0
1450 LOCAL i:i=vidas
1460 IF vidas >= 0 THEN SPRITE 24+i,20+i*16,16,8,1
1470 IF i > 0 THEN i=i-1: GO TO %1460
1480 IF x <> 0 THEN IF % SPRITE 71=0 THEN DRIVER 49,2,8: GO TO %80
1490 ENDPROC
1500 DEFPROC debugsprites()
1510 LOCAL %x: LOCAL %y: LOCAL %s
1520 %x=0:%y=10:s=0
1530 IF %s < 128 THEN PRINT AT %x,%y;% SPRITE s
1540 %y=%y+2:%s=%s+1
1550 IF %y < 32 THEN GO TO %1530
1560 %y=10:%x=%x+2
1570 IF %x < 24 THEN GO TO %1530
1580 ENDPROC
1590 DEFPROC boss()
1600 SPRITE 113,218,80,29,1
1610 SPRITE -114,16,0,30,1
1620 SPRITE -115,32,0,33,1
1625 SPRITE -116,48,0,36,1
1630 SPRITE -117,16,-16,31,1
1640 SPRITE -118,32,16,32,1
1645 SPRITE -119,32,-16,35,1
1646 SPRITE -120,16,16,28,1
1647 SPRITE -121,48,-16,37,1
1648 SPRITE -122,48,16,34,1
1650 PROC barraene(0)
1660 PROC movboss()
1670 ENDPROC
1680 DEFPROC movboss()
1690 SPRITE CONTINUE 113,160 TO 218 STEP -2 RUN ,,29
1700 ENDPROC
1710 DEFPROC movboss2()
1720 SPRITE CONTINUE 113,160 TO 218 STEP -6 STOP ,80 TO 140 STEP 1 RUN ,29
1730 ENDPROC
1740 DEFPROC dispboss(): REM Gestion de disparos del boss
1750 LOCAL %r:%r=% RND 9:%r=%r+113
1760 IF d=65 THEN d=51
1770 IF % RND 10 > 5 THEN SPRITE d,% SPRITE AT (r,0),% SPRITE AT (r,1),5,1: SPRITE CONTINUE d,0 TO % SPRITE AT (r,1) STEP -10 RUN ,,5, BIN 11: DRIVER 49,2,3,3:d=d+1
1780 ENDPROC
1790 DEFPROC impactosboss(): REM rutina impactos con los enemigos
1800 LOCAL %s: REM LOCAL %a
1810 FOR %s=1 TO 6
1820 %a=% SPRITE OVER (s,113 TO 122)
1830 IF %a > 0 THEN SPRITE %s,,,,0: SPRITE %a-43,% SPRITE AT (a,0),% SPRITE AT (a,1),38,1: SPRITE CONTINUE %a-43,% SPRITE AT (a,0)-8 RUN ,,40 TO 42, BIN 00100000: DRIVER 49,2,3,3: PROC puntos(1): PROC barraene(1)
1840 NEXT %s
1850 ENDPROC
1860 DEFPROC barraene(x)
1870 eneboss=eneboss-x
1880 LOCAL %q:%q=eneboss/10
1890 IF %q > 0 THEN SPRITE 10,220,15,24,1: ELSE SPRITE 10,,,,0
1900 IF %q > 1 THEN SPRITE 11,220+16,15,25,1: ELSE SPRITE 11,,,,0
1910 IF %q > 2 THEN SPRITE 12,220+32,15,25,1: ELSE SPRITE 12,,,,0
1920 IF %q > 3 THEN SPRITE 13,220+48,15,25,1: ELSE SPRITE 13,,,,0
1930 IF %q > 4 THEN SPRITE 14,220+64,15,25,1: ELSE SPRITE 14,,,,0
1950 ENDPROC
1960 DEFPROC endlevel()
1965 eneboss=-666: REM BOss Kaput
1966 LOCAL x: LOCAL y
1967 x=% SPRITE AT (113,0):y=% SPRITE AT (113,1)
1970 SPRITE 113,,,38,,,2,2: SPRITE CONTINUE 113,,y TO y-1 RUN ,38 TO 42, BIN 00100000 : DRIVER 49,2,18: DRIVER 49,2,18
1975 REM esperaos que explote
1976 bossdie=1
1980 ENDPROC
1990 DEFPROC mov4(%s,s)
1991 LOCAL x: LOCAL y
1992 x=% SPRITE AT (s,0):y=% SPRITE AT (s,1)
2000 SPRITE CONTINUE %s,0 TO x STEP -2 RUN ,y TO y+20 STEP 3 RUN ,s, BIN 01000000
2010 ENDPROC
2020 DEFPROC impacmuro()
2030 LOCAL %i: LOCAL %u
2040 FOR %u=20 TO 21
2050 %i=% SPRITE OVER (u,30 TO 65)
2060 IF %i > 29 THEN SPRITE %i,,,, BIN 0000000
2070 NEXT %u
2080 ENDPROC
8000 REM vuelta a empezar
8010 PAUSE 50
8020 GO TO 10
9000 defproc mensajevidas()
9010 local x:local t1:local t2
9012 IF vidas < 0 THEN PRINT AT 12,12;"GAME OVER": pause 220:goto 12000
9015 t1=(65536 * PEEK 23674 + 256 * PEEK 23673+ PEEK 23672) / 50
9120 repeat
9121 t2=(65536 * PEEK 23674 + 256 * PEEK 23673+ PEEK 23672) / 50
9122 layer at 0,0:PRINT at 10,6;"YOU HAVE LOST A LIFE"
9123 repeat until t2-t1>5
9150 l=0:sprite 99,,,,1
9500 endproc