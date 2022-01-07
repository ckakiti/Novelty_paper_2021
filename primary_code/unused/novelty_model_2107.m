%function novelty_model_2107
clear
close all
clc

t = 1:500;
% avoidance and approach conflict
%avoidance mouse

V0 = 100;
a = 0.01;
I = 100;
drop = 10; %drop of prediction
TPE(1) = I-V0/drop;
V(1) = V0 + a*TPE(1);
TPE(1) = I-V0;
for i = 2:max(t)
    TPE(i) = I - V(i-1)/drop; %prediction is dropped
    V(i) = V(i-1) + a*TPE(i); 
end
threat_prediction = V; 
threat_prediction(threat_prediction>100) = 100;
% threat_prediction = 100*ones(1,max(t)); %maintain

curiosity = 100 - 0.4*t; %novelty
curiosity(curiosity<0) = 0;

conflict = 100*(threat_prediction>50 & curiosity>50); %risk assessment behavior
approach = 50 + curiosity - threat_prediction;
approach(approach<0) = 0;
approach(conflict>0) = 0;

%baseline
behavior_base = zeros(1,500);
approach_base = 50 * ones(1,500);
timeWin = -499:500;

figure
subplot(3,3,1)
plot(timeWin,smooth([behavior_base,threat_prediction],20),'r-')
hold on
plot(timeWin,smooth([behavior_base, curiosity],20),'b-')
title('curiosity-threat conflict')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)

subplot(3,3,4)
plot(timeWin,smooth([behavior_base,TPE],20),'g-')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)

subplot(3,3,7)
plot(timeWin,smooth([behavior_base,conflict],20),'m-')
hold on
plot(timeWin,smooth([approach_base,approach],20),'c-')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)


%6OHDA

ba = 100; %dopamine normal baseline
V(1) = V0 + a*(-ba);
for i = 2:max(t)
    V(i) = V(i-1) + a*(-ba);
end
threat_prediction = V;   
% threat_prediction = 100 - 0.5*t; %decay because of negative TPE
threat_prediction(threat_prediction<0) = 0;
TPE = -ba * ones(1,max(t));

curiosity = 100 - 0.4*t;
curiosity(curiosity<0) = 0;

conflict = 100*(threat_prediction>50 & curiosity>50); %risk assessment behavior
approach = 50 + curiosity - threat_prediction;
approach(approach<0) = 0;
approach(conflict>0) = 0;

subplot(3,3,2)
plot(timeWin,smooth([behavior_base,threat_prediction],20),'r-')
hold on
plot(timeWin,smooth([behavior_base, curiosity],20),'b-')
title('no dopamine in TS')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)

subplot(3,3,5)
plot(timeWin,smooth([behavior_base,TPE],20),'g-')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)

subplot(3,3,8)
plot(timeWin,smooth([behavior_base,conflict],20),'m-')
hold on
plot(timeWin,smooth([approach_base,approach],20),'c-')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)


%contextual novelty

V0 = 0;
I = 0;
TPE(1) = I-V0/drop;
V(1) = V0 + a*TPE(1);
for i = 2:max(t)
    TPE(i) = I - V(i-1)/drop;
    V(i) = V(i-1) + a*TPE(i);
end
threat_prediction = V;  
threat_prediction(threat_prediction<0) = 0;

curiosity = 100 - 0.4*t;
curiosity(curiosity<0) = 0;

conflict = 100*(threat_prediction>50 & curiosity>50); %risk assessment behavior
approach = 50 + curiosity - threat_prediction;
approach(approach<0) = 0;
approach(approach>100) = 100;
approach(conflict>0) = 0;

subplot(3,3,3)
plot(timeWin,smooth([behavior_base,threat_prediction],20),'r-')
hold on
plot(timeWin,smooth([behavior_base, curiosity],20),'b-')
legend('threat prediction','curiosity')
title('contextual novelty')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)

subplot(3,3,6)
plot(timeWin,smooth([behavior_base,TPE],20),'g-')
legend('TPE')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)

subplot(3,3,9)
plot(timeWin,smooth([behavior_base,conflict],20),'m-')
hold on
plot(timeWin,smooth([approach_base,approach],20),'c-')
legend('risk assessment','approach')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)

set(gcf,'color','w')


%% risk assessment is novelty response
%avoidance mouse

V0 = 0;
a = 0.01;
I = 100;
TPE(1) = I-V0/drop;
V(1) = V0 + a*TPE(1);
for i = 2:max(t)
    TPE(i) = I-V(i-1)/drop;
    V(i) = V(i-1) + a*TPE(i);
end
threat_prediction = V; 
threat_prediction(threat_prediction>100) = 100;
        
conflict = 100 - t; %stimulus novelty
conflict(conflict<0) = 0;

curiosity = 100 - 0.4*t; %contextual novelty
curiosity(curiosity<0) = 0;

approach = 50 + curiosity - threat_prediction;
approach(approach<0) = 0;
approach(conflict>0) = 0;

figure
subplot(3,3,1)
plot(timeWin,smooth([behavior_base,threat_prediction],20),'r-')
hold on
plot(timeWin,smooth([behavior_base, conflict],20),'m-')
plot(timeWin,smooth([behavior_base, curiosity],20),'b-')
title('3 behavioral inputs')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)

subplot(3,3,4)
plot(timeWin,smooth([behavior_base,TPE],20),'g-')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)

subplot(3,3,7)
plot(timeWin,smooth([behavior_base,conflict],20),'m-')
hold on
plot(timeWin,smooth([approach_base,approach],20),'c-')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)


%6OHDA

