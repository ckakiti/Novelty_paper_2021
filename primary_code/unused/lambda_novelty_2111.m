function lambda_novelty_2111

% similar to 2110, but behavioral output was added
% similar to lambda_modification_novelty_2110, but for a composite figure
% similar to 2005_2 but for novelty with a second cue
% this is similar to lambda1911

%% only one order (object possesses threat)

clear
initial = 2;

V = []; W = [];
t_step = 10; %timestep per second
t_max = 8*t_step; %time for trial end
t_stim = 1*t_step; %time for cue
% t_stim2 = 7*t_step; %time for cue2
t_rew = 7*t_step; %time for reward
n_trials = 500; %trial number
gamma = 0.98;

% alpha = .01; %Rescorla-Wagner with TD
% lambda = 1;

alpha = .02; 
lambda = 0.9;

% alpha = .7; %1-step TD
% lambda = 0;
 
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
% w(t_stim:t_rew)=0.5; %novelty
 
% reward function
r = zeros(t_max,1); % reward function
% r(t_rew) = 1;
r(t_rew) = initial; %threat
 
% Value function
for t = 1:t_max
    v(t) = (sum(w.*x(:,t)));
end
V = [V; v];

for n = 1:n_trials
    et = zeros(t_max,1); %initialize eligibility traces
    et2 = zeros(t_max,1); %initialize eligibility traces
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

figure
subplot(1,5,1)
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
legend('trial1','trial21','trial41','trial61','trial81','trial101','trial121','trial141','trial161')
xlabel('Time (s)')
% ylabel('TD error')
% title('basic classical conditioning')
title('TD error')
box off
set(gca,'tickdir','out')
set(gca,'ylim',[0 1])
set(gca,'xtick',[0 2 4 6])
axis([-1 8 -0.1 2])
set(gca,'FontSize',10)

subplot(1,5,2)
winterColors = colormap(winter(9));
plot(T,[V(1,1:(end-1)) 0],'Color',winterColors(1,:))
hold on
plot(T,[V(21,1:(end-1)) 0],'Color',winterColors(2,:))
plot(T,[V(41,1:(end-1)) 0],'Color',winterColors(3,:))
plot(T,[V(61,1:(end-1)) 0],'Color',winterColors(4,:))
plot(T,[V(81,1:(end-1)) 0],'Color',winterColors(5,:))
plot(T,[V(101,1:(end-1)) 0],'Color',winterColors(6,:))
plot(T,[V(121,1:(end-1)) 0],'Color',winterColors(7,:))
plot(T,[V(141,1:(end-1)) 0],'Color',winterColors(8,:))
plot(T,[V(161,1:(end-1)) 0],'Color',winterColors(9,:))
xlabel('Time (s)')
title('threat prediction')
box off
set(gca,'tickdir','out')
set(gca,'ylim',[0 1])
set(gca,'xtick',[0 2 4 6])
axis([-1 8 -0.1 2])
set(gca,'FontSize',10)


subplot(1,5,3)
plot(delta(:,t_rew),'-')
axis([0 500 -0.5 2])
xlabel('trial')
title('TD error at object')
box off
% set(gca,'ylim',[0 1])
set(gca,'tickdir','out')
set(gca,'FontSize',10)

subplot(1,5,4)
plot(0:500,initial*ones(1,501),'-')
title('threat')
xlabel('trial')
title('threat at object')
box off
set(gca,'xlim',[0 500])
set(gca,'tickdir','out')
set(gca,'FontSize',10)
set(gcf,'color','w')

subplot(1,5,5)
plot(V(:,t_stim+40),'-')
title('threat prediction at 4s')
xlabel('trial')
box off
set(gca,'xlim',[0 500])
set(gca,'tickdir','out')
set(gca,'FontSize',10)
set(gcf,'color','w')


