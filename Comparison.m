function [ output_args ] = Comparison( input_args )
%UNTITLED3 此处显示有关此函数的摘要
%   比较几个B_PRES2之间的区别
%open file selection dialog
[filename,filepath]=uigetfile('*.bkp');

handles.aspen=actxserver('Apwn.Document');

handles.filepathname=strcat(filepath,filename);

handles.aspen.InitFromArchive2(handles.filepathname);

handles.aspen.Visible=1;

aspen=handles.aspen;

aspen.Tree.FindNode('\Data\Blocks\B1\Input\BASIS_CSFLOW\2').value=S2(i);

aspen.Run2
    
handles.aspen.Close

end

