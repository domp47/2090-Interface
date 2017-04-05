#!/bin/bash
# the next line restarts using wish\
exec wish "$0" "$@"

set APPNAME [lindex [file split [info script]] end]
set VERSION [clock format [file mtime [info script]] -format {%Y.%m.%d %H:%M}]

set D_XMAX 0.25	;# the default fraction of xrange to display on reload

 package require Tk
# do a dummy file load, to import the ::dialog:: space
 catch {tk_getOpenFile foo bar}
# relative to the defaults, change these tkfbox settings
 set ::tk::dialog::file::showHiddenBtn 1
 set ::tk::dialog::file::showHiddenVar 0
# or change the system-wide defaults, typically in /usr/share/tk8.5/tkfbox.tcl

 package require rbc
 namespace import ::rbc::*

# source fourier.tcl
 package require math::fourier
 namespace import ::math::fourier::*

# source qcomplex.tcl
 package require math::complexnumbers
 namespace import ::math::complexnumbers::*

image create photo button_exit -data {
   R0lGODdhEQAQAPEAAAAAADAwMHV1df///ywAAAAAEQAQAAACOJyPqcsK0ByMYz4zVbgcBCVc
   lQUIyWaORvghoopl8fG+BjoPbBLKcYrYlFaPluaB9EQEwgCQwigAADs=
   }

image create photo button_vzoom -data {
   R0lGODdhGAAYAPEAAAAAAJmZmf///wAAACwAAAAAGAAYAAACT4yPqSjtD6Mw0gFQG6335h11
   XQU+oiiVzXlGKstCJQw/IE07qtWmAddz/SQxHxBlXOGKk6Fy6dE5nzjZlMqUEmvC4yi5jYK3
   mWb53Fyo1QUAOw==
   }

image create photo button_vunzoom -data {
   R0lGODdhGAAYAPEAAAAAAJmZmf///wAAACwAAAAAGAAYAAACUIyPqSjtD6MwUoCLK224++5s
   3Ec+4khmZhClV3Q6qRTLnsZWIF6N/ZT7/WpCCNE2DLZUNOXjw1tCYU6LiwpxMRsn7Y4b9N7A
   ujG22Fuo14ECADs=
   }

image create photo button_hzoom -data {
   R0lGODdhGAAYAPEAAAAAAJmZmf///wAAACwAAAAAGAAYAAACVoyPqSjtD6Mwskpqc8MRPH8F
   EgA2ZNidDlk6nMl+8fOyKjxvIm73trvzCXs6wfAYoyCRk+DSV+Q9gbKc8UettrDZqhfyWm1b
   Xci2EtZE0mrarh1ayOUFADs=
   }

image create photo button_hunzoom -data {
   R0lGODdhGAAYAPEAAAAAAJmZmf///wAAACwAAAAAGAAYAAACVoyPqSjtD6Mwskpqc8NAwz4F
   DQB65CYKZGmt6Oi2MbeyTw1S+PntobpjBTu6ISz4G4KUSaTDWMRFkLTYtPYC8irYn9bEo3lg
   WZsmlxpf0moIpu1eyOcFADs=
   }