% %% uncertainty
% % initial estimation = stim salience
% % initial estimation uncertainty = 1 (standard normal distribution)
% % measurement uncertainty = 1
% % estimation uncertainty pp(n) = (1-K)*pp(n-1)
% % K = pp/(pp + measurement uncertainty)
% 
% measure = 1; %measurement uncertainty
% pp = NaN(1,n_trials);
% pp(1) = 1; %initial estimation uncertainty
% for n = 1:n_trials
%     K = pp(n)/(pp(n) + measure);
%     pp(n+1) = (1-K)*pp(n);
% end
% 
% % subplot(5,5,5*(initial_n-1)+4)
% % plot(pp,'-')
% % % title('estimation uncertainty')
% % xlabel('trial')
% % ylabel('variance')
% % box off
% % set(gca,'ylim',[0 1])
% % set(gca,'tickdir','out')
% % set(gca,'FontSize',15)
% 
% m_plot = V(:,t_stim+40);
% s_plot = sqrt(2*pp); % 95.4%
% plotWin = 1:501;
% subplot(length(initial),4,4*(initial_n-1)+4)
% errorbar_patch(plotWin,m_plot',s_plot,'b');
% xlabel('trial')
% ylabel('TP')
% box off
% set(gca,'ylim',[0 1])
% set(gca,'tickdir','out')
% set(gca,'FontSize',15)
% set(gcf,'color','w')
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
% initial = [0, 0.5, 1, 2];
initial = 0:0.1:2;
V_all = []; delta_all = [];

% scrsz = get(groot,'ScreenSize');
% figure('Position',[1 scrsz(4)/1.5 scrsz(3)/1.5 scrsz(4)/1.5])

for initial_n = 1:length(initial)

%% second order (threat prediction is initialized with shaping bonus)

V = []; W = []; W2 = []; delta = [];
t_step = 10; %timestep per second
t_max = 30*t_step; %time for trial end
t_stim = 1*t_step; %time for cue
t_stim2 = 7*t_step; %time for cue2
t_rew = 29*t_step; %time for reward
n_trials = 500; %trial number
gamma = 0.98;

% alpha = .01; %Rescorla-Wagner with TD
% lambda = 1;

alpha = .02; 
lambda = 0.9;

% alpha = .7; %1-step TD
% lambda = 0;
 
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
% w(t_stim:t_rew)=0.5; %novelty

% stimulus2
x2 = zeros(t_max,t_max);
for i = 1:t_max-t_stim2
    x2(i+t_stim2,i+t_stim2) = 1;
end

% weight2
w2 = zeros(t_max,1);
% w(t_stim:t_rew)=-0.5; %puff reversal
% w(t_stim:t_rew)=0.2; %novelty
w2(t_stim2:t_rew)=initial(initial_n); %initialiing value
 
% reward function
r = zeros(t_max,1); % reward function
% r(t_rew) = 1;
r(t_rew) = 0; %extinction
 
% Value function
for t = 1:t_max
    v(t) = (sum(w.*x(:,t))) + (sum(w2.*x2(:,t)));
end
V = [V; v];

for n = 1:n_trials
    et = zeros(t_max,1); %initialize eligibility traces
    et2 = zeros(t_max,1); %initialize eligibility traces
    for t = 1:t_max-1
         v(t) = (sum(w.*x(:,t))) + (sum(w2.*x2(:,t)));
         v(t+1) = (sum(w.*x(:,t+1))) + (sum(w2.*x2(:,t+1)));
        d = r(t)+gamma*v(t+1)-v(t); % calculate delta
        et = gamma*lambda*et + (x(:,t));
        et2 = gamma*lambda*et2 + (x2(:,t));
        w = w + alpha*d*et;
        w2 = w2 + alpha*d*et2;
        
        delta(n,t) = d;
    end
    W(n,:) = w;
    W2(n,:) = w2;
    V = [V;v];
end


%% uncertainty
% initial estimation = stim salience
% initial estimation uncertainty = 1 (standard normal distribution)
% measurement uncertainty = 1
% estimation uncertainty pp(n) = (1-K)*pp(n-1)
% K = pp/(pp + measurement uncertainty)

measure = 1; %measurement uncertainty
pp = NaN(1,n_trials);
pp(1) = 1; %initial estimation uncertainty
for n = 1:n_trials
    K = pp(n)/(pp(n) + measure);
    pp(n+1) = (1-K)*pp(n);
end
    
V_all{initial_n} = V;
delta_all{initial_n} = delta;

end

scrsz = get(groot,'ScreenSize');
figure('Position',[1 scrsz(4)/1.5 scrsz(3)/1.5 scrsz(4)/1.5])

initial_plot = [1 11 21]; %bonus 0, 1, 2
for initial_n = 1:length(initial_plot)
subplot(length(initial_plot),5,5*(initial_n-1)+1)
winterColors = colormap(winter(9));
plot(T(2:end),[delta_all{initial_plot(initial_n)}(1,1:(end-1)) 0],'Color',winterColors(1,:))
hold on
plot(T(2:end),[delta_all{initial_plot(initial_n)}(21,1:(end-1)) 0],'Color',winterColors(2,:))
plot(T(2:end),[delta_all{initial_plot(initial_n)}(41,1:(end-1)) 0],'Color',winterColors(3,:))
plot(T(2:end),[delta_all{initial_plot(initial_n)}(61,1:(end-1)) 0],'Color',winterColors(4,:))
plot(T(2:end),[delta_all{initial_plot(initial_n)}(81,1:(end-1)) 0],'Color',winterColors(5,:))
plot(T(2:end),[delta_all{initial_plot(initial_n)}(101,1:(end-1)) 0],'Color',winterColors(6,:))
plot(T(2:end),[delta_all{initial_plot(initial_n)}(121,1:(end-1)) 0],'Color',winterColors(7,:))
plot(T(2:end),[delta_all{initial_plot(initial_n)}(141,1:(end-1)) 0],'Color',winterColors(8,:))
plot(T(2:end),[delta_all{initial_plot(initial_n)}(161,1:(end-1)) 0],'Color',winterColors(9,:))
xlabel('Time (s)')
ylabel('TD error')
title(initial(initial_plot(initial_n)))
box off
set(gca,'tickdir','out')
set(gca,'ylim',[0 1])
set(gca,'xtick',[0 2 4 6])
axis([-1 8 -0.1 2])
set(gca,'FontSize',10)

subplot(length(initial_plot),5,5*(initial_n-1)+2)
winterColors = colormap(winter(9));
plot(T,[V_all{initial_plot(initial_n)}(1,1:(end-1)) 0],'Color',winterColors(1,:))
hold on
plot(T,[V_all{initial_plot(initial_n)}(21,1:(end-1)) 0],'Color',winterColors(2,:))
plot(T,[V_all{initial_plot(initial_n)}(41,1:(end-1)) 0],'Color',winterColors(3,:))
plot(T,[V_all{initial_plot(initial_n)}(61,1:(end-1)) 0],'Color',winterColors(4,:))
plot(T,[V_all{initial_plot(initial_n)}(81,1:(end-1)) 0],'Color',winterColors(5,:))
plot(T,[V_all{initial_plot(initial_n)}(101,1:(end-1)) 0],'Color',winterColors(6,:))
plot(T,[V_all{initial_plot(initial_n)}(121,1:(end-1)) 0],'Color',winterColors(7,:))
plot(T,[V_all{initial_plot(initial_n)}(141,1:(end-1)) 0],'Color',winterColors(8,:))
plot(T,[V_all{initial_plot(initial_n)}(161,1:(end-1)) 0],'Color',winterColors(9,:))
xlabel('Time (s)')
ylabel('TP')
box off
set(gca,'tickdir','out')
set(gca,'ylim',[0 1])
set(gca,'xtick',[0 2 4 6])
axis([-1 8 -0.1 2])
set(gca,'FontSize',10)


subplot(length(initial_plot),5,5*(initial_n-1)+3)
plot(delta_all{initial_plot(initial_n)}(:,t_stim2),'-')
axis([0 500 -0.5 2])
xlabel('trial')
ylabel('TD error at object')
box off
% set(gca,'ylim',[0 1])
set(gca,'tickdir','out')
set(gca,'FontSize',10)

% subplot(1,4,2)
% plot(V(:,t_stim+40),'-')
% title('threat prediction')
% xlabel('trial')
% ylabel('V at 4s')
% box off
% set(gca,'ylim',[0 1])
% set(gca,'tickdir','out')
% set(gca,'FontSize',15)

% subplot(5,5,5*(initial_n-1)+4)
% plot(pp,'-')
% % title('estimation uncertainty')
% xlabel('trial')
% ylabel('variance')
% box off
% set(gca,'ylim',[0 1])
% set(gca,'tickdir','out')
% set(gca,'FontSize',15)

m_plot = V_all{initial_plot(initial_n)}(:,t_stim+61);
s_plot = 2*sqrt(pp); % 95.4%
plotWin = 1:501;
subplot(length(initial_plot),5,5*(initial_n-1)+4)
errorbar_patch(plotWin,m_plot',s_plot,'b');
axis([0 500 0 1])
xlabel('trial')
ylabel('TP at object')
box off
set(gca,'ylim',[0 1])
set(gca,'tickdir','out')
set(gca,'FontSize',10)
set(gcf,'color','w')

m_plot = V_all{initial_plot(initial_n)}(:,t_stim+40);
s_plot = 2*sqrt(pp); % 95.4%
plotWin = 1:501;
subplot(length(initial_plot),5,5*(initial_n-1)+5)
errorbar_patch(plotWin,m_plot',s_plot,'b');
axis([0 500 0 1])
xlabel('trial')
ylabel('TP at 4')
box off
set(gca,'ylim',[0 1])
set(gca,'tickdir','out')
set(gca,'FontSize',10)
set(gcf,'color','w')

end

figure
subplot(1,3,1)
% plot(pp,'-')
plot(2*sqrt(pp),'-')
axis([0 500 0 2])
title('threat uncertainty')
xlabel('trial')
ylabel('2*std')
box off
set(gca,'ylim',[0 1])
set(gca,'tickdir','out')
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(1,3,2)
x = -5:0.1:5;
% m = delta(1,t_stim2); %last setting (bonus 2)
y1 = normpdf(x,V(1,t_stim+40),pp(1)); %last setting (bonus 2)
y2 = normpdf(x,0,measure);
% y2 = normpdf(x,m(1,t_stim2)+V(1,t_stim2),measure);
plot(x,y1)
hold on
plot(x,y2)
legend('estimation','measurement')
title('trial 1')
xlabel('threat')
ylabel('pdf')
box off
set(gca,'tickdir','out')
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(1,3,3)
x = -5:0.1:5;
m = delta(100,t_stim2);
y1 = normpdf(x,V(100,t_stim+40),pp(100));
y2 = normpdf(x,0,measure);
plot(x,y1)
hold on
plot(x,y2)
legend('estimation','measurement')
title('trial 100')
xlabel('threat')
ylabel('pdf')
box off
set(gca,'tickdir','out')
set(gca,'FontSize',15)
set(gcf,'color','w')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %% familiar
% 
% V = []; W = []; W2 = [];
% t_step = 10; %timestep per second
% t_max = 30*t_step; %time for trial end
% t_stim = 1*t_step; %time for cue
% t_stim2 = 7*t_step; %time for cue2
% t_rew = 29*t_step; %time for reward
% n_trials = 500; %trial number
% gamma = 0.98;
% 
% % alpha = .01; %Rescorla-Wagner with TD
% % lambda = 1;
% 
% alpha = .015; 
% lambda = 0.9;
% 
% % alpha = .7; %1-step TD
% % lambda = 0;
%  
% T = ([1:t_max]-t_stim)/t_step; %actual time for plot
% 
% % stimulus
% x = zeros(t_max,t_max);
% for i = 1:t_max-t_stim
%     x(i+t_stim,i+t_stim) = 1;
% end
% 
% % weight
% w = zeros(t_max,1);
% % w(t_stim:t_rew)=-0.5; %puff reversal
% % w(t_stim:t_rew)=0.2; %novelty
% % w(t_stim:t_rew)=0.5; %novelty
% 
% % stimulus2
% x2 = zeros(t_max,t_max);
% for i = 1:t_max-t_stim2
%     x2(i+t_stim2,i+t_stim2) = 1;
% end
% 
% % weight2
% initial = w2(t_stim2:t_rew); %from 1st round
% w2 = zeros(t_max,1);
% % w(t_stim:t_rew)=-0.5; %puff reversal
% % w(t_stim:t_rew)=0.2; %novelty
% w2(t_stim2:t_rew)=initial; %initialiing value
%  
% % reward function
% r = zeros(t_max,1); % reward function
% % r(t_rew) = 1;
% r(t_rew) = 0; %extinction
%  
% % Value function
% for t = 1:t_max
%     v(t) = (sum(w.*x(:,t))) + (sum(w2.*x2(:,t)));
% end
% V = [V; v];
% 
% for n = 1:n_trials
%     et = zeros(t_max,1); %initialize eligibility traces
%     et2 = zeros(t_max,1); %initialize eligibility traces
%     for t = 1:t_max-1
%          v(t) = (sum(w.*x(:,t))) + (sum(w2.*x2(:,t)));
%          v(t+1) = (sum(w.*x(:,t+1))) + (sum(w2.*x2(:,t+1)));
%         d = r(t)+gamma*v(t+1)-v(t); % calculate delta
% %         et = gamma*lambda*et + alpha*(x(:,t)); %old
% %         w = w + d*et;
%         et = gamma*lambda*et + (x(:,t));
%         et2 = gamma*lambda*et2 + (x2(:,t));
%         w = w + alpha*d*et;
%         w2 = w2 + alpha*d*et2;
%         
%         delta(n,t) = d;
%     end
%     W(n,:) = w;
%     W2(n,:) = w2;
%     V = [V;v];
% end
% 
% figure
% subplot(1,4,1)
% winterColors = colormap(winter(9));
% plot(T(2:end),[delta(1,1:(end-1)) 0],'Color',winterColors(1,:))
% hold on
% plot(T(2:end),[delta(21,1:(end-1)) 0],'Color',winterColors(2,:))
% plot(T(2:end),[delta(41,1:(end-1)) 0],'Color',winterColors(3,:))
% plot(T(2:end),[delta(61,1:(end-1)) 0],'Color',winterColors(4,:))
% plot(T(2:end),[delta(81,1:(end-1)) 0],'Color',winterColors(5,:))
% plot(T(2:end),[delta(101,1:(end-1)) 0],'Color',winterColors(6,:))
% plot(T(2:end),[delta(121,1:(end-1)) 0],'Color',winterColors(7,:))
% plot(T(2:end),[delta(141,1:(end-1)) 0],'Color',winterColors(8,:))
% plot(T(2:end),[delta(161,1:(end-1)) 0],'Color',winterColors(9,:))
% xlabel('Time (s)')
% ylabel('TD error')
% title(initial)
% box off
% set(gca,'tickdir','out')
% set(gca,'ylim',[0 1])
% set(gca,'xtick',[0 2 4 6])
% axis([-1 8 -0.1 1])
% set(gca,'FontSize',15)
% 
% subplot(1,4,2)
% winterColors = colormap(winter(9));
% plot(T,[V(1,1:(end-1)) 0],'Color',winterColors(1,:))
% hold on
% plot(T,[V(21,1:(end-1)) 0],'Color',winterColors(2,:))
% plot(T,[V(41,1:(end-1)) 0],'Color',winterColors(3,:))
% plot(T,[V(61,1:(end-1)) 0],'Color',winterColors(4,:))
% plot(T,[V(81,1:(end-1)) 0],'Color',winterColors(5,:))
% plot(T,[V(101,1:(end-1)) 0],'Color',winterColors(6,:))
% plot(T,[V(121,1:(end-1)) 0],'Color',winterColors(7,:))
% plot(T,[V(141,1:(end-1)) 0],'Color',winterColors(8,:))
% plot(T,[V(161,1:(end-1)) 0],'Color',winterColors(9,:))
% xlabel('Time (s)')
% ylabel('TP')
% box off
% set(gca,'tickdir','out')
% set(gca,'ylim',[0 1])
% set(gca,'xtick',[0 2 4 6])
% axis([-1 8 -0.1 1])
% set(gca,'FontSize',15)
% 
% 
% subplot(1,4,3)
% plot(delta(:,t_stim2),'-')
% axis([0 500 -0.1 1])
% xlabel('trial')
% ylabel('TD error')
% box off
% % set(gca,'ylim',[0 1])
% set(gca,'tickdir','out')
% set(gca,'FontSize',15)
% 
% 
% %% uncertainty
% % initial estimation = stim salience
% % initial estimation uncertainty = 1 (standard normal distribution)
% % measurement uncertainty = 1
% % estimation uncertainty pp(n) = (1-K)*pp(n-1)
% % K = pp/(pp + measurement uncertainty)
% 
% pp = NaN(1,n_trials);
% pp(1) = 1;
% for n = 1:n_trials
%     K = pp(n)/(pp(n) + 1);
%     pp(n+1) = (1-K)*pp(n);
% end
% 
% 
% m_plot = V(:,t_stim+40);
% s_plot = sqrt(2*pp); % 95.4%
% plotWin = 1:501;
% subplot(1,4,4)
% errorbar_patch(plotWin,m_plot',s_plot,'b');
% xlabel('trial')
% ylabel('TP')
% box off
% set(gca,'ylim',[0 1])
% set(gca,'tickdir','out')
% set(gca,'FontSize',15)
% set(gcf,'color','w')
%    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% alternate model, novelty bonus (object posseses threat, and it decays)
% 
% clear
% bonus = [0, 1, 2, 4];
% 
% scrsz = get(groot,'ScreenSize');
% figure('Position',[1 scrsz(4)/1.5 scrsz(3)/1.5 scrsz(4)/1.5])
% 
% for rew_n = 1:length(bonus)
% 
% V = []; W = []; W2 = [];
% t_step = 10; %timestep per second
% t_max = 30*t_step; %time for trial end
% t_stim = 1*t_step; %time for cue
% t_stim2 = 7*t_step; %time for cue2
% t_rew = 29*t_step; %time for reward
% t_rew2 = 7*t_step; %time for cue2
% n_trials = 500; %trial number
% gamma = 0.98;
% 
% % alpha = .01; %Rescorla-Wagner with TD
% % lambda = 1;
% 
% alpha = .015; 
% lambda = 0.9;
% 
% % alpha = .7; %1-step TD
% % lambda = 0;
%  
% T = ([1:t_max]-t_stim)/t_step; %actual time for plot
% 
% % stimulus
% x = zeros(t_max,t_max);
% for i = 1:t_max-t_stim
%     x(i+t_stim,i+t_stim) = 1;
% end
% 
% % weight
% w = zeros(t_max,1);
% % w(t_stim:t_rew)=-0.5; %puff reversal
% % w(t_stim:t_rew)=0.2; %novelty
% % w(t_stim:t_rew)=0.5; %novelty
% 
% % stimulus2
% x2 = zeros(t_max,t_max);
% for i = 1:t_max-t_stim2
%     x2(i+t_stim2,i+t_stim2) = 1;
% end
% 
% % weight2
% w2 = zeros(t_max,1);
% % w(t_stim:t_rew)=-0.5; %puff reversal
% % w(t_stim:t_rew)=0.2; %novelty
% % w2(t_stim2:t_rew)=initial(initial_n); %initialiing value
%  
% % reward function
% r = zeros(t_max,n_trials); % reward function
% % r(t_rew) = 1;
% if bonus(rew_n)>0
% r(t_rew2,1:100) = bonus(rew_n) - [(bonus(rew_n)/100):(bonus(rew_n)/100):bonus(rew_n)]; %novelty bonus
% end
%  
% % Value function
% for t = 1:t_max
%     v(t) = (sum(w.*x(:,t))) + (sum(w2.*x2(:,t)));
% end
% V = [V; v];
% 
% for n = 1:n_trials
%     et = zeros(t_max,1); %initialize eligibility traces
%     et2 = zeros(t_max,1); %initialize eligibility traces
%     for t = 1:t_max-1
%          v(t) = (sum(w.*x(:,t))) + (sum(w2.*x2(:,t)));
%          v(t+1) = (sum(w.*x(:,t+1))) + (sum(w2.*x2(:,t+1)));
%         d = r(t,n)+gamma*v(t+1)-v(t); % calculate delta
% %         et = gamma*lambda*et + alpha*(x(:,t)); %old
% %         w = w + d*et;
%         et = gamma*lambda*et + (x(:,t));
%         et2 = gamma*lambda*et2 + (x2(:,t));
%         w = w + alpha*d*et;
%         w2 = w2 + alpha*d*et2;
%         
%         delta(n,t) = d;
%     end
%     W(n,:) = w;
%     W2(n,:) = w2;
%     V = [V;v];
% end
% 
% 
% % subplot(i,5,3)
% % colormap yellowblue
% % imagesc(V)
% % colorbar
% % lim=caxis;
% % caxis([-0.2 0.2])
% % % caxis([-.5 .5])
% % % axis([9 31 0 40])
% % xlabel('Time')
% % ylabel('Trials')
% % title(initial(i))
% % box off
% % set(gca,'tickdir','out')
% % set(gca,'TickLength',2*(get(gca,'TickLength')))
% % set(gca,'FontSize',15)
% % set(gcf,'color','w')
% % 
% % subplot(i,5,4)
% % colormap yellowblue
% % imagesc(delta)
% % colorbar
% % lim=caxis;
% % caxis([-0.2 0.2])
% % % caxis([-.5 .5])
% % % axis([9 31 0 40])
% % xlabel('Time')
% % ylabel('Trials')
% % box off
% % set(gca,'tickdir','out')
% % set(gca,'TickLength',2*(get(gca,'TickLength')))
% % set(gca,'FontSize',15)
% % set(gcf,'color','w')
% 
% 
% % %% convolution with water kernel
% % cd('/Users/mitsuko/Documents/Matlab_work/model')
% % load kernel_UnexpR_HyungGoo.mat
% % kernel_water = dn_y(501:1001); %every10ms
% % kernel_water = kernel_water(1:10:end); %every100ms, same as model timestep
% % kernel_water(2) = 0; %fix negative value
% % 
% % delta_conv = zeros(n_trials,size(delta,2)+50);
% % for trial = 1:n_trials
% % delta_conv(trial,:) = conv(delta(trial,:),kernel_water');
% % end
% % delta_conv = delta_conv(:,1:(t_max-1));
% % 
% % subplot(1,3,3)
% % colormap yellowblue
% % imagesc(delta_conv/max(max(delta_conv)))
% % colorbar
% % % lim=caxis;
% % % caxis([-0.2 0.2])
% % caxis([-.5 .5])
% % % axis([9 31 0 40])
% % xlabel('Time')
% % ylabel('Trials')
% % title(sprintf('gamma = %1.2f; alpha = %1.2f; lambda = %1.2f',gamma,alpha,lambda))
% % box off
% % set(gca,'tickdir','out')
% % set(gca,'TickLength',2*(get(gca,'TickLength')))
% % set(gca,'FontSize',15)
% % set(gcf,'color','w')
% 
% 
% subplot(length(bonus),4,4*(rew_n-1)+1)
% winterColors = colormap(winter(9));
% plot(T(2:end),[delta(1,1:(end-1)) 0],'Color',winterColors(1,:))
% hold on
% plot(T(2:end),[delta(21,1:(end-1)) 0],'Color',winterColors(2,:))
% plot(T(2:end),[delta(41,1:(end-1)) 0],'Color',winterColors(3,:))
% plot(T(2:end),[delta(61,1:(end-1)) 0],'Color',winterColors(4,:))
% plot(T(2:end),[delta(81,1:(end-1)) 0],'Color',winterColors(5,:))
% plot(T(2:end),[delta(101,1:(end-1)) 0],'Color',winterColors(6,:))
% plot(T(2:end),[delta(121,1:(end-1)) 0],'Color',winterColors(7,:))
% plot(T(2:end),[delta(141,1:(end-1)) 0],'Color',winterColors(8,:))
% plot(T(2:end),[delta(161,1:(end-1)) 0],'Color',winterColors(9,:))
% xlabel('Time (s)')
% ylabel('TD error')
% title(bonus(rew_n))
% box off
% set(gca,'tickdir','out')
% set(gca,'ylim',[0 1])
% set(gca,'xtick',[0 2 4 6])
% axis([-1 8 -1.5 4])
% set(gca,'FontSize',15)
% 
% subplot(length(bonus),4,4*(rew_n-1)+2)
% winterColors = colormap(winter(9));
% plot(T,[V(1,1:(end-1)) 0],'Color',winterColors(1,:))
% hold on
% plot(T,[V(21,1:(end-1)) 0],'Color',winterColors(2,:))
% plot(T,[V(41,1:(end-1)) 0],'Color',winterColors(3,:))
% plot(T,[V(61,1:(end-1)) 0],'Color',winterColors(4,:))
% plot(T,[V(81,1:(end-1)) 0],'Color',winterColors(5,:))
% plot(T,[V(101,1:(end-1)) 0],'Color',winterColors(6,:))
% plot(T,[V(121,1:(end-1)) 0],'Color',winterColors(7,:))
% plot(T,[V(141,1:(end-1)) 0],'Color',winterColors(8,:))
% plot(T,[V(161,1:(end-1)) 0],'Color',winterColors(9,:))
% xlabel('Time (s)')
% ylabel('TP')
% box off
% set(gca,'tickdir','out')
% set(gca,'ylim',[0 1])
% set(gca,'xtick',[0 2 4 6])
% axis([-1 8 -0.1 2])
% set(gca,'FontSize',15)
% 
% 
% subplot(length(bonus),4,4*(rew_n-1)+3)
% plot(delta(:,t_stim2),'-')
% axis([0 500 -1.5 4])
% xlabel('trial')
% ylabel('TD error')
% box off
% % set(gca,'ylim',[0 1])
% set(gca,'tickdir','out')
% set(gca,'FontSize',15)
% 
% % subplot(1,4,2)
% % plot(V(:,t_stim+40),'-')
% % title('threat prediction')
% % xlabel('trial')
% % ylabel('V at 4s')
% % box off
% % set(gca,'ylim',[0 1])
% % set(gca,'tickdir','out')
% % set(gca,'FontSize',15)
% 
% 
% %% uncertainty
% % initial estimation = stim salience
% % initial estimation uncertainty = 1 (standard normal distribution)
% % measurement uncertainty = 1
% % estimation uncertainty pp(n) = (1-K)*pp(n-1)
% % K = pp/(pp + measurement uncertainty)
% 
% pp = NaN(1,n_trials);
% pp(1) = 1;
% for n = 1:n_trials
%     K = pp(n)/(pp(n) + 1);
%     pp(n+1) = (1-K)*pp(n);
% end
% 
% % subplot(5,5,5*(initial_n-1)+4)
% % plot(pp,'-')
% % % title('estimation uncertainty')
% % xlabel('trial')
% % ylabel('variance')
% % box off
% % set(gca,'ylim',[0 1])
% % set(gca,'tickdir','out')
% % set(gca,'FontSize',15)
% 
% m_plot = V(:,t_stim+40);
% s_plot = sqrt(2*pp); % 95.4%
% plotWin = 1:501;
% subplot(length(bonus),4,4*(rew_n-1)+4)
% errorbar_patch(plotWin,m_plot',s_plot,'b');
% axis([0 500 0 1])
% xlabel('trial')
% ylabel('TP')
% box off
% % set(gca,'ylim',[0 1])
% set(gca,'tickdir','out')
% set(gca,'FontSize',15)
% set(gcf,'color','w')
%     
% end


figure
subplot(1,2,1)
x = 0:100;
m1 = 50;
sig = 15;
m2 = 1.1;
y1 = 40*normpdf(x,m1,sig);
y2 = m2.^(-x);
plot(x,y1)
hold on
plot(x,y2)
h=gca;
h.XTick = 0:20:100;
h.XTickLabel = (1-(0:0.2:1));
legend('curiosity','fear')
title('2 drives model')
xlabel('novelty')
ylabel('a.u.')
box off
set(gca,'tickdir','out')
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(1,2,2)
x = 0:100;
m1 = 50;
sig = 15;
m2 = 1.1;
y1 = 40*normpdf(x,m1,sig);
y2 = m2.^(-x);
plot(x,y1)
hold on
plot(x,y2)
h=gca;
h.XTick = 0:20:100;
h.XTickLabel = (1-(0:0.2:1));
legend('avoid','approach')
title('fear model')
xlabel('novelty/fear')
ylabel('a.u.')
box off
set(gca,'tickdir','out')
set(gca,'FontSize',15)
set(gcf,'color','w')

scrsz = get(groot,'ScreenSize');
figure('Position',[1 scrsz(4)/1.5 scrsz(3)/1.5 scrsz(4)/1.5])
subplot(1,4,1)
% x = 0:500;
m2 = 1.03;
y2 = m2.^(-x);
plot(x,y2)
% hold on
% plot(x,pp(1:101))
h=gca;
h.XTick = 0:20:100;
h.XTickLabel = (1-(0:0.2:1));
title('approach drive')
% legend('approach drive','threat uncertainty')
% title('our model')
xlabel('contextual novelty')
% xlabel('trial')
ylabel('a.u.')
box off
set(gca,'tickdir','out')
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(1,4,4)
m_plot = V(:,t_stim+40);
s_plot = 2*sqrt(pp); % 2*standard deviation, 95.4%
plotWin = 1:501;
errorbar_patch(plotWin,m_plot',s_plot,'b');
axis([0 500 0 1])
xlabel('trial')
title('TP+-uncertainty')
ylabel('a.u.')
box off
% set(gca,'ylim',[0 1])
set(gca,'tickdir','out')
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(1,4,2)
plot(plotWin,m_plot','b-');
axis([0 500 0 1])
title('threat prediction')
xlabel('trial')
ylabel('a.u.')
box off
% set(gca,'ylim',[0 1])
set(gca,'tickdir','out')
set(gca,'FontSize',15)
set(gcf,'color','w')

subplot(1,4,3)
plot(plotWin,s_plot)
title('threat uncertainty')
xlabel('trial')
ylabel('a.u.')
box off
set(gca,'tickdir','out')
set(gca,'FontSize',15)
set(gcf,'color','w')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% behavior

%approach drive
x = 0:499;
m2 = 1.02;
approach = m2.^(-x);

% uncertainty
uncertain = sqrt(2*pp);

threat_thresh = 0.2; %threat threshold
approach_thresh = 0;
behavior = NaN(length(initial),500);

for initial_n = 1:length(initial)
    
%threat prediction
TP = V_all{initial_n}(:,t_stim+40);

for i = 1:500 %trial
    if isnan(behavior(initial_n,i))
    if approach(i) > approach_thresh
        if TP(i) + uncertain(i) > threat_thresh && TP(i) - uncertain(i) < threat_thresh
            behavior(initial_n,i) = 1; % risk assessment
        else
            if TP(i) + uncertain(i) < threat_thresh
                behavior(initial_n,i) = 2; % engagement
            else
                behavior(initial_n,i:end) = 0; % no approach
            end
        end
    else
       behavior(initial_n,i:end) = 0; % no approach
    end
    end
end

end

figure
imagesc(behavior)
colormap summer
colorbar
h=gca;
h.YTick = 1:5:21;
h.YTickLabel = initial(1:5:21);
title('behavioral variability')
xlabel('trial')
ylabel('bonus')
box off
set(gca,'tickdir','out')
set(gca,'TickLength',2*(get(gca,'TickLength')))
set(gca,'FontSize',20)
set(gcf,'color','w')

