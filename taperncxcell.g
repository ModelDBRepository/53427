//CHEMESIS2.0
//taperncxcell.g

/****** set clocks, units are milliseconds *********/
setclock 0 0.005	/* Used for Calcium cytosol */
setclock 1 0.01		/* iicr and CaER, Vm, gaba A, serca and leak */
setclock 2 0.02		/* cicr, biochem rxn, gaba B, cytleak and pump */
setclock 3 0.04		/* Used for ip3*/
setclock 4 1.0		/* Used for spike generator, inject current*/
setclock 5 2.0		/* for graphs and plot_out*/
setclock 6 10.0		/* used for spatial output */

create conservepool /extracell
setfield /extracell Cinit 10 Ctot 10 Conc 10 volume 2e-4
useclock /extracell 4

   /************ set up soma *************************/
/* electrical compartment and voltage dependent channels*/
create neutral /soma
Vcomp /soma/vm[1] {somalen} {somarad} {RM} {CM} {RI} {Er} {Vinit}

/* calcium objects */
ca_buf_ip3_taper /soma {somacyls} {somashells} {somarad} {shellsize} {somalen} {ERfactor} {concen} {umole}
/*taper the soma, then make calcium release */
changeradius /soma 24 5.5e-4 2 {shellsize}	
	/* change from 6.0 to 5.5 on 8/16/02 */
changeradius /soma 23 8.0e-4 2 {shellsize}
changeradius /soma 1 4.5e-4 2 {shellsize}
changeradius /soma 2 7e-4 2 {shellsize}
makecyt2er /soma/Cacyt /soma/ip3 /soma/CaER {maxiicr} {iicrpower} {maxcicr} {cicrpower} {somashells} {somacyls} {serca} {pumppower} 1e-3
  useclock /soma/Cacyts#[]/x# 1
  useclock /soma/Cacyts#[]/iicrflux 1
  useclock /soma/Cacyts#[]/x00 2
  useclock /soma/Cacyts#[]/x01 2
  useclock /soma/Cacyts#[]/x10 2
  useclock /soma/Cacyts#[]/x11 2
  useclock /soma/Cacyts#[]/ryanflux 2
  useclock /soma/Cacyts#[]/serca 2
  useclock /soma/Cacyts#[]/leak 2

cytpumpcomp /soma/Cacyts1 /extracell pmca {somacyls} {Vpmca} {kpmca} {pmca_power} {mmole}
ncxcomp /soma/Cacyts1 /soma/vm[1] extracell 1 {somacyls} {Vncx} {kncx}
setsercaleak /soma/Cacyt /soma/CaER {somashells} {somacyls} {serca}

/* channels */
kleak_comp /soma/vm[1] /soma/Cacyts1 1 {somacyls} {gleak}
ica_ghk_comp /soma/vm[1] /soma/Cacyts1 1 {somacyls} {pca_p} {pca_t} /extracell
ih_comp /soma/vm 1 1 {g_ih}
icak_comp /soma/vm[1] /soma/Cacyts1 {somacyls} {gkca}
make_ka /soma/vm[1] {gka}

/* shunt due to electrode */ 
create leakage /soma/shunt
setfield /soma/shunt Ek 0 Gk {gshunt}
addmsg /soma/shunt /soma/vm[1] CHANNEL Gk Ek
addmsg /soma/vm[1] /soma/shunt VOLTAGE Vm

useclock /soma/vm[1] 1
useclock /soma/Cacyts1[]/pmca 2
useclock /soma/Cacyts1[]/ncx 2
useclock /soma/Cacyts1[]/kleak 3
useclock /soma/Cacyts1[]/cytleak 2
useclock /soma/shunt 3
useclock /soma/vm[1]/ih 2
useclock /soma/Cacyt[]/#ica 1
useclock /soma/Cacyt[]/kca 2
useclock /soma/vm[1]/ka 1

  /************* set up rhabdomere **********************/
        /**voltage compartment **/

