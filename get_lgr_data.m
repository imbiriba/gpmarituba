function lgrdata = get_lgr_data(lgrdatafiles, lgrdatadelay)
% function lgrdata = get_lgr_data(lgrdatafiles, lgrdatadelay)
% 
% Concatenate given LGR data files into a single structure of data
% vectores, removing any time delay provided. 
%
% lgrdatafiles - cell array with ggaDDMMMAAA_fxxxx.txt  files.
% lgrdatadelay - cell array with time delays in seconds. 
%
% B. I. 08/2019.

  if(nargin()==0)

    lgrdatafiles = {...
      'data/gga02Aug2019_f0000.txt',
      'data/gga02Aug2019_f0001.txt',
      'data/gga06Aug2019_f0000.txt',
      'data/gga06Aug2019_f0001.txt',
      'data/gga06Aug2019_f0002.txt',
      'data/gga06Aug2019_f0003.txt',
      'data/gga07Aug2019_f0000.txt',
      'data/gga07Aug2019_f0001.txt',
      'data/gga07Aug2019_f0002.txt',
      'data/gga08Aug2019_f0000.txt',
      'data/gga19Nov2019_f0001.txt'};

    lgrdatadelay = {...
      4,
      4,
      4,
      4,
      4,
      4,
      4,
      4,
      4,
      4,
      18};
  else
    if(numel(lgrdatafiles)~=numel(lgrdatadelay))
      error('lgrdatafiles and lgrdatadelay must have the same length');
    end
  end

  lgrdata.mtime = [];
  lgrdata.data = [];
  for iff=1:numel(lgrdatafiles)
    [mtime data] = read_lgr(lgrdatafiles{iff});
    npt = numel(mtime);
    disp(['Brining data ' num2str(lgrdatadelay{iff}), ' sec back.']);
    lgrdata.mtime(end+1:end+npt) = mtime - lgrdatadelay{iff}/3600/24;
    lgrdata.data(:,end+1:end+npt) = data;
  end
end

