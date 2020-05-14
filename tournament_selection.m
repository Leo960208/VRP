function chromo_parent = tournament_selection( chromo,x_num )
%二进制竞标赛

%只选择了一半
[pop, suoyin] = size(chromo);
touranment=2;
a=round(pop/2);%选取一半
chromo_candidate=zeros(touranment,1);
chromo_rank=zeros(touranment,1);
%chromo_distance=zeros(touranment,1);
chromo_parent=zeros(a,suoyin);
% 获取等级的索引
rank = suoyin ;

for i=1:a
  for j=1:touranment 
      %while (1)
        chromo_candidate(j)=round(pop*rand(1));%随机产生候选者,产生索引
        if(chromo_candidate(j)==0)%索引从1开始
              chromo_candidate(j)=1;
        end%产生一个有效的候选人 
       
        if(j>1)
              while (~isempty(find(chromo_candidate(1:j-1)==chromo_candidate(j))))
                  chromo_candidate(j)=round(pop*rand(1));
                if(chromo_candidate(j)==0)%索引从1开始
                      chromo_candidate(j)=1;
                end
              end
        end %该候选人不重复

      
  end
  for j=1:touranment
      chromo_rank(j)=chromo(chromo_candidate(j),rank);
      %chromo_distance(j)=chromo(chromo_candidate(j),distance);
  end
  %取出低等级的个体索引
  minchromo_candidate=find(chromo_rank==min(chromo_rank));
  chromo_parent(i,:)=chromo(chromo_candidate(minchromo_candidate(1)),:);
  
end
end