create neutral /rhab
Vcomp /rhab/vm {rhablen} {rhabrad} {RM} {CM} {RI} {Er} {Vinit}
//setfield /rhab/vm Rm {RM/rhabSA} Cm {CM*rhabSA} Ra {Rcore}
setfield /rhab/vm Rm {RM/rhabSA} Cm {CM*rhabSA} Ra {RI*rhablen/rhabxarea}
ca_ip3_rhab /rhab {rhabcyls} {rhabshells} {rhabrad} {rhabrad-rhabcorerad} {rhablen} {ERfactor} {quant} {concen} {umole}
cytpumpcomp /rhab/Cacyts1 /extracell pmca {rhabcyls} {Vpmca} {kpmca} {pmca_power} {mmole}
ncxcomp /rhab/Cacyts1 /rhab/vm extracell 1 {rhabcyls} {Vncx} {kncx}
setsercaleak /rhab/Cacyt /rhab/CaER {rhabshells} {rhabcyls} {serca}
kleak_comp /rhab/vm /rhab/Cacyts1 1 {rhabcyls} {gleak}

useclock /rhab/vm 1
useclock /rhab/Cacyts1[]/pmca 2
useclock /rhab/Cacyts1[]/ncx 2
useclock /rhab/Cacyts1[]/cytleak 2
useclock /rhab/Cacyts1[]/kleak 3

  /************* create neck *************/
	/***voltage compartment **/
create neutral /neck
Vcomp /neck/vm {necklen} {neckrad} {RM} {CM} {RI} {Er} {Vinit}
ca_buf_ip3_2D /neck 1 1 {neckrad} {shellsize} {necklen} {ERfactor} {concen} {umole}
cytpumpcomp /neck/Cacyts1 /extracell pmca 1 {Vpmca} {kpmca} {pmca_power} {mmole}
ncxcomp /neck/Cacyts1 /neck/vm extracell 1 1 {Vncx} {kncx}
setsercaleak /neck/Cacyt /neck/CaER 1 1 {serca}

useclock /neck/vm 1
useclock /neck/Cacyts1[]/pmca 2
useclock /neck/Cacyts1[]/ncx 2
useclock /neck/Cacyts1[]/cytleak 2
 
   /************ set up axon *************************/
        /**voltage compartment **/

create neutral /axon
ellipse_vcomp /axon/vm {axonlen} {axonslice} {axondiama} {axondiamb}  {RM} {CM} {RI} {Er} {Vinit}
/* calcium objects */
/* change divide by 2 to divide by 4 because axondiama is diameter */
ca_buf_ip3_taper /axon {axoncyls} 1 {(axondiama+axondiamb)/4} {shellsize} {axonlen} {ERfactor} {concen} {umole}

/*taper the axon, then make calcium release */
changeradius /axon 100 4.0e-4 1 {shellsize}
	/* change from 4.5 to 4.0 on 08/16/02 */
changeradius /axon 99 2.5e-4 1 {shellsize}
	/* change from 3.0 to 2.5 on 08/16/02 */
makecyt2er /axon/Cacyt /axon/ip3 /axon/CaER {maxiicr} {iicrpower} {maxcicr} {cicrpower} 1 {axoncyls} {serca} {pumppower} 1e-3
  useclock /axon/Cacyts#[]/x# 1
  useclock /axon/Cacyts#[]/iicrflux 1
  useclock /axon/Cacyts#[]/x00 2
  useclock /axon/Cacyts#[]/x01 2
  useclock /axon/Cacyts#[]/x10 2
  useclock /axon/Cacyts#[]/x11 2
  useclock /axon/Cacyts#[]/ryanflux 2
  useclock /axon/Cacyts#[]/serca 2
  useclock /axon/Cacyts#[]/leak 2

cytpumpcomp /axon/Cacyts1 /extracell pmca {axoncyls} {Vpmca} {kpmca} {pmca_power} {mmole}
ncxcomp /axon/Cacyts1 /axon/vm[1] extracell 1 25 {Vncx} {kncx}
ncxcomp /axon/Cacyts1 /axon/vm[2] extracell 26 50 {Vncx} {kncx}
ncxcomp /axon/Cacyts1 /axon/vm[3] extracell 51 75 {Vncx} {kncx}
ncxcomp /axon/Cacyts1 /axon/vm[4] extracell 76 100 {Vncx} {kncx}
setsercaleak /axon/Cacyt /axon/CaER 1 {axoncyls} {serca}
kleak_comp /axon/vm[1] /axon/Cacyts1 1 25 {gleak}
kleak_comp /axon/vm[2] /axon/Cacyts1 26 50 {gleak}
kleak_comp /axon/vm[3] /axon/Cacyts1 51 75 {gleak}
kleak_comp /axon/vm[4] /axon/Cacyts1 76 100 {gleak}
ih_comp /axon/vm 1 {axonslice}  {g_ih}

