function [line ipt]=sreadline(fdata, ipt)
% function [line ipt]=sreadline(fdata, ipt)
% The same as readline but for a string array instead of a file.
% fdata - string array (in)
% ipt - array pointe (in/out)
%
% line - the next line of text (out)
%
% B.I. 2019-11-02

line=[];

while(true)
  ch = fdata(ipt);
  ipt = ipt+1;

  % test for end of file
  if(numel(ch)==0)
    return
  end

  % test for end of line
  if(strcmp(ch,char(10)))
    return
  end   
  line(end+1)=ch;
end

end
