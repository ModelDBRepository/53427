//CHEMESIS2.0
//nokleak-icasus.g
/* include current to compartment to decrease hyperpolarization
 * initialized ncx with lower V to decrease total ncx effect
 * increase cytleak by 2%. no pumps in rhab */
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
include kleak-const.g
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
gshunt	=	0.005
float kncx = 1.5e-3
float Vncx = 1400
float kpmca = 0.3e-3
float Vpmca = 1.6e-11
float Vpmcarhab = 0
float Vncxrhab = 0
float Vncxaxon = 110
float pca_s = {pca_p}
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
ica_axon /axon/vm[1] /axon/Cacyts1 1 25 {pca_s} /extracell
ica_axon /axon/vm[2] /axon/Cacyts1 26 50 {pca_s} /extracell
ica_axon /axon/vm[3] /axon/Cacyts1 51 75 {pca_s} /extracell
ica_axon /axon/vm[4] /axon/Cacyts1 76 100 {pca_s} /extracell
ica_axon /branch_syn/vm[1] /branch_syn/Cacyts1 1 5 {2*pca_s} /extracell
ica_axon /branch_syn/vm[2] /branch_syn/Cacyts1 6 15 {2*pca_s} /extracell
ica_axon /branch/vm[1] /branch/Cacyts1 1 5 {2*pca_s} /extracell
ica_axon /branch/vm[2] /branch/Cacyts1 6 15 {2*pca_s} /extracell

useclock /axon/Cacyt[]/#ica 1

phototrans /rhab/ip3s1
lgtna_comp /rhab/vm /rhab/ip3s2 {rhabcyls} {gna}

echo "initializing output file"
str gaba="/branch_syn/vm[2]"
include small-output.g

reset
setcytpumpleak /soma/Cacyts1 /extracell {somacyls} {Vpmca} {kpmca} {Vncx} {kncx}
setcytpumpleak /rhab/Cacyts1 /extracell {rhabcyls} {Vpmcarhab} {kpmca} {Vncxrhab} {kncx}
setcytpumpleak /neck/Cacyts1 /extracell 1 {Vpmcarhab} {kpmca} {Vncxrhab} {kncx}
setcytpumpleak /axon/Cacyts1 /extracell {axoncyls} {Vpmcarhab} {kpmca} {Vncxaxon} {kncx}
setcytpumpleak /branch/Cacyts1 /extracell {branchcyls} {Vpmcarhab} {kpmca} {2*Vncxaxon} {kncx}
setcytpumpleak /branch_syn/Cacyts1 /extracell {branchcyls} {Vpmcarhab} {kpmca} {2*Vncxaxon} {kncx}
//check

/* light alone */
/*    setfield /stat/spike_rate peak 0.0 tau_fall 1000 decay_type 0 delay 26000

     str filenam = (filepath)@"kleakconst-icasus-light.dat"
     setfield /output/plot_out filename {filenam} initialize 1 append 0 leave_open 1

     str filenam = (filepath)@"kleakconst-icasus-light.cal"
     setfield /output/spatial filename {filenam} initialize 1 append 0 leave_open 1

     reset
     step 1000000
     step 2400000 

*/
/* decrease Gbar of vdep K currents: Kca and Ka */
float oldgka, oldgkca

oldgka={getfield /soma/vm[1]/ka Gbar}
setfield /soma/vm[1]/ka Gbar {oldgka*0.7}

for (i=1; i<=somacyls; i=i+1)
	showfield /soma/Cacyts1[{i}]/kc Gbar
	oldgkca={getfield /soma/Cacyts1[{i}]/kc Gbar}
	setfield /soma/Cacyts1[{i}]/kc Gbar {oldgkca*0.7}
	showfield /soma/Cacyts1[{i}]/kc Gbar
end

    setfield /stat/spike_rate peak 0.0 tau_fall 1000 decay_type 0 delay 26000

/*     str filenam = (filepath)@"kleakconst-icasus-k70-light.dat"
     setfield /output/plot_out filename {filenam} initialize 1 append 0 leave_open 1

     str filenam = (filepath)@"kleakconst-icasus-k70-light.cal"
     setfield /output/spatial filename {filenam} initialize 1 append 0 leave_open 1

     reset
     step 1000000
     step 2400000 
*/
/* decrease Gbar of Ca currents  */
float oldcat, oldcap, oldcas


/*for (i=1; i<=somacyls; i=i+1)
	oldcap={getfield /soma/Cacyts1[{i}]/persist_ghk_ica Pca}
	setfield /soma/Cacyts1[{i}]/persist_ghk_ica Pca {oldcap*0.7}

	oldcat={getfield /soma/Cacyts1[{i}]/trans_ghk_ica Pca}
	setfield /soma/Cacyts1[{i}]/trans_ghk_ica Pca {oldcat*0.7}

	echo oldcat={oldcat} oldcap={oldcap}
	showfield /soma/Cacyts1[{i}]/persist_ghk_ica Pca
	showfield /soma/Cacyts1[{i}]/trans_ghk_ica Pca
end
for (i=1; i<axoncyls; i=i+1)
	oldcas={getfield /axon/Cacyts1[{i}]/persist_ghk_ica Pca}
	setfield /axon/Cacyts1[{i}]/persist_ghk_ica Pca {oldcas*0.7}
end

    setfield /stat/spike_rate peak 0.0 tau_fall 1000 decay_type 0 delay 26000

     str filenam = (filepath)@"kleakconst-icasus-vdep70-light.dat"
     setfield /output/plot_out filename {filenam} initialize 1 append 0 leave_open 1

     str filenam = (filepath)@"kleakconst-icasus-vdep70-light.cal"
     setfield /output/spatial filename {filenam} initialize 1 append 0 leave_open 1

     reset
     step 1000000
     step 2400000 
*/
for (i=1; i<=somacyls; i=i+1)
	oldcap={getfield /soma/Cacyts1[{i}]/persist_ghk_ica Pca}
	setfield /soma/Cacyts1[{i}]/persist_ghk_ica Pca {oldcap*0.7}

	echo oldcat={oldcat} oldcap={oldcap}
	showfield /soma/Cacyts1[{i}]/persist_ghk_ica Pca
	showfield /soma/Cacyts1[{i}]/trans_ghk_ica Pca
end
for (i=1; i<axoncyls; i=i+1)
	oldcas={getfield /axon/Cacyts1[{i}]/persist_ghk_ica Pca}
	setfield /axon/Cacyts1[{i}]/persist_ghk_ica Pca {oldcas*0.7}
end

    setfield /stat/spike_rate peak 0.0 tau_fall 1000 decay_type 0 delay 26000

     str filenam = (filepath)@"kleakconst-icasus-cap70-light.dat"
     setfield /output/plot_out filename {filenam} initialize 1 append 0 leave_open 1

     str filenam = (filepath)@"kleakconst-icasus-cap70-light.cal"
     setfield /output/spatial filename {filenam} initialize 1 append 0 leave_open 1

     reset
     step 1000000
     step 2400000 

