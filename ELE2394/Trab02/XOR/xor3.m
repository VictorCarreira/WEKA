function xor3

% Dados
P = [0 0 1 1; 0 1 0 1]; % Padroes
T = [0 1 1 0]; % Targets

% Criacao da rede
net = newff([min(P')' max(P')'], [2 1], {'logsig', 'purelin'}, 'traingdx');

% Configuracao dos parametros da rede
net.trainParam.epochs = 5000;
net.trainParam.goal = 1e-3;
net.trainParam.lr = 0.01;
net.trainParam.show = 25;

net.trainParam.mc = 0.9;

net.trainParam.lr_inc = 1.05;
net.trainParam.lr_dec = 0.7;
net.trainParam.max_perf_inc = 1.04;

% Treinamento da rede
net = train(net, P, T);

% Teste da rede
C = sim(net, P)

%% Visualizacao

figure
subplot(1,2,1)
hold on
for i = 1:4,
   if (T(i) > 0.5)
      plot(P(1,i), P(2,i), 'b.')
   else
      plot(P(1,i), P(2,i), 'r.')
   end
end
xlim([-1 2])
ylim([-1 2])
axis square
set(gca, 'xtick', [0 1])
set(gca, 'ytick', [0 1])
box on
title('Desejado')

subplot(1,2,2)
hold on
for i = 1:4,
   if (C(i) > 0.5)
      plot(P(1,i), P(2,i), 'b.')
   else
      plot(P(1,i), P(2,i), 'r.')
   end
end
xlim([-1 2])
ylim([-1 2])
axis square
set(gca, 'xtick', [0 1])
set(gca, 'ytick', [0 1])
box on
title('Obtido')