useclock /axon/vm[] 1
useclock /axon/Cacyts1[]/pmca 2
useclock /axon/Cacyts1[]/ncx 2
useclock /axon/Cacyts1[]/cytleak 2
useclock /axon/Cacyts1[]/kleak 3
useclock /axon/vm[]/ih 2

   /************ set up terminal branches *************************/
	/* assume 1 of branches has gaba synapse, others don't */

        /**voltage compartment **/
create neutral /branch_syn
Vcomp /branch_syn/vm[1] {branchlen1} {syn_br_rad} {RM} {CM} {RI} {Er} {Vinit}
Vcomp /branch_syn/vm[2] {branchlen2} {syn_br_rad} {RM} {CM} {RI} {Er} {Vinit}

	/**calcium **/
ca_buf_ip3_2D /branch_syn {branchcyls} 1 {syn_br_rad} {shellsize} {(branchlen1+branchlen2)} {ERfactor} {concen} {umole}
cytpumpcomp /branch_syn/Cacyts1 /extracell pmca {branchcyls} {Vpmca} {kpmca} {pmca_power} {mmole}
ncxcomp /branch_syn/Cacyts1 /branch_syn/vm[1] extracell 1 5 {Vncx} {kncx}
ncxcomp /branch_syn/Cacyts1 /branch_syn/vm[2] extracell 6 15 {Vncx} {kncx}
setsercaleak /branch_syn/Cacyt /branch_syn/CaER 1 {branchcyls} {serca}

	/**calcium dependent channels**/
kleak_comp /branch_syn/vm[1] /branch_syn/Cacyts1 1 5 {gleak}
kleak_comp /branch_syn/vm[2] /branch_syn/Cacyts1 6 15 {gleak}
//ih_comp /branch_syn/vm 1 2  {g_ih}

	/**clocks **/
useclock /branch_syn/vm[] 1
useclock /branch_syn/Cacyt[]/pmca 2
useclock /branch_syn/Cacyt[]/ncx 2
useclock /branch_syn/Cacyt[]/cytleak 2
//useclock /branch_syn/vm[]/ih 2
//useclock /branch_syn/Cacyt[]/#ica 1

   /*** Branch without synapse ***/
        /**voltage compartment **/
create neutral /branch
Vcomp /branch/vm[1] {branchlen1} {syn_br_rad} {RM} {CM} {RI} {Er} {Vinit}
Vcomp /branch/vm[2] {branchlen2} {syn_br_rad} {RM} {CM} {RI} {Er} {Vinit}

	/**calcium **/
ca_buf_ip3_2D /branch {branchcyls} 1 {syn_br_rad} {shellsize} {(branchlen1+branchlen2)} {ERfactor} {concen} {umole}
cytpumpcomp /branch/Cacyts1 /extracell pmca {branchcyls} {Vpmca} {kpmca} {pmca_power} {mmole}
ncxcomp /branch/Cacyts1 /branch_syn/vm[1] extracell 1 5 {Vncx} {kncx}
ncxcomp /branch/Cacyts1 /branch_syn/vm[2] extracell 6 15 {Vncx} {kncx}
setsercaleak /branch/Cacyt /branch/CaER 1 {branchcyls} {serca}

	/**calcium dependent channels**/
kleak_comp /branch/vm[1] /branch/Cacyts1 1 5 {gleak}
kleak_comp /branch/vm[2] /branch/Cacyts1 6 15 {gleak}
//ih_comp /branch/vm 1 2  {g_ih}

	/**clocks **/
useclock /branch/vm[] 1
useclock /branch/Cacyt[]/pmca 2
useclock /branch/Cacyt[]/ncx 2
useclock /branch/Cacyt[]/cytleak 2
//useclock /branch/vm[]/ih 2
//useclock /branch/Cacyt[]/#ica 1

