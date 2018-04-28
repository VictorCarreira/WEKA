%% divisao de dados

tipo_AT=[1;0;0;1];
tipo_BT=[0;1;0;1];
tipo_CT=[0;0;1;1];

tipo_AB=[1;1;0;0];
tipo_AC=[1;0;1;0];
tipo_BC=[0;1;1;0];

tipo_ABT=[1;1;0;1];
tipo_BCT=[0;1;1;1];
tipo_ACT=[1;0;1;1];

tipo_ABC=[1;1;1;0];

tipo_ABCT=[1;1;1;1];

%% falta AT

trei_at=1;
trei_bt=1;
trei_ct=1;

trei_ab=1;
trei_ac=1;
trei_bc=1;

trei_abt=1;
trei_bct=1;
trei_act=1;

trei_abc=1;

trei_abct=1; 

for i=1:length(target_tr),
    tipo=target_tr(1:4,i);
    if (tipo==tipo_AT); % Fase-Terra
       padroes_tr_pu_AT(:,trei_at)=padroes_tr_pu(:,i);
       target_tr_AT(:,trei_at)=target_tr(:,i);
       trei_at=trei_at+1;
       tipo_out_tr{i}='AT';
    elseif (tipo==tipo_BT);
       padroes_tr_pu_BT(:,trei_bt)=padroes_tr_pu(:,i);
       target_tr_BT(:,trei_bt)=target_tr(:,i);
       trei_bt=trei_bt+1;
       tipo_out_tr{i}='BT';
    elseif (tipo==tipo_CT);
       padroes_tr_pu_CT(:,trei_ct)=padroes_tr_pu(:,i);
       target_tr_CT(:,trei_ct)=target_tr(:,i);
       trei_ct=trei_ct+1;
       tipo_out_tr{i}='CT';
    end

    if (tipo==tipo_AB); % Fase-Fase
       padroes_tr_pu_AB(:,trei_ab)=padroes_tr_pu(:,i);
       target_tr_AB(:,trei_ab)=target_tr(:,i);
       trei_ab=trei_ab+1;
        tipo_out_tr{i}='AB';
    elseif (tipo==tipo_AC);
       padroes_tr_pu_AC(:,trei_ac)=padroes_tr_pu(:,i);
       target_tr_AC(:,trei_ac)=target_tr(:,i);
       trei_ac=trei_ac+1;
        tipo_out_tr{i}='AC';
    elseif (tipo==tipo_BC);
       padroes_tr_pu_BC(:,trei_bc)=padroes_tr_pu(:,i);
       target_tr_BC(:,trei_bc)=target_tr(:,i);
       trei_bc=trei_bc+1;
        tipo_out_tr{i}='BC';
    end    
    
    if (tipo==tipo_ABT); % Fase-Fase-Terra 
       padroes_tr_pu_ABT(:,trei_abt)=padroes_tr_pu(:,i);
       target_tr_ABT(:,trei_abt)=target_tr(:,i);
       trei_abt=trei_abt+1;
        tipo_out_tr{i}='ABT';
    elseif (tipo==tipo_BCT);
       padroes_tr_pu_BCT(:,trei_bct)=padroes_tr_pu(:,i);
       target_tr_BCT(:,trei_bct)=target_tr(:,i);
       trei_bct=trei_bct+1;
        tipo_out_tr{i}='BCT';
    elseif (tipo==tipo_ACT);
       padroes_tr_pu_ACT(:,trei_act)=padroes_tr_pu(:,i);
       target_tr_ACT(:,trei_act)=target_tr(:,i);
       trei_act=trei_act+1;
        tipo_out_tr{i}='ACT';
    end   
    
    if (tipo==tipo_ABC); % Fase-Fase-Fase 
       padroes_tr_pu_ABC(:,trei_abc)=padroes_tr_pu(:,i);
       target_tr_ABC(:,trei_abc)=target_tr(:,i);
       trei_abc=trei_abc+1;
        tipo_out_tr{i}='ABC';
    end   
    
    if (tipo==tipo_ABCT); % Fase-Fase-Fase-Terra 
       padroes_tr_pu_ABCT(:,trei_abct)=padroes_tr_pu(:,i);
       target_tr_ABCT(:,trei_abct)=target_tr(:,i);
       trei_abct=trei_abct+1;
        tipo_out_tr{i}='ABCT';
    end 
