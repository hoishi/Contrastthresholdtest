function DrawTextureTest
ListenChar(2);
AssertOpenGL;
%手作りfunction
%myKeyCheck;
try
  screenNumber=max(Screen('Screens'));
  [expWin, rect]=Screen('OpenWindow', screenNumber, [255 255 255]./2, [100, 200, 700, 600]);
  
  %画面の中心座標
  [mx, my]=RectCenter(rect);
  
  %十字マークの行列（20×20）を作る
  FixCr=ones(20,20)*255;
  FixCr(10:11,:)=0;
  FixCr(:,10:11)=0;
  fixcross = Screen('MakeTexture',expWin,FixCr);
  
  %以下の７行のいずれか１行のみを有効にして実行してみてください。
%   Screen('DrawTexture', expWin, fixcross,[0,0, 20, 20]);
  Screen('DrawTexture', expWin, fixcross,[0,0,20,20],[mx-100, my-100, mx+10, my+10]);
%   Screen('DrawTexture', expWin, fixcross,[5, 5, 20, 20],[mx-10, my-10, mx+10, my+10]);
%   Screen('DrawTexture', expWin, fixcross,[5, 5, 20, 20],[mx-50, my-50, mx+50, my+50]);
  %Screen('DrawTexture', expWin, fixcross,[5, 5, 20, 20],[mx, my, mx+100, my+100]);
  %Screen('DrawTexture', expWin, fixcross,[5, 5, 20, 20],[mx, my, mx+100, my+100], 30);
%   Screen('DrawTexture', expWin, fixcross,[],[mx-50, my-50, mx+50, my+50], 45);
  
  %画面に呈示
  Screen('Flip', expWin);
  
  %何かのキーを押すまで画面を閉じない
  KbWait([], 3);
  
  %終了処理
  Screen('CloseAll');
  ShowCursor;
  ListenChar(0);
catch
  Screen('CloseAll');
  ShowCursor;
  ListenChar(0);
end