/******************messages between compartments ***************/
/* messages between voltage compartments */
addmsg /rhab/vm /neck/vm RAXIAL Ra previous_state
addmsg /neck/vm /rhab/vm AXIAL previous_state
addmsg /neck/vm /soma/vm[1] RAXIAL Ra previous_state
addmsg /soma/vm[1] /neck/vm AXIAL  previous_state
addmsg /soma/vm[1] /axon/vm[1] RAXIAL Ra previous_state
addmsg /axon/vm[1] /soma/vm[1]  AXIAL  previous_state
addmsg /axon/vm[{axonslice}] /branch_syn/vm[1] RAXIAL Ra previous_state
addmsg /branch_syn/vm[1] /axon/vm[{axonslice}] AXIAL previous_state
addmsg /branch_syn/vm[1] /branch_syn/vm[2] RAXIAL Ra previous_state
addmsg /branch_syn/vm[2] /branch_syn/vm[1] AXIAL previous_state
addmsg /axon/vm[{axonslice}] /branch/vm[1] RAXIAL Ra previous_state
addmsg /branch/vm[1] /axon/vm[{axonslice}] AXIAL previous_state
addmsg /branch/vm[1] /branch/vm[2] RAXIAL Ra previous_state
addmsg /branch/vm[2] /branch/vm[1] AXIAL previous_state

/* messages between rxnpool compartments */
difcyl /rhab/ip3s2[{rhabcyls}] /neck/ip3s1[1] /rhab/neck_ip3dif {ip3dif} {umole}
difcyl /neck/ip3s1[1] /soma/ip3s2[1] /neck/soma_ip3dif {ip3dif} {umole}
difcyl /soma/ip3s2[{somacyls}] /axon/ip3s1[1] /soma/axon_ip3dif {ip3dif} {umole}
difcyl /axon/ip3s1[{axoncyls}] /branch_syn/ip3s1[1] /axon/brsyn_ip3dif {ip3dif} {umole}
difcyl /axon/ip3s1[{axoncyls}] /branch/ip3s1[1] /axon/branch_ip3dif {ip3dif} {umole}

useclock /neck/soma_ip3dif 3
useclock /rhab/neck_ip3dif 3
useclock /soma/axon_ip3dif 3
useclock /axon/brsyn_ip3dif 3
useclock /axon/branch_ip3dif 3

difcyl /rhab/Cacyts2[{rhabcyls}] /neck/Cacyts1[1] /rhab/neck_Cacytdif {Cadif} {mmole}
difcyl /neck/Cacyts1[1] /soma/Cacyts2[1] /neck/soma_Cacytdif {Cadif} {mmole}
difcyl /soma/Cacyts2[{somacyls}] /axon/Cacyts1[1] /soma/axon_Cacytdif {Cadif} {mmole}
difcyl /axon/Cacyts1[{axoncyls}] /branch_syn/Cacyts1[1] /axon/brsyn_Cacytdif {Cadif} {mmole}
difcyl /axon/Cacyts1[{axoncyls}] /branch/Cacyts1[1] /axon/branch_Cacytdif {Cadif} {mmole}

/***************************************************/
/* set up statocyst as a spiker with adapting rate */

create neutral /stat
create randomspike /stat/spike
setfield /stat/spike min_amp 1.0 max_amp 1.0 rate 0.2 abs_refract 4.0
create transmitter /stat/spike_rate
setfield /stat/spike_rate peak 0.15 tau_fall 1000 decay_type 0 delay 100
addmsg /stat/spike_rate /stat/spike RATE trans_conc

useclock /stat/spike 4

/************************GABA synapse*******************/
str vpath="/branch_syn/vm[2]"
str ip3path="/branch_syn/ip3s1"

/**** make gabaa channel in the synaptic branch ****/
makegabaa {vpath} /stat/spike {g_gabaa}

echo {plctype}
/* make gabab receptor, biochem reactions */
gabab_synapse {vpath} {branchlen2/2} {syn_br_rad} {ip3path} {plctype}

/* make gabab channel */
makegabab {vpath} {vpath}/Gbg {g_gabab}

/***use clock 2 for biochemical reactions and GABA B conductance***/
useclock /branch_syn/vm[2]/# 2
useclock /branch_syn/gabaa 1
useclock /branch_syn/gabab 2
 

/* Add pulse current injection to measure input resistance before and 
	during IPSP*/
/*create pulsegen /soma/inject
setfield /soma/inject width1 200 level1 -0.5 baselevel 0 delay1 600 trig_mode 0
addmsg /soma/inject /soma/vm[1] INJECT output
useclock /soma/inject 4
*/



