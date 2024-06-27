clc;
clear all; %#ok<CLALL>
close all;
addpath(genpath(pwd));
%%
frameCount = 1;
ID=922; %ncell_ID
mu = 1;
[pss,sss]=SsGenerator.getSsSignalsByCellInfo(ID);
r=ResourceMapper();
r.createResourceGrid(mu,frameCount,false,30);

r.addSsBlockByCase('A',0:1,ID,pss,sss,round(rand(5*500,432)),round(rand(5*500,144)),0,0);

[NID2, PSSTimeSlotIndex] = CheckPSS(r.resourceGrid(1:260,9:16));
NID1 = CheckSSS(r.resourceGrid(1:260,9:16),NID2,PSSTimeSlotIndex);
NcellID = 3*NID1 + NID2;


% s=pcolor(abs(r.resourceGrid(1:260,1:80)));
s=pcolor(abs(r.resourceGrid));
s.EdgeColor='none';
grid off
a=gca();
a.YDir='normal';
xlabel('l (номер OFDM символа)')
ylabel('k (номер поднесущей)')