image create photo button_redraw -data {
R0lGODdhGAAYAPcAAP////7+/v39/fz8/Pv7+/r6+vn5+fj4+Pf39/X19fLy8vDw8O7u7vHx
8ezs7Ovr6+jo6Obm5uTk5OPj4+np6eHh4eDg4N7e3tzc3NjY2NnZ2d/f39TU1MrKysfHx8nJ
ycXFxcPDw8bGxsHBwb6+vr+/v7S0tLW1tbq6urm5ubOzs6+vr9HR0aamprCwsK2trbGxsays
rLi4uJubm6GhoZeXl5WVlZ+fn5ycnJqamoyMjJKSkpGRkaKioomJiYODg4iIiJSUlISEhHd3
d3BwcIGBgX5+fmpqanp6enR0dH19fWdnZ2ZmZmNjY3V1dWBgYHh4eF5eXl1dXWxsbFtbW1pa
WllZWXJycm1tbVdXV1ZWVlRUVFNTU1FRUVBQUGFhYU9PT0pKSkhISEZGRkVFRURERENDQ0FB
QU1NTT8/P0xMTD09PTw8PElJSUBAQDc3NzY2Njk5OTIyMjAwMC8vLy4uLjMzMy0tLSwsLCsr
KyoqKikpKScnJyYmJiUlJSQkJCEhISMjIx8fHx4eHh0dHRwcHBsbGxkZGRgYGBcXFxYWFhUV
FRQUFBMTEwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAAGAAYAAAI/gABCBxIsKDBgwIFYFCxQ0eP
FBECGERwsAKUQIsUJUqE6A4WFAcGagBhUAObRow0HjpkqFBLKRwATNhCouACKyg3qmxJSNAg
OjeW9KlJEEajN1OA8MgR5IqdQ4D0vGFDB06dEgWRdNmR5IREgRBwuJnDJo0ZMnewDjQwxUcR
HAoMWgACh00ZMnjUJqzxQsaIBAdNyDlDhkwevQACtNhAocEAgyLirDlLRg9iAA8CBBDAWcAA
iReERJFCxYoWLiQJKhEjZswYMVlMfDVYgEHBNn/66B7k43FBCQUAOOhQMIwf3YKmUDQog0WD
D0QHGu/DB9AZF4AJBuBRY4SN6ALVgRzns2ePHCclQgpMAedLjSEXCqLxQ+jPHTFewoxBgmOG
jh8/+LBEDcER5AUgNHwBBxhecLHFaV1oQcUTTRARgkFV2CDAATFYUQYXWlhRhRRRUHjECgIY
1IIBA0nwghFZeJGFFVIwYYMHBByUHUEFZDDCCSqMkMFyCBVp5JFIJplkQAA7
   }

image create photo button_save -data {
R0lGODdhGAAYAPcAAP////7+/v39/fv7+/r6+vn5+fj4+Pf39/X19fPz8/b29vT09Ofn5/Hx
8eTk5O/v7+Hh4eDg4Ovr6+rq6unp6ejo6Nvb293d3c/Pz83NzdfX18vLy8rKytTU1NPT09/f
38bGxsHBwcnJyb6+vtXV1bm5ubi4uNLS0ry8vLa2trW1tbq6urS0tLKysrCwsLOzs66urrGx
sampqaysrKioqKurq6ampqSkpKOjo6WlpaqqqqKioqCgoJ+fn7e3t52dnZycnJubm5qampiY
mJeXl5aWlpWVla2trZCQkKenp5SUlIuLi5OTk4mJiY+Pj4eHh4SEhJKSko6Ojo2NjYyMjIiI
iIaGhoODg4KCgoGBgX9/f35+fn19fXNzc3t7e3p6enl5eXd3d3Z2dnV1dXJycnFxcWxsbG9v
b25ubmtra2pqamhoaGdnZ2VlZWRkZGFhYV5eXlhYWFxcXFZWVltbW1lZWVVVVVNTU1JSUk5O
Tk1NTUtLS0pKSkhISEZGRkVFRUNDQ0FBQUBAQD4+Pjw8PDs7Ozk5OTc3NzU1NTQ0NDIyMjAw
MC8vLy0tLQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAAGAAYAAAI/gABCBxIsKDBgwITRLDgAAHC
hwU89HgCpckODQMeFiTQwUWMHEuQEBkiIoDGgREuJBBgoEMRIDx+QDgJgAADAQQ5BLlBQwVO
jQcGHDDShs2aGUJkwMDxY0wYME4WGCQAwAejJk6c1NgBo0WPEUqUMInD4+CAOYps4Fh7g0UK
FzhsGEEBSM4BgxQaHVpUA4eKFCZGgNhg4sUeQIVIGHSiSBGjRH83ZMCAIcSLOYMCAYLyU6AC
PogWHRrUZ0UJyiBgdOnjB1CgPA8InmiEaJCfP3/moCjBYQaSOXjy8HGdYqAAMoQGHQLkR88d
MyZs5HgjJ84dPs3HGBDYwHUgQYgE0OmxU6eLDjl15ugR1Bz7B4ElQgsSFKhQokOFkhMyZGgQ
nz58HMKHEAJZ8VgiiSCi4CGHKMhffsnNFwhnAPywRhldiBHGF1xskcUVUDzRxBJTOIEEE2El
gZOFXdwQRBRUWAEFFlhYUUUTWmAB4hNeKCEDTj2oIYYMPBQhRRVQXHHFE1UskYWOUFjRYw04
8ZDGGGqgEQYXXHwYYhNUeBllj0fgFIIddMDxhhtsqGHGGV2MAYYXOUJxI5gjCFSABBX02ScF
FFQA6KCDTmDoXTTRFBAAOw==
   }

