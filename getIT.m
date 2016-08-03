function [Inputs, Targets]=getIT(path)
D=dir(path);
%������� ����� ������� � ������. ������ ����� � ��������� ������.
classes={};
for i=1:length(D)
   if (D(i).isdir)&&(D(i).name(1)~='.') %���� ����� � �� ��������
      classes=[classes D(i).name];
   end
end

Inputs=[];
Targets=[];
for j=1:length(classes)
    ph=[path '\' cell2mat(classes(j))];
    Files=dir(ph);
    %Inputs=[Inputs zeros(length(Files),1)];
    for i=3:length(Files)
        [Y,Fs]=audioread([ph '\' Files(i).name]);
        y=fft(Y);
        Inputs=[Inputs; y(1:330000)']; %��������� ������ ����� � ������
    end
    Targets=[Targets; j*ones(length(Files)-2,1)]; %������� ������ �������, ��������������� ������
end

end