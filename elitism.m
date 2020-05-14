function chromo = elitism( pop,combine_chromo2,f_num,x_num )
%精英保留策略
[pop2,temp]=size(combine_chromo2);
%chromo=zeros(pop,(f_num+x_num));%初始化
tp=sortrows(combine_chromo2,temp);
chromo=tp(1:pop,:);


end
