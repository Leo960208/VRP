clc;clear all;close all;
rand('seed',1e5);

%��ȡ����
data_all=xlsread('data.xlsx');
data_ori=xlsread('data_ori.xlsx');

%��������
global omg1;%Ȩ��1 ʱ��ɱ�
global omg2;%Ȩ��2 �˷ѳɱ�
global po;%λ��
global need;%����
global c;%�˷�
global gd_c;%�̶��˷�
global w;%�������� ������ʽ
global car_num;%������Ŀ
global ORI;%0�������
%global color;%·����ɫ
global w_home;%�����������ֿ�
%global kehu_num;%���ֵ����
global Cij;%��·ͨ������
global yij;%ʵ�ʵ�·�ĳ�����
global ck_num;%�ֿ���Ŀ
global r;
global m;
global v;
global dis_max;%������
global yunfeixishu;


omg1=0.7;
omg2=0.3;
po=data_all(:,1:2);
need=data_all(:,3);
c=15;
gd_c=200;
w=[30,30,30];
w_home=[1,2,3];
%color=['k','k','m','m','g','g','b','b','r','r'];
car_num=length(w);
ORI=data_ori;
[kehu_num,~]=size(data_all);
Cij=1000;
ck_num=size(ORI,1);
yij=unidrnd(600,[kehu_num+ck_num,kehu_num+ck_num]);
r=0.15;
m=4;
v=50;
dis_max=100;
yunfeixishu=1e-3;


tic;

f_num=1;

x_num=kehu_num;%���߱����ĸ���
x_min=zeros(1,x_num);%���߱�������Сֵ�����ʼ��
x_max=zeros(1,x_num);%���߱��������ֵ����ĳ�ʼ��

x_min(:)=1+0.001; 
x_max(:)=car_num+0.999;

pop=5e3;%��Ⱥ��С
gen=50;%��������
pc=0.90;%�������
pm=0.9;%�������
yita1=20;%ģ������ƽ������
yita2=20;%����ʽ�������

pf1=zeros(1,gen);

px=1:1:gen;

%��ʼ����Ⱥ
chromo=initialize(pop,f_num,x_num,x_min,x_max);

for ii=1:gen
   %�����ƾ���ѡ��(kȡ��pop/2������ѡ����)
   chromo_parent_1 = tournament_selection(chromo,x_num);
   chromo_parent_2 = tournament_selection(chromo,x_num);
   chromo_parent=[chromo_parent_1;chromo_parent_2];
   %ģ������ƽ��������ʽ����
   chromo_offspring=cross_mutation(chromo_parent,f_num,x_num,x_min,x_max,pc,pm,yita1,yita2);
   %��Ӣ��������
   %���������Ӵ��ϲ�
   [pop_parent,~]=size(chromo);
   [pop_offspring,~]=size(chromo_offspring);
   combine_chromo(1:pop_parent,1:(f_num+x_num))=chromo(:,1:(f_num+x_num));
   combine_chromo((pop_parent+1):(pop_parent+pop_offspring),1:(f_num+x_num))=chromo_offspring(:,1:(f_num+x_num));
   %��Ӣ����������һ����Ⱥ
   chromo=elitism(pop,combine_chromo,f_num,x_num);
   
   if mod(ii,1) == 0
       fprintf('%d�������.\n',ii);
   end
   
   pf1(ii)=mean(chromo(:,x_num+1));
   
end

toc;
time=toc;

figure(1);
plot(px,pf1);
xlabel('��������');
ylabel('��Ⱥ��Ŀ�꺯����ƽ��ֵ');
grid on;

uncode(chromo(1,:),f_num,x_num);