% ablation = 0.01;
% V(1) = V0 + a*(I-V0)*ablation;
% for i = 2:max(t)
%     V(i) = V(i-1) + a*(I-V(i-1))*ablation; %threat prediction error is discounted
% end
  
ba = 100; %dopamine normal baseline
V(1) = V0 + a*(-ba);
TPE(1) = -ba;
for i = 2:max(t)
    V(i) = V(i-1) + a*(-ba);
    TPE(i) = -ba;
end
threat_prediction = V; 
threat_prediction(threat_prediction<0) = 0;
        
conflict = 100 - t; %stimulus novelty
conflict(conflict<0) = 0;

curiosity = 100 - 0.4*t; %contextual novelty
curiosity(curiosity<0) = 0;

approach = 50 + curiosity - threat_prediction;
approach(approach<0) = 0;
approach(approach>100) = 100;
approach(conflict>0) = 0;


subplot(3,3,2)
plot(timeWin,smooth([behavior_base,threat_prediction],20),'r-')
hold on
plot(timeWin,smooth([behavior_base, conflict],20),'m-')
plot(timeWin,smooth([behavior_base, curiosity],20),'b-')
title('no dopamine in TS')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)

subplot(3,3,5)
plot(timeWin,smooth([behavior_base,TPE],20),'g-')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)

subplot(3,3,8)
plot(timeWin,smooth([behavior_base,conflict],20),'m-')
hold on
plot(timeWin,smooth([approach_base,approach],20),'c-')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)


%contextual novelty
%stimulus novelty and threat prediction error = 0

threat_prediction = zeros(1,t(max(t))); 
TPE(t) = 0;

conflict = 30 - t; %stimulus novelty
conflict(conflict<0) = 0;

curiosity = 100 - 0.4*t; %contextual novelty
curiosity(curiosity<0) = 0;

approach = 50 + curiosity - threat_prediction;
approach(approach<0) = 0;
approach(approach>100) = 100;
approach(conflict>0) = 0;


subplot(3,3,3)
plot(timeWin,smooth([behavior_base,threat_prediction],20),'r-')
hold on
plot(timeWin,smooth([behavior_base, conflict],20),'m-')
plot(timeWin,smooth([behavior_base, curiosity],20),'b-')
legend('threat prediction','stimulus novelty','contextual novelty')
title('contextual novelty')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)

subplot(3,3,6)
plot(timeWin,smooth([behavior_base,TPE],20),'g-')
legend('TPE')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)

subplot(3,3,9)
plot(timeWin,smooth([behavior_base,conflict],20),'m-')
hold on
plot(timeWin,smooth([approach_base,approach],20),'c-')
legend('risk assessment','approach')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)

set(gcf,'color','w')


%% too much novelty is threat

%avoidance mouse

curiosity = 100 - 0.4*t; %novelty
curiosity(curiosity<0) = 0;

threat_prediction = 100*(curiosity>50);
% TPE = threat_prediction;
TPE = curiosity;

conflict = threat_prediction; %risk assessment behavior
approach = 50 + curiosity;
approach(approach<0) = 0;
approach(conflict>0) = 0;


figure
subplot(3,3,1)
plot(timeWin,smooth([behavior_base,threat_prediction],20),'r-')
hold on
plot(timeWin,smooth([behavior_base, curiosity],20),'b-')
title('too much novelty is threat')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)

subplot(3,3,4)
plot(timeWin,smooth([behavior_base,TPE],20),'g-')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)

subplot(3,3,7)
plot(timeWin,smooth([behavior_base,conflict],20),'m-')
hold on
plot(timeWin,smooth([approach_base,approach],20),'c-')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)


%6OHDA

% curiosity = 100 - 0.4*t; %novelty
curiosity = -100 * ones(1,max(t));
curiosity(curiosity<0) = 0;

threat_prediction = 100*(curiosity>50);
% threat_prediction = zeros(1,max(t));
% TPE = threat_prediction;
TPE = curiosity;

conflict = threat_prediction; %risk assessment behavior
approach = 50 + curiosity;
approach(approach<0) = 0;
approach(conflict>0) = 0;


subplot(3,3,2)
plot(timeWin,smooth([behavior_base,threat_prediction],20),'r-')
hold on
plot(timeWin,smooth([behavior_base, curiosity],20),'b-')
title('no dopamine in TS')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)

subplot(3,3,5)
plot(timeWin,smooth([behavior_base,TPE],20),'g-')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)

subplot(3,3,8)
plot(timeWin,smooth([behavior_base,conflict],20),'m-')
hold on
plot(timeWin,smooth([approach_base,approach],20),'c-')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)

%contextual novelty

curiosity = 60 - 0.4*t; %novelty is low in contextual novelty
curiosity(curiosity<0) = 0;

threat_prediction = 100*(curiosity>50);
% TPE = threat_prediction;
TPE = curiosity;

conflict = threat_prediction; %risk assessment behavior
approach = 50 + curiosity;
approach(approach<0) = 0;
approach(conflict>0) = 0;


subplot(3,3,3)
plot(timeWin,smooth([behavior_base,threat_prediction],20),'r-')
hold on
plot(timeWin,smooth([behavior_base, curiosity],20),'b-')
legend('too much novelty','novelty')
title('contextual novelty')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)

subplot(3,3,6)
plot(timeWin,smooth([behavior_base,TPE],20),'g-')
legend('TPE')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)

subplot(3,3,9)
plot(timeWin,smooth([behavior_base,conflict],20),'m-')
hold on
plot(timeWin,smooth([approach_base,approach],20),'c-')
legend('risk assessment','approach')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',10)

set(gcf,'color','w')


