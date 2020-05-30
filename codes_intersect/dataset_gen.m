%%
% �Զ������߶��ཻ���ж�ѵ�����ݼ�
clear;clc;
num_of_samples = 10000;
data = zeros(num_of_samples,9);
for i = 1:num_of_samples
    
    a=rand(1,2);
    b=rand(1,2);
    c=rand(1,2);
    d=rand(1,2);

    % ����4�������������߶���ɵľ������غϵ�
    % �ر�Ҫע��һ�����κ�����һ������֮�ڵ����
    flag = 0;
    if( (  min(a(1),b(1)) <= max(c(1),d(1)) ...  % 1.ab�������С��cd�����Ҷ�
        && min(c(1),d(1)) <= max(a(1),b(1)) ...  % 2.cd�������С��ab�����Ҷ�
        && min(a(2),b(2)) <= max(c(2),d(2)) ...  % 4.ab����͵����cd����ߵ�
        && min(c(2),d(2)) <= max(a(2),b(2))))    % 3.cd����͵����ab����ߵ�

        u=(c(1)-a(1))*(b(2)-a(2))-(b(1)-a(1))*(c(2)-a(2));
        v=(d(1)-a(1))*(b(2)-a(2))-(b(1)-a(1))*(d(2)-a(2));
        w=(a(1)-c(1))*(d(2)-c(2))-(d(1)-c(1))*(a(2)-c(2));
        z=(b(1)-c(1))*(d(2)-c(2))-(d(1)-c(1))*(b(2)-c(2));
        flag = (u*v<=0.00000001 && w*z<=0.00000001);    
    end

data(i,:) = [a,b,c,d,flag];
end
% dlmwrite('./train_data_intersect.dat', data, 'delimiter', '\t', 'precision', '%.6f')
dlmwrite('./validate_data_intersect.dat', data, 'delimiter', '\t', 'precision', '%.6f')

x=[a(1),c(1);b(1),d(1)];
y=[a(2),c(2);b(2),d(2)];
plot(x,y,'*-')
axis([0,1,0,1])
text(a(1)+0.02,a(2)+0.02,'a');
text(b(1)+0.02,b(2)+0.02,'b');
text(c(1)+0.02,c(2)+0.02,'c');
text(d(1)+0.02,d(2)+0.02,'d');
str = ['flag = ' num2str(flag)];
text(0.5,0.5,str)