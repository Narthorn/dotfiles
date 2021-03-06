-- xmonad config based on
-- http://github.com/vicfryzel/xmonad-config

import XMonad
import XMonad.Operations
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.LayoutHints
import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed
import XMonad.Layout.Spacing
import XMonad.Layout.ThreeColumns
import XMonad.Util.Run
import qualified XMonad.StackSet as W
import qualified Data.Map as M

import System.Exit

import Data.List
import Data.Monoid
import Data.Maybe
import Data.Function
import Control.Monad
import qualified Data.Foldable as F
--
------------------------------------------------------------------------
-- General
--

conf = docks defaultConfig {

    modMask            = mod4Mask,

    terminal           = "urxvt",

    layoutHook         = smartBorders $ avoidStruts $ (    spacing 6 $            (Tall 1 (3/100) (1/2))
                                                                       ||| Mirror (Tall 1 (3/100) (1/2))
                                                                       ||| ThreeColMid 1 (3/100) (1/3))
                                                       ||| noBorders Full,


    workspaces         = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],

    keys               = \(XConfig {modMask = modMask}) -> M.fromList $

                            [ ((modMask,               xK_t), spawn $ terminal conf)                           -- Launch terminal.
                            , ((modMask,               xK_g), spawn $ (terminal conf) ++ " -name urxvt_float") -- Launch floating terminal.
                            , ((modMask,               xK_r), spawn "exec $(dmenu_path | dmenu)")        -- Launch something using dmenu.
                            , ((modMask .|. shiftMask, xK_r), spawn "SUDO_ASKPASS=$HOME/dev/scripts/dpass exec sudo -A $(dmenu_path | dmenu)")        -- Launch something as root using dmenu.
                            , ((modMask,               xK_a), spawn "pactl load-module module-loopback latency_msec=20") -- Microphone loopback
                            , ((modMask .|. shiftMask, xK_a), spawn "pactl unload-module module-loopback") -- Disable microphone loopback
                            , ((modMask,               xK_c), spawn "chromium")
                            , ((modMask,               xK_e), spawn "pcmanfm")
                            , ((modMask,               xK_p), spawn "pavucontrol")
                            , ((modMask .|. shiftMask, xK_p), spawn "pactl set-card-profile alsa_card.usb-Native_Instruments_RigKontrol3_SN-ydag0t9x-00 off; pactl set-card-profile alsa_card.usb-Native_Instruments_RigKontrol3_SN-ydag0t9x-00 output:analog-stereo")
                            , ((modMask,               xK_m), spawn "killall mid2key; exec fluidsynth -si -r 44100 -c 1 -z 1280 -g 3 -a pulseaudio /usr/share/soundfonts/FluidR3_GM.sf2 & (sleep 1; aconnect RigKontrol3 128)") -- use piano as synth
                            , ((modMask .|. shiftMask, xK_m), spawn "killall fluidsynth; exec dev/mid2key/mid2key /dev/midi* ~/dev/mid2key/test") -- use piano as keybinds

                            -- Screenshots

                            , ((modMask .|. mod1Mask,     xK_Print), screenshot 3 True)
                            , ((modMask .|. controlMask,  xK_Print), spawn "xclip -sel c </dev/null; bash -c 'maim -su | ~/dev/scripts/pyclip CLIPBOARD text/html <(echo -n \"<img src=\\\"http://localhost/$(date +%s).png\\\"/>\") image/png'") -- Copy timestamped screenshot to clipboard in select mode.
                            , ((modMask,                  xK_Print), screenshot 0 False)       -- Upload a screenshot in select mode.
                            , ((modMask .|. shiftMask,    xK_Print), screenshot 0 True)        -- Upload full screenshot in multi-head mode.

                            -- Screensaving

                            , ((modMask,                  xK_Pause), spawn "xset dpms force standby")

                            -- Key layout

                            , ((modMask .|. controlMask,  xK_Shift_L), spawn "bash -c 'if grep fr <(setxkbmap -query); then setxkbmap us; else setxkbmap fr; fi'")

                            -- Autoclicker

                            , ((modMask,               xK_x), spawn "sleep 0.2; xdotool click --repeat 100000000 --delay 5 1")
                            , ((modMask .|. shiftMask, xK_x), spawn "killall xdotool")

                            -- Switch internet connection (requires /usr/bin/ip permission in sudoers)

                            , ((modMask,               xK_KP_Insert), spawn "sudo ip route change default via 192.168.0.1")
                            , ((modMask,               xK_KP_End),    spawn "sudo ip route change default via 192.168.0.129")

                            -- Audio

                            , ((0, 0x1008ff11), spawn "amixer -q set Master 10%-")    -- XF86AudioLowerVolume
                            , ((0, 0x1008ff12), spawn "amixer -q set Master toggle")  -- XF86AudioMute
                            , ((0, 0x1008ff13), spawn "amixer -q set Master 10%+")    -- XF86AudioRaiseVolume
                            , ((0, 0x1008ff14), spawn "mpc toggle")                   -- XF86AudioPlay
                            , ((0, 0x1008ff15), spawn "mpc stop")                     -- XF86AudioStop
                            , ((0, 0x1008ff16), spawn "mpc prev")                     -- XF86AudioPrev
                            , ((0, 0x1008ff17), spawn "mpc next")                     -- XF86AudioNext
                            , ((0, 0x1008ff31), spawn "mpc pause")                    -- XF86AudioPause

                            -- Xmonad

                            , ((modMask,               xK_q),         spawn "xmonad --recompile && xmonad --restart")  -- Restart xmonad
                            , ((modMask .|. shiftMask, xK_q),         io (exitWith ExitSuccess))                       -- Quit xmonad
                            , ((modMask .|. shiftMask, xK_b),         sendMessage ToggleStruts)                        -- Toggle dock gaps (struts)
                            , ((modMask,               xK_n),         refresh)                         -- Reset windows to proper sizes
                            , ((modMask,               xK_space),     sendMessage NextLayout)          -- Rotate through available layouts
                            , ((modMask,               xK_Tab),       windows W.focusDown)             -- Move focus to the next window
                            , ((modMask,               xK_comma),     sendMessage (IncMasterN 1))      -- Increment the number of windows in the master area.
                            , ((modMask,               xK_semicolon), sendMessage (IncMasterN (-1)))   -- Decrement the number of windows in the master area.

                            , ((modMask,               xK_Scroll_Lock), asks theRoot >>= setFocusX) -- Forcibly grab focus away from the current window

                            ] ++ [ -- Default keybinding fixes for Azerty keyboard layout

                              ((m .|. modMask, k), windows $ f i)
                                     | (i, k) <- zip (XMonad.workspaces conf) [0xb2, 0x26,0xe9,0x22,0x27,0x28,0x2d,0xe8,0x5f,0xe7,0xe0] -- mod-[²,1..9,0], Switch to workspace N
                                     , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]                                              -- mod-shift-[&,1..9,0], Move client to workspace N
                            ],

    mouseBindings      = \(XConfig {modMask = modMask}) -> M.fromList $

                            [ ((modMask, button1), mouseMoveWindow)               -- Float and move
                            , ((modMask, button3), mouseResizeWindow)             -- Float and resize
                            , ((modMask, button2), (\w -> windows (W.sink w) >> windows W.shiftMaster)) -- Sink and switch with master window
                            , ((modMask, 8), killWindow)                          -- Kill window under cursor
                            , ((modMask, 9), windows . W.sink)                    -- Sink window under cursor
                            , ((modMask .|. shiftMask, button3), (\w -> windows (W.delete' w) >> reveal w)) -- Unmanage a window without losing stackset information
                            , ((modMask .|. shiftMask, button1), manage)          -- Manage an ignored window again
                            ],

    normalBorderColor  = myNormalBorderColor,
    focusedBorderColor = myFocusedBorderColor,
    borderWidth        = myBorderWidth,

    startupHook        = ewmhDesktopsStartup <+> setEWMHSupported "_NET_WM_STATE_FULLSCREEN",
    handleEventHook    = ewmhDesktopsEventHook <+> fullscreenEventHook <+> hintsEventHook,
    logHook            = ewmhDesktopsLogHook,

    manageHook         = composeAll manageRules

}

------------------------------------------------------------------------
-- Window rules
--

manageRules = concat $
    [ [      match n --> doCenterFloat |     n <- wFloats ]
    , [      match n --> doShift w     | (n,w) <- wShifts ]
    , [      match n --> doIgnore      |     n <- wIgnores ]
    , [ isFullscreen --> (doF W.focusDown <+> doFullFloat) ]
    ]
    where
      match n = foldl1 (<||>) $ map (=? n) [title, className, appName]
      wFloats = ["Pcmanfm", "Qjackctl", "Thunderbird", "Xmessage", "Transmission-qt", "Steam", "Anki", "urxvt_float"]
      wShifts = [("discord", "0")]
      wIgnores = ["qt-ponies"]

------------------------------------------------------------------------
-- Screenshots
--

screenshot :: MonadIO m => Int -> Bool -> m ()
screenshot delay full = do
     runProcessWithInput "/usr/bin/sleep" [ "0.1" ] ""
     safeSpawn "/home/narthorn/dev/scripts/screen.sh" [if full then "" else "-s", "-u", "-d", show delay]

------------------------------------------------------------------------
-- Colors and borders
-- Currently based on the ir_black theme.
--
myNormalBorderColor  = "#000000" -- "#7c7c7c"
myFocusedBorderColor = "#ffb6b0" -- "#ffb6b0"
myBorderWidth        = 1

-- Colors for text and backgrounds of each tab when in "Tabbed" layout.
tabConfig = defaultTheme {
    activeBorderColor   = "#7C7C7C",
    activeTextColor     = "#CEFFAC",
    activeColor         = "#000000",
    inactiveBorderColor = "#7C7C7C",
    inactiveTextColor   = "#EEEEEE",
    inactiveColor       = "#000000"
}

xmobarTitleColor            = "#FFB6B0" -- Color of current window title in xmobar.
xmobarCurrentWorkspaceColor = "#CEFFAC" -- Color of current workspace in xmobar.

------------------------------------------------------------------------
-- Set EWMH capability
--
setEWMHSupported :: String -> X ()
setEWMHSupported prop = do
    d <- asks display
    r <- asks theRoot
    a <- getAtom "_NET_SUPPORTED"
    c <- getAtom "ATOM"
    supp <- getAtom prop
    io $ changeProperty32 d r a c propModeAppend [fromIntegral supp]

unsetEWMHSupported :: String -> X ()
unsetEWMHSupported prop = do
    d <- asks display
    r <- asks theRoot
    a <- getAtom "_NET_SUPPORTED"
    c <- getAtom "ATOM"
    supp <- getAtom prop
    Just proplist <- io $ getWindowProperty32 d a r
    let filtered_proplist = [ x | x <- proplist, x /= fromIntegral supp]
    io $ changeProperty32 d r a c propModeReplace filtered_proplist

------------------------------------------------------------------------
-- ignore configure and ewmh focus requests for misbehaving windows
--
customEventHook :: Query Bool -> (Event -> X All) -> Event -> X All
customEventHook q hook e = do
    match <- runQuery q (ev_window e)
    if match
        then do
            case e of
                PropertyEvent {} -> return (All False)
                ConfigureRequestEvent {} -> return (All False)
                ClientMessageEvent {ev_message_type = mt} -> do
                    Just mt_name <- withDisplay $ \dpy -> io (getAtomName dpy mt)
                    trace ("xmonad eventHook trace: " ++ eventName e ++ " (" ++ mt_name ++ ")")
                    a_aw <- getAtom "_NET_ACTIVE_WINDOW"
                    if mt == a_aw
                        then return (All False)
                        else hook e
                _ -> do
                    --trace ("xmonad eventHook trace: " ++ eventName e)
                    hook e
        else do
            hook e

------------------------------------------------------------------------
-- Run xmonad.
--
main_xmobar = do
  xmproc <- spawnPipe "/usr/bin/xmobar ~/.config/xmonad/xmobar.hs"
  xmonad $ conf {
      logHook = logHook conf <+> (dynamicLogWithPP $ xmobarPP {
            ppOutput = hPutStrLn xmproc
          , ppTitle = xmobarColor xmobarTitleColor ""
          , ppCurrent = xmobarColor xmobarCurrentWorkspaceColor ""
          , ppSep = "   "
          , ppLayout = const ""})
  }

main_bare = xmonad $ conf
    { logHook = return ()
    , startupHook = return ()
    , handleEventHook = \_ -> return (All True)
    , manageHook = composeAll []
    , layoutHook = Tall 1 (3/100) (1/2)
    }

main = main_xmobar

-- vim: et
