function ExpBlock = ExpOrder(exp_id,subject_id,ExpNum)

posNum = 4;
if strfind(exp_id,'4pos')
    order(:,1) =  1: posNum;
    for n = 1:ExpNum
        ExpBlock(n).Order = Shuffle(order); 
    end
%     exp_id_initnamenum = strfind(exp_id,'4pos') + length('4pos') -1 ;
%     exp_id_initial = exp_id(1:exp_id_initnamenum);
end

for n = 1: ExpNum
    for m = 1: posNum 
        if ExpBlock(n).Order(m) == 1
            ExpBlock(n).GivenOrder{m} = 'UR';
            ExpBlock(n).Sequence{m} = 'ContrastTest161220-4pos-UR';
            
        end
        if ExpBlock(n).Order(m) == 2
            ExpBlock(n).GivenOrder{m} = 'UL';
            ExpBlock(n).Sequence{m} = 'ContrastTest161220-4pos-UL';
        end
        if ExpBlock(n).Order(m) == 3
            ExpBlock(n).GivenOrder{m} = 'DL';
            ExpBlock(n).Sequence{m} = 'ContrastTest161220-4pos-DL';
        end        
        if ExpBlock(n).Order(m) == 4
            ExpBlock(n).GivenOrder{m} = 'DR';
            ExpBlock(n).Sequence{m} = 'ContrastTest161220-4pos-DR';
        end
    end
end
ExpBlock = rmfield(ExpBlock,'Order');
currentTimeString = datestr(now, 'yyyymmddTHHMMSS');
%% ÉfÅ[É^ï€ë∂
save([ 'Order' '_' 'ContrastTest-4pos' '_' subject_id '_' currentTimeString '.mat' ], 'ExpBlock');

