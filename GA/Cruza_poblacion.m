function [Cromosoma]=Cruza_poblacion(ganador_torneo,Cromosoma,cromN)
Nc=ganador_torneo(1,1);
MaxA=cromN/2;
MinA=1;
MaxB=cromN;
MinB=cromN/2+1;

MaxD=cromN/2;
MinD=1;
MaxE=cromN;
MinE=cromN/2+1;


A1=Nc;
A2=Nc;
A3=Nc;
A4=Nc;

valor=ganador_torneo(1,2);
   if valor>0
       %% cruza dirigida
       while A1==Nc
            A1=round((MaxA-MinA)*rand+MinA);
       end
       while A2==Nc
            A2=round((MaxB-MinB)*rand+MinB);
       end
       Cromosoma(A1,1)=Cromosoma(A1,1);
       Cromosoma(A2,2)=Cromosoma(Nc,2);
       Cromosoma(Nc,1)=Cromosoma(Nc,1);
       Cromosoma(Nc,2)=Cromosoma(A2,2);
       
       %% cruza aleatoria
       while A3==Nc
           if A3~=A1
            A3=round((MaxD-MinD)*rand+MinD);
           else
               A3=Nc;
           end
       end
       while A4==Nc
           if A4~=A2
            A4=round((MaxE-MinE)*rand+MinE);
           else
               A4=Nc;
           end
       end
       Cromosoma(A3,1)=Cromosoma(A1,1);
       Cromosoma(A3,2)=Cromosoma(Nc,2);
       Cromosoma(A4,1)=Cromosoma(A4,1);
       Cromosoma(A4,2)=Cromosoma(A1,2);
       
                  
    else
       while A1==Nc
            A1=round((MaxD-MinD)*rand+MinD);
       end
       while A2==Nc
            A2=round((MaxE-MinE)*rand+MinE);
       end
       Cromosoma(A1,1)=Cromosoma(A1,1);
       Cromosoma(A1,2)=Cromosoma(A2,2);
       Cromosoma(A2,1)=Cromosoma(A2,1);
       Cromosoma(A2,2)=Cromosoma(A1,2);
       
   end
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        

 