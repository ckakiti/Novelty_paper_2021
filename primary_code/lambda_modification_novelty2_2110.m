function lambda_modification_novelty2_2110

% similar to 2005_2 but for novelty with a second cue
% different system for first order and second order
% this is similar to lambda1911 but convoluted with kernels

clear

V = []; W = []; V2 = []; W2 = []; delta = [];
t_step = 10; %timestep per second
t_max = 8*t_step; %time for trial end
t_stim = 1*t_step; %time for cue
t_rew = 7*t_step; %time for reward
n_trials = 200; %trial number
% gamma = 0.9;
gamma = 1;

alpha = .01; %Rescorla-Wagner with TD
lambda = 1;

% alpha = .06; %use this for Ryu figure
% lambda = 0.75;

% alpha = .7; %1-step TD
% lambda = 0;

% x(i,t): stimulus representation
% when light comes on at t = k; x(i+k,i+k)=1;
 
T = ([1:t_max]-t_stim)/t_step; %actual time for plot

% stimulus
x = zeros(t_max,t_max);
for i = 1:t_max-t_stim
    x(i+t_stim,i+t_stim) = 1;
end

% weight
w = zeros(t_max,1);
% w(t_stim:t_rew)=-0.5; %puff reversal
% w(t_stim:t_rew)=0.2; %novelty
% w(t_stim:t_rew)=1; %novelty
 
% reward function
r = zeros(t_max,1); % reward function
% r(t_rew) = 1;
r(t_rew) = 1; %no outcome
 
% Value function
for t = 1:t_max
    v(t) = (sum(w.*x(:,t)));
end
V = [V; v];

for n = 1:n_trials
    et = zeros(t_max,1); %initialize eligibility traces
    for t = 1:t_max-1
         v(t) = (sum(w.*x(:,t)));
         v(t+1) = (sum(w.*x(:,t+1)));
        d = r(t)+gamma*v(t+1)-v(t); % calculate delta
%         et = gamma*lambda*et + alpha*(x(:,t)); %old
%         w = w + d*et;
        et = gamma*lambda*et + (x(:,t));
        w = w + alpha*d*et;
        
        delta(n,t) = d;
    end
    W(n,:) = w;
    V = [V;v];
end

% figure
% subplot(1,2,1)
% surf(delta)
% colorbar
% lim=caxis;
% caxis([0 0.2])
% xlabel('Time')
% ylabel('Trials')
% title('TD error')
% % h=gca;
% % h.XTick = -2000:2000:6000;
% % h.XTickLabel = {-2:2:6};
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)
% set(gcf,'color','w')
% 
% subplot(1,2,2)
% surf(V)
% colorbar
% caxis([-1 1])
% xlabel('Time')
% ylabel('Trials')
% title('Value')
% % h=gca;
% % h.XTick = -2000:2000:6000;
% % h.XTickLabel = {-2:2:6};
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',20)
% set(gcf,'color','w')
% 
% figure
% colormap yellowblue
% imagesc(delta)
% colorbar
% lim=caxis;
% % caxis([-0.2 0.2])
% caxis([-.5 .5])
% % axis([9 31 0 40])
% xlabel('Time')
% ylabel('Trials')
% title(sprintf('gamma = %1.2f; alpha = %1.2f; lambda = %1.2f',gamma,alpha,lambda))
% box off
% set(gca,'tickdir','out')
% set(gca,'TickLength',2*(get(gca,'TickLength')))
% set(gca,'FontSize',15)
% set(gcf,'color','w')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% second order

alpha = .01; %Rescorla-Wagner with TD
lambda = 1;

% stimulus
x = zeros(t_max,t_max);
for i = 1:t_max-t_stim
    x(i+t_stim,i+t_stim) = 1;
end

% weight
w = zeros(t_max,1);
% w(t_stim:t_rew)=-0.5; %puff reversal
% w(t_stim:t_rew)=0.2; %novelty
% w(t_stim:t_rew)=0.5; %novelty
 
% % reward function
% r = zeros(t_max,1); % reward function
% % r(t_rew) = 1;
% r(t_rew) = 0; %no outcome
 
% Value function
for t = 1:t_max
    v(t) = (sum(w.*x(:,t)));
end
V2 = [V2; v];

for n = 1:n_trials
    et = zeros(t_max,1); %initialize eligibility traces
    % reward function
    r = zeros(t_max,1); % reward function
    r(t_rew) = delta(n,t_stim); %use delta in 1st order
    for t = 1:t_max-1
         v(t) = (sum(w.*x(:,t)));
         v(t+1) = (sum(w.*x(:,t+1)));
        d = r(t)+gamma*v(t+1)-v(t); % calculate delta
