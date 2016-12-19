//CHEMESIS2.0
//pumpsoma-axon5.g
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
lightdelay=2000
str filepath="/export/home/avrama/chemesis2.0/ncx/results/"

echo "reading in model"

include taperncxcell.g
phototrans /rhab/ip3s1
lgtna_comp /rhab/vm /rhab/ip3s2 {rhabcyls} {gna}

echo "initializing output file"
str gaba="/branch_syn/vm[2]"
include small-output.g
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
   start GABA at 1000 or 3000, start light at 2000, stop at 5000 msec */
int stop=5000/0.005
int isi, start

  for (isi=-1000; isi<=1000; isi=isi+2000)
    start=lightdelay+isi
    echo "isi=" {isi} "start=" {start} "stop=" {stop}
    setfield /stat/spike_rate peak 0.15 tau_fall 1000 decay_type 0 delay {start}

     str filenam = (filepath)@"pumpsoma-axon5"@(isi/1000)@".dat"
     setfield /output/plot_out filename {filenam} initialize 1 append 0 leave_open 1

     str filenam = (filepath)@"pumpsoma-axon5"@(isi/1000)@".cal"
     setfield /output/spatial filename {filenam} initialize 1 append 0 leave_open 1
     str filenam = (filepath)@"pumpsoma-axon5"@(isi/1000)@".ip3"
     setfield /output/ip3 filename {filenam} initialize 1 append 0 leave_open 1

     reset
     step {stop}
     setfield /stat/spike_rate peak 0
     step 1600000 
end

/* light alone */
    setfield /stat/spike_rate peak 0.0 tau_fall 1000 decay_type 0 delay 16000

     str filenam = (filepath)@"pumpsoma-axon5-light.dat"
     setfield /output/plot_out filename {filenam} initialize 1 append 0 leave_open 1

     str filenam = (filepath)@"pumpsoma-axon5-light.cal"
     setfield /output/spatial filename {filenam} initialize 1 append 0 leave_open 1
     str filenam = (filepath)@"pumpsoma-axon5-light.ip3"
     setfield /output/ip3 filename {filenam} initialize 1 append 0 leave_open 1


     reset
     step 1000000
     step 2400000 

/* GABA alone */
    setfield /stat/spike_rate peak 0.15 tau_fall 1000 decay_type 0 delay 1000
    setfield /rhabmemb/shutter level1 0 delay1 16000 width1 0

     str filenam = (filepath)@"pumpsoma-axon5-gaba.dat"
     setfield /output/plot_out filename {filenam} initialize 1 append 0 leave_open 1

     str filenam = (filepath)@"pumpsoma-axon5-gaba.cal"
     setfield /output/spatial filename {filenam} initialize 1 append 0 leave_open 1
     str filenam = (filepath)@"pumpsoma-axon5-gaba.ip3"
     setfield /output/ip3 filename {filenam} initialize 1 append 0 leave_open 1

     reset
     step {stop}
     setfield /stat/spike_rate peak 0
     step 1600000 

delete /output/ip3 

/* decrease Gbar of vdep K currents: Kca and Ka, to evaluate effect of 
learning.  Only due light alone stimulil */
float oldgka, oldgkca, oldcap, oldcat

oldgka={getfield /soma/vm[1]/ka Gbar}
setfield /soma/vm[1]/ka Gbar {oldgka*0.7}
echo oldgka={oldgka}
showfield /soma/vm[1]/ka Gbar

for (i=1; i<=somacyls; i=i+1)
	oldgkca={getfield /soma/Cacyts1[{i}]/kc Gbar}
	echo oldgkca={oldgkca}
	setfield /soma/Cacyts1[{i}]/kc Gbar {oldgkca*0.7}
	showfield /soma/Cacyts1[{i}]/kc Gbar
end

/* light alone */
    setfield /rhabmemb/shutter level1 {intensity} delay1 {lightdelay} width1 {duration}
    setfield /stat/spike_rate peak 0.0 tau_fall 1000 decay_type 0 delay 16000

     str filenam = (filepath)@"pumpsoma-vdepk70-light.dat"
     setfield /output/plot_out filename {filenam} initialize 1 append 0 leave_open 1

     str filenam = (filepath)@"pumpsoma-vdepk70-light.cal"
     setfield /output/spatial filename {filenam} initialize 1 append 0 leave_open 1

     reset
     step 1000000
     step 2400000 

/*add in change in just one calcium current*/
for (i=1; i<=somacyls; i=i+1)
	showfield /soma/Cacyts1[{i}]/persist_ghk_ica Pca
	oldcap={getfield /soma/Cacyts1[{i}]/persist_ghk_ica Pca}
	setfield /soma/Cacyts1[{i}]/persist_ghk_ica Pca {oldcap*0.7}
	showfield /soma/Cacyts1[{i}]/persist_ghk_ica Pca

end

    setfield /stat/spike_rate peak 0.0 tau_fall 1000 decay_type 0 delay 26000

     str filenam = (filepath)@"pumpsoma-cap70-light.dat"
     setfield /output/plot_out filename {filenam} initialize 1 append 0 leave_open 1

     str filenam = (filepath)@"pumpsoma-cap70-light.cal"
     setfield /output/spatial filename {filenam} initialize 1 append 0 leave_open 1

     reset
     step 1000000
     step 2400000 

/* add in change in transient calcium currents */
for (i=1; i<=somacyls; i=i+1)

	showfield /soma/Cacyts1[{i}]/trans_ghk_ica Pca
	oldcat={getfield /soma/Cacyts1[{i}]/trans_ghk_ica Pca}
	setfield /soma/Cacyts1[{i}]/trans_ghk_ica Pca {oldcat*0.7}
	showfield /soma/Cacyts1[{i}]/trans_ghk_ica Pca
end

    setfield /stat/spike_rate peak 0.0 tau_fall 1000 decay_type 0 delay 26000

     str filenam = (filepath)@"pumpsoma-allvdep70-light.dat"
     setfield /output/plot_out filename {filenam} initialize 1 append 0 leave_open 1

     str filenam = (filepath)@"pumpsoma-allvdep70-light.cal"
     setfield /output/spatial filename {filenam} initialize 1 append 0 leave_open 1

     reset
     step 1000000
     step 2400000 







