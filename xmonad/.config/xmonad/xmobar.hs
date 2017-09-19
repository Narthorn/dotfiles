-- This is setup for dual {1680x1050, 1920x1080} monitors, with the right monitor as primary
-- and 120px space for trayer dock
Config {
    font = "xft:Misc Fixed:pixelsize=11,IPAGothic:pixelsize=11",
    bgColor = "#000000",
    fgColor = "#ffffff",
    position = Static { xpos = 1680, ypos = 0, width = 1800, height = 16 },
    -- position = Static { xpos = 0, ypos = 0, width = 1800, height = 16 },
    lowerOnStart = True,
    commands = [
        Run AutoMPD          ["-t","<fc=#FFFFCC><statei></fc> <state>: <fc=#CEFFAC><artist> - <title> (<length>)</fc>"],
        Run MPD              ["-t","<fc=#FFFFCC><bar></fc> [<flags>]", "-W", "25", "-b", "-", "-f", "#"] 10, -- AutoMPD won't wake up to update progres bar, so use regular 1s polling
        Run MultiCpu         ["-t","<total0> <total1> <total2> <total3> <total4> <total5> <total6> <total7> <total8> <total9> <total10> <total11>","-L","30",   "-H","60",   "-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC","-w","3"] 10,
        Run Memory           ["-t","<usedratio>%",                                         "-L","4096", "-H","8192", "-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,
        Run Swap             ["-t","<usedratio>%",                                        "-L","512",  "-H","1024", "-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,
        Run Network "enp5s0" ["-t","Net: <rx>, <tx>",                                 "-m","4", "-L","10",   "-H","1000", "-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,

        Run Date "%A %_d %B %Y  %H:%M" "date" 10,
        Run Kbd [("us", "qw"), ("fr", "az")],
        Run Com "sh" ["-c", "sensors amdgpu-pci-0b00 | sed '/temp/!d;s/  (.*//;s/.*+//'"] "gputemp" 10,
		Run Com "sh" ["-c", "sensors it8686-isa-0a40 | sed '/AMDSI/!d;s/ (.*//;s/.*+//'"] "cputemp" 10,


        Run StdinReader
    ],
    sepChar = "%",
    alignSep = "}{",
    template = "%StdinReader% }{ %autompd% %mpd%       Gpu: <fc=#CEFFAC>%gputemp%</fc>    Cpu: <fc=#CEFFAC>%cputemp%</fc> %multicpu%    Mem: %memory% (%swap%)    %enp5s0%    Keys: <fc=#CEFFAC>%kbd%</fc>    <fc=#FFFFCC>%date%</fc>"
}