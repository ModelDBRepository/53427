include total-currents.g

create diffamp /rhab/kleak_total
setfield /rhab/kleak_total gain 1 saturation 10000
create diffamp /rhab/gleak_total
setfield /rhab/gleak_total gain 1 saturation 10000
create diffamp /rhab/lgtna_total
setfield /rhab/lgtna_total gain 1 saturation 10000
create diffamp /rhab/glgtna_total
setfield /rhab/glgtna_total gain 1 saturation 10000
create diffamp /rhab/cashell
setfield ^ gain 1.0 saturation 10

for (i=1; i<=rhabcyls; i=i+1)
  	addmsg /rhab/Cacyts1[{i}] /rhab/cashell PLUS Conc
        addmsg /rhab/ip3s2[{i}]/lgtna /rhab/glgtna_total PLUS G
        addmsg /rhab/ip3s2[{i}]/lgtna /rhab/lgtna_total PLUS I
        addmsg /rhab/Cacyts1[{i}]/kleak /rhab/kleak_total PLUS I
        addmsg /rhab/Cacyts1[{i}]/kleak /rhab/gleak_total PLUS G
end

create diffamp /axon/casust
setfield /axon/casust gain 1 saturation 10000
for (i=1; i<=axoncyls; i=i+1)
	addmsg /axon/Cacyts1[{i}] /axon/casust PLUS Conc
end

create asc_file /output/plot_out
addmsg /soma/vm[1] /output/plot_out SAVE Vm 
addmsg /rhab/vm /output/plot_out SAVE Vm 
addmsg /branch_syn/vm[2] /output/plot_out SAVE Vm 
addmsg /branch_syn/vm[2]/gabab /output/plot_out SAVE I 
addmsg /branch_syn/vm[2]/gabaa /output/plot_out SAVE I 
addmsg /stat/spike /output/plot_out SAVE state 

addmsg /branch_syn/Cacyts1[5]  /output/plot_out SAVE Conc 
addmsg /branch/Cacyts1[5]  /output/plot_out SAVE Conc
addmsg /soma/cashell /output/plot_out SAVE output
addmsg /rhab/cashell /output/plot_out SAVE output
addmsg /branch_syn/ip3s1[5] /output/plot_out SAVE Conc
addmsg /axon/ip3s1[100] /output/plot_out SAVE Conc

addmsg /axon/vm[1]/kleak_total  /output/plot_out SAVE output 
addmsg /axon/vm[2]/kleak_total /output/plot_out SAVE output 
addmsg /axon/vm[3]/kleak_total  /output/plot_out SAVE output 
addmsg /axon/vm[4]/kleak_total  /output/plot_out SAVE output
addmsg /axon/vm[1]/gkleak_total  /output/plot_out SAVE output 
addmsg /axon/vm[2]/gkleak_total /output/plot_out SAVE output 
addmsg /axon/vm[3]/gkleak_total  /output/plot_out SAVE output 
addmsg /axon/vm[4]/gkleak_total  /output/plot_out SAVE output

addmsg /rhab/lgtna_total /output/plot_out SAVE output
addmsg /rhab/glgtna_total /output/plot_out SAVE output
addmsg /rhab/kleak_total /output/plot_out SAVE output
addmsg /rhab/gleak_total /output/plot_out SAVE output

addmsg /soma/vm[1]/ih /output/plot_out SAVE I
addmsg /soma/vm[1]/ka /output/plot_out SAVE I
addmsg /soma/vm[1]/pca /output/plot_out SAVE output
addmsg /soma/vm[1]/tca /output/plot_out SAVE output
addmsg /soma/vm[1]/kc_total /output/plot_out SAVE output
addmsg /soma/vm[1]/kleak_total /output/plot_out SAVE output
addmsg /soma/vm[1]/gleak_total /output/plot_out SAVE output
addmsg /soma/vm[1]/ncx /output/plot_out SAVE output
addmsg /soma/vm[1]/pmca /output/plot_out SAVE output
addmsg /axon/casust /output/plot_out SAVE output

useclock /output/plot_out 5


create asc_file /output/spatial
addmsg /axon/Cacyts1[100] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[98] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[96] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[94] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[92] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[90] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[88] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[86] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[84] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[82] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[80] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[78] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[76] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[74] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[72] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[70] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[68] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[66] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[64] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[62] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[60] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[58] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[56] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[54] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[52] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[50] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[48] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[46] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[44] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[42] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[40] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[38] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[36] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[34] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[32] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[30] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[28] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[26] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[24] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[22] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[20] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[18] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[16] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[14] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[12] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[10] /output/spatial SAVE Conc
addmsg /axon/Cacyts1[8] /output/spatial SAVE Conc	
addmsg /axon/Cacyts1[6] /output/spatial SAVE Conc	
addmsg /axon/Cacyts1[4] /output/spatial SAVE Conc	
addmsg /axon/Cacyts1[2] /output/spatial SAVE Conc	
addmsg /soma/Cacyts2[24] /output/spatial SAVE Conc
addmsg /soma/Cacyts2[22] /output/spatial SAVE Conc
addmsg /soma/Cacyts2[20] /output/spatial SAVE Conc
addmsg /soma/Cacyts2[18] /output/spatial SAVE Conc
addmsg /soma/Cacyts2[16] /output/spatial SAVE Conc
addmsg /soma/Cacyts2[14] /output/spatial SAVE Conc
addmsg /soma/Cacyts2[12] /output/spatial SAVE Conc
addmsg /soma/Cacyts2[10] /output/spatial SAVE Conc
addmsg /soma/Cacyts2[8] /output/spatial SAVE Conc
addmsg /soma/Cacyts2[6] /output/spatial SAVE Conc
addmsg /soma/Cacyts2[4] /output/spatial SAVE Conc
addmsg /soma/Cacyts2[2] /output/spatial SAVE Conc
addmsg /rhab/Cacyts2[12] /output/spatial SAVE Conc
addmsg /rhab/Cacyts2[10] /output/spatial SAVE Conc
addmsg /rhab/Cacyts2[8] /output/spatial SAVE Conc
addmsg /rhab/Cacyts2[6] /output/spatial SAVE Conc
addmsg /rhab/Cacyts2[4] /output/spatial SAVE Conc
addmsg /rhab/Cacyts2[2] /output/spatial SAVE Conc

useclock /output/spatial 6
