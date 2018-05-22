%% Arquivo principal para previsao de series temporais
%%%% DEE, Pontificia Universidade Catolica do Rio de Janeiro
%%%% chvn@ele.puc-rio.br
%% Instruções:

% O presente código é utilizado para realizar a previsão multi-step de uma
% serie temporal, os paramêtros que devem ser modificados estão
% especificados em Paramêtros Gerais e Paramêtros da Rede.

% Devem ser realizados testes para um microclima qualquer dos 8 diponiveis
% com diferentes configurações de rede para obter o menor possível valor de
% MAPE_t_f.

% Duvidas devem ser tiradas com o monitor Cesar Valencia no mail:
% chvn@ele.puc-rio.br 

%%

clear all
clc

tic
    
%% Parametros gerais

microclima=1;  % opcoes 1-8
codificacao=1;% opcoes 1=real, 2=4bits, 3=12bits
janela=3; % 
Num=1; % Numero de redes a testar

%% Parametros da rede
Numproc=13; % Numero de processadores
tipofunc='tansig'; % logsig tansig
funcsaida='purelin'; % purelin logsig
algtrei='trainlm'; % trainlm traingd traingdm traingdx
Nepoch=100; % Numero de epocas
Numchkval=50; % Se Numchkval=Nepoch --> Sem (early stop); Se Numchkval<Nepoch --> Com (early stop)

%% Selecao do microclima da base de dados

if microclima == 1;
   load microclimab1.mat
elseif microclima == 2;
       load microclimab2.mat
elseif microclima == 3;
       load microclimab3.mat
elseif microclima == 4;
       load microclimab4.mat
elseif microclima == 5;
       load microclimab5.mat
elseif microclima == 6;
       load microclimab6.mat
elseif microclima == 7;
       load microclimab7.mat
else microclima = 8;
       load microclimab8.mat
end

%% Normalizacao 

dados_geral=[dados_treinamento(2,:) dados_validacao(2,:)];
[dados_geral_N,val]=mapminmax(dados_geral,0,1); % Normalizacao entre 0 e 1

dados_treinamento_M=dados_treinamento(1,:);
dados_treinamento_ST_N=dados_geral_N(1,1:length(dados_treinamento));

dados_validacao_M=dados_validacao(1,:);
dados_validacao_ST_N=dados_geral_N(1,length(dados_treinamento)+1:end);

%% Codificacao

% Codificacao real normalizada 
if codificacao == 1; 
    mes_cod_trei=dados_treinamento_M/12; % codificacao dos meses do conjunto de treinamento
    mes_cod_val=dados_validacao_M/12;   % codificacao dos meses do conjunto de validacao   
end

% Codificacao 4 bits
if codificacao == 2;
    binm=dec2bin(dados_treinamento_M); % treinamento
    binm=binm';
    binm1=binm(1,:);
    binm2=binm(2,:);
    binm3=binm(3,:);
    binm4=binm(4,:);
    for conta=1:max(size(dados_treinamento_M));
        binmn(1,conta)=str2num(binm1(conta));
        binmn(2,conta)=str2num(binm2(conta));
        binmn(3,conta)=str2num(binm3(conta));
        binmn(4,conta)=str2num(binm4(conta));        
    end
       
    binmv=dec2bin(dados_validacao_M); % validacao
    binmv=binmv';
    binmv1=binmv(1,:);
    binmv2=binmv(2,:);
    binmv3=binmv(3,:);
    binmv4=binmv(4,:);
    for conta=1:max(size(dados_validacao_M));
        binmnv(1,conta)=str2num(binmv1(conta));
        binmnv(2,conta)=str2num(binmv2(conta));
        binmnv(3,conta)=str2num(binmv3(conta));
        binmnv(4,conta)=str2num(binmv4(conta));        
    end
    
    mes_cod_trei=binmn; % codificacao dos meses do conjunto de treinamento
    mes_cod_val=binmnv; % codificacao dos meses do conjunto de validacao
end

% Codificacao 12 bits
if codificacao == 3;
    mes_cod_trei=eye(12);
    mes_cod_val=eye(12);
    
    for j = 1:max(size(dados_treinamento_M))
        mes_cod_trei(:,j)=mes_cod_trei(:,dados_treinamento_M(j))'; % codificacao dos meses do conjunto de treinamento
    end 
    
    for j = 1:max(size(dados_validacao_M))
        mes_cod_val(:,j)=mes_cod_val(:,dados_validacao_M(j))'; % codificacao dos meses do conjunto de validacao
    end
end

%% Janela

%Janela treinamento
len = length(dados_treinamento_ST_N);
num_subset = len - janela; 

