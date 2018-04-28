function tabbedGUI(primer_a,primer_b,segun_a,segun_b,tercer_a,tercer_b,dados_treinamento_M,janela)
    %# create tabbed GUI
    hFig = figure('Menubar','none');
    s = warning('off', 'MATLAB:uitabgroup:OldVersion');
    hTabGroup = uitabgroup('Parent',hFig);
    warning(s);
    hTabs(1) = uitab('Parent',hTabGroup, 'Title','Treinamento');
    hTabs(2) = uitab('Parent',hTabGroup, 'Title','Validação');
    hTabs(3) = uitab('Parent',hTabGroup, 'Title','Teste');
    set(hTabGroup, 'SelectedTab',hTabs(1));

    %# populate tabs with UI components

    hAx = axes('Parent',hTabs(1));
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
    
    hAx = axes('Parent',hTabs(2));
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
    ylabel('Sensacao Termica');
    legend('Real','Resposta da Rede','Location','SouthWest');
    xlim([1 12]);
    grid
    
    hAx = axes('Parent',hTabs(3));
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
    ylabel('Sensacao Termica');
    legend('Real','Previsto','Location','SouthWest');
    xlim([1 12]);
    grid
end