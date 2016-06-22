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

conf = defaultConfig {

    modMask            = mod4Mask,

    terminal           = "urxvt",

    layoutHook         = smartBorders $ avoidStruts $     (spacing 6 $ Tall 1 (3/100) (1/2) ||| Mirror (Tall 1 (3/100) (1/2)) ||| ThreeColMid 1 (3/100) (1/3))
                                                      ||| tabbed shrinkText tabConfig
                                                      ||| noBorders Full,

    keys               = \(XConfig {modMask = modMask}) -> M.fromList $

                            [ ((modMask,               xK_t), spawn $ XMonad.terminal conf)              -- Launch terminal.
                            , ((modMask,               xK_r), spawn "exec $(dmenu_path | dmenu)")        -- Launch something using dmenu.
                            , ((modMask .|. shiftMask, xK_r), spawn "SUDO_ASKPASS=$HOME/dev/scripts/dpass exec sudo -A $(dmenu_path | dmenu)")        -- Launch something as root using dmenu.
                            , ((modMask,               xK_a), spawn "bt-audio -d Zik ; bt-audio -c Zik") -- Reconnect bluetooth headset.
                            , ((modMask,               xK_b), spawn "killall ts3client_linux_amd64; exec teamspeak3")
                            , ((modMask,               xK_c), spawn "chromium")
                            , ((modMask,               xK_e), spawn "spacefm")
                            , ((modMask,               xK_p), spawn "pavucontrol")
                            , ((modMask .|. shiftMask, xK_p), spawn "pactl set-card-profile alsa_card.usb-Native_Instruments_RigKontrol3_SN-ydag0t9x-00 off; pactl set-card-profile alsa_card.usb-Native_Instruments_RigKontrol3_SN-ydag0t9x-00 output:analog-stereo")

                            , ((modMask .|. mod1Mask,     xK_Print), screenshot 3 True)
                            , ((modMask .|. controlMask,  xK_Print), spawn "import png:- | xclip -selection clipboard") -- Copy screenshot to clipboard in select mode.
                            , ((modMask,                  xK_Print), screenshot 0 False)       -- Upload a screenshot in select mode.
                            , ((modMask .|. shiftMask,    xK_Print), screenshot 0 True)        -- Upload full screenshot in multi-head mode.

                            , ((modMask .|. controlMask,              xK_Shift_L), spawn "bash -c 'if grep fr <(setxkbmap -query); then setxkbmap us; else setxkbmap fr; fi'")

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

                            ] ++ [ -- Default keybinding fixes for Azerty keyboard layout

                              ((m .|. modMask, k), windows $ f i)
                                     | (i, k) <- zip (XMonad.workspaces conf) [0x26,0xe9,0x22,0x27,0x28,0x2d,0xe8,0x5f,0xe7,0xe0] -- mod-[1..9], Switch to workspace N
                                     , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]                                        -- mod-shift-[1..9], Move client to workspace N
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

    startupHook        = ewmhDesktopsStartup <+> setFullscreenSupported,
    handleEventHook    = ewmhDesktopsEventHook <+> fullscreenEventHook <+> hintsEventHook,
    logHook            = ewmhDesktopsLogHook,

    manageHook         = manageDocks <+> composeAll manageRules

}

------------------------------------------------------------------------
-- Window rules
--

manageRules = concat $
    [ [     title =? t --> doCenterFloat | t <- titleFloats ]
    , [ className =? c --> doCenterFloat | c <- classFloats ]
    , [ className =? c --> doShift w | (c,w) <- classShifts ]
    , [     title =? t --> doShift w | (t,w) <- titleShifts ]
    , [   isFullscreen --> (doF W.focusDown <+> doFullFloat) ]
    ]
    where
      classFloats = ["Spacefm", "Qjackctl", "Thunderbird", "Xmessage", "Wine", "Thunar", "Transmission-qt", "Steam"]
      titleFloats = []
      classShifts = [("Gajim", "1"), ("Mumble", "1"), ("Ts3client_linux_amd64", "1")]
      titleShifts = [("irssi", "1")]

------------------------------------------------------------------------
-- Screenshots
--

screenshotFile = "%Y-%m-%d_%Hh%Mm%Ss_$wx$h.png"

screenshot :: MonadIO m => Int -> Bool -> m ()
screenshot delay full = do
	runProcessWithInput "/usr/bin/sleep" [ "0.1" ] ""
	filename <- liftIO $ runProcessWithInput "/usr/bin/scrot" [
		screenshotFile,
		(if full then "-m" else "-s"),
		"-d", (show delay),
		"-e", "echo $f & mv $f ~/stuff/screenshots" ] ""
	when (not $ null filename) $ safeSpawn "chromium" ["http://www.narthorn.com/stuff/screenshots/" ++ filename]

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
-- Set EWMH fullscreen capability
setFullscreenSupported :: X ()
setFullscreenSupported = do
	d <- asks display
	r <- asks theRoot
	a <- getAtom "_NET_SUPPORTED"
	c <- getAtom "ATOM"
	supp <- getAtom "_NET_WM_STATE_FULLSCREEN"
	io $ changeProperty32 d r a c propModeAppend [fromIntegral supp]

------------------------------------------------------------------------
-- Run xmonad.
--
main = do
  xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmonad/xmobar.hs"
  xmonad $ conf {
      logHook = logHook conf <+> (dynamicLogWithPP $ xmobarPP {
            ppOutput = hPutStrLn xmproc
          , ppTitle = xmobarColor xmobarTitleColor ""
          , ppCurrent = xmobarColor xmobarCurrentWorkspaceColor ""
          , ppSep = "   "
          , ppLayout = const ""})
  }
