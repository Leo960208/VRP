function chromo = initialize( pop,f_num,x_num,x_min,x_max )
%   ��Ⱥ��ʼ�� %%�޸�

for i=1:pop
   for j=1:x_num
       chromo(i,j)=x_min(j)+(x_max(j)-x_min(j))*rand(1);
   end
 
   chromo(i,1:x_num)=cor(chromo(i,:),x_num);%%%%Լ������
   
   chromo(i,x_num+1:x_num+f_num) = object_fun(chromo(i,:),f_num,x_num);
  
end