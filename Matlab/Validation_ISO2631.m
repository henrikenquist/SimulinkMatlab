clear all;
clc
print_multiple = 1;
Wk_input = 2;
Wd_input = 3;
Wf_input = 4;

Wc_input = 8;
We_input = 9;
Wj_input = 10;

f1_index = 1;

Wk_Index = f1_index + 1;
Wd_Index = Wk_Index + 3;
Wf_Index = Wd_Index + 3;
f2_index = Wf_Index + 3;
Wc_Index = f2_index + 1;
We_Index = Wc_Index + 3;
Wj_Index = We_Index + 3;
Coefficients = zeros(8,1);
% This is the indexes of the report written, at later phase.
Coefficients={Wk_Index, Wd_Index, Wf_Index,Wc_Index,We_Index,Wj_Index};
InputFilters = {Wk_input, Wd_input, Wf_input, Wc_input, We_input, Wj_input};
Amp = 1; % Amplitude of the test signal
xlsdata = xlsread('ISO2631_simplified.xlsx',1);
%[num, txt, raw] = xlsread('ISO2631.xlsx',1);

FinalFile = zeros(28,20);
% number of iterations
it = length(InputFilters);
%*************************************************
% Respective frequencies are written
%*************************************************

FinalFile(:,f1_index)=xlsdata(:,1);
FinalFile(:,f2_index)=xlsdata(:,7);
Calculated = zeros(28,6);
Tabled = zeros(28,6);
for count=1:it 
    if count > 3        
        %7 is the index of freq 2 in the input file
        frequency = xlsdata(:,7); 
        
    else
        %1 is the index of freq 1 in the input file
        frequency = xlsdata(:,1);
    end;
    %remove trailing NaN in the array
    frequency(isnan(frequency(:,1)),:) = [];
    % Take the appropriate lentght of the block
    len = length(frequency);
    table_filter_index = cell2mat(InputFilters(count));
    W_Filter = xlsdata(:,table_filter_index); 
    position = cell2mat(Coefficients(1,count));
   
    for i=1:len
        f = frequency(i);             % Signal frequency
        T = 1/f;                      % Window period on which the RMS will be applied0
        Fs = f*100;                   % Sampling frequency
        t = 0:1/Fs:200*T;             % Form the time window
        sig = Amp*sin(2*pi*f*t);      % Form the signal
        temp = ISO2631(sig,count,Fs);     % Filter the signal with iso2631 filter
        
        %*************************************************
        % First write calculated by ISO2631 filter RMS
        %*************************************************
        FinalFile(i,position) = sqrt(mean(temp.^2)); %Implementation of the RMS function
        Calculated(i,count) = FinalFile(i,position);
        % And now make the manual calculation on the given frequncy
        %*************************************************
        % now calculated by table in ISO2631
        %*************************************************
        FinalFile(i,(position+1)) = ((Amp*W_Filter(i))/sqrt(2))/1000;
        Tabled(i,count) = FinalFile(i,(position+1));
        %*************************************************
        if FinalFile(i,(position+1)) == 0
            FinalFile(i,(position+2)) = 0;
        else
            FinalFile(i,(position+2)) = (abs(FinalFile(i,(position+1))-FinalFile(i,(position))))/FinalFile(i,(position+1));    
            FinalFile(i,(position+2)) = FinalFile(i,(position+2)) * 100;
        end;
        
    end;  
