module Main

import Data.Fin
import Effects
import Effect.StdIO
import Graphics.Color
import Graphics.SDL2.SDL
import Graphics.SDL2.Effect

red : Color
red = RGBA 252 141 89 255

Prog : Type -> Type -> Type
Prog i t = { [SDL i,   -- the SDL effect
              STDIO]   -- a std io effect 
           } Eff t
-- Convenient shorthand for initialised SDL
Running : Type -> Type
Running t = Prog SDLCtx t

-- -------------------------------------------------------------------------------------------------
-- Main loop
-- -------------------------------------------------------------------------------------------------

process : Maybe Event -> Bool
process (Just (KeyDown KeyEsc)) = False
process (Just (AppQuit))        = False
process _                       = True

emain : Prog () ()
emain = do putStrLn "Initialising"
           putStrLn "..."
           initialise "SDL2 Test" 640 480
           putStrLn "Initialised"
           eventLoop
           quit
        where 
          draw : Running ()
          draw = with Effects do
                      putStrLn "drawing"
                      renderClear white
                      bezier red [(10,10), (50,10), (30,50), (40, 200)] 3
                      rectangle red 100 100 300 300
                      render
                      
          eventLoop : Running ()
          eventLoop = do draw
                         when (process (!poll)) eventLoop

main : IO ()
main = runInit [(), -- initial state for the SDL2 effect (nothing needs to go in here)
                ()  -- initial state for the StdIO effect 
                ] 
       emain

