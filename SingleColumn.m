function [ output_args ] = SingleColumn( input_args )
%UNTITLED2 此处显示有关此函数的摘要
%   Random Assignment of Single Stage Pressure Drop Influence
% %open file selection dialog
% [filename,filepath]=uigetfile('*.bkp');
% 
% %CreateObject("Apwn.Document") to create the automation object. This is
% %non-version specific call.
% handles.aspen=actxserver('Apwn.Document');
% 
% % tf=iscom('handles.aspen');
% % disp(tf);
% 
% handles.filepathname=strcat(filepath,filename);
% 
% %Open an Aspen Plus document and connect to the simulation engine.
% %InitFromFile2 has the same arguments as InitFromArchive2
% handles.aspen.InitFromArchive2(handles.filepathname);
% 
% %application visible
% handles.aspen.Visible=0;
% 
% %replace handles.aspen with aspen
% aspen=handles.aspen;
% 
% %define concentration matrix
% s1=[];
% 
% for j=1:51
%     prefix = '\Data\Blocks\B1\Output\Y\';
%     stage = int2str(j);
%     ethanol = '\ETHANOL';
%     address = strcat(prefix,stage,ethanol);
%     s1(j)= aspen.Tree.FindNode(address).value;
% end
%         
%     
% handles.aspen.Close
% 
% %---------------------------------------------------------------------%
% 
% %open file selection dialog
% [filename,filepath]=uigetfile('*.bkp');
% 
% %CreateObject("Apwn.Document") to create the automation object. This is
% %non-version specific call.
% handles.aspen=actxserver('Apwn.Document');
% 
% % tf=iscom('handles.aspen');
% % disp(tf);
% 
% handles.filepathname=strcat(filepath,filename);
% 
% %Open an Aspen Plus document and connect to the simulation engine.
% %InitFromFile2 has the same arguments as InitFromArchive2
% handles.aspen.InitFromArchive2(handles.filepathname);
% 
% %application visible
% handles.aspen.Visible=0;
% 
% %replace handles.aspen with aspen
% aspen=handles.aspen;
% 
% 
% s2=[];
% 
% for j=1:51
%     prefix = '\Data\Blocks\B1\Output\Y\';
%     stage = int2str(j);
%     ethanol = '\ETHANOL';
%     address = strcat(prefix,stage,ethanol);
%     s2(j)= aspen.Tree.FindNode(address).value;
% end
% figure
% plot(1:51,s1,1:51,s2)
% legend('Default','Tray Rating')
% title('Ethanol Mole Concentration')
% xlabel('Stage')
% ylabel('Ethanol Mole Concentration')
%     
%     
%     
% handles.aspen.Close

%-------------------------------------------------------------------%
%open file selection dialog
[filename,filepath]=uigetfile('*.bkp');

%CreateObject("Apwn.Document") to create the automation object. This is
%non-version specific call.
handles.aspen=actxserver('Apwn.Document');

% tf=iscom('handles.aspen');
% disp(tf);

handles.filepathname=strcat(filepath,filename);

%Open an Aspen Plus document and connect to the simulation engine.
%InitFromFile2 has the same arguments as InitFromArchive2
handles.aspen.InitFromArchive2(handles.filepathname);

%application visible
handles.aspen.Visible=0;

%replace handles.aspen with aspen
aspen=handles.aspen;

%define concentration matrix
z=zeros(7,51);

dp=linspace(0,0.012,7);


for i=1:7
    aspen.Tree.FindNode('\Data\Blocks\B1\Input\DP_STAGE').value=dp(i);
%use dot notation for navigating the tree and use Findnote function to specify an object
%the expression can be copied from Variable Explorer in aspen customize


    %Reinit needs to click OK in Aspen GUI every round
    %Reinit(aspen)
    
    %Run2 function is to make the simulation run asynchronous. This allows
    %the automation client to proceed with other tasks while waiting  for
    %the simulation run to complete. 
    %ASPEN PlUS SHOULD ALWAYS BE RAN ASYNCHRONOUSLY IF THE APPLICATION IS VISIBLE.
    aspen.Run2
    for j=1:51
        prefix = '\Data\Blocks\B1\Output\Y\';
        stage = int2str(j);
        ethanol = '\ETHANOL';
        address = strcat(prefix,stage,ethanol);
        z(i,j)= aspen.Tree.FindNode(address).value;
    end
end
figure
plot(1:51,z(1:7,:))
legend(strcat(num2str(dp(1)),' bar'),strcat(num2str(dp(2)),' bar'),strcat(num2str(dp(3)),' bar'),strcat(num2str(dp(4)),' bar'),strcat(num2str(dp(5)),' bar'),strcat(num2str(dp(6)),' bar'),strcat(num2str(dp(7)),' bar'))
title('Ethanol Concentration')
xlabel('Stage')
ylabel('Ethanol Concentration')
    
    
    
handles.aspen.Close

end

