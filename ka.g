//genesis
//ka.g

function make_ka(path, gbar)
str path
float gbar

float area
float PI = 3.14159

area = {getfield {path} len} *  PI * {getfield {path} dia}

create inf_tau_chan {path}/ka	/* units are msec, nA, uS, mV */
setfield ^ 	act_ss.min 0 \
		act_ss.max 1.0 \
		act_ss.slope -20 \
		act_ss.v0 -20.0 \
		act_ss.in_exp_power 1 \
		act_ss.out_exp_power -1 \
		act_ss.in_exp_offset 0 \
		act_ss.out_exp_offset 1 \
		act_tau.min 2.0 \
		act_tau.max 5.0 \
		act_tau.slope 10.0 \
		act_tau.v0 -23.0 \
		act_tau.in_exp_power 1 \
		act_tau.out_exp_power -1 \
		act_tau.in_exp_offset 0 \
		act_tau.out_exp_offset 1 \
		inact_ss.min 0.0  \
		inact_ss.max 1.0  \
		inact_ss.slope 8.0 \
		inact_ss.v0 -40.0 \	/* -56 for acosta-Urquidi & Crow */
		inact_ss.in_exp_power 1 \
		inact_ss.out_exp_power -1 \
		inact_ss.in_exp_offset 0 \
		inact_ss.out_exp_offset 1 \
		inact_tau.min 150.0 \	/* 115 for acosta-Urquidi & Crow */
		inact_tau.max -50.0 \	/* 0 for acosta-Urquidi & Crow */
		inact_tau.slope 6.0 \
		inact_tau.v0 -17.0 \
		inact_tau.in_exp_power 1 \
		inact_tau.out_exp_power -1 \
		inact_tau.in_exp_offset 0 \
		inact_tau.out_exp_offset 1 \
		act_power 3 \
		inact_power 1 \
		Vr -85.0 \
		Gbar  {gbar*area} 

addmsg {path} {path}/ka VOLTAGE Vm
addmsg {path}/ka {path} CHANNEL G Vr

end
