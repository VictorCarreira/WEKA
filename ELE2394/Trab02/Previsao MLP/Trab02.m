% Padr�es de entradas
 P = [ 0 0 1 1; 0 1 0 1];

% Padr�es de sa�da
 T = [0 1 1 0];
 
 %PERCEPTRON
 
 % OP��O 1 
 % net1 = newff(P,T,0)
 
 % OP��O 2
 % net2 = newff(P,T)
 
 % OP��O 3
 n = [-10 0 10];
 
  net = newff(P,T,[],{},'traingdx','learngdm')
  
  net.trainParam
  
  net = train(net,P,T)
  
  view(net)
  
  

