function chromo = elitism( pop,combine_chromo2,f_num,x_num )
%��Ӣ��������
[pop2,temp]=size(combine_chromo2);
%chromo=zeros(pop,(f_num+x_num));%��ʼ��
tp=sortrows(combine_chromo2,temp);
chromo=tp(1:pop,:);


end