for i = (1:num_subset),
        T_data_P(i,:) = dados_treinamento_ST_N(i:janela-1+i); % Conjunto de padroes de treinamento
        T_data_T(i,:) = dados_treinamento_ST_N(:,janela+i); % Conjunto de targets de treinamento
end

%Janela validacao
dados_validacao_ST_N=[dados_treinamento_ST_N((length(dados_treinamento)+1)-janela:length(dados_treinamento)) dados_validacao_ST_N];
len = length(dados_validacao_ST_N);
num_subset = len - janela;

for i = (1:num_subset),
        V_data_P(i,:) = dados_validacao_ST_N(i:janela-1+i); % Conjunto de padroes de validacao
        V_data_T(i,:) = dados_validacao_ST_N(:,janela+i); % Conjunto de targets de validacao
end

%% Reorganizacao dos dados

% Organizacao dados treinamento
T_data_P=T_data_P';
T_data_P=[T_data_P;mes_cod_trei(:,janela+1:end)]; % Padroes de treinamento
T_data_T=T_data_T';

% Organizacao dados validacao
V_data_P=V_data_P';
V_data_P=[V_data_P;mes_cod_val]; % Padroes de validacao
V_data_T=V_data_T';

% Agrupando padroes e targets com para treinamento e validacao
To_data_P=[T_data_P V_data_P]; % Conjunto de padroes de treinamento e validacao
To_data_T=[T_data_T V_data_T]; % Conjunto de targets de treinamento e validacao

%% Criacao e configuracao da rede

%T=waitbar(0,'Criando, treinando e Avaliando....');
for NumRN=1:Num; % Numero de redes a testar

RN_C=newff(To_data_P,To_data_T,[Numproc],{tipofunc,funcsaida},algtrei); % Criacao da rede  
RN_C.trainParam.epochs = 1;% Definindo numero de epocas

RN_C.initFcn=('initlay'); % Inicializacao de pesos 'initlay' 'initnw' 'initwb'

RN_C.divideFcn=('divideind'); % Funcao para divisao de subconjuntos de treinamento e validacao
RN_C.divideParam.trainInd=1:length(dados_treinamento)-janela; % Subconjunto de treinamento
% wb_i=getwb(RN_C); % Versoes de Matlab 2011b para frente
% RN_C=setwb(RN_C,wb_i/10); % Versoes de Matlab 2011b para frente

%% Treinamento da rede e selecao de pesos

RN_C.trainParam.showWindow=0; % Visualizacao nntraintool 0=desalitado 1=habilitado
RN_T=train(RN_C,To_data_P,To_data_T); % Treinamento utilizando a CPU
%wb_t(:,1) = getwb(RN_T); % Versoes de Matlab 2011b para frente
I_W_v(:,1)=RN_T.IW(1,1); % Pesos das conexoes de entrada
L_W_v(:,1)=RN_T.LW(2,1); % Pesos das conexoes de saida
B_v(:,1)=[RN_T.b(1,1);RN_T.b(2,1)]; % Bias

%% Realizar a previsao do conjunto de validacao

chkval=0; % Valor inicial do contador utilizado para os erros consecutivos 
for epocas=2:Nepoch; 

    % 1 Mes previsao conjunto de validacao
    index=length(dados_geral_N)-12-janela;

    for i=1:janela;
        vetor_v(1,i)=dados_geral_N(1,index+i);
    end

    vetor1_v(1,:) = vetor_v(1:janela);
    vetor1_v=vetor1_v';

    Pr_data_P_N(:,1)=[vetor1_v(:,1);mes_cod_val(:,1)];
    prev1_N_v(1)=sim(RN_T,Pr_data_P_N(:,1));
    prev1_v(1)=mapminmax('reverse',prev1_N_v(1),val); % Valor 1 mes de validacao previsto desnormalizado
    %prev1_v(1)=mapminmax.reverse(prev1_N_v(1),val); % Versoes de Matlab 2011b para frente

    %2 - 12 Mes previsao conjunto de validacao
    for i=1:11;
        vetor_v(1,janela+i)=prev1_N_v(i);
        vetor1_v(:,i+1) = vetor_v(1,i+1:janela+i);

        Pr_data_P_N(:,1)=[vetor1_v(:,i+1);mes_cod_val(:,i+1)];
        prev1_N_v(i+1)=sim(RN_T,Pr_data_P_N(:,1));
        prev1_v(i+1)=mapminmax('reverse',prev1_N_v(i+1),val); % Valores 2-12 de validacao previstos desnormalizados
        %prev1_v(i+1)=mapminmax.reverse(prev1_N_v(i+1),val); % Versoes de Matlab 2011b para frente
    end
       
    dados_validacao_real_ST=dados_geral(1,121:end); % Valores reais do conjunto de validacao
    MAPE_v(epocas-1)=100*mean(abs((dados_validacao_real_ST-prev1_v)./dados_validacao_real_ST));
    MAPEmin_v=min(MAPE_v(1,:));
    [x_v] = find(MAPE_v(1,:)==MAPEmin_v);

