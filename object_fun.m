function f = object_fun( x,f_num,x_num )
%������Ӧ��ֵ Ŀ�꺯�� %
%xΪ���е���Ϣ
f=zeros(1,f_num);%Ŀ�꺯����ʼ��
xu=x(1:x_num);%��ȡ���߱���

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

dis_flag=0;


if xu(1)<-100 %���ʽ� %����
    f(1)=1e8;
else %��Ч��
    yunfei=0;
    all_t=0;
    
    for ii=1:car_num %����ÿ����
        tp_x=xu;%��ʱ����
        
        quzheng=floor(tp_x);%!!!!�õ�ÿ�����������γ�  [1,2,3,4,6,6,1,2,2,2,2,2,2,2,2]
        kehu_idx=find(quzheng==ii);%�õ��ó��Ŀͻ��б�,���� ����ͻ����� [1,7]
        fei_kehu_idx=find(quzheng~=ii);%�õ��ó��ķǿͻ��б�,���� ����ͻ����� [1,7]
        tp_x(fei_kehu_idx)=1e4;
        [~,road_all]=sort(tp_x);
        road=road_all(1:length(kehu_idx));%�õ�·��
        
        star_t=0;%��ʼʱ���ʼ��
        av_t=0;%����ʱ���ʼ��
        all_d=0;
        if length(kehu_idx)>0 %�пͻ��б�
            yunfei=yunfei+gd_c;%�̶�����
            kehu_num=length(kehu_idx);
            
            home_idx=w_home(ii);
            
            %�ͻ����ᳬ�� ����ֻ�ж�װ���Ƿ���
            this_remain=w(ii)-sum(need(kehu_idx));%������ʼ��
            
            for j=1:kehu_num %����ÿ���ͻ�
                if j==1%��һ���ͻ�
                    this_kehu=road(j);%�ͻ�������
                    
                    this_need=need(this_kehu);
                    this_send=0;
                    this_remain=this_remain+this_need;%�������ʣ������������need������
                    if this_remain<this_send %����̫С ʧ��
                        send_bad_f=1;
                        break;
                    end
                    
                    this_po=po(this_kehu,:);%��ÿͻ���λ��
                    qian_po=ORI(home_idx,:);%���ǰһ���ͻ���λ��
                    
                    this_d=sqrt (sum( ( this_po-qian_po).^2));%����·�̵ľ���
                    t_use=( 1+r*( yij(this_kehu,this_kehu+home_idx)/Cij  )^m )*(this_d/v);
                    av_t=star_t+t_use ;%ʱ��
                    star_t=av_t;%ʱ��
                    
                    yunfei=yunfei+this_d*c;%�ۼ��˷�
                    all_t=all_t+t_use;
                    all_d=all_d+this_d;
                    
                    
                    
                else %���ǵ�һ���ͻ�
                    this_kehu=road(j);%�ͻ�������
                    qian_kehu=road(j-1);%ǰ��һ���ͻ�������
                    
                    this_need=need(this_kehu);
                    this_send=0;
                    this_remain=this_remain+this_need;%�������ʣ������������need������
                    if this_remain<this_send %����̫С ʧ��
                        send_bad_f=1;
                        break;
                    end
                    
                    
                    this_po=po(this_kehu,:);%��ÿͻ���λ��
                    qian_po=po(qian_kehu,:);%���ǰһ���ͻ���λ��
                    
                    this_d=sqrt (sum( ( this_po-qian_po).^2));%����·�̵ľ���
                    t_use=( 1+r*( yij(this_kehu,this_kehu+home_idx)/Cij )^m )*(this_d/v);
                    av_t=star_t+t_use ;%ʱ��
                    star_t=av_t;%ʱ��
                    
                    yunfei=yunfei+this_d*c;%�ۼ��˷�
                    all_t=all_t+t_use;
                    all_d=all_d+this_d;
                    
                end
            end%���пͻ��������
            
            this_po=ORI(home_idx,:);%����
            qian_kehu=road(kehu_num);
            qian_po=po(qian_kehu,:);%���ǰһ���ͻ���λ��
            this_d= sqrt (sum( ( this_po-qian_po).^2));%����·�̵ľ���
            t_use=( 1+r*( yij(this_kehu,this_kehu+home_idx)/Cij )^m )*(this_d/v);
            av_t=star_t+t_use ;%ʱ��
            star_t=av_t;%ʱ��
            
            yunfei=yunfei+this_d*c;%�ۼ��˷�
            all_t=all_t+t_use;
            all_d=all_d+this_d;
            
            if all_d>dis_max
                dis_flag=dis_flag+1;%������Լ��
            end
            
        end
        
    end
    
    
    f(1)=all_t*omg1+yunfei*omg2*yunfeixishu+dis_flag*1e10;
    
    
end





