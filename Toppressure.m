function [ output_args ] = Toppressure( input_args )
%UNTITLED4 此处显示有关此函数的摘要
%   Prefractionator Main Column Top Stage Pressure Influence on Pressure
%   Drop/ Ethanol Concentration
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

p2=linspace(0.1215,0.122,6);

p14=[];

pd1=[];
pd2=[];

z=zeros(6,51);

for i=1:6
    aspen.Tree.FindNode('\Data\Blocks\B1\Input\PRES1\2').value=p2(i);
%use dot notation for navigating the tree and use Findnote function to specify an object
%the expression can be copied from Variable Explorer in aspen customize


    %Reinit needs to click OK in Aspen GUI every round
    %Reinit(aspen)
    
    %Run2 function is to make the simulation run asynchronous. This allows
    %the automation client to proceed with other tasks while waiting  for
    %the simulation run to complete. 
    %ASPEN PlUS SHOULD ALWAYS BE RAN ASYNCHRONOUSLY IF THE APPLICATION IS VISIBLE.
    aspen.Run2
    p14(i)=aspen.Tree.FindNode('\Data\Blocks\B1\Output\B_PRES2\1\14').value/10;
    
    
    aspen.Run2
    
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
    
    for j=1:51
        prefix = '\Data\Blocks\B1\Output\Y\1\';
        stage = int2str(j);
        ethanol = '\ETHANOL';
        address = strcat(prefix,stage,ethanol);
        z(i,j)= aspen.Tree.FindNode(address).value;
    end
    
end
disp(p14);
fprintf('%12.6f\n',p14(1));
fprintf('%12.6f\n',p14(2));
fprintf('%12.6f\n',p14(3));
fprintf('%12.6f\n',p14(4));
fprintf('%12.6f\n',p14(5));
fprintf('%12.6f\n',p14(6));

plot(p2,p14)
hold on
x=linspace(0.1215,0.122,6);
y=linspace(0.1215,0.122,6);
plot(x,y)
title('Pressure: Main Column Stage 14 VS Prefractionator Stage 1')
xlabel('Prefractionator /MPa')
ylabel('Main Column Stage 14 /MPa')
hold off

figure
plot(p2,pd1,p2,pd2) 
title('Prefractionator & Main Column Pressure Drop')
xlabel('Prefractionatro Stage 1 Pressure /MPa')
ylabel('Pressure Drop bar')
legend('Main Column','Prefractionator')

figure
plot(1:51,z(1:6,:))
legend(strcat(num2str(p2(1)),'MPa'),strcat(num2str(p2(2)),'MPa'),strcat(num2str(p2(3)),'MPa'),strcat(num2str(p2(4)),'MPa'),strcat(num2str(p2(5)),'MPa'),strcat(num2str(p2(6)),'MPa'))
title('Ethanol Concentration')
xlabel('Stage')
ylabel('Ethanol Concentration')
    
    
handles.aspen.Close

end

