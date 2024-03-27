function con_order=select_latin_square(text_cell,par_code,type)
%text_cell is to show the experimental conditions
%the cell number in a text cell MUST be equal to the length of a latin's
%square's row.
if isequal(type,'Latin')
    load('latinSquare.mat');
elseif isequal(type,'ABBA')
    load('ABBA_square.mat');
end
for i=1:size(latinSquare,1)
    disp('============================================')
    disp(['The No',num2str(i),' row of the Latin Square is:']);
    disp(latinSquare(i,:));
    for text_Tag=1:size(latinSquare,2);
       lt_num=latinSquare(i,text_Tag);
       fprintf([num2str(lt_num),':',text_cell{lt_num},' ']);
    end
    fprintf('\n');
end
disp('============================================')
%con_num=input('Please input the participant''s latin square row number:');
%[20190429: 改手动输入为自动计算：]
if isequal(type,'Latin')
    con_num = mod(par_code,14);
    if con_num==0
        con_num=14;
    end
elseif isequal(type,'ABBA')
    con_num = mod(par_code,14);
    if con_num==0
        con_num=14;
    end
end

con_order=latinSquare(con_num,:);
disp('============================================')
disp('============================================')
disp('The order you select is:')
for text_Tag=1:size(latinSquare,2);
   lt_num=latinSquare(con_num,text_Tag);
   fprintf([num2str(lt_num),':',text_cell{lt_num},' ']);
end
fprintf('\n');
disp('============================================')