end % ordem treino

%%

val_at=1;
val_bt=1;
val_ct=1;

val_ab=1;
val_ac=1;
val_bc=1;

val_abt=1;
val_bct=1;
val_act=1;

val_abc=1;

val_abct=1;

for i=1:length(target_v),
    tipo=target_v(1:4,i);
    if (tipo==tipo_AT); % Fase-Terra
       padroes_v_pu_AT(:,val_at)=padroes_v_pu(:,i);
       target_v_AT(:,val_at)=target_v(:,i);
       val_at=val_at+1;
        tipo_out_v{i}='AT';
    elseif (tipo==tipo_BT);
        padroes_v_pu_BT(:,val_bt)=padroes_v_pu(:,i);
       target_v_BT(:,val_bt)=target_v(:,i);
       val_bt=val_bt+1;
       tipo_out_v{i}='BT';
    elseif (tipo==tipo_CT);
        padroes_v_pu_CT(:,val_ct)=padroes_v_pu(:,i);
       target_v_CT(:,val_ct)=target_v(:,i);
       val_ct=val_ct+1;
       tipo_out_v{i}='CT';
    end
    
    if (tipo==tipo_AB); % Fase-Fase
        padroes_v_pu_AB(:,val_ab)=padroes_v_pu(:,i);
       target_v_AB(:,val_ab)=target_v(:,i);
       val_ab=val_ab+1;
       tipo_out_v{i}='AB';
    elseif (tipo==tipo_AC);
        padroes_v_pu_AC(:,val_ac)=padroes_v_pu(:,i);
       target_v_AC(:,val_ac)=target_v(:,i);
       val_ac=val_ac+1;
       tipo_out_v{i}='AC';
    elseif (tipo==tipo_BC);
        padroes_v_pu_BC(:,val_bc)=padroes_v_pu(:,i);
       target_v_BC(:,val_bc)=target_v(:,i);
       val_bc=val_bc+1;
       tipo_out_v{i}='BC';
    end
    
    if (tipo==tipo_ABT); % Fase-Fase-Terra
        padroes_v_pu_ABT(:,val_abt)=padroes_v_pu(:,i);
       target_v_ABT(:,val_abt)=target_v(:,i);
       val_abt=val_abt+1;
       tipo_out_v{i}='ABT';
    elseif (tipo==tipo_BCT);
        padroes_v_pu_BCT(:,val_bct)=padroes_v_pu(:,i);
       target_v_BCT(:,val_bct)=target_v(:,i);
       val_bct=val_bct+1;
       tipo_out_v{i}='BCT';
    elseif (tipo==tipo_ACT);
        padroes_v_pu_ACT(:,val_act)=padroes_v_pu(:,i);
       target_v_ACT(:,val_act)=target_v(:,i);
       val_act=val_act+1;
       tipo_out_v{i}='ACT';
    end
    
    if (tipo==tipo_ABC); % Fase-Fase-Fase
        padroes_v_pu_ABC(:,val_abc)=padroes_v_pu(:,i);
       target_v_ABC(:,val_abc)=target_v(:,i);
       val_abc=val_abc+1;
       tipo_out_v{i}='ABC';
    end
    
    if (tipo==tipo_ABCT); % Fase-Fase-Fase-Terra
        padroes_v_pu_ABCT(:,val_abct)=padroes_v_pu(:,i);
       target_v_ABCT(:,val_abct)=target_v(:,i);
       val_abct=val_abct+1;
       tipo_out_v{i}='ABCT';
    end 