image create photo button_open -data {
R0lGODdhGAAYAPYAAP///wcHBwgICBMTExQUFBYWFhwcHB8fHycnJy8vL0BAQCsrK0pKSjIy
Ml5eXk5OTjY2Njs7O1hYWGFhYT09PVJSUj8/P1VVVUZGRmhoaFFRUVNTU2tra19fX3FxcWBg
YGNjY3JycoKCgpGRkZKSkpaWlpeXl5ubm5ycnHt7e39/f6CgoKGhoY6OjqOjo4WFhYmJiYeH
h6Wlpaampqenp56enoqKiqqqqpCQkK6urpOTk6ioqLKysrOzs52dnZ+fn7a2tq2traKiori4
uLm5ubq6uqSkpKmpqaurq6ysrMDAwK+vr7GxscPDw8TExLu7u8rKysvLy8zMzM3Nzb6+vs7O
zsHBwcLCwsXFxcnJyc/Pz9TU1NjY2Nra2t/f3+Dg4OPj4+Xl5ejo6O3t7e7u7u/v7/Dw8PHx
8fLy8vPz8/T09Pr6+vv7+/z8/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAACwAAAAAGAAYAAAH/oAAgoOEhYaHgxAuP4yNjj8aiIJIkoJo
LoQDGxecHTQAbG2io21ra2NHhBZUrFQ0VgBQTDw9PLQ8TFdjn4MUPCoqNjRsZGRoampoZ2dl
ZWldmIlPOjo0XmZaKDLbMiwsNFhmTkuEEUsnL0JiVVBZ7lFZUVJZX1k+H4QNJkY4YFtBK1b8
qEHwh4skXu4VQqBixY4iHhxInChxwgSKDi4IMsBhBhcYUKLIkzKlypSSVVKqnCCoAAgXYTI4
oUGzpk2bRSQIEvDghxQOM28KpbmDwaALSZSUaDJUKI8aBQZhuBEiyJAZM7htw6qViAgBvWK0
UJLDG4uAZ816ywHkAaEFPilk9DhBF0XdE3ZR2L0h4kCmDEpolBhMeLAJwlgrFAoggYRjxyMi
R4Y8woWJBIYIYNxMUUGlz6BDix5NWlIgADs=
   }


