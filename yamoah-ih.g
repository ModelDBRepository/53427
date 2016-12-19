//genesis
//yamoah-ih.g

function make_ih(path, actv0, actslope, taumin, taumax, tauv0, tauslope, Er, gbar)
str path
float actv0, actslope, taumin, taumax, tauv0, tauslope
float Er, gbar

float area

area = {getfield {path} Cm}/{CM}
/* use this formula because Cm takes into account elliptical cross section */

create inf_tau_chan {path}/ih	/* units are msec, nA, uS, mV */
setfield ^ 	act_ss.min 0 \
		act_ss.max 1.0 \
		act_ss.slope {actslope} \
		act_ss.v0 {actv0} \
		act_ss.in_exp_power 1 \
		act_ss.out_exp_power -1 \
		act_ss.in_exp_offset 0 \
		act_ss.out_exp_offset 1 \
		act_tau.min {taumin} \
		act_tau.max {taumax} \
		act_tau.slope {tauslope} \
		act_tau.v0 {tauv0} \
		act_tau.in_exp_power 1 \
		act_tau.out_exp_power -1 \
		act_tau.in_exp_power 1 \
		act_tau.in_exp_offset 0 \
		act_tau.out_exp_offset 1 \
		act_power 1 \
		inact_power 0 \
		Vr {Er} \
		Gbar   {gbar*area}
end

/******************************************************************/

function ih_comp (vpath, startcyl, endcyl, gbar)
str vpath
int startcyl, endcyl

int i

  for (i=startcyl; i<=endcyl; i=i+1)
//   make_ih {vpath}[{i}] -74.0 15.5 25.0 240.0 -45.0 -18.0 -36.0 {gbar}
   make_ih {vpath}[{i}] -74.0 15.5 50.0 480.0 -45.0 -18.0 -36.0 {gbar}
   addmsg {vpath}[{i}] {vpath}[{i}]/ih VOLTAGE Vm
   addmsg {vpath}[{i}]/ih {vpath}[{i}] CHANNEL G Vr

 end
end

