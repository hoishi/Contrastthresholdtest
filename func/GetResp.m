function respCode = GetResp(resp, keyCode)
% GetResp    response 構造体 (resp) から keyCode に対応する反応コードを検索し返す

respCode = NaN;
for n = 1:length(resp)
    if keyCode(KbName(resp(n).key))
        respCode = resp(n).code;
    end
end

