mkdir c:\MiKTeX2.8
mkdir c:\MiKTeX2.8\texmf
mkdir c:\MiKTeX2.8\localtexmf
icacls c:\MiKTeX2.8 /grant Users:(d,rc,wdac,wo,s,as,ma,gr,gw,ge,ga,rd,wd,ad,rea,wea,x,dc,ra,wa)
icacls c:\MiKTeX2.8 /deny Users:(d)