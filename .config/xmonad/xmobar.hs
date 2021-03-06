-- This is setup for dual {1680x1050, 1920x1080} monitors, with the right monitor as primary
-- and 120px space for trayer dock
Config {
    font = "xft:Misc Fixed:pixelsize=11,IPAGothic:pixelsize=11,xos4 Terminus:pixelsize=11",
    bgColor = "#000000",
    fgColor = "#ffffff",
    position = Static { xpos = 1680, ypos = 0, width = 1800, height = 16 },
    -- position = Static { xpos = 0, ypos = 0, width = 1800, height = 16 },
    lowerOnStart = True,
    commands = [
        Run AutoMPD          ["-t","<fc=#FFFFCC><statei></fc> <state>: <fc=#CEFFAC><artist> - <title> (<length>)</fc>"],
        Run MPD              ["-t","<fc=#FFFFCC><bar></fc> [<flags>]", "-W", "10", "-b", "-", "-f", "#"] 10, -- AutoMPD won't wake up to update progres bar, so use regular 1s polling
        Run MultiCpu         ["-t","<autovbar>","-L","30","-H","60","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC","-w","3"] 5,
        Run DiskU            [("/", "/ <free>")] ["-L","20","-H","80","-h","#CEFFAC","-l","#FFB6B0","-n","#FFFFCC","-S","true"] 10,
        Run Memory           ["-t","<usedratio>%",                                         "-L","4096", "-H","8192", "-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,
        Run Swap             ["-t","<usedratio>%",                                        "-L","512",  "-H","1024", "-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,
        Run Network "enp4s0" ["-t","Net: <rx>, <tx>",                                 "-m","4", "-L","10",   "-H","1000", "-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,

        Run Date "%A %_d %B %Y  %H:%M" "date" 10,
        Run Kbd [("us", "qw"), ("fr", "az")],
        Run Com "sh" ["-c", "sensors amdgpu-pci-0900  | sed '/temp/!d;s/  (.*//;s/.*+//'"] "gputemp" 10,
        Run Com "sh" ["-c", "sensors k10temp-pci-00c3 | sed '/Tdie/!d;s/ (.*//;s/.*+//'"] "cputemp" 10,


        Run StdinReader
    ],
    sepChar = "%",
    alignSep = "}{",
    template = "%StdinReader% }{ %autompd% %mpd%       Gpu: <fc=#CEFFAC>%gputemp%</fc>    Cpu: <fc=#CEFFAC>%cputemp%</fc> %multicpu%  %disku%    Mem: %memory% (%swap%)    %enp4s0%    Keys: <fc=#CEFFAC>%kbd%</fc>    <fc=#FFFFCC>%date%</fc>"
}

-- cpu meter ideas
--
-- symbols:  ‧ ⁖ ⁘ ⁙ ⁜
-- more :    ⠏ ⠕ ⠛ ⠟   http://graphemica.com/blocks/braille-patterns
-- play with font options (pixelsize, style)
