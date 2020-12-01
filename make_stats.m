

iCH4d=7;

% After angle_adjust.m
%

makeall = true;
makejoin = false;

if(~exist('sul'))
  error('Sulfix "sul" varibale not set.');
end
statfile = ['statall' sul '.txt'];
figall   = ['figall' sul '.png'];
statfile = ['statfile' sul '.txt'];

iplumes = [2 5 7 8 11 12 14 15 16 21 22];

if(makeall)
  fh = fopen(statfile,'w');

  [~,iptm] = sort([plumes(iplumes).mtime]-floor([plumes(iplumes).mtime]));
  iptm = [11 10 4 3 1 2 9 8 7 6 5];
  figure;  ik=0;
  for is=iplumes(iptm)

    ch4b = quantile(sections(is).lgrdata(1).data(iCH4d,:),.1);
    ikeep = trackcalc(is).ikeep;

    %X*C=Y <-> y = C(2)x + C(1) <-> [1 x]*[c1] = [y
    %                                1 x   c2]    y
    %                                ...         ...
    A=cat(2,ones(numel(ikeep),1), sections(is).lgrdata(1).data(iCH4d,ikeep)'-ch4b);
    B=trackcalc(is).PPMnew(ikeep)';
    C=lsqr(A,B);


  %  figure;
    ik=ik+1;
    subplot(4,3,ik);
    hold on
    plot(sections(is).lgrdata.data(iCH4d,ikeep)-ch4b, trackcalc(is).PPM(ikeep),'+','color',[.7 .7 .7]);
    plot(sections(is).lgrdata.data(iCH4d,ikeep)-ch4b, trackcalc(is).PPMnew(ikeep),'.','color',[0 0 0]);
    plot(sections(is).lgrdata.data(iCH4d,ikeep)-ch4b, C(2).*(sections(is).lgrdata.data(iCH4d,ikeep)-ch4b) + C(1),'-','color',[.5 .5 .5]);
    %legend(num2str(trackcalc(is).ccprev), num2str(trackcalc(is).ccnew)); 
    %title({datestr(plumes(is).mtime),[ ' stab=' num2str(plumes(is).OUT.stability) ' id=' num2str(is) ' \theta=' num2str(trackcalc(is).anglefix/pi*180) ' a=' num2str(C(2),2) ]});
    title(datestr(plumes(is).mtime,'HHPM'),'FontWeight','normal');
    grid;
    oo=max(sections(is).lgrdata.data(iCH4d,ikeep)-ch4b);
    axis([0 oo*1.1 0 C(2)*oo*1.1+C(1)]);
    %{
    hh = nearest((plumes(is).mtime-floor(plumes(is).mtime))*24);
    switch hh
      case 19
	axis([0 10 0 8]);
      case 20
	axis([0 4 0 4]);
      case 22
	axis([0 10 0 30]);
      case 23
	axis([0 12 0 30]);
      case 0
	axis([0 6 0 8]);
      case 1
	axis([0 5 0 20]);
      case 11
	axis([0 4 0 .6]);
      case 12
	axis([0 4 0 .6]);
      case 13
	axis([0 1.5 0 0.15]);
      case 15
	axis([0 1.5 0 0.15]);
      case 16
	axis([0 1.5 0 0.15]);
    end
%}
    set(gcf,'PaperPosition',[0.2500 6 7.5000 4.7500],'PaperUnits','inches');


    disp([datestr(plumes(is).mtime-floor(plumes(is).mtime),'HHPM') ' ' num2str(trackcalc(is).anglefix/pi*180) '° cprev=' num2str(trackcalc(is).ccprev) ' cnew=' num2str(trackcalc(is).ccnew) ' c/o=' num2str(C(2),2) ' stab=' num2str(plumes(is).OUT.stability)])

    fprintf(fh,['Time=' datestr(plumes(is).mtime,'HHPM') ' date=' datestr(plumes(is).mtime) ' angle=' num2str(trackcalc(is).anglefix/pi*180) '° cprev=' num2str(trackcalc(is).ccprev) ' cnew=' num2str(trackcalc(is).ccnew) ' c/o=' num2str(C(2),2) ' stab=' num2str(plumes(is).OUT.stability) 10]);
   
  end
  print(gcf,figall,'-dpng','-r300');
  fclose(fh);
end

if(makejoin)

  fh = fopen(statfile,'w');


  day = [9 8 7 6 5];
  nig = [11 10 4 3 1 2];

  d1 = [9 8]; % morning
  d2 = [7 6 5]; % afternoon
  d3 = [11 10 4 3]; % evening
  d4 = [1 2]; % midnight


  figure;
  obs=[]; cal=[];
  for ii=1:numel(day)
    is = iplumes(day(ii));
    ch4b = quantile(sections(is).lgrdata(1).data(iCH4d,:),.1);
    ikeep = trackcalc(is).ikeep;

    obs = [obs (sections(is).lgrdata(1).data(iCH4d,ikeep) - ch4b)];
    cal = [cal trackcalc(is).PPMnew(ikeep)];
  end
  plot(obs,cal,'.');
  A = cat(2,ones(numel(obs),1), obs');
  B = cal';
  C = lsqr(A,B);
  hold on
  plot(obs, C(2).*obs + C(1));
  legend(['calc/obs = ' num2str(C(2),2)]);
  title('Day time')
  grid
  axis([0 4 0 0.6]);
  cc = corrcoef(obs,cal);
  fprintf(fh,'Day time - corr=%g - calc/obs=%g \n',cc(1,2),C(2));

  figure;
  obs=[]; cal=[];
  for ii=1:numel(nig)
    is = iplumes(nig(ii));
    ch4b = quantile(sections(is).lgrdata(1).data(iCH4d,:),.1);
    ikeep = trackcalc(is).ikeep;

    obs = [obs (sections(is).lgrdata(1).data(iCH4d,ikeep) - ch4b)];
    cal = [cal trackcalc(is).PPMnew(ikeep)];
  end
  plot(obs,cal,'.');
  A = cat(2,ones(numel(obs),1), obs');
  B = cal';
  C = lsqr(A,B);
  hold on
  plot(obs, C(2).*obs + C(1));
  legend(['calc/obs = ' num2str(C(2),2)]);
  title('Night time')
  grid
  axis([0 12 0 30]);
  cc = corrcoef(obs,cal);
  fprintf(fh,'Night time - corr=%g - calc/obs=%g \n',cc(1,2),C(2));


  
  figure;
  obs=[]; cal=[];
  for ii=1:numel(d1)
    is = iplumes(d1(ii));
    ch4b = quantile(sections(is).lgrdata(1).data(iCH4d,:),.1);
    ikeep = trackcalc(is).ikeep;

    obs = [obs (sections(is).lgrdata(1).data(iCH4d,ikeep) - ch4b)];
    cal = [cal trackcalc(is).PPMnew(ikeep)];
  end
  plot(obs,cal,'.');
  A = cat(2,ones(numel(obs),1), obs');
  B = cal';
  C = lsqr(A,B);
  hold on
  plot(obs, C(2).*obs + C(1));
  legend(['calc/obs = ' num2str(C(2),2)]);
  title('Morning time')
  grid
  axis([0 4 0 0.6]);
  cc = corrcoef(obs,cal);
  fprintf(fh,'Morning time - corr=%g - calc/obs=%g \n',cc(1,2),C(2));


 
  figure;
  obs=[]; cal=[];
  for ii=1:numel(d2)
    is = iplumes(d2(ii));
    ch4b = quantile(sections(is).lgrdata(1).data(iCH4d,:),.1);
    ikeep = trackcalc(is).ikeep;

    obs = [obs (sections(is).lgrdata(1).data(iCH4d,ikeep) - ch4b)];
    cal = [cal trackcalc(is).PPMnew(ikeep)];
  end
  plot(obs,cal,'.');
  A = cat(2,ones(numel(obs),1), obs');
  B = cal';
  C = lsqr(A,B);
  hold on
  plot(obs, C(2).*obs + C(1));
  legend(['calc/obs = ' num2str(C(2),2)]);
  title('Afternoon time')
  grid
  axis([0 1.4 0 0.12]);
  cc = corrcoef(obs,cal);
  fprintf(fh,'Afternoon time - corr=%g - calc/obs=%g \n',cc(1,2),C(2));



  figure;
  obs=[]; cal=[];
  for ii=1:numel(d3)
    is = iplumes(d3(ii));
    ch4b = quantile(sections(is).lgrdata(1).data(iCH4d,:),.1);
    ikeep = trackcalc(is).ikeep;

    obs = [obs (sections(is).lgrdata(1).data(iCH4d,ikeep) - ch4b)];
    cal = [cal trackcalc(is).PPMnew(ikeep)];
  end
  plot(obs,cal,'.');
  A = cat(2,ones(numel(obs),1), obs');
  B = cal';
  C = lsqr(A,B);
  hold on
  plot(obs, C(2).*obs + C(1));
  legend(['calc/obs = ' num2str(C(2),2)]);
  title('Evening time')
  grid
  axis([0 12 0 30]);
  cc = corrcoef(obs,cal);
  fprintf(fh,'Evening time - corr=%g - calc/obs=%g \n',cc(1,2),C(2));



  figure;
  obs=[]; cal=[];
  for ii=1:numel(d4)
    is = iplumes(d4(ii));
    ch4b = quantile(sections(is).lgrdata(1).data(iCH4d,:),.1);
    ikeep = trackcalc(is).ikeep;

    obs = [obs (sections(is).lgrdata(1).data(iCH4d,ikeep) - ch4b)];
    cal = [cal trackcalc(is).PPMnew(ikeep)];
  end
  plot(obs,cal,'.');
  A = cat(2,ones(numel(obs),1), obs');
  B = cal';
  C = lsqr(A,B);
  hold on
  plot(obs, C(2).*obs + C(1));
  legend(['calc/obs = ' num2str(C(2),2)]);
  title('Midnight time')
  grid
  axis([0 6 0 20]);
  cc = corrcoef(obs,cal);
  fprintf(fh,'Midnight time - corr=%g - calc/obs=%g \n',cc(1,2),C(2));


  fclose(fh);
  
end


