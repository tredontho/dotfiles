import XMonad

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Layout.Magnifier
import XMonad.Layout.ThreeColumns
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig
import XMonad.Util.Loggers
import XMonad.Util.Ungrab

main :: IO ()
main = xmonad
     . ewmhFullscreen
     . ewmh
     . withEasySB (statusBarProp "xmobar" (pure myXmobarPP)) defToggleStrutsKey
     $ myConfig

myWorkspaces :: [WorkspaceId]
myWorkspaces = take 10 . tail . cycle . map show $ [0..9 :: Int]

-- Rebind mod to the Super key (usually windows key between left Ctrl and Alt keys)
myModMask = mod4Mask

myConfig = def
    { layoutHook = myLayout
    , modMask = myModMask
    , terminal = "urxvt"
    , workspaces = myWorkspaces
    }
  -- `additionalKeysP`
    -- [ ("M-S-z", spawn "xscreensaver-command -lock")
    -- , ("M-C-s", unGrab *> spawn "scrot -s")
    -- ]
  `additionalKeys`
    [ ((myModMask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
    , ((myModMask .|. controlMask, xK_s), unGrab *> spawn "scrot -s")
    , ((myModMask, xK_0), windows $ W.greedyView (show 0))
    , ((myModMask .|. shiftMask, xK_0), windows $ W.shift (show 0))
    ]

myLayout = tiled ||| Mirror tiled ||| threeCol ||| Full
  where
    threeCol = magnifiercz' 1.3 $ ThreeColMid nmaster delta ratio
    tiled = Tall nmaster delta ratio
    nmaster = 1 -- Default number of windows in the master pane
    ratio = 1/2 -- Default proportion of screen occupied by master pane
    delta = 3/100 -- Percent of screen to increment by when resizing panes

myXmobarPP :: PP
myXmobarPP = def
    { ppSep = magenta " • "
    , ppTitleSanitize = xmobarStrip
    , ppCurrent = wrap " " "" . xmobarBorder "Bottom" "#8be9fd" 2
    , ppHidden = white . wrap " " ""
    , ppHiddenNoWindows = lowWhite . wrap " " ""
    , ppUrgent = red . wrap (yellow "!") (yellow "!")
    , ppOrder = \[ws, l, _, wins] -> [ws, l, wins]
    , ppExtras = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused = wrap (white "[") (white "]") . magenta . ppWindow
    formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue . ppWindow

    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30
    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""
