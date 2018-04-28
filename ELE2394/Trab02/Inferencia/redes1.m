%% Rede ABCT

% Carregando os dados
load dados_conf9.mat

divisao_dados

for i=1:1; % numero de redes a testar

% Dados
P=[padroes_tr_pu_ABCT padroes_v_pu_ABCT padroes_t_pu_ABCT]; % Padroes
Tt=[target_tr_ABCT target_v_ABCT target_t_ABCT];
T=[target_tr_ABCT(6,:) target_v_ABCT(6,:) target_t_ABCT(6,:)]; % Targets

% Criacao da rede
net=newff(P,T,[24,12]);

% Configuracao de parametros da rede
net.trainParam.epochs = 1000;
net.trainParam.max_fail = 200;

% Inicializacao de pesos
net.initFcn=('initlay'); 

% Divisao do conjunto de dados
net.divideFcn=('divideind'); 
net.divideParam.trainInd=1:size(padroes_tr_pu_ABCT,2); % Conjunto de treino
net.divideParam.valInd=size(padroes_tr_pu_ABCT,2)+1:size(padroes_tr_pu_ABCT,2)+size(padroes_v_pu_ABCT,2); % Conjunto de validacao
net.divideParam.testInd=size(padroes_tr_pu_ABCT,2)+size(padroes_v_pu_ABCT,2)+1:size(padroes_tr_pu_ABCT,2)+size(padroes_v_pu_ABCT,2)+1+size(padroes_t_pu_ABCT,2); % Conjunto de teste

net.trainParam.showWindow=0; % Visulaizacao nntraintool 0=desalitado 1=habilitado

% Treinamento da rede
net_T=trainlm(net,P,T); % Treinamento

%save rede.mat net_T

% Teste da rede
outputs=sim(net_T,padroes_v_pu_ABCT);

% Erro de validacao
perf(i) = mse(net_T,target_v_ABCT(6,:),outputs);

%load('rede.mat');

% Armazenamento dos pesos
pesos(:,i)=getwb(net_T);

i

end

% Determinar a rede com o menor MSE
menor=min(perf);
[x]=find(perf==menor);

% Utilizar os pesos da melhor rede
net_T=setwb(net_T,pesos(:,x));

% Obter a saida da melhor rede
outputs=sim(net_T,padroes_v_pu_ABCT);

% Erro percentual
MSE=mse(net_T,target_v_ABCT(6,:)*100,outputs*100)
RMSE=sqrt(sum((target_v_ABCT(6,:)*100-outputs*100).^2)/numel(target_v_ABCT(6,:)*100))

original=target_v_ABCT(6,:);

%% Visualizacao

figure(1)
plot(original*100,'b')
hold on
plot(outputs*100,'r')
grid

figure(2)
plot(original*100-outputs*100)
grid

figure(3)
plot(abs(original*100-outputs*100))
grid

media_ABCT=mean(abs(original*100-outputs*100))


