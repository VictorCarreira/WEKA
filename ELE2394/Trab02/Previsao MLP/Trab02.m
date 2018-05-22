% Padrões de entradas
 P = [ 0 0 1 1; 0 1 0 1];

% Padrões de saída
 T = [0 1 1 0];
 
 %PERCEPTRON
 
 % OPÇÃO 1 
 % net1 = newff(P,T,0)
 
 % OPÇÃO 2
 % net2 = newff(P,T)
 
 % OPÇÃO 3
 n = [-10 0 10];
 
  net = newff(P,T,[],{},'traingdx','learngdm')
  
  net.trainParam
  
  net = train(net,P,T)
  
  view(net)
  
  

