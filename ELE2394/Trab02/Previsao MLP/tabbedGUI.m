function tabbedGUI(primer_a,primer_b,segun_a,segun_b,tercer_a,tercer_b,dados_treinamento_M,janela)
    %# create tabbed GUI
   
    figure('Position',[1 1 1400 400],'Color',[1 1 1]);
    
    %
    subplot(1,3,1)
    hLine = plot(primer_a, '--rs','LineWidth',2,...
                       'MarkerEdgeColor','k',...
                       'MarkerFaceColor','g',...
                       'MarkerSize',5);
    hold on
    hLine = plot(primer_b,'--bs','LineWidth',2,...
                       'MarkerEdgeColor','k',...
                       'MarkerFaceColor','y',...
                       'MarkerSize',5);
    title('Conjunto de Treinamento');
    xlabel('Mes');
    ylabel('Sensacao Termica');
    legend('Real','Resposta da Rede','Location','SouthWest');
    xlim([1 (length(dados_treinamento_M)-janela)]);
    grid
    
    
    %
    subplot(1,3,2)
    hLine = plot(segun_a,'--rs','LineWidth',2,...
                       'MarkerEdgeColor','k',...
                       'MarkerFaceColor','g',...
                       'MarkerSize',8);
    hold on
    hLine = plot(segun_b,'--bs','LineWidth',2,...
                       'MarkerEdgeColor','k',...
                       'MarkerFaceColor','y',...
                       'MarkerSize',8);
    title('Conjunto de Validacao');
    xlabel('Mes');    
    legend('Real','Resposta da Rede','Location','SouthWest');
    xlim([1 12]);
    grid
   
    
    %
    subplot(1,3,3)
    hLine = plot(tercer_a,'--rs','LineWidth',2,...
                       'MarkerEdgeColor','k',...
                       'MarkerFaceColor','g',...
                       'MarkerSize',8);
    hold on
    hLine = plot(tercer_b,'--bs','LineWidth',2,...
                       'MarkerEdgeColor','k',...
                       'MarkerFaceColor','y',...
                       'MarkerSize',8);
    title('Conunto de Teste');
    xlabel('Mes');    
    legend('Real','Previsto','Location','SouthWest');
    xlim([1 12]);
    grid
    
    AxesHandle=findobj(gcf,'Type','axes');
    set(AxesHandle(3),'Position',[0.03,0.1,0.3,0.85]);
    set(AxesHandle(2),'Position',[0.36,0.1,0.3,0.85]);
    set(AxesHandle(1),'Position',[0.69,0.1,0.3,0.85]);
    
    saveas(gcf,'trn_val_tst','jpg')
end