end % ordem validacao

%%

tes_at=1;
tes_bt=1;
tes_ct=1;

tes_ab=1;
tes_ac=1;
tes_bc=1;

tes_abt=1;
tes_bct=1;
tes_act=1;

tes_abc=1;

tes_abct=1;

for i=1:length(target_t),
    tipo=target_t(1:4,i);
    if (tipo==tipo_AT); % Fase-Terra
        padroes_t_pu_AT(:,tes_at)=padroes_t_pu(:,i);
       target_t_AT(:,tes_at)=target_t(:,i);
       tes_at=tes_at+1;
       tipo_out_t{i}='AT';
    elseif (tipo==tipo_BT);
        padroes_t_pu_BT(:,tes_bt)=padroes_t_pu(:,i);
       target_t_BT(:,tes_bt)=target_t(:,i);
       tes_bt=tes_bt+1;
       tipo_out_t{i}='BT';
    elseif (tipo==tipo_CT);
        padroes_t_pu_CT(:,tes_ct)=padroes_t_pu(:,i);
       target_t_CT(:,tes_ct)=target_t(:,i);
       tes_ct=tes_ct+1;
       tipo_out_t{i}='CT';
    end
    
    if (tipo==tipo_AB); % Fase-Fase
        padroes_t_pu_AB(:,tes_ab)=padroes_t_pu(:,i);
       target_t_AB(:,tes_ab)=target_t(:,i);
       tes_ab=tes_ab+1;
       tipo_out_t{i}='AB';
    elseif (tipo==tipo_AC);
        padroes_t_pu_AC(:,tes_ac)=padroes_t_pu(:,i);
       target_t_AC(:,tes_ac)=target_t(:,i);
       tes_ac=tes_ac+1;
       tipo_out_t{i}='AC';
    elseif (tipo==tipo_BC);
        padroes_t_pu_BC(:,tes_bc)=padroes_t_pu(:,i);
       target_t_BC(:,tes_bc)=target_t(:,i);
       tes_bc=tes_bc+1;
       tipo_out_t{i}='BC';
    end
    
    if (tipo==tipo_ABT); % Fase-Fase-Terra
        padroes_t_pu_ABT(:,tes_abt)=padroes_t_pu(:,i);
       target_t_ABT(:,tes_abt)=target_t(:,i);
       tes_abt=tes_abt+1;
       tipo_out_t{i}='ABT';
    elseif (tipo==tipo_BCT);
        padroes_t_pu_BCT(:,tes_bct)=padroes_t_pu(:,i);
       target_t_BCT(:,tes_bct)=target_t(:,i);
       tes_bct=tes_bct+1;
       tipo_out_t{i}='BCT';
    elseif (tipo==tipo_ACT);
        padroes_t_pu_ACT(:,tes_act)=padroes_t_pu(:,i);
       target_t_ACT(:,tes_act)=target_t(:,i);
       tes_act=tes_act+1;
       tipo_out_t{i}='ACT';
    end
    
    if (tipo==tipo_ABC); % Fase-Fase-Fase
        padroes_t_pu_ABC(:,tes_abc)=padroes_t_pu(:,i);
       target_t_ABC(:,tes_abc)=target_t(:,i);
       tes_abc=tes_abc+1;
       tipo_out_t{i}='ABC';
    end
    
    if (tipo==tipo_ABCT); % Fase-Fase-Fase-Terra
        padroes_t_pu_ABCT(:,tes_abct)=padroes_t_pu(:,i);
       target_t_ABCT(:,tes_abct)=target_t(:,i);
       tes_abct=tes_abct+1;
       tipo_out_t{i}='ABCT';
    end 
end % ordem teste

%%

clear i tipo trei_ff trei_fff trei_ffft trei_fft trei_ft val_ff val_fff val_ffft val_fft val_ft tes_ff tes_fff tes_ffft tes_fft tes_ft caminho_arq caminho_out nome_input ans






