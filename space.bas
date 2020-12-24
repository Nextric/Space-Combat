10 REM SPACE COMBAT
20 REM Version 1.1 2020 By Nextric
30 RUN AT 3
40 LET h=2: REM Vidas
50 LET o=0: REM Score
60 LET x=36:y=116: REM Posicion nave
70 driverok= PEEK 64000
80 IF driverok=1 THEN .uninstall"ayfx.drv"
90 .install "ayfx.drv"
100 REM clear 63999
110 POKE 64000,1
120 DRIVER 49,1,22
130 LOAD "sound.afb" BANK 22
140 LET v=5: REM Velocidad Nave
150 LET n=1: REM Contador disparos PLayer
155 let p=1:REM NIVEL
160 REM LET s=0
170 LET t=0: REM muerte del boss
180 LET l=0: REM Muerte del player
190 LET b=10: REM Eneboss
200 LET %i=0: REM indice bucle principal
210 LET d=51: REM Sprite disparos enemigos desde el 51 hasta el 100
220 REM Cargamos sprites
225 proc cargasprites(p)
280 REM Aqui le indicamos las dimensiones de Mapa de Tiles. En este caso la pantalla completa 256x192 (16x16 y 12x16) y 256 colores
290 TILE DIM 17,0,45,16
300 REM Posicionamos x elementos en la posicion de filas y columnas definidas
310 LET g=0: REM LAYER
320 REM LET %e=0:REM PLAYER EN EXPLOSION
330 SPRITE 99,x,y,4,1
332 sprite -100,-16,,43,1:sprite continue 100,,0 to 0 run ,43 to 47
335 REM Inicializamos los sprites de disparos de enemigos que luego dan problemas
336 proc initdisparosene()
340 REM **********BLOQUE DE LOOP DE JUEGO*********
350 PROC crearmuro()
360 PROC puntos(0)
370 PROC lives(0)
380 FOR i=0 TO 20000: REM Despazamos el Layer a lo largo del TilesMap
390 IF l=1 THEN IF % SPRITE 71=0 THEN x=35:y=116: PROC mensajevidas()
400 IF l=0 THEN PROC movlayer()
410 IF l=0 THEN PROC movimiento()
420 IF i > 0 AND i < 50 THEN PROC crearene(1,6)
430 REM IF i > 100 AND i < 150 THEN PROC crearene(2,19)
440 REM IF i > 200 AND i < 250 THEN PROC crearene(3,20)
450 REM IF i > 250 AND i < 300 THEN PROC crearene(4,21)
460 PROC impactos()
470 IF i < 50 THEN PROC dispene()
480 PROC reset(): REM Tecla R para salir
490 IF i=100 THEN PROC boss()
500 IF i=100 THEN PROC movboss2()
510 IF i > 100 THEN PROC dispboss()
520 IF i > 100 THEN PROC impactosboss()
530 IF b < 0 AND t=0 THEN PROC endlevel()
540 IF % SPRITE 113=0 THEN IF t=1 THEN DRIVER 49,2,53: PRINT AT 10,10;"OLE con OLE": PAUSE 0: GO TO 2360
550 PROC impacmuro()
560 PROC impacnave()
570 REM if %sprite 71=0 and l=1 then proc mensajevidas()
580 REM print at 12,12;x
590 print at 10,10;d
600 SPRITE MOVE
610 NEXT i
620 REM ************fin bucle juego***************
630 DEFPROC movimiento(): REM RUTINA DE MOVIMIENTO
640 IF IN 64510=30 AND IN 57342=31 AND IN 65022=31 AND y > 30 THEN y=y-v: REM TECLA Q
650 IF IN 64510=31 AND IN 57342=31 AND IN 65022=30 AND y < 210 THEN y=y+v: REM TECLA A
660 IF IN 64510=31 AND IN 57342=30 AND IN 65022=31 AND x < 270 THEN x=x+v: REM TECLA P
670 IF IN 64510=31 AND IN 57342=29 AND IN 65022=31 AND x > 35 THEN x=x-v: REM TECLA O
680 IF IN 64510=30 AND IN 57342=30 AND IN 65022=31 AND y > 30 AND x < 270 THEN y=y-v:x=x+v: REM TECLA Q y P
690 IF IN 64510=30 AND IN 57342=29 AND IN 65022=31 AND y > 30 AND x > 35 THEN y=y-v:x=x-v: REM TECLA Q y O
700 IF IN 64510=31 AND IN 57342=30 AND IN 65022=30 AND y < 210 AND x < 270 THEN y=y+v:x=x+v: REM TECLA A y P
710 IF IN 64510=31 AND IN 57342=29 AND IN 65022=30 AND y < 210 AND x > 35 THEN y=y+v:x=x-v: REM TECLA A y O
720 IF IN 32766=30 THEN PROC gestshoot(): DRIVER 49,2,6,1: REM TECLA SPACE DISPARO
730 SPRITE 99,x,y,4
740 ENDPROC
750 DEFPROC gestshoot(): REM Rutina de Disparo del Player
760 LOCAL z
770 IF n >= 6 THEN n=1: GO TO %810: REM Mantenemos un cache de 6 disparos en pantalla
780 IF n < 6 AND n > 0 THEN SPRITE n,x,y,5,1
790 IF n < 6 AND n > 0 THEN SPRITE CONTINUE n,x TO 280 STEP 5 RUN ,,5, BIN 00000011
800 n=n+1
810 ENDPROC
820 DEFPROC impactos(): REM rutina impactos con los enemigos
830 LOCAL %s: LOCAL %a
840 FOR %s=1 TO 6
850 REM hay que hacero desde el 1 hasta el 6
860 %a=% SPRITE OVER (s,30 TO 50)
870 IF %a > 29 THEN SPRITE %s,,,,0: SPRITE %a+40,% SPRITE AT (a,0),% SPRITE AT (a,1),38,1: SPRITE CONTINUE %a+40,% SPRITE AT (a,0) RUN ,,38 TO 42, BIN 00100000: SPRITE %a,,,,0: DRIVER 49,2,11,2: PROC puntos(1)
880 NEXT %s
890 ENDPROC
900 DEFPROC dispene(): REM Gestion de disparos de los enemigos
910 LOCAL %r:%r=% RND 20:%r=%r+30
920 LOCAL x: LOCAL y
930 x=% SPRITE AT (r,0):y=% SPRITE AT (r,1)
940 IF d>=65 THEN d=51
950 IF % SPRITE r=1 THEN SPRITE d,x,y,5,1: SPRITE CONTINUE d,0 TO y STEP -10 RUN ,,5, BIN 11: DRIVER 49,2,12:d=d+1
960 ENDPROC
970 DEFPROC mov1(%s,s)
980 LOCAL x
990 x=% SPRITE AT (s,0)
1000 SPRITE CONTINUE %s,0 TO x STEP -5 RUN ,,s, BIN 11
1010 ENDPROC
1020 DEFPROC mov2(%s,s)
1030 LOCAL x: LOCAL y
1040 x=% SPRITE AT (s,0):y=% SPRITE AT (s,1)
1050 SPRITE CONTINUE %s,0 TO x STEP -5 RUN ,y TO y+10 STEP 1 RUN ,s, BIN 001001
1060 REM SPRITE s,,,,1
1070 ENDPROC
1080 DEFPROC movlayer(): REM Gestion del movimiento del layer
1090 TILE 16,12
1100 LAYER AT g,0
1110 IF g > 254.99 THEN g=0
1120 g=g+1
1130 ENDPROC
1140 DEFPROC crearene(m,s): REM Gestion la creacion de enemigos
1150 LOCAL x: LOCAL showene
1160 IF PEEK 23672 > 70 AND PEEK 23672 < 110 THEN PROC buscahueco() TO x:showene=x: IF showene <> 0 THEN SPRITE showene,256,30+ RND *180,s,1: IF m=1 THEN PROC mov1(showene,s): ELSE IF m=2 THEN PROC mov2(showene,s): ELSE IF m=3 THEN PROC mov3(showene,s): ELSE IF m=4 THEN PROC mov4(showene,s)
1170 ENDPROC
1180 DEFPROC buscahueco(): REM Gestion de sprites para enemigos sin usar bucle para no penalizar
1190 LET %f=30
1200 LOCAL x:x=0
1210 IF % SPRITE f=0 THEN x=%f: GO TO %1250:
1220 %f=%f+1
1230 IF %f=50 THEN GO TO %1250
1240 GO TO %1210
1250 ENDPROC =x
1260 DEFPROC impacnave(): REM Gestion del impacto con el Player
1270 LOCAL %s:%s=% SPRITE OVER (99,30 TO 65,0,7)
1280 LOCAL x: LOCAL y
1290 x=% SPRITE AT (99,0):y=% SPRITE AT (99,1)
1300 IF %s > 0 THEN DRIVER 49,2,18: SPRITE %s,,,,0: SPRITE 71,x,y,38, BIN 00000001: SPRITE 99,,,,0: SPRITE CONTINUE 71,x RUN ,y RUN ,31 TO 41, BIN 00100000,1: PROC lives(1): FOR %s=30 TO 65: SPRITE %s,,,,0: NEXT %s: FOR %s=1 TO 6: SPRITE %s,,,,0: NEXT %s:l=1
1310 ENDPROC
1320 DEFPROC mov3(%s,s)
1330 LOCAL x: LOCAL y
1340 x=% SPRITE AT (s,0):y=% SPRITE AT (s,1)
1350 IF y < 96 THEN SPRITE CONTINUE %s,0 TO x STEP -5 RUN ,40 TO y STEP -1 RUN ,s, BIN 00000000
1360 IF y >= 96 THEN SPRITE CONTINUE %s,0 TO x STEP -5 RUN ,y TO 200 STEP 1 RUN ,s, BIN 0000000
1370 ENDPROC
1380 DEFPROC crearmuro()
1390 SPRITE 20,18,32,60,1,,,2
1400 SPRITE 21,18,96,60,1,,,3
1410 ENDPROC
1420 DEFPROC reset()
1430 IF INKEY$ ="r" THEN STOP
1440 ENDPROC
1450 DEFPROC puntos(x)
1460 o=o+x
1470 LOCAL %s:%s=o
1480 SPRITE 15,180,16,%s MOD 10+9,1
1490 %s=%s/10
1500 SPRITE 16,164,16,%s MOD 10+9,1
1510 %s=%s/10
1520 SPRITE 17,148,16,%s MOD 10+9,1
1530 %s=%s/10
1540 SPRITE 18,132,16,%s MOD 10+9,1
1550 ENDPROC
1560 DEFPROC lives(x)
1570 IF x=1 THEN h=h-x
1580 SPRITE 24,,,,0
1590 SPRITE 25,,,,0
1600 SPRITE 26,,,,0
1610 LOCAL i:i=h
1620 IF h >= 0 THEN SPRITE 24+i,20+i*16,16,8,1
1630 IF i > 0 THEN i=i-1: GO TO %1620
1640 IF x <> 0 THEN IF % SPRITE 71=0 THEN DRIVER 49,2,8: GO TO %60
1650 ENDPROC
1660 DEFPROC debugsprites()
1670 LOCAL %x: LOCAL %y: LOCAL %s
1680 %x=0:%y=10:%s=0
1690 IF %s < 128 THEN PRINT AT %x,%y;% SPRITE s
1700 %y=%y+2:%s=%s+1
1710 IF %y < 32 THEN GO TO %1690
1720 %y=10:%x=%x+2
1730 IF %x < 24 THEN GO TO %1690
1740 ENDPROC
1750 DEFPROC boss()
1760 SPRITE 113,218,80,29,1
1770 SPRITE -114,16,0,30,1
1780 SPRITE -115,32,0,33,1
1790 SPRITE -116,48,0,36,1
1800 SPRITE -117,16,-16,31,1
1810 SPRITE -118,32,16,32,1
1820 SPRITE -119,32,-16,35,1
1830 SPRITE -120,16,16,28,1
1840 SPRITE -121,48,-16,37,1
1850 SPRITE -122,48,16,34,1
1860 PROC barraene(0)
1870 PROC movboss()
1880 ENDPROC
1890 DEFPROC movboss()
1900 SPRITE CONTINUE 113,160 TO 218 STEP -2 RUN ,,29
1910 ENDPROC
1920 DEFPROC movboss2()
1930 SPRITE CONTINUE 113,160 TO 218 STEP -6 STOP ,80 TO 140 STEP 1 RUN ,29
1940 ENDPROC
1950 DEFPROC dispboss(): REM Gestion de disparos del boss
1960 LOCAL %r:%r=% RND 9:%r=%r+113
1961 LOCAL x: LOCAL y
1962 x=% SPRITE AT (r,0):y=% SPRITE AT (r,1)
1970 IF d=65 THEN d=51
1980 IF % RND 10 > 5 THEN SPRITE d,x,y,5,1: SPRITE CONTINUE d,0 TO x STEP -10 RUN ,,5, BIN 11: DRIVER 49,2,34:d=d+1
1990 ENDPROC
2000 DEFPROC impactosboss(): REM rutina impactos con el Boss
2010 LOCAL %s: REM LOCAL %a
2020 FOR %s=1 TO 6
2030 %a=% SPRITE OVER (s,113 TO 122)
2040 IF %a > 0 THEN SPRITE %s,,,,0: SPRITE %a-43,% SPRITE AT (a,0),% SPRITE AT (a,1),38,1: SPRITE CONTINUE %a-43,% SPRITE AT (a,0)-8 RUN ,,40 TO 42, BIN 00100000: DRIVER 49,2,3: PROC puntos(1): PROC barraene(1)
2050 NEXT %s
2060 ENDPROC
2070 DEFPROC barraene(x)
2080    b=b-x
2090    LOCAL %q:%q=b/10
2100    IF %q > 0 THEN SPRITE 10,220,15,24,1: ELSE SPRITE 10,,,,0
2110    IF %q > 1 THEN SPRITE 11,220+16,15,25,1: ELSE SPRITE 11,,,,0
2120    IF %q > 2 THEN SPRITE 12,220+32,15,25,1: ELSE SPRITE 12,,,,0
2130    IF %q > 3 THEN SPRITE 13,220+48,15,25,1: ELSE SPRITE 13,,,,0
2140    IF %q > 4 THEN SPRITE 14,220+64,15,25,1: ELSE SPRITE 14,,,,0
2150 ENDPROC
2160 DEFPROC endlevel()
2170    REM b=-1: REM BOss Kaput
2180    LOCAL x: LOCAL y: LOCAL t1: LOCAL t2
2190    x=% SPRITE AT (113,0):y=% SPRITE AT (113,1): LAYER AT 0,0: LAYER OVER BIN 001: PRINT AT 10,2;"WELL DONE! LEVEL COMPLETE!"
2200    SPRITE 113,,,38,,,2,2: SPRITE CONTINUE 113,,y TO y-1 RUN ,38 TO 42, BIN 00100000 : DRIVER 49,2,18: DRIVER 49,2,18
2210    t=1
2220    LAYER OVER BIN 000
2230 ENDPROC
2240 DEFPROC mov4(%s,s)
2250    LOCAL x: LOCAL y
2260    x=% SPRITE AT (s,0):y=% SPRITE AT (s,1)
2270    SPRITE CONTINUE %s,0 TO x STEP -2 RUN ,y TO y+20 STEP 3 RUN ,s, BIN 01000000
2280 ENDPROC
2290 DEFPROC impacmuro()
2300    LOCAL %i: LOCAL %u
2310        FOR %u=20 TO 21
2320            %i=% SPRITE OVER (u,30 TO 65)
2330            IF %i > 29 THEN SPRITE %i,,,, BIN 0000000
2340        NEXT %u
2350 ENDPROC
2360 DEFPROC mensajevidas()
2370    LOCAL x: LOCAL t1: LOCAL t2
2380    t1=(65536* PEEK 23674+256* PEEK 23673+ PEEK 23672)/50
2390        REPEAT
2400        t2=(65536* PEEK 23674+256* PEEK 23673+ PEEK 23672)/50
2410        IF h >= 0 THEN LAYER AT 0,0: LAYER OVER BIN 001: PRINT AT 10,6;"YOU HAVE LOST A LIFE"
2420        IF h < 0 THEN LAYER OVER BIN 001: PRINT AT 10,10;"GAME OVER"
2430        REPEAT UNTIL t2-t1 > 5
2440    l=0: SPRITE 99,35,116,,1: LAYER OVER BIN 000
2450 ENDPROC
2500 defproc cargasprites(p)
2510 LOAD "space.spr" BANK 16,0,12288: REM OJO SI AÑADIMOS MAS SPRITES!!!
2520 REM Ponemos el modo Layer2 para usar los Tiles
2530 SPRITE CLEAR : LAYER 2,1: CLS : PAPER 0: INK 255: SPRITE PRINT 1: SPRITE BORDER 1: BORDER 0
2540 REM Aqui el meollo del asunto de los tiles. Cargamos el conjunto de sprites que usamos en el Mapa de Sprites/Tiles.
2545 REM Dependiendo del nivel inicializamos un Sprites u otros
2546 if p = 1 then LOAD "space.map" BANK 17: TILE BANK 16: SPRITE BANK 16
2550 if p = 2 then LOAD "space.map" BANK 17: TILE BANK 16: SPRITE BANK 16
2560 if p = 3 then LOAD "space.map" BANK 17: TILE BANK 16: SPRITE BANK 16
2600 endproc
2700 defproc initdisparosene ()
2710 local i
2720 for i=51 to 65
2730 sprite i,,,5,0
2740 next i
2750 endproc