%         et = gamma*lambda*et + alpha*(x(:,t)); %old
%         w = w + d*et;
        et = gamma*lambda*et + (x(:,t));
        w = w + alpha*d*et;
        
        delta2(n,t) = d;
    end
    W2(n,:) = w;
    V2 = [V2;v];
end

figure
subplot(1,2,1)
surf(delta2)
colorbar
lim=caxis;
caxis([0 0.2])
xlabel('Time')
ylabel('Trials')
title('TD error')
% h=gca;
% h.XTick = -2000:2000:6000;
% h.XTickLabel = {-2:2:6};
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

subplot(1,2,2)
surf(V2)
colorbar
caxis([-1 1])
xlabel('Time')
ylabel('Trials')
title('Value')
% h=gca;
% h.XTick = -2000:2000:6000;
% h.XTickLabel = {-2:2:6};
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

figure
colormap yellowblue
imagesc(delta2)
colorbar
lim=caxis;
% caxis([-0.2 0.2])
caxis([-.5 .5])
% axis([9 31 0 40])
xlabel('Time')
ylabel('Trials')
title(sprintf('gamma = %1.2f; alpha = %1.2f; lambda = %1.2f',gamma,alpha,lambda))
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',15)
set(gcf,'color','w')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('color','w')
subplot(1,2,1)
winterColors = colormap(winter(9));
plot(T(2:end),[delta(1,1:(end-1)) 0],'Color',winterColors(1,:))
hold on
plot(T(2:end),[delta(21,1:(end-1)) 0],'Color',winterColors(2,:))
plot(T(2:end),[delta(41,1:(end-1)) 0],'Color',winterColors(3,:))
plot(T(2:end),[delta(61,1:(end-1)) 0],'Color',winterColors(4,:))
plot(T(2:end),[delta(81,1:(end-1)) 0],'Color',winterColors(5,:))
plot(T(2:end),[delta(101,1:(end-1)) 0],'Color',winterColors(6,:))
plot(T(2:end),[delta(121,1:(end-1)) 0],'Color',winterColors(7,:))
plot(T(2:end),[delta(141,1:(end-1)) 0],'Color',winterColors(8,:))
plot(T(2:end),[delta(161,1:(end-1)) 0],'Color',winterColors(9,:))
title(sprintf('gamma = %1.2f; alpha = %1.2f; lambda = %1.2f',gamma,alpha,lambda))
xlabel('Time (s)')
ylabel('TD error')
box off
set(gca,'tickdir','out')
set(gca,'ylim',[0 1])
set(gca,'xtick',[0 2 4 6])
axis([-1 4 -0.1 1])
set(gca,'FontSize',15)

subplot(1,2,2)
winterColors = colormap(winter(9));
plot(T,[V2(1,1:(end-1)) 0],'Color',winterColors(1,:))
hold on
plot(T,[V2(21,1:(end-1)) 0],'Color',winterColors(2,:))
plot(T,[V2(41,1:(end-1)) 0],'Color',winterColors(3,:))
plot(T,[V2(61,1:(end-1)) 0],'Color',winterColors(4,:))
plot(T,[V2(81,1:(end-1)) 0],'Color',winterColors(5,:))
plot(T,[V2(101,1:(end-1)) 0],'Color',winterColors(6,:))
plot(T,[V2(121,1:(end-1)) 0],'Color',winterColors(7,:))
plot(T,[V2(141,1:(end-1)) 0],'Color',winterColors(8,:))
plot(T,[V2(161,1:(end-1)) 0],'Color',winterColors(9,:))
title(sprintf('gamma = %1.2f; alpha = %1.2f; lambda = %1.2f',gamma,alpha,lambda))
xlabel('Time (s)')
ylabel('threat prediction')
box off
set(gca,'tickdir','out')
set(gca,'ylim',[0 1])
set(gca,'xtick',[0 2 4 6])
axis([-1 4 -0.1 1])
set(gca,'FontSize',15)

figure('color','w')
subplot(1,2,1)
plot(delta(:,t_stim),'-')
title('TS dopamine')
xlabel('trial')
ylabel('response at retreat')
box off
set(gca,'ylim',[0 1])
set(gca,'tickdir','out')
set(gca,'FontSize',15)

subplot(1,2,2)
plot(V2(:,t_stim+1),'-')
title('threat prediction')
xlabel('trial')
ylabel('V')
box off
set(gca,'ylim',[0 1])
set(gca,'tickdir','out')
set(gca,'FontSize',15)

