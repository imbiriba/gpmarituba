function [paths NN] = get_pathes(s)
% function [paths NN] = get_pathes(s)
%
% Return paths.

  z1_0 = complex(-3190,3519);
  z1_1 = complex(-351,3603); v1 = z1_1-z1_0; n1 = abs(v1)/s;

  z2    = complex(-2777,3502);  
  z2(2) = complex(-2671,2511); 
  z2(3) = complex(-2527,2134);
  z2(4) = complex(-2400,1771);
  z2(5) = complex(-2258,1539);
  z2(6) = complex(-1475,-193);
  z2(7) = complex(-1380,-337);
  z2(8) = complex(-1227,-426);
  z2(9) = complex(-343,-549);
  z2(10)= complex(-171,-587);
  z2(11)= complex(-52,-676);
  z2(12) = complex(531,-1466);  
  z2(13) = complex(650, -1646);
  z2(14) = complex(674.6, -1757);
  z2(15) = complex(690, -2098);
  z2(16) = complex(703, -2243);
  z2(17) = complex(736, -2362);
  v2 = z2(2:end)-z2(1:end-1); n2 = abs(v2)./s;

  z3(1) = complex(-932,3556); 
  z3(2) = complex(-944,3281);
  z3(3) = complex(-1018,3285);
  z3(4) = complex(-1058,3280);
  v3 = z3(2:end)-z3(1:end-1); n3 = abs(v3)./s;

  z4(1) = complex(-1474,-192); 
  z4(2) = complex(-827,-107);
  z4(3) = complex(-611,-85);
  z4(4) = complex(-517, -89);
  v4 = z4(2:end)-z4(1:end-1); n4 = abs(v4)./s;

  z5(1) = complex(-2685, 2860);
  z5(2) = complex(-1663, 2924);
  z5(3) = complex(-1623, 1833);
  z5(4) = complex(-1598, 1744);
  z5(5) = complex(-1366, 1355);
  z5(6) = complex(-1170,  760);
  z5(7) = complex(-1161,  581);
  z5(8) = complex(-1099,  377);
  z5(9) = complex(-1110,  270);
  z5(10) = complex(-1133,  200);
  z5(11) = complex(-1124, 105);
  z5(12) = complex(-1060, -75);
  z5(13) = complex(-1050,-132);
  v5 = z5(2:end)-z5(1:end-1); n5 = abs(v5)./s;

  i=complex(0,1);
  z6 = [...
  -1171+i*702
  -1220+i*674
  -1228+i*651
  -1263+i*658
  -1304+i*669
  -1334+i*630];
  v6 = z6(2:end)-z6(1:end-1); n6 = abs(v6)./s;


  z7 = [...
  -1299+i*601
  -1267+i*590
  -1234+i*614
  -1227+i*636];
  v7 = z7(2:end)-z7(1:end-1); n7 = abs(v7)./s;

  z8 = [...
  -937.8+i*3283
  -690.6+i*3281
  -691.4+i*3562];
  v8 = z8(2:end)-z8(1:end-1); n8 = abs(v8)./s;

  z9 = [...
  -923.8+i*3437
  -703.2+i*3437];
  v9 = z9(2:end)-z9(1:end-1); n9 = abs(v9)./s;

  path1 = z1_0 + s*[0:n1].*v1./abs(v1);

  path2 = [];
  for ii=1:numel(z2)-1
    path2 = [path2 z2(ii)+s*[0:n2(ii)].*v2(ii)./abs(v2(ii))];
  end
  path2 = [path2 z2(end)];


  path3 = [];
  for ii=1:numel(z3)-1
    path3 = [path3 z3(ii)+s*[0:n3(ii)].*v3(ii)./abs(v3(ii))];
  end
  path3 = [path3 z3(end)];


  path4 = [];
  for ii=1:numel(z4)-1
    path4 = [path4 z4(ii)+s*[0:n4(ii)].*v4(ii)./abs(v4(ii))];
  end
  path4 = [path4 z4(end)];


  path5 = [];
  for ii=1:numel(z5)-1
    path5 = [path5 z5(ii)+s*[0:n5(ii)].*v5(ii)./abs(v5(ii))];
  end
  path5 = [path5 z5(end)];

  path6 = [];
  for ii=1:numel(z6)-1
    path6 = [path6 z6(ii)+s*[0:n6(ii)].*v6(ii)./abs(v6(ii))];
  end
  path6 = [path6 z6(end)];

  path7 = [];
  for ii=1:numel(z7)-1
    path7 = [path7 z7(ii)+s*[0:n7(ii)].*v7(ii)./abs(v7(ii))];
  end
  path7 = [path7 z7(end)];

  path8 = [];
  for ii=1:numel(z8)-1
    path8 = [path8 z8(ii)+s*[0:n8(ii)].*v8(ii)./abs(v8(ii))];
  end
  path8 = [path8 z8(end)];

  path9 = [];
  for ii=1:numel(z9)-1
    path9 = [path9 z9(ii)+s*[0:n9(ii)].*v9(ii)./abs(v9(ii))];
  end
  path9 = [path9 z9(end)];





  n1 = numel(path1);
  n2 = numel(path2);
  n3 = numel(path3);
  n4 = numel(path4);
  n5 = numel(path5);
  n6 = numel(path6);
  n7 = numel(path7);
  n8 = numel(path8);
  n9 = numel(path9);

  paths{1} = path1;
  paths{2} = path2;
  paths{3} = path3;
  paths{4} = path4;
  paths{5} = path5;
  paths{6} = path6;
  paths{7} = path7;
  paths{8} = path8;
  paths{9} = path9;
  NN = [n1 n2 n3 n4 n5 n6 n7 n8 n9];
end


