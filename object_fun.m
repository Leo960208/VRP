function f = object_fun( x,f_num,x_num )
%计算适应度值 目标函数 %
%x为所有的信息
f=zeros(1,f_num);%目标函数初始化
xu=x(1:x_num);%获取决策变量

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

dis_flag=0;


if xu(1)<-100 %劣质解 %超载
    f(1)=1e8;
else %有效解
    yunfei=0;
    all_t=0;
    
    for ii=1:car_num %遍历每个车
        tp_x=xu;%临时变量
        
        quzheng=floor(tp_x);%!!!!得到每个需求点的责任车  [1,2,3,4,6,6,1,2,2,2,2,2,2,2,2]
        kehu_idx=find(quzheng==ii);%得到该车的客户列表,索引 引向客户数组 [1,7]
        fei_kehu_idx=find(quzheng~=ii);%得到该车的非客户列表,索引 引向客户数组 [1,7]
        tp_x(fei_kehu_idx)=1e4;
        [~,road_all]=sort(tp_x);
        road=road_all(1:length(kehu_idx));%得到路径
        
        star_t=0;%开始时间初始化
        av_t=0;%到达时间初始化
        all_d=0;
        if length(kehu_idx)>0 %有客户列表
            yunfei=yunfei+gd_c;%固定费用
            kehu_num=length(kehu_idx);
            
            home_idx=w_home(ii);
            
            %送货不会超载 这里只判断装货是否超载
            this_remain=w(ii)-sum(need(kehu_idx));%余量初始化
            
            for j=1:kehu_num %遍历每个客户
                if j==1%第一个客户
                    this_kehu=road(j);%客户的索引
                    
                    this_need=need(this_kehu);
                    this_send=0;
                    this_remain=this_remain+this_need;%这个车的剩余容量因送了need增加了
                    if this_remain<this_send %余量太小 失败
                        send_bad_f=1;
                        break;
                    end
                    
                    this_po=po(this_kehu,:);%获得客户的位置
                    qian_po=ORI(home_idx,:);%获得前一个客户的位置
                    
                    this_d=sqrt (sum( ( this_po-qian_po).^2));%本次路程的距离
                    t_use=( 1+r*( yij(this_kehu,this_kehu+home_idx)/Cij  )^m )*(this_d/v);
                    av_t=star_t+t_use ;%时间
                    star_t=av_t;%时间
                    
                    yunfei=yunfei+this_d*c;%累加运费
                    all_t=all_t+t_use;
                    all_d=all_d+this_d;
                    
                    
                    
                else %不是第一个客户
                    this_kehu=road(j);%客户的索引
                    qian_kehu=road(j-1);%前面一个客户的索引
                    
                    this_need=need(this_kehu);
                    this_send=0;
                    this_remain=this_remain+this_need;%这个车的剩余容量因送了need增加了
                    if this_remain<this_send %余量太小 失败
                        send_bad_f=1;
                        break;
                    end
                    
                    
                    this_po=po(this_kehu,:);%获得客户的位置
                    qian_po=po(qian_kehu,:);%获得前一个客户的位置
                    
                    this_d=sqrt (sum( ( this_po-qian_po).^2));%本次路程的距离
                    t_use=( 1+r*( yij(this_kehu,this_kehu+home_idx)/Cij )^m )*(this_d/v);
                    av_t=star_t+t_use ;%时间
                    star_t=av_t;%时间
                    
                    yunfei=yunfei+this_d*c;%累加运费
                    all_t=all_t+t_use;
                    all_d=all_d+this_d;
                    
                end
            end%所有客户配送完毕
            
            this_po=ORI(home_idx,:);%返厂
            qian_kehu=road(kehu_num);
            qian_po=po(qian_kehu,:);%获得前一个客户的位置
            this_d= sqrt (sum( ( this_po-qian_po).^2));%本次路程的距离
            t_use=( 1+r*( yij(this_kehu,this_kehu+home_idx)/Cij )^m )*(this_d/v);
            av_t=star_t+t_use ;%时间
            star_t=av_t;%时间
            
            yunfei=yunfei+this_d*c;%累加运费
            all_t=all_t+t_use;
            all_d=all_d+this_d;
            
            if all_d>dis_max
                dis_flag=dis_flag+1;%超距离约束
            end
            
        end
        
    end
    
    
    f(1)=all_t*omg1+yunfei*omg2*yunfeixishu+dis_flag*1e10;
    
    
end





