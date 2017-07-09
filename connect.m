function [ output_args ] = Connect( input_args )
%UNTITLED3 此处显示有关此函数的摘要
%   比较几个B_PRES2之间的区别
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

S2=linspace(590,615,26);

%pressure drop for main column
pd1=[];

%pressure drop for prefractionator
pd2=[];

p14=[];

for i=1:26
    %Assign value to the connecting stream 2 
    aspen.Tree.FindNode('\Data\Blocks\B1\Input\BASIS_CSFLOW\2').value=S2(i);
    
    aspen.Run2
    
    p14(i)=aspen.Tree.FindNode('\Data\Blocks\B1\Output\B_PRES2\1\14').value/10;
    
    count1=0;
    for j=15:42
        stage=int2str(j);
        prefix='\Data\Blocks\B1\Output\PDROP3\1\';
        address=strcat(prefix,stage);
        count1=count1+aspen.Tree.FindNode(address).value;
    end
    pd1(i)=count1;
    
    count2=0;
  
    for j=1:15
        stage = int2str(j);
        prefix='\Data\Blocks\B1\Output\PDROP3\2\';
        address=strcat(prefix,stage);
        count2=count2+aspen.Tree.FindNode(address).value;
    end
    pd2(i)=count2;
end

%use dot notation for navigating the tree and use Findnote function to specify an object
%the expression can be copied from Variable Explorer in aspen customize

handles.aspen.Close

plot(S2,p14)
title('Main Column Stage 14 Pressure /MPa')
xlabel('Connecting Stream 2 Flowrate kmol/hr')
ylabel('Main Column Stage 14 Pressure /MPa')

figure
plot(S2,pd1,S2,pd2) 
title('Prefractionator & Main Column Pressure Drop')
xlabel('Connecting Stream 2 Flowrate kmol/hr')
ylabel('Pressure Drop bar')
legend('Main Column','Prefractionator')

end

