function chromo_parent = tournament_selection( chromo,x_num )
%�����ƾ�����

%ֻѡ����һ��
[pop, suoyin] = size(chromo);
touranment=2;
a=round(pop/2);%ѡȡһ��
chromo_candidate=zeros(touranment,1);
chromo_rank=zeros(touranment,1);
%chromo_distance=zeros(touranment,1);
chromo_parent=zeros(a,suoyin);
% ��ȡ�ȼ�������
rank = suoyin ;

for i=1:a
  for j=1:touranment 
      %while (1)
        chromo_candidate(j)=round(pop*rand(1));%���������ѡ��,��������
        if(chromo_candidate(j)==0)%������1��ʼ
              chromo_candidate(j)=1;
        end%����һ����Ч�ĺ�ѡ�� 
       
        if(j>1)
              while (~isempty(find(chromo_candidate(1:j-1)==chromo_candidate(j))))
                  chromo_candidate(j)=round(pop*rand(1));
                if(chromo_candidate(j)==0)%������1��ʼ
                      chromo_candidate(j)=1;
                end
              end
        end %�ú�ѡ�˲��ظ�

      
  end
  for j=1:touranment
      chromo_rank(j)=chromo(chromo_candidate(j),rank);
      %chromo_distance(j)=chromo(chromo_candidate(j),distance);
  end
  %ȡ���͵ȼ��ĸ�������
  minchromo_candidate=find(chromo_rank==min(chromo_rank));
  chromo_parent(i,:)=chromo(chromo_candidate(minchromo_candidate(1)),:);
  
end
end
