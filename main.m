clc;clear all;close all;
rand('seed',1e5);

%读取数据
data_all=xlsread('data.xlsx');
data_ori=xlsread('data_ori.xlsx');

%参数设置
global omg1;%权重1 时间成本
global omg2;%权重2 运费成本
global po;%位置
global need;%需求
global c;%运费
global gd_c;%固定运费
global w;%车的载重 向量形式
global car_num;%车的数目
global ORI;%0点的坐标
%global color;%路线颜色
global w_home;%车辆的所属仓库
%global kehu_num;%受灾点个数
global Cij;%道路通行能力
global yij;%实际道路的车流量
global ck_num;%仓库数目
global r;
global m;
global v;
global dis_max;%最大距离
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

x_num=kehu_num;%决策变量的个数
x_min=zeros(1,x_num);%决策变量的最小值数组初始化
x_max=zeros(1,x_num);%决策变量的最大值数组的初始化

x_min(:)=1+0.001; 
x_max(:)=car_num+0.999;

pop=5e3;%种群大小
gen=50;%进化代数
pc=0.90;%交叉概率
pm=0.9;%变异概率
yita1=20;%模拟二进制交叉参数
yita2=20;%多项式变异参数

pf1=zeros(1,gen);

px=1:1:gen;

%初始化种群
chromo=initialize(pop,f_num,x_num,x_min,x_max);

for ii=1:gen
   %二进制竞赛选择(k取了pop/2，所以选两次)
   chromo_parent_1 = tournament_selection(chromo,x_num);
   chromo_parent_2 = tournament_selection(chromo,x_num);
   chromo_parent=[chromo_parent_1;chromo_parent_2];
   %模拟二进制交叉与多项式变异
   chromo_offspring=cross_mutation(chromo_parent,f_num,x_num,x_min,x_max,pc,pm,yita1,yita2);
   %精英保留策略
   %将父代和子代合并
   [pop_parent,~]=size(chromo);
   [pop_offspring,~]=size(chromo_offspring);
   combine_chromo(1:pop_parent,1:(f_num+x_num))=chromo(:,1:(f_num+x_num));
   combine_chromo((pop_parent+1):(pop_parent+pop_offspring),1:(f_num+x_num))=chromo_offspring(:,1:(f_num+x_num));
   %精英保留产生下一代种群
   chromo=elitism(pop,combine_chromo,f_num,x_num);
   
   if mod(ii,1) == 0
       fprintf('%d代已完成.\n',ii);
   end
   
   pf1(ii)=mean(chromo(:,x_num+1));
   
end

toc;
time=toc;

figure(1);
plot(px,pf1);
xlabel('迭代次数');
ylabel('种群内目标函数的平均值');
grid on;

uncode(chromo(1,:),f_num,x_num);
