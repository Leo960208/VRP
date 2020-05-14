function chromo_offspring = cross_mutation( chromo_parent,f_num,x_num,x_min,x_max,pc,pm,yita1,yita2)
%ģ������ƽ��������ʽ���� 

[pop,~]=size(chromo_parent);
suoyin=1;
for i=1:pop
   %%%ģ������ƽ���
   %��ʼ���Ӵ���Ⱥ
   %���ѡȡ������������
   parent_1=round(pop*rand(1));
   if (parent_1<1)
       parent_1=1;
   end
   parent_2=round(pop*rand(1));
   if (parent_2<1)
       parent_2=1;
   end
   %ȷ�������������岻��ͬһ��
   ff=0;
   while isequal(chromo_parent(parent_1,:),chromo_parent(parent_2,:))
       parent_2=round(pop*rand(1));
       if(parent_2<1)
           parent_2=1;
       end
       ff=ff+1;
       if ff>pop*2
           break;
       end
   end
   chromo_parent_1=chromo_parent(parent_1,:);
   chromo_parent_2=chromo_parent(parent_2,:);
   off_1=chromo_parent_1;
   off_2=chromo_parent_1;
   if(rand(1)<pc)
       %����ģ������ƽ���
       u1=zeros(1,x_num);
       gama=zeros(1,x_num);
       for j=1:x_num
           u1(j)=rand(1);
           if u1(j)<0.5
               gama(j)=(2*u1(j))^(1/(yita1+1));
           else
               gama(j)=(1/(2*(1-u1(j))))^(1/(yita1+1));
           end
           off_1(j)=0.5*((1+gama(j))*chromo_parent_1(j)+(1-gama(j))*chromo_parent_2(j));
           off_2(j)=0.5*((1-gama(j))*chromo_parent_1(j)+(1+gama(j))*chromo_parent_2(j));
           %ʹ�Ӵ��ڶ�������
           if(off_1(j)>x_max(j))
               off_1(j)=x_max(j);
           elseif(off_1(j)<x_min(j))
               off_1(j)=x_min(j);
           end
           if(off_2(j)>x_max(j))
               off_2(j)=x_max(j);
           elseif(off_2(j)<x_min(j))
               off_2(j)=x_min(j);
           end
       end
       %�����Ӵ������Ŀ�꺯��ֵ
       off_1(1,1:x_num)=cor(off_1(1,1:x_num),x_num);%%%%%
       off_2(1,1:x_num)=cor(off_2(1,1:x_num),x_num);%%%%%
       off_1(1,(x_num+1):(x_num+f_num))=object_fun(off_1,f_num,x_num);
       off_2(1,(x_num+1):(x_num+f_num))=object_fun(off_2,f_num,x_num);
   end
   %%%����ʽ����
   if(rand(1)<pm)
       u2=zeros(1,x_num);
       delta=zeros(1,x_num);
       for j=1:x_num
           u2(j)=rand(1);
           if(u2(j)<0.5)
               delta(j)=(2*u2(j))^(1/(yita2+1))-1;
           else
               delta(j)=1-(2*(1-u2(j)))^(1/(yita2+1));
           end
           off_1(j)=off_1(j)+delta(j);
           %ʹ�Ӵ��ڶ�������
           if(off_1(j)>x_max(j))
               off_1(j)=x_max(j);
           elseif(off_1(j)<x_min(j))
               off_1(j)=x_min(j);
           end
       end
       %�����Ӵ������Ŀ�꺯��ֵ
       off_1(1,1:x_num)=cor(off_1(1,1:x_num),x_num);%%%%%
       off_1(1,(x_num+1):(x_num+f_num))=object_fun(off_1,f_num,x_num);
   end
   if(rand(1)<pm)
       u2=zeros(1,x_num);
       delta=zeros(1,x_num);
       for j=1:x_num
           u2(j)=rand(1);
           if(u2(j)<0.5)
               delta(j)=(2*u2(j))^(1/(yita2+1))-1;
           else
               delta(j)=1-(2*(1-u2(j)))^(1/(yita2+1));
           end
           off_2(j)=off_2(j)+delta(j);
           %ʹ�Ӵ��ڶ�������
           if(off_2(j)>x_max(j))
               off_2(j)=x_max(j);
           elseif(off_2(j)<x_min(j))
               off_2(j)=x_min(j);
           end
       end
       %�����Ӵ������Ŀ�꺯��ֵ
       off_2(1,1:x_num)=cor(off_2(1,1:x_num),x_num);%%%%%
       off_2(1,(x_num+1):(x_num+f_num))=object_fun(off_2,f_num,x_num);
   end
   off(suoyin,:)=off_1;
   off(suoyin+1,:)=off_2;
   suoyin=suoyin+2;
end
chromo_offspring=off;
end