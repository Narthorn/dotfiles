-- This is setup for dual {1680x1050, 1920x1080} monitors, with the right monitor as primary
-- and 120px space for trayer dock
Config {
    font = "xft:Fixed-8",
    bgColor = "#000000",
    fgColor = "#ffffff",
    position = Static { xpos = 0, ypos = 0, width = 1800, height = 16 },
	lowerOnStart = True,
    commands = [
        Run AutoMPD          ["-t","<fc=#FFFFCC><statei></fc> <state>: <fc=#CEFFAC><artist> - <title> (<length>)</fc> <fc=#FFFFCC><bar></fc> [<flags>]", "-W", "25", "-b", "-", "-f", "#"], 
        Run MultiCpu         ["-t","Cpu: <total0> <total1> <total2> <total3> <total4> <total5>","-L","30",   "-H","60",   "-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC","-w","3"] 10,
        Run Memory           ["-t","Mem: <usedratio>%",                                         "-L","4096", "-H","8192", "-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,
        Run Swap             ["-t","Swap: <usedratio>%",                                        "-L","512",  "-H","1024", "-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,
        Run Network "enp3s0" ["-t","Net: <rx>, <tx>",                                 "-m","4", "-L","10",   "-H","1000", "-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,

        Run Date "%A %_d %B %H:%M" "date" 10,
		Run Kbd [("us", "qw"), ("fr", "az")],
		Run Com "sh" ["-c", "sensors radeon-pci-0700 | sed '/temp/!d;s/  (.*//;s/.*+//'"] "gputemp" 10,


        Run StdinReader
    ],
    sepChar = "%",
    alignSep = "}{",
    template = "%StdinReader% }{%autompd%       Gpu: <fc=#CEFFAC>%gputemp%</fc>  %multicpu%   %memory%   %swap%   %enp3s0%   Keys: <fc=#CEFFAC>%kbd%</fc>   <fc=#FFFFCC>%date%</fc>"
}
