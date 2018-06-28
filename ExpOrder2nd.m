function ExpBlock2nd = ExpOrder2nd(exp_id,subject_id,ExpNum)

posNum = 4;
if strfind(exp_id,'4pos')
    order(:,1) =  1: posNum;
    for n = 1:ExpNum
        ExpBlock2nd(n).Order = Shuffle(order); 
    end
%     exp_id_initnamenum = strfind(exp_id,'4pos') + length('4pos') -1 ;
%     exp_id_initial = exp_id(1:exp_id_initnamenum);
end

for n = 1: ExpNum
    for m = 1: posNum 
        if ExpBlock2nd(n).Order(m) == 1
            ExpBlock2nd(n).GivenOrder{m} = 'UR';
            ExpBlock2nd(n).Sequence{m} = 'StereoTestHaplo151201-4pos-UR-2nd';
            
        end
        if ExpBlock2nd(n).Order(m) == 2
            ExpBlock2nd(n).GivenOrder{m} = 'UL';
            ExpBlock2nd(n).Sequence{m} = 'StereoTestHaplo151201-4pos-UL-2nd';
        end
        if ExpBlock2nd(n).Order(m) == 3
            ExpBlock2nd(n).GivenOrder{m} = 'DL';
            ExpBlock2nd(n).Sequence{m} = 'StereoTestHaplo151201-4pos-DL-2nd';
        end        
        if ExpBlock2nd(n).Order(m) == 4
            ExpBlock2nd(n).GivenOrder{m} = 'DR';
            ExpBlock2nd(n).Sequence{m} = 'StereoTestHaplo151201-4pos-DR-2nd';
        end
    end
end
ExpBlock2nd = rmfield(ExpBlock2nd,'Order');
currentTimeString = datestr(now, 'yyyymmddTHHMMSS');
%% ÉfÅ[É^ï€ë∂
save([ 'Order' '_' 'StereoTestHaplo-4pos-2nd' '_' subject_id '_' currentTimeString '.mat' ], 'ExpBlock2nd');