proc FFT { } {
   global .g ::re ::im size staddress domain x_min x_max y_min y_max re_ im_
   for {set i 0} {$i < $size} {incr i} {
     set j [expr $staddress + $i]
     if [expr $j < $size ] {
	set z [lappend z [complex $::re($j) $::im($j)]]
     } else {
	set z [lappend z [complex 0 0]]
        }
     }
   set f [dft $z]
   for {set i 0} {[expr $i < $size/2]} {incr i} {
     set zz [lindex $f $i]
     set j [expr $size/2 + $i]
     set ::re($j) [real $zz]
     set ::im($j) [imag $zz]
     set zz [lindex $f $j]
     set ::re($i) [real $zz]
     set ::im($i) [imag $zz]
     }

   set domain 1
   if [info exists re_] {vector destroy re_ im_}
   set x_min {}
   set x_max {}
   set y_min {}
   set y_max {}
   ReDraw .g
   }

 proc VertZoom { factor } {
   global .g y_min y_max
   AddZoomStack .g
   set y_min [.g axis cget y -min]
   set y_max [.g axis cget y -max]
   set height [expr 0.5*($y_max - $y_min)*$factor]
   set y_mid [expr 0.5*($y_max + $y_min)]
   set y_min [expr $y_mid - $height]
   set y_max [expr $y_mid + $height]
   .g axis configure y -min $y_min -max $y_max
   event generate .g <Configure>
   }

 proc HoriZoom { factor } {
   global .g x_min x_max
   AddZoomStack .g
   set x_min [expr $factor * [.g axis cget x -min]]
   set x_max [expr $factor * [.g axis cget x -max]]
   .g axis configure x -min $x_min -max $x_max
   event generate .g <Configure>
   }

 proc AddZoomStack { graph } {
    global zoomInfo
    set cmd {}
    foreach margin { xaxis yaxis x2axis y2axis } {
      foreach axis [$graph $margin use] {
        set min [$graph axis cget $axis -min]
        set max [$graph axis cget $axis -max]
        set c [list $graph axis configure $axis -min $min -max $max]
        append cmd "$c\n"
        }
      }
    set zoomInfo($graph,stack) [linsert $zoomInfo($graph,stack) 0 $cmd]
    }

 proc ReDraw { graph } {
   global D_XMAX ::tt x_min x_max y_min y_max hide_r hide_i size staddress sw dw domain
   if {  $domain == 0 } {
     ::tt seq [expr -$dw*$staddress*1000] [expr $dw*($size-$staddress)*1000] [expr $dw*1000]
     if { $x_min == "" } { set x_min 0 } else { set x_min [.g axis cget x -min] }
     if { $x_max == "" } { set x_max [expr $dw*$size*$D_XMAX*1000] } else { set x_max [.g axis cget x -max] }
     .tbar.sw configure -textvariable dw
     .tbar.swl configure -text "   DW (s): "
     $graph axis configure x -title "Time, ms" -min $x_min -max $x_max
   } else {
     ::tt seq [expr -0.0005*$sw] [expr 0.0005*(($size)*$sw)/$size] [expr 0.001*$sw/$size]
     if { $x_min == "" } { set x_min [expr -0.0005*$D_XMAX*$sw] } else { set x_min [.g axis cget x -min] }
     if { $x_max == "" } { set x_max [expr  0.0005*$D_XMAX*$sw] } else { set x_max [.g axis cget x -max] }
     .tbar.sw configure -textvariable sw
     .tbar.swl configure -text "   SW (Hz): "
     $graph axis configure x -title "Frequency, kHz" -min $x_min -max $x_max
     }
   $graph element configure Re -xdata ::tt -hide $hide_r
   $graph element configure Im -xdata ::tt -hide $hide_i

   if { $y_min == "" && $y_max == "" } {
     set y_min 0
     set y_max 1
     if {!$hide_r} {
       set y_min $::re(min)
       set y_max $::re(max)
       }
     if {!$hide_i} {
       if [expr $y_min > $::im(min)] { set y_min $::im(min) }
       if [expr $y_max < $::im(max)] { set y_max $::im(max) }
       }
     $graph axis configure y -min $y_min -max $y_max 
     }
   event generate $graph <Configure>
   InitStack $graph
   }
 proc SaveFile { } {
   global filename ::tt ::re ::im 
   global nscans size staddress ph0 sw make domain
   if {$domain == 0} {
	set fname [tk_getSaveFile -initialdir [file dirname $filename] -filetypes {{"Xnmr data" {.dat}} {All {*}}}]
   } else {
	set fname [tk_getSaveFile -initialdir [file dirname $filename] -filetypes {{"Xnmr data" {.ft}} {All {*}}}]
	}
   if {$fname == ""} { SetStatus "ok" "save file cancelled"; return }

   set fp_fail [catch {set fp [open $fname "w"]}]
   if { $fp_fail } { SetStatus "error" "error opening $fname for writing"; return }
   fconfigure $fp -translation binary -encoding binary
####	header
   set FMT "iiiiiiiiiiiiiiiiia4rrrrrrrrrrrrrrrri"
   set np -16
   set nf [expr 8*abs($np)+4]
   set type 1
   set axis2 0
   set w1_2 0
   set axis1 0
   set i7 0
   set i8 0
   set i9 0
   set comm_st 0
   set comm_len 0
   set raw_st 0
   set raw_len 0
   if { $make == "" } { set make "XNMR" }
   set w0 46061500
   set ref_u 0.
   set ref_pt 0.
   set ph_pt 0.
   set ph1 0.
   set sw_1 0.
   set w0_1 0.
   set ref_u_1 0.
   set ref_pt_1 0.
   set ph_pt_1 0.
   set ph0_1 0.
   set ph1_1 0.
   set fshift 0.
   set r32 0.
   set wh_fail [catch {puts -nonewline $fp [binary format $FMT $nf $np \
	$size $type $domain $axis2 $w1_2 $axis1 $i7 $i8 $i9 $nscans $comm_st $comm_len $raw_st $raw_len $staddress $make \
	$sw $w0 $ref_u $ref_pt $ph_pt $ph0 $ph1 $sw_1 $w0_1 $ref_u_1 $ref_pt_1 $ph_pt_1 $ph0_1 $ph1_1 $fshift $r32 \
	$nf ] \
	}]
   if { $wh_fail } { SetStatus "error" "error writing header to $fname"; close $fp; return }
####	data
   set np [expr $size]
   set nf [expr 8*abs($np)+4]
   set FMT "ii"
   set wd_fail [catch {puts -nonewline $fp [binary format $FMT $nf $np ] }]
   if { $wd_fail } { SetStatus "error" "error writing data frame info to $fname"; close $fp; return }
   set FMT "rr"
   for {set i 0} {$i < $size} {incr i} {
	set wd_fail [catch {puts -nonewline $fp [binary format $FMT $::re($i) $::im($i)] }]
	}
   if { $wd_fail } { SetStatus "error" "error writing data to $fname"; close $fp; return }
   set FMT "i"
   set wd_fail [catch { puts -nonewline $fp [binary format $FMT $nf] }]
   if { $wd_fail } { SetStatus "error" "error closing data frame on $fname"; close $fp; return }
   set cl_fail [catch {close $fp}]

   if { $fp_fail || $wh_fail || $wd_fail || $cl_fail } {
     SetStatus "error" "error saving to $fname"
     return
   } else {
     set filename $fname
     SetStatus "ok" "$filename saved"
     } 
   }