end;
Column_names_str = {'Freq [Hz]','Wk-Processed','Wk-Analitical','Wk-Error','Wd-Processed','Wd-Analitical','Wd-Error','Wf-Processed','Wf-Analitical','Wf-Error','Freq [Hz]','Wc-Processed','Wc-Analitical','Wc-Error','We-Processed','We-Analitical','We-Error','Wj-Processed','Wj-Analitical','Wj-Error'};
    %output_matrix = [Column_names_str; FinalFile];
    xlswrite('NewTestReport_ISO2631.xlsx',Column_names_str,'A1:T1'); 
    xlswrite('NewTestReport_ISO2631.xlsx',FinalFile,'A2:T45');
    Frequn = FinalFile(1:28,1);
    Frequn1 = FinalFile(1:22,11);
    Wk_Error = FinalFile(1:28,4);
    Wd_Error = FinalFile(1:28,7);
    Wf_Error = FinalFile(1:28,10);
    Wc_Error = FinalFile(1:22,14);
    We_Error = FinalFile(1:22,17);
    Wj_Error = FinalFile(1:22,20);
    
    %----------------------------------------
    %         +++ Wk Error +++
    %----------------------------------------
    
    figure % opens new figure window
    if(print_multiple == 1)
        subplot(3,1,1)
    end;
    plot(Frequn,Wk_Error)
    title('������ �� Wk(�������)')
    xlabel('������� [Hz]') % x-axis label
    ylabel('����� ��������� ������[%]') % y-axis label
    %----------------------------------------
    if(print_multiple == 1)
        subplot(3,1,2)    
        plot(Frequn,Tabled(:,1));
        title('Wk �������� �������� �� ���������')
        xlabel('������� [Hz]') % x-axis label
        ylabel('���������� � Wk ') % y-axis labe
        subplot(3,1,3)
        plot(Frequn,Calculated(:,1));
        title('Wk ��������� �� �������')
        xlabel('������� [Hz]') % x-axis label
        ylabel('���������� � Wk') % y-axis label
    end; 
    %----------------------------------------
    %         +++ Wd Error +++
    %----------------------------------------
    figure % opens new figure window
    if(print_multiple == 1)
        subplot(3,1,1)
    end;
    plot(Frequn,Wd_Error)
    title('������ �� Wd(�������)')
    xlabel('������� [Hz]') % x-axis label
    ylabel('����� ��������� ������[%]') % y-axis label
    %----------------------------------------
    if(print_multiple == 1)
        subplot(3,1,2)    
        plot(Frequn,Tabled(:,1));
        title('Wd �������� �������� �� ���������')
        xlabel('������� [Hz]') % x-axis label
        ylabel('���������� � Wd ') % y-axis labe
        subplot(3,1,3)
        plot(Frequn,Calculated(:,1));
        title('Wd ��������� �� �������')
        xlabel('������� [Hz]') % x-axis label
        ylabel('���������� � Wd') % y-axis label
    end;
    %----------------------------------------
    %         +++ Wf Error +++
    %----------------------------------------
    figure % opens new figure window
    if(print_multiple == 1)
        subplot(3,1,1)
    end;
    plot(Frequn,Wf_Error)
    title('������ �� Wf(�������)')
    xlabel('������� [Hz]') % x-axis label
    ylabel('����� ��������� ������[%]') % y-axis label
    %----------------------------------------
    if(print_multiple == 1)
        subplot(3,1,2)    
        plot(Frequn,Tabled(:,1));
        title('Wf �������� �������� �� ���������')
        xlabel('������� [Hz]') % x-axis label
        ylabel('���������� � Wf ') % y-axis labe
        subplot(3,1,3)
        plot(Frequn,Calculated(:,1));
        title('Wf ��������� �� �������')
        xlabel('������� [Hz]') % x-axis label
        ylabel('���������� � Wf') % y-axis label
    end;
    %----------------------------------------
    %         +++ Wc Error +++
    %----------------------------------------
    figure % opens new figure window
    if(print_multiple == 1)
        subplot(3,1,1)
    end;
    plot(Frequn1,Wc_Error)
    title('������ �� Wc(�������)')
    xlabel('������� [Hz]') % x-axis label
    ylabel('����� ��������� ������[%]') % y-axis label
    %----------------------------------------
    if(print_multiple == 1)
        subplot(3,1,2)    
        plot(Frequn,Tabled(:,1));
        title('Wc �������� �������� �� ���������')
        xlabel('������� [Hz]') % x-axis label
        ylabel('���������� � Wc ') % y-axis labe
        subplot(3,1,3)
        plot(Frequn,Calculated(:,1));
        title('Wc ��������� �� �������')
        xlabel('������� [Hz]') % x-axis label
        ylabel('���������� � Wc') % y-axis label
    end;
   %----------------------------------------
    %         +++ We Error +++
    %----------------------------------------
    figure % opens new figure window
    if(print_multiple == 1)
        subplot(3,1,1)
    end;
    plot(Frequn1,We_Error)
    title('������ �� We(�������)')
    xlabel('������� [Hz]') % x-axis label
    ylabel('����� ��������� ������[%]') % y-axis label
    %----------------------------------------
    if(print_multiple == 1)
        subplot(3,1,2)    
        plot(Frequn,Tabled(:,1));
        title('We �������� �������� �� ���������')
        xlabel('������� [Hz]') % x-axis label
        ylabel('���������� � We ') % y-axis labe
        subplot(3,1,3)
        plot(Frequn,Calculated(:,1));
        title('We ��������� �� �������')
        xlabel('������� [Hz]') % x-axis label
        ylabel('���������� � We') % y-axis label
    end;
    %----------------------------------------
    %         +++ Wj Error +++
    %----------------------------------------
    figure % opens new figure window
    if(print_multiple == 1)
        subplot(3,1,1)
    end;
    plot(Frequn1,Wj_Error)
    title('������ �� Wj(�������)')
    xlabel('������� [Hz]') % x-axis label
    ylabel('����� ��������� ������[%]') % y-axis label
    %----------------------------------------
    if(print_multiple == 1)
        subplot(3,1,2)    
        plot(Frequn,Tabled(:,1));
        title('Wj �������� �������� �� ���������')
        xlabel('������� [Hz]') % x-axis label
        ylabel('���������� � Wj ') % y-axis labe
        subplot(3,1,3)
        plot(Frequn,Calculated(:,1));
        title('Wj ��������� �� �������')
        xlabel('������� [Hz]') % x-axis label
        ylabel('���������� � Wj') % y-axis label
    end;
