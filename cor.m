function [xnew]=cor(c,x_num)
%Լ��

x_old=c(1:x_num);%��ȡ�ɵľ��߱���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global need;%����
global w;%��������
global car_num;%������Ŀ

while (1)
    %���Ȼ��ÿ������Ϣ(��)
    
    remain=w;%��������ʼ��
    min_kehu_idx=zeros(1,car_num);%������С�Ŀͻ���������ʼ��
    
    min_kehu_w=zeros(1,car_num);%������С�Ŀͻ�����
   
    for ii=1:car_num%����ÿ���� 
        quzheng=floor(x_old);%!!!!�õ�ÿ�����������γ�  [1,2,3,4,6,6,1,2,2,2,2,2,2,2,2] 
        kehu_idx=find(quzheng==ii);%����ͻ����� [1,7]
        if length(kehu_idx)>0 %�пͻ��б�
            [this_min_kehu_w,min_kehu_idx_in]=min(need(kehu_idx)); %min_kehu_idx_in=2 min_kehu_w=8.31;
            min_kehu_idx(ii)=kehu_idx(min_kehu_idx_in); %7
            remain(ii)=remain(ii)-sum(need(kehu_idx));%���ʣ��Ŀ��
            min_kehu_w(ii)=this_min_kehu_w;
        else %�޿ͻ��� ���øı�remain
            
        end

    end%���ÿ����������,��С�ͻ�������������������
   
    over_flag=0;%���ر�־��ʼ�� Ϊ0 ������
    
    if length(remain(remain<0))>0 %˵��remain֮�д��ڸ���
        over_flag=1;
    end
    
    if over_flag==0 %������ ˵�����Ǻ����
        break;%����while 1��ѭ��
    else %������
        tp=min_kehu_w;%��ʱ����
        nor_idx=find(remain>0);%δ���صĳ�����
        tp(nor_idx)=1e5;%δ���ص�ȡ�ܴ�
        [~,idx]=min(tp);%��� ���صĳ��� ����С�ͻ������ ��������
        change_kehu_idx=min_kehu_idx(idx);%��Ҫ�ı�Ŀͻ�������
        [zhi,QZC_idx]=max(remain);%��þ������ԣ�ȵĳ������� ������������
        
        if zhi<need(change_kehu_idx) %ʧ�� ���ʽ�
            x_old(1)=-1e5; %!!!!!!!!!���ʽ�ı�־
            break;
        else %����ת��
            x_old(change_kehu_idx)=QZC_idx+rand*0.9;%ֱ��ת��
        end
    end
end


xnew=x_old;
    