proc SetFile {} {
	set f [open
}
proc SaveConfig { } {
  global .g filename hide_r hide_i x_min x_max y_min y_max
  if { [catch {set fp [open ".xnmrrc" w]}] } {
    SetStatus warning "Unable to save configuration in .xnmrrc, exiting"
    update; after 2000
    } \
  else {
    puts $fp "set filename $filename"
    set width [winfo width .]
    set height [winfo height .]
    puts $fp ".g configure -width $width"
    puts $fp ".g configure -height $height"
    puts $fp "set hide_r $hide_r"
    puts $fp "set hide_i $hide_i"
    puts $fp "set x_min $x_min"
    puts $fp "set x_max $x_max"
    puts $fp "set y_min $y_min"
    puts $fp "set y_max $y_max"
    close $fp
    }
}
proc BaselineCorrect { } {
   global .g ::re ::im size staddress
   set iend [expr $size - $staddress -1]
   set ibeg [expr $iend - $size / 16 ]
   set base [vector expr mean(::re($ibeg:$iend))]
   ::re expr { ::re - $base }
   set base [vector expr mean(::im($ibeg:$iend))]
   ::im expr { ::im - $base }
   ReDraw .g
   }
proc FracShift { } {
   global .zoom.g .g ::tt ::re ::im domain size staddress fshift ::zt ::zx ::zy ibeg iend
   if { $domain == 1 } { SetStatus "warning" "fractional shift not available in FT domain"; return }
   if { [winfo exists .zoom] } { 
	ApplyFS $ibeg $iend
   } else {
     set ibeg [expr $staddress - 4]
     if [expr $ibeg < 0] { set ibeg 0 }
     set iend [expr $staddress + 4]
     if [expr $ibeg > $size] { set ibeg $size }
#     if { [info exists ::zy] } { vector destroy ::zt ::zx ::zy }
     set l [expr $iend - $ibeg + 1]
     vector create ::zt($l) ::zx($l) ::zy($l)
     for {set i $ibeg} {$i <= $iend} {incr i} {
       set l [expr $i - $ibeg]
       set ::zt($l) $::tt($i)
       set ::zx($l) $::re($i)
       set ::zy($l) $::im($i)
       }
##puts "zx 0..$l = $::zx(0) $::zx(1) $::zx(2) $::zx(3) .. $::zx($l)" 
     toplevel .zoom
     graph .zoom.g -width 600 -height 600 -bd 2 -relief groove 
     .zoom.g grid configure -hide no -dashes { 2 2 }
     .zoom.g legend configure -position plotarea -anchor ne
     frame .zoom.b
     label .zoom.b.lfs -text "Fraction of dwell time: "
     spinbox .zoom.b.fs -width 5 -textvariable fshift -from -0.5 -to 0.5 -increment 0.01 -command { ApplyFS $ibeg $iend }
     bind .zoom.b.fs <Return> { ApplyFS $ibeg $iend }
     button .zoom.b.cancel -text "Cancel" -command { set fshift 0; wm deiconify .; destroy .zoom; return }
     button .zoom.b.done -text "  OK  " -command { ::re dup ::zx; ::im dup ::zy; ApplyFS 0 [expr $size -1]; ::zx dup ::re; ::zy dup ::im; wm deiconify .; destroy .zoom; return }
     pack .zoom.b -side top
     pack .zoom.b.done .zoom.b.cancel -side right
     pack .zoom.b.lfs .zoom.b.fs -side left
     pack .zoom.g -side bottom -expand 1 -fill both
     .zoom.g element create Re -xdata ::zt -ydata ::zx -pixels 3 -color blue
#     .zoom.g element create Im -xdata ::zt -ydata ::zy -pixels 3 -color green -hide on
     wm iconify .
     ApplyFS $ibeg $iend
     }

   .zoom.g element configure Re -ydata ::zx 
#   .zoom.g element configure Im -ydata ::zy -hide on
   event generate .zoom.g <Configure>
   }
proc SetStatus { state message } {
   global .status.led .status.text
   switch -- $state {
     ok      { .status.led configure -background green }
     warning { .status.led configure -background yellow }
     error   { .status.led configure -background red }
     default { .status.led configure -background grey }
     }
   .status.text configure -text "$message"
   }
proc PhaseShift { } {
   global .g ph0 size ::re ::im re_ im_
   if ![info exists re_] {
     ::re dup re_
     ::im dup im_
     }
   if [expr $ph0 == 0] {
     ::re expr { re_ }
     ::im expr { im_ }
     vector destroy re_ im_
     SetStatus "ok" "phase_0=0, original data restored"
   } else {
     set sf [expr sin($ph0*3.14159265/180)]
     set cf [expr cos($ph0*3.14159265/180)]
     ::re expr {  $cf * re_ + $sf * im_ }
     ::im expr { -$sf * re_ + $cf * im_ }
     SetStatus "ok" "0th order phase shift of $ph0 applied"
     }
   ReDraw .g
   }
proc ExpMultiply { } {
   global .g ::tt ::re ::im size staddress dw tau domain
   if { $domain == 1 } { SetStatus "warning" "exponential multiplication not available in FT domain"; return }
   if { $tau == "" } {set tau [expr $::tt($size/8)]}
   for {set i $staddress} {$i < $size} {incr i} {
	set f [expr exp(-($::tt($i)-$::tt($staddress))/$tau)]
	set ::re($i) [expr $::re($i)*$f]
	set ::im($i) [expr $::im($i)*$f]
	}
   ReDraw .g
   }
#
# defaults needed for the blank start-up, if there is no .xnmrrc
#
 vector create ::tt ::re ::im
 set np 1
 set x_min {}
 set y_min {}
 set x_max {}
 set y_max {}
 set hide_r "off"
 set hide_i "on"
 set filename {}
 set nscans 1
 set staddress 0
 set ph0 0
 set fshift 0
 set make ""
 set domain 0
 set sw 1000000
 set dw [expr 1./$sw]
 set size {}
 set tau {}
#
# master window setup
#
 wm geometry . "+0+0"; wm title . "$APPNAME (v. $VERSION)"

  frame .tbar
  button .tbar.l -image button_open -command {SetFile {}}
#  button .tbar.rl -text "Data file: " -command {ReloadFile $filename}
  entry .tbar.f -width 35 -textvariable filename
  bind  .tbar.f <Return> {ReloadFile $filename}
  entry .tbar.make -width 6 -textvariable make
  button .tbar.save -image button_save -command { SaveFile }
#  button .tbar.r -text "Redraw" -command {set x_min {}; set x_max {}; set y_min {}; set y_max {}; ReDraw .g}
  button .tbar.r -image button_redraw -command {set x_min {}; set x_max {}; set y_min {}; set y_max {}; ReDraw .g}
  button .tbar.exit -image button_exit -command { SaveConfig; exit }

  pack .tbar -side top -fill x
  pack .tbar.l .tbar.f .tbar.make .tbar.save -side left

  graph .g -width 900 -height 600 -bd 2 -relief groove

  checkbutton .tbar.si -text "Im" -command { .g element configure Im -hide $hide_i } -variable hide_i -onvalue "off" -offvalue "on" -foreground green
  checkbutton .tbar.sr -text "Re" -command { .g element configure Re -hide $hide_r } -variable hide_r -onvalue "off" -offvalue "on" -foreground blue
  entry .tbar.sw -width 12 -justify right -textvariable sw
  bind  .tbar.sw <Return> { if {$domain == 0} {set sw [expr 1./$dw]} else {set dw [expr 1./$sw]} ; ReDraw .g }
  spinbox .tbar.st -width 5 -textvariable staddress -from 0 -to Inf -increment 1 -command { if {$domain == 0} { ReDraw .g } }
  bind  .tbar.st <Return> { if {$domain == 0} { ReDraw .g } }
  spinbox .tbar.ph0 -width 5 -justify right -textvariable ph0 -from -180 -to 180 -increment 0.1 -command { PhaseShift }
  bind  .tbar.ph0 <Return> { PhaseShift }
  spinbox .tbar.fsh -width 5 -justify right -textvariable fshift -from -0.5 -to 0.5 -increment 0.01 -command { FracShift }
  bind  .tbar.fsh <Return> { FracShift }
  button .tbar.em -text "EM" -command {ExpMultiply}
  entry .tbar.tau -width 8 -justify right -textvariable tau
  label .tbar.shl -text "  Shift: "
  label .tbar.phl -text "  Phase: "
  label .tbar.stl -text "  StAddr: "
  label .tbar.swl -text "  SW (kHz): "
  label .tbar.s   -text "" -width 5
  button .tbar.bc -text "BC" -command { BaselineCorrect }
  button .tbar.ft -text "FT" -command { FFT }
  pack .tbar.exit .tbar.s .tbar.si .tbar.sr .tbar.sw .tbar.swl .tbar.st .tbar.stl .tbar.ph0 .tbar.phl .tbar.fsh .tbar.shl .tbar.bc .tbar.tau .tbar.em .tbar.ft -side right -fill x


  frame .bbar 
  button .bbar.r -image button_redraw -command {set x_min {}; set x_max {}; set y_min {}; set y_max {}; ReDraw .g}
  button .bbar.e -image button_hzoom   -command {HoriZoom 0.5}
  button .bbar.c -image button_hunzoom -command {HoriZoom 2.0}
#  button .bbar.e -text "< >" -command {HoriZoom 0.5}
#  button .bbar.c -text "> <" -command {HoriZoom 2.0}
  scrollbar .bbar.hs -command { .g axis view x } -orient horizontal
  label .bbar.s -text "" -width 5
  pack .bbar -side top -fill x
  pack .bbar.r .bbar.e .bbar.c -side right
  pack .bbar.s -side left
  pack .bbar.hs -expand 1 -fill both

  frame .status
  label .status.led  -text "" -background green -width 2
  label .status.text -text "Ready."
  pack .status -side bottom -fill x
  pack .status.led .status.text -side left

  frame .rbar
  scrollbar .rbar.vs -command { .g axis view y } -orient vertical
#  button .rbar.m -text "x2" -command {VertZoom 0.5}
#  button .rbar.d -text ":2" -command {VertZoom 2.0}
  button .rbar.m -image button_vzoom   -command {VertZoom 0.5}
  button .rbar.d -image button_vunzoom -command {VertZoom 2.0}
  pack .rbar -side right -fill y
  pack .rbar.m .rbar.d -side top
  pack .rbar.vs -expand 1 -fill both

  pack .g  -expand 1  -fill both
 
  set rcname ".xnmrrc" 
  if [file exists $rcname] { 
    source $rcname 
    }

 .g element create Re -xdata ::tt -ydata ::re -pixels 3 -color blue;  .g element configure Re -hide $hide_r
 .g element create Im -xdata ::tt -ydata ::im -pixels 3 -color green; .g element configure Im -hide $hide_i

  if {$filename != "" && [file exists $filename]} { ReloadFile $filename }

 .g axis configure y -min $y_min -max $y_max
 .g axis configure x -min $x_min -max $x_max
 .g axis configure x -scrollcommand { .bbar.hs set }
 .g axis configure y -scrollcommand { .rbar.vs set }
 .g grid configure -hide no -dashes { 2 2 }
 .g legend configure -position plotarea -anchor ne

 Rbc_Crosshairs .g
 Rbc_ZoomStack .g
# Rbc_ActiveLegend .g

 event generate .g <Configure>
