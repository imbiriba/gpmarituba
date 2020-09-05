function [mdate dat] = read_lgr(cname)
% function [mdate dat] = read_lgr(fname)
%
% Read LGR's text based data file 'fname' and return times and data structure.
%
% Breno Imbiriba - 2019.08.01

if(~iscell(cname))
  cname = {cname};
end

nf = numel(cname);
for ii=1:nf
  [mdi{ii}, dati{ii}] = read_lgr_core(cname{ii});
end
mdate = cat(2,mdi{:});
dat = cat(2,dati{:});

end

function [mdate dat] = read_lgr_core(fname)
% function [mdate dat] = read_lgr(fname)
%
% Read LGR's text based data file 'fname' and return times and data structure.
%
% Breno Imbiriba - 2019.08.01

disp(['Reading LGR data file ',fname]);

if(~exist(fname,'file'))
  error(['File ' fname ' does not exist']);
end

fid = fopen(fname);
% Read the whole data file into a single vector array
fdata = fread(fid,inf,'uint8=>char');
fclose(fid);

% Skip two lines
ipt = 1; npt = numel(fdata);
[sline ipt] = sreadline(fdata, ipt);
[sline ipt] = sreadline(fdata, ipt);

ip=0;
while(ipt<=npt) 
  [sline ipt] = sreadline(fdata, ipt);
  sline = char(sline);
  if(strfind(sline,'PGP'));
    disp('Start of PGP key... end of file');
    break
  end
  if(numel(strtrim(sline))==0)
    disp('Empty line... ignoring');
    continue
  end
  ip=ip+1;
  commas = strfind(sline,',');

  sdate = sline(1:commas(1)-1);
  mdate(ip) = datenum(sdate, 'mm/dd/yyyy HH:MM:SS.FFF');

  for ic=1:(numel(commas)-1)
    stmp = sline(commas(ic)+1:commas(ic+1)-1);
    dat(ic,ip) = str2num(stmp);
  end
  stmp = sline(commas(end)+1:end);
end
%fclose(fid);

end
