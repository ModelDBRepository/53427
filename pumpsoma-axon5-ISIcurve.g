//CHEMESIS2.0
//pumpsoma-axon5-ISIcurve.g
/* include current to compartment to decrease hyperpolarization
 * initialized ncx with lower V to decrease total ncx effect
 * increase cytleak by 2% */
/* model of phototransduction at level of stochastic activation of rhodopsin
** and mass action enzyme reactions from G protein activation
** to ip3 production.  Includes calcium release and light induced Na current.
*/

include bcell-const.g
include rxn-func.g
include comp-func.g
include changerad.g
include cicr-func.g
include ryan-func.g
include iicrflux-func.g
include cytpump-func.g
include cal-ip3-2D.g
include cal-ip3-rhab.g
include cal-ip3-taper.g
include volt-func-shunt.g
include kleak-newlig2.g
include phototrans2.g
include yamoah-ih.g
include ica.g
include kc4act1.g
include ka.g
include lgt-na17.g
include gabaa-chan.g
include gabab-syn.g
include gabab-chan.g

int i, j
Vinit	=	-60.0
gshunt	=	0.005
float kncx = 1.5e-3
float Vncx = 1400
float kpmca = 0.3e-3
float Vpmca = 1.6e-11
float Vpmcarhab = 0
float Vncxrhab = 0
int pmca_power =	1
maxcicr	=	0.16
serca   =	0.00094
axondiama = 3e-4
axondiamb = 5e-4
str plctype="mm"
//lightdelay=7000
//lightdelay=2000
//lightdelay=5000

str filepath="/export/home/avrama/chemesis2.0/ncx/results/"

echo "reading in model"

include taperncxcell.g
phototrans /rhab/ip3s1
lgtna_comp /rhab/vm /rhab/ip3s2 {rhabcyls} {gna}

echo "initializing output file"
str gaba="/branch_syn/vm[2]"
include tiny-output.g
//include small-output.g
//include whole-output.g
//include ip3whole-output.g

reset
setcytpumpleak /soma/Cacyts1 /extracell {somacyls} {Vpmca} {kpmca} {Vncx} {kncx}
setcytpumpleak /rhab/Cacyts1 /extracell {rhabcyls} {Vpmcarhab} {kpmca} {Vncxrhab} {kncx}
setcytpumpleak /neck/Cacyts1 /extracell 1 {Vpmcarhab} {kpmca} {Vncxrhab} {kncx}
setcytpumpleak /axon/Cacyts1 /extracell {axoncyls} {Vpmcarhab} {kpmca} {Vncxrhab} {kncx}
setcytpumpleak /branch/Cacyts1 /extracell {branchcyls} {Vpmcarhab} {kpmca} {Vncxrhab} {kncx}
setcytpumpleak /branch_syn/Cacyts1 /extracell {branchcyls} {Vpmcarhab} {kpmca} {Vncxrhab} {kncx}
//check

/* loop for paired stimuli
  start light at 7s, stop GABA at 10 s.
  start GABA at 1s (-6), 2s (-5), 3s (-4), 4s (-3), 5s (-2). */
/*int stop=10000/0.005
int isi, start

  for (isi=-6000; isi<=-2000; isi=isi+1000)
    start=lightdelay+isi
    echo "isi=" {isi} "start=" {start} "stop=" {stop}
    setfield /stat/spike_rate peak 0.15 tau_fall 1000 decay_type 0 delay {start}

     str filenam = (filepath)@"pumpsoma-axon5"@(isi/1000)@".dat"
     setfield /output/plot_out filename {filenam} initialize 1 append 0 leave_open 1

     str filenam = (filepath)@"pumpsoma-axon5"@(isi/1000)@".cal"
     setfield /output/spatial filename {filenam} initialize 1 append 0 leave_open 1
     reset
     step {stop}
     setfield /stat/spike_rate peak 0
     step 1000000 
end
*/
/* loop for paired stimuli
  start light at 2s, stop GABA at 5 s.
  start GABA at 2s (+0), 4s (+2) */
int stop=5000/0.005
int isi, start
//int stop=8000/0.005
start = 6000
isi=1000
setclock 5 5.0		/* for graphs and plot_out*/
setclock 6 10.0		/* used for spatial output */

//  for (isi=0; isi<=2000; isi=isi+2000)
//    start=lightdelay+isi
//    echo "isi=" {isi} "start=" {start} "stop=" {stop}
//    setfield /stat/spike_rate peak 0.15 tau_fall 1000 decay_type 0 delay {start}

//     str filenam = (filepath)@"pumpsoma-axon5"@(isi/1000)@".dat"
//     str filenam = (filepath)@"pumpsoma-axon5-1slong.dat"
//      setfield /output/plot_out filename {filenam} initialize 1 append 0 leave_open 1
//
//     str filenam = (filepath)@"pumpsoma-axon5"@(isi/1000)@".cal"
//       str filenam = (filepath)@"pumpsoma-axon5-1slong.cal"
//    setfield /output/spatial filename {filenam} initialize 1 append 0 leave_open 1
/*     reset
     step {stop}
     setfield /stat/spike_rate peak 0
     step 1000000
*//* continue until 52 sec after light off */ 
//     step 10000000
//end


/* GABA alone */
    setfield /stat/spike_rate peak 0.15 tau_fall 1000 decay_type 0 delay 1000
    setfield /rhabmemb/shutter level1 0 delay1 700000 width1 0

     str filenam = (filepath)@"pumpsoma-axon5-gabalong.dat"
     setfield /output/plot_out filename {filenam} initialize 1 append 0 leave_open 1

     str filenam = (filepath)@"pumpsoma-axon5-gabalong.cal"
     setfield /output/spatial filename {filenam} initialize 1 append 0 leave_open 1
     reset
     step {stop}
     setfield /stat/spike_rate peak 0
     step 12000000 





