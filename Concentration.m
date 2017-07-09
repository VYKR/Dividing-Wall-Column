function [ output_args ] = Concentration( input_args )
%UNTITLED2 此处显示有关此函数的摘要
%   随便定S2流量对于Main Column中的Ethanol的影响
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
z=zeros(6,51);

S2=linspace(500,700,6);


for i=1:6
    aspen.Tree.FindNode('\Data\Blocks\B1\Input\BASIS_CSFLOW\2').value=S2(i);
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
        prefix = '\Data\Blocks\B1\Output\Y\1\';
        stage = int2str(j);
        ethanol = '\ETHANOL';
        address = strcat(prefix,stage,ethanol);
        z(i,j)= aspen.Tree.FindNode(address).value;
    end
end
figure
plot(1:51,z(1:6,:))
legend(strcat(int2str(S2(1)),'kmol/hr'),strcat(int2str(S2(2)),'kmol/hr'),strcat(int2str(S2(3)),'kmol/hr'),strcat(int2str(S2(4)),'kmol/hr'),strcat(int2str(S2(5)),'kmol/hr'),strcat(int2str(S2(6)),'kmol/hr'))
title('Ethanol Concentration')
xlabel('Stage')
ylabel('Ethanol Concentration')
    
    
    
handles.aspen.Close



end