clear vetor1_v
  
if MAPE_v(epocas-1) <= MAPEmin_v % Comparacao do menor MAPE
   chkval=0;
else
    chkval=chkval+1;       
end 
    
if chkval == Numchkval; % Numero de chkval
    %disp('Numero de chkval alcanzado')
    break
end

RN_T=train(RN_T,To_data_P,To_data_T); % Treinamento utilizando a CPU
%RN_T=train(RN_C,To_data_P,To_data_T,'useGPU','yes'); % Treinamento utilizando a GPU
%wb_t(:,epocas) = getwb(RN_T); % Versoes de Matlab 2011b para frente
I_W_v(:,epocas)=RN_T.IW(1,1); % Pesos das conexoes de entrada
L_W_v(:,epocas)=RN_T.LW(2,1); % Pesos das conexoes de saida
B_v(:,epocas)=[RN_T.b(1,1);RN_T.b(2,1)]; % Bias

end

%RN_T = setwb(RN_T,wb_t(:,x_v)); % Versoes de Matlab 2011b para frente
RN_T.IW=[I_W_v(1,x_v(1)); RN_T.IW(2,1)]; % Set dos pesos das conexoes de entrada 
RN_T.LW=[RN_T.LW(1,1) RN_T.LW(1,2);L_W_v(1,x_v(1)) RN_T.LW(2,2)]; % Set dos pesos das conexoes de saida
RN_T.b=B_v(:,x_v(1)); % Set dos Bias
I_W_t(:,NumRN)=RN_T.IW(1,1); % Pesos das conexoes de entrada
L_W_t(:,NumRN)=RN_T.LW(2,1); % Pesos das conexoes de saida
B_t(:,NumRN)=[RN_T.b(1,1);RN_T.b(2,1)]; % Bias
%wb_v(:,NumRN)=getwb(RN_T); % Versoes de Matlab 2011b para frente

%% Realizar a previsao conjunto de teste

% 1 Mes
index=length(dados_geral_N)-janela;

for i=1:janela;
    vetor(1,i)=dados_geral_N(1,index+i);
end

vetor1(1,:) = vetor(1:janela);
vetor1=vetor1';

Pr_data_P_N(:,1)=[vetor1(:,1);mes_cod_val(:,1)];
prev1_N(1)=sim(RN_T,Pr_data_P_N(:,1));
prev1(1)=mapminmax('reverse',prev1_N(1),val); % Valor 1 mes de teste previsto desnormalizado
%prev1(1)=mapminmax.reverse(prev1_N(1),val); % Versoes de Matlab 2011b para frente

%2 - 12 Mes
for i=1:11;
    vetor(1,janela+i)=prev1_N(i);
    vetor1(:,i+1) = vetor(1,i+1:janela+i);

    Pr_data_P_N(:,1)=[vetor1(:,i+1);mes_cod_val(:,i+1)];
    prev1_N(i+1)=sim(RN_T,Pr_data_P_N(:,1));
    prev1(i+1)=mapminmax('reverse',prev1_N(i+1),val); % Valores 2-12 de teste previstos desnormalizados
    %prev1(i+1)=mapminmax.reverse(prev1_N(i+1),val); % Versoes de Matlab 2011b para frente
end

%% Metricas

dados_teste_real_ST=dados_teste_real(2,:); % Valores reais do conjuntod de teste

MAPE_t(NumRN)=100*mean(abs((dados_teste_real_ST-prev1)./dados_teste_real_ST)); % MAPE para todas as redes testadas
RMSE_t(NumRN)=sqrt(sum((dados_teste_real_ST(:)-prev1(:)).^2)/numel(dados_teste_real_ST)); % RMSE para todas as redes testadas

total(1,NumRN)=MAPE_t(NumRN); % MAPE para todos os testes
total(2,NumRN)=RMSE_t(NumRN); % RMSE para todos os testes

NumRN

clear T_data_P V_data_P T_data_T V_data_T vetor vetor1 prev1

% waitbar(NumRN/Num)        
   
   end
  %close(T)
%% Escolher a melhor configuracao de pesos, para Realizar a previsao final

MAPEmin_t=min(total(1,:)); % Minimo valor do MAPE para o teste
RMSEmin_t=min(total(2,:)); % Minimo valor do RMSE para o teste

[x] = find(total(1,:)==MAPEmin_t); % Posicao da melhor configuracao de MAPE para teste
[y] = find(total(2,:)==RMSEmin_t); % Posicao da melhor configuracao de RMSE para teste

