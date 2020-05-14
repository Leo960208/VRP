function [xnew]=cor(c,x_num)
%约束

x_old=c(1:x_num);%获取旧的决策变量
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global need;%需求
global w;%车的载重
global car_num;%车的数目

while (1)
    %首先获得每个的信息(车)
    
    remain=w;%车余量初始化
    min_kehu_idx=zeros(1,car_num);%车的最小的客户的索引初始化
    
    min_kehu_w=zeros(1,car_num);%车的最小的客户需求
   
    for ii=1:car_num%遍历每个车 
        quzheng=floor(x_old);%!!!!得到每个需求点的责任车  [1,2,3,4,6,6,1,2,2,2,2,2,2,2,2] 
        kehu_idx=find(quzheng==ii);%引向客户数组 [1,7]
        if length(kehu_idx)>0 %有客户列表
            [this_min_kehu_w,min_kehu_idx_in]=min(need(kehu_idx)); %min_kehu_idx_in=2 min_kehu_w=8.31;
            min_kehu_idx(ii)=kehu_idx(min_kehu_idx_in); %7
            remain(ii)=remain(ii)-sum(need(kehu_idx));%获得剩余的库存
            min_kehu_w(ii)=this_min_kehu_w;
        else %无客户的 不用改变remain
            
        end

    end%获得每个车的余量,最小客户的索引，及其需求量
   
    over_flag=0;%超载标志初始化 为0 不超载
    
    if length(remain(remain<0))>0 %说明remain之中存在负数
        over_flag=1;
    end
    
    if over_flag==0 %不超载 说明解是合理的
        break;%跳出while 1总循环
    else %超载了
        tp=min_kehu_w;%临时变量
        nor_idx=find(remain>0);%未超载的车索引
        tp(nor_idx)=1e5;%未超载的取很大；
        [~,idx]=min(tp);%获得 超载的车中 有最小客户需求的 车的索引
        change_kehu_idx=min_kehu_idx(idx);%需要改变的客户的索引
        [zhi,QZC_idx]=max(remain);%获得具有最大裕度的车的索引 及其具体的余量
        
        if zhi<need(change_kehu_idx) %失败 劣质解
            x_old(1)=-1e5; %!!!!!!!!!劣质解的标志
            break;
        else %可以转移
            x_old(change_kehu_idx)=QZC_idx+rand*0.9;%直接转移
        end
    end
end


xnew=x_old;
    