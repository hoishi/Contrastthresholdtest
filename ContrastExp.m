function ContrastExp(exp_id,subject_id,ExpNum)

ExpBlock1st = ExpOrder(exp_id,subject_id,ExpNum);
if strfind(exp_id,'4pos')
    for n = 1: ExpNum
        if n == 1
           NEXT(ExpBlock1st(n).Sequence{1},subject_id);
        end
        for m = 1: 4
                PsyExp(ExpBlock1st(n).Sequence{m},subject_id);
                if m <= 3
                    NEXT(ExpBlock1st(n).Sequence{m+1},subject_id);
                end 
        end
        if n <= 4
            NEXT(ExpBlock1st(n+1).Sequence{1},subject_id);
        end
    end
end
% addpath('./StereoDiffusionMRI/Script');
% addpath('./StereoDiffusionMRI/Script/lib');
% addpath('./StereoDiffusionMRI/Script/func');
% dataPcc = AnalysisStereoExp;
% Get2ndDisp(dataPcc);
% ExpBlock2nd = ExpOrder2nd(exp_id,subject_id,ExpNum);
% if strfind(exp_id,'4pos')
%     for n = 1: ExpNum
%         if n == 1
%            NEXT(ExpBlock2nd(n).Sequence{1},subject_id);
%         end
%         for m = 1: 4
%                 PsyExp(ExpBlock2nd(n).Sequence{m},subject_id);
%                 if m <= 3
%                     NEXT(ExpBlock2nd(n).Sequence{m+1},subject_id);
%                 end 
%         end
%         if n <= 4
%             NEXT(ExpBlock2nd(n+1).Sequence{1},subject_id);
%         end
%     end
% end
% 
% Copy_of_AnalysisPsychophysics;