%RN_T = setwb(RN_T,wb_v(:,x)); % Versoes de Matlab 2011b para frente
RN_T.IW=[I_W_t(1,x(1)); RN_T.IW(2,1)]; % Set dos pesos das conexoes de entrada
RN_T.LW=[RN_T.LW(1,1) RN_T.LW(1,2);L_W_t(1,x(1)) RN_T.LW(2,2)]; % Set dos pesos das conexoes de saida
RN_T.b=B_t(:,x(1)); % Set dos Bias

%% Realizar a previsao conjunto de validacao

clear vetor1_v
index=length(dados_geral_N)-12-janela;

    for i=1:janela;
        vetor_v(1,i)=dados_geral_N(1,index+i);
    end

    vetor1_v(1,:) = vetor_v(1:janela);
    vetor1_v=vetor1_v';

    Pr_data_P_N(:,1)=[vetor1_v(:,1);mes_cod_val(:,1)];
    prev1_N_v(1)=sim(RN_T,Pr_data_P_N(:,1));
    prev1_v(1)=mapminmax('reverse',prev1_N_v(1),val); % Valor 1 mes de validacao previsto desnormalizado
    %prev1_v(1)=mapminmax.reverse(prev1_N_v(1),val); % Versoes de Matlab 2011b para frente 

    
    %2 - 12 Mes previsao conjunto de validacao
    for i=1:11;
        vetor_v(1,janela+i)=prev1_N_v(i);
        vetor1_v(:,i+1) = vetor_v(1,i+1:janela+i);

        Pr_data_P_N(:,1)=[vetor1_v(:,i+1);mes_cod_val(:,i+1)];
        prev1_N_v(i+1)=sim(RN_T,Pr_data_P_N(:,1));
        prev1_v(i+1)=mapminmax('reverse',prev1_N_v(i+1),val); % Valores 2-12 de validacao previstos desnormalizados
        %prev1_v(i+1)=mapminmax.reverse(prev1_N_v(i+1),val); % Versoes de Matlab 2011b para frente
    end

dados_validacao_real_ST=dados_geral(1,121:end); % Valores reais do conjunto de validacao
MAPE_v_f=100*mean(abs((dados_validacao_real_ST-prev1_v)./dados_validacao_real_ST))
RMSE_v_f=sqrt(sum((dados_validacao_real_ST(:)-prev1_v(:)).^2)/numel(dados_validacao_real_ST)) % RMSE

%% Realizar a previsao conjunto de teste

% 1 Mes
clear vetor1
index=length(dados_geral_N)-janela;

for i=1:janela;
    vetor(1,i)=dados_geral_N(1,index+i);
end

vetor1(1,:) = vetor(1:janela);
vetor1=vetor1';

Pr_data_P_N(:,1)=[vetor1(:,1);mes_cod_val(:,1)];
prev1_N(1)=sim(RN_T,Pr_data_P_N(:,1));
prev1(1)=mapminmax('reverse',prev1_N(1),val); % Valor 1 mes de teste previsto desnormalizado
%prev1(1)=mapminmax.reverse(prev1_N(1),val); % Versoes de Matlab 2011b para frente

%2 - 12 Mes
for i=1:11;
    vetor(1,janela+i)=prev1_N(i);
    vetor1(:,i+1) = vetor(1,i+1:janela+i);

    Pr_data_P_N(:,1)=[vetor1(:,i+1);mes_cod_val(:,i+1)];
    prev1_N(i+1)=sim(RN_T,Pr_data_P_N(:,1));
    prev1(i+1)=mapminmax('reverse',prev1_N(i+1),val); % Valores 2-12 de teste previstos desnormalizados
    %prev1(i+1)=mapminmax.reverse(prev1_N(i+1),val); % Versoes de Matlab 2011b para frente
end

dados_teste_real_ST=dados_teste_real(2,:); % Valores reais do conjunto de teste
MAPE_t_f=100*mean(abs((dados_teste_real_ST-prev1)./dados_teste_real_ST)) % MAPE final de teste
RMSE_t_f=sqrt(sum((dados_teste_real_ST(:)-prev1(:)).^2)/numel(dados_teste_real_ST)) % RMSE

%% Figuras

% Figuras dos conjuntos de treinamento, validação e teste

tabbedGUI(dados_treinamento(2,janela+1:end),mapminmax('reverse',sim(RN_T,To_data_P(:,1:(length(dados_treinamento_M)-janela))),val),...
    dados_validacao(2,:),prev1_v,dados_teste_real_ST,prev1,dados_treinamento_M,janela)

view(RN_T) % Configuracao final da rede